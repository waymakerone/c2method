# shellcheck shell=bash
# One pass of the tower's control loop. Idempotent: a second run with nothing new changes nothing.
#
# Roster states: starting → running → landing → landed | cold ;  down (process lost) ; failed ; queued
# A lane reports through its own state file: lane_status ∈ ready | working | blocked | landed.

_older_than_min() { # iso minutes
  local t; t="$(iso_to_epoch "$1")"
  [ "$t" -gt 0 ] && [ $(( $(epoch) - t )) -gt $(( $2 * 60 )) ]
}

# Failed lanes hold their slot: a lane the pilot has not dealt with should not be quietly
# overtaken by a lower-priority one, which is how a fleet ends up flying the wrong work.
_flying() { roster_lanes_in lane "starting,running,landing,failed"; }
_live()   { roster_lanes_in lane "starting,running,landing"; }

# A lane's report counts only if it was written after this incarnation started, so a woken
# lane isn't stopped by the "landed" it wrote last time. Both stamps are whole seconds, so a
# "landed" must be strictly after: a lane woken in the second it landed would otherwise re-land
# and re-wake on every pass. Any other report may share the start second.
_fresh() { # name prd
  local hb st; hb="$(iso_to_epoch "$(state_get "$2" heartbeat)")"; st="$(iso_to_epoch "$(roster_get "$1" started)")"
  if [ "$(state_get "$2" lane_status)" = landed ]; then [ "$hb" -gt "$st" ]; else [ "$hb" -ge "$st" ]; fi
}

reconcile() {
  local live launched=0 name prd rstate id lstatus status hold after ver seen hb last flying
  local queue='[]' spawned=0 n who why
  ROSTER_CHANGES=0
  # Reconciling blind would call every lane lost and respawn the lot. Stop instead.
  live="$(runner_list)" || die "cannot list live sessions — reconcile skipped, nothing changed"
  [ -f "$RT/launched" ] && launched=1

  # 1. Match the roster to reality: anything we think is up but isn't live.
  for name in $(roster_names); do
    rstate="$(roster_get "$name" state)"; id="$(roster_get "$name" id)"
    case "$rstate" in starting|running|landing) ;; *) continue ;; esac
    if ! live_status "$live" "$id" >/dev/null; then
      if [ "$rstate" = landing ]; then roster_set "$name" state=landed id=null; decide "landed $name (process ended)"
      else roster_set "$name" state=down id=null; decide "lost $name (process not running)"; fi
    fi
  done

  # 2. Lanes report progress through their state files.
  for name in $(roster_lanes_in lane "starting,running,landing"); do
    prd="$(roster_get "$name" prd)"; rstate="$(roster_get "$name" state)"; id="$(roster_get "$name" id)"
    lstatus=""; _fresh "$name" "$prd" && lstatus="$(state_get "$prd" lane_status)"
    status="$(live_status "$live" "$id" || true)"
    if [ "$lstatus" = landed ]; then
      stop_one "$name" landed "$(roster_get "$name" hold)"; continue
    fi
    case "$rstate" in
      starting)
        case "$lstatus" in
          ready|working|blocked) roster_set "$name" state=running ;;
          *) if _older_than_min "$(roster_get "$name" started)" "$STARTING_TIMEOUT_MIN"; then
               stop_one "$name" down; decide "restart $name: never reported ready"; fi ;;
        esac ;;
      landing)
        if [ "$status" = idle ] && ! worktree_dirty "$(roster_get "$name" worktree)"; then
          stop_one "$name" landed "$(roster_get "$name" hold)"
        fi ;;
      running)
        [ $launched = 1 ] || continue
        hb="$(state_get "$prd" heartbeat)"
        if [ "$status" = idle ] && _older_than_min "${hb:-$(roster_get "$name" started)}" "$HEARTBEAT_TIMEOUT_MIN" \
           && [ "$(roster_get "$name" nudged)" != "${hb:-none}" ]; then
          inbox_post "$name" tower "NUDGE: no heartbeat since ${hb:-start}. Report your status, then carry on."
          roster_set "$name" nudged="${hb:-none}"; decide "nudge $name"
        fi
        last="$(state_get "$prd" last_merge)"
        if _older_than_min "${last:-$(roster_get "$name" started)}" $(( DEMOTE_AFTER_DAYS * 1440 )); then
          inbox_post "$name" tower "LAND: no merged PR in $DEMOTE_AFTER_DAYS days. Checkpoint and land cold."
          roster_set "$name" state=landing hold=demoted; decide "demote $name"
        fi ;;
    esac
  done

  if [ $launched = 1 ]; then
    # 3. The tower and the checkpoint are always up while the fleet is launched.
    for who in tower checkpoint; do
      name="$(lane_name "$who")"; rstate="$(roster_get "$name" state)"
      case "$rstate" in
        starting|running|failed) continue ;;
        down) _count_respawn "$name" || continue ;;
      esac
      spawn_one "$who" && roster_set "$name" state=running
    done

    # 4. Desired lanes, in priority order, up to the ceiling.
    flying="$(_flying | wc -l | tr -d ' ')"
    for prd in $(lanes_active); do
      name="$(lane_name "$prd")"; rstate="$(roster_get "$name" state)"; hold="$(roster_get "$name" hold)"
      why=""
      case "$rstate" in
        starting|running|landing|failed) continue ;;
        landed|cold)
          [ -z "$hold" ] || continue
          ver="$(fm_get "$(lane_prd_path "$prd")" version)"; seen="$(state_get "$prd" prd_version_seen)"
          [ -n "$seen" ] && [ "$ver" != "$seen" ] || continue
          why="wake: PRD $seen → $ver" ;;
        down) why="respawn" ;;
      esac
      after="$(lane_field "$prd" after)"
      if [ -n "$after" ] && [ "$(roster_get "$(lane_name "$after")" state)" != landed ]; then
        queue="$(printf '%s' "$queue" | jq -c --arg p "$prd" --arg r "after $after" '. + [{prd: $p, reason: $r}]')"
        _mark_queued "$name" "$prd"; continue
      fi
      if find_overlaps "$prd" $(for n in $(_live); do roster_get "$n" prd; done) >/dev/null; then :; else
        queue="$(printf '%s' "$queue" | jq -c --arg p "$prd" '. + [{prd: $p, reason: "surface overlap"}]')"
        _mark_queued "$name" "$prd"; continue
      fi
      if [ "$flying" -ge "$LANE_CEILING" ]; then
        queue="$(printf '%s' "$queue" | jq -c --arg p "$prd" '. + [{prd: $p, reason: "ceiling"}]')"
        _mark_queued "$name" "$prd"; continue
      fi
      if [ "$why" = respawn ]; then _count_respawn "$name" || continue; fi
      [ -n "$why" ] && decide "$why $name"
      [ $spawned -gt 0 ] && [ "${STAGGER_SEC:-0}" -gt 0 ] && sleep "$STAGGER_SEC"
      if spawn_one "$prd"; then spawned=$((spawned + 1)); flying=$((flying + 1)); fi
    done

    # 5. Lanes that are flying but no longer enlisted land.
    for name in $(roster_lanes_in lane "starting,running"); do
      prd="$(roster_get "$name" prd)"
      case " $(lanes_active | tr '\n' ' ') " in *" $prd "*) continue ;; esac
      inbox_post "$name" tower "LAND: your PRD was removed from the fleet. Checkpoint and land."
      roster_set "$name" state=landing hold=retired; decide "retire $name"
    done
  fi

  write_if_changed "$RT/queue.json" "$(printf '%s' "$queue" | jq '.')"
  if [ "$ROSTER_CHANGES" -eq 0 ]; then say "reconcile: no changes"; else say "reconcile: $ROSTER_CHANGES change(s)"; fi
}

_mark_queued() { # name prd  (a lost lane stays "down" so it is still counted as a respawn)
  [ "$(roster_get "$1" state)" = down ] || roster_set "$1" role=lane prd="$2" state=queued
}

# Count a respawn; past MAX_RESPAWNS the lane is marked failed and waits for the pilot.
_count_respawn() {
  local r; r="$(roster_get "$1" respawns)"; r=$(( ${r:-0} + 1 ))
  if [ "$r" -gt "$MAX_RESPAWNS" ]; then
    roster_set "$1" state=failed; decide "failed $1: died $MAX_RESPAWNS times, needs the pilot"
    return 1
  fi
  roster_set "$1" respawns="$r"
}
