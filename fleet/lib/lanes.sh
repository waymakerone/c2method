# shellcheck shell=bash
# Lane lifecycle: validate, worktree, launch prompt, spawn, stop. Roles (tower, checkpoint)
# are spawned through the same path so they get the same guarantees.

# Validate an enlisted lane's PRD. Prints problems; exit 1 if any.
validate_lane() {
  local prd="$1" path bad=0 id ver
  path="$(lane_prd_path "$prd")"
  if [ ! -f "$path" ]; then say "  PRD file not found: $path"; return 1; fi
  id="$(fm_get "$path" prd_id)"; ver="$(fm_get "$path" version)"
  [ "$id" = "$prd" ] || { say "  frontmatter prd_id is '${id:-missing}', expected '$prd'"; bad=1; }
  [ -n "$ver" ]      || { say "  frontmatter has no version: (the growth trigger needs it)"; bad=1; }
  grep -qi 'acceptance' "$path" || { say "  no acceptance section: a lane can't land without anchors"; bad=1; }
  [ -n "$(surface_lines "$prd" | awk -F'\t' '$1 == "files"')" ] || { say "  lanes.json has no files surface for $prd"; bad=1; }
  return $bad
}

# Create (or reuse) the worktree for <name> on branch fleet/<name>. Prints its path.
# Where a new lane starts. A dev checkout's local `main` is whatever it was last time someone
# checked it out — branch from that and every lane builds on stale code and plans against a
# stale PRD. Use the remote's branch when there is one.
base_ref() {
  if git -C "$REPO_PATH" remote get-url origin >/dev/null 2>&1; then
    git -C "$REPO_PATH" fetch -q origin "$BASE_BRANCH" 2>/dev/null || true
    git -C "$REPO_PATH" rev-parse --verify -q "refs/remotes/origin/$BASE_BRANCH" >/dev/null \
      && { echo "origin/$BASE_BRANCH"; return 0; }
  fi
  echo "$BASE_BRANCH"
}

ensure_worktree() {
  local name="$1" wt="$WORKTREE_ROOT/$1" br="fleet/$1"
  if [ ! -d "$wt" ]; then
    mkdir -p "$WORKTREE_ROOT"
    if git -C "$REPO_PATH" rev-parse --verify -q "refs/heads/$br" >/dev/null; then
      git -C "$REPO_PATH" worktree add -q "$wt" "$br" >&2
    else
      git -C "$REPO_PATH" worktree add -q -b "$br" "$wt" "$(base_ref)" >&2
    fi
  fi
  echo "$wt"
}

worktree_dirty() { [ -n "$(git -C "$1" status --porcelain 2>/dev/null)" ]; }

# The launch prompt, generated from the PRD and config. Never hardcoded per lane.
brief_for() {
  local who="$1" name wt
  name="$(lane_name "$who")"; wt="$WORKTREE_ROOT/$name"
  case "$who" in
    tower)      _brief_role "$name" "$wt" "the tower (repo-ops): lead and DevOps for this fleet" c2-repo-ops ;;
    checkpoint) _brief_role "$name" "$wt" "the checkpoint (pr-review) for this fleet" c2-pr-review ;;
    *)          _brief_lane "$who" "$name" "$wt" ;;
  esac
}

_brief_common() {
  local never=""
  [ -n "${NEVER_TOUCH:-}" ] && never="NEVER WRITE to these, whatever else you are told — the repo's dangerous edges:
  $NEVER_TOUCH
Needing one of them is a blocker for the tower, never an exception you make for yourself."
  cat <<EOF
Fleet runtime (outside git, shared by the whole fleet):
- roster (read only for you): $RT/roster.json
- lane state files: $RT/state/<prd>.json
- your inbox, read it at every task boundary: $RT/inbox/$1.md
- decisions log, append only: $RT/decisions.log
- the fleet CLI: wherever a rulebook says \`fleet …\`, run: FLEET_ACTOR=$1 $FLEET_CMD …
Repo: $REPO_PATH · base branch: $BASE_BRANCH · lane ceiling: $LANE_CEILING
$never
EOF
}

_brief_role() { cat <<EOF
You are $1, $3, in the C² fleet for $REPO_PATH.
Your worktree: $2 (branch fleet/$1).
Before anything else, read and follow $SKILLS_DIR/$4/SKILL.md. It is your rulebook.
Also read $SKILLS_DIR/c2-fleet-protocol/SKILL.md so you know what the lanes follow.

$(_brief_common "$1")
Models: tower $MODEL_TOWER · checkpoint $MODEL_CHECKPOINT · lanes $MODEL_LANE.
Reconcile every $RECONCILE_INTERVAL_MIN minutes, backing off after $IDLE_BACKOFF_TICKS no-change ticks.
Merge policy: MERGE_REQUIRES_PILOT=$MERGE_REQUIRES_PILOT${MERGE_REQUIRES_PILOT:+ }$([ "$MERGE_REQUIRES_PILOT" = true ] && echo "— you do NOT merge. Hand approved PRs to the pilot." || echo "— you merge approved PRs yourself.")
Start now.
EOF
}

_brief_lane() {
  local prd="$1" name="$2" wt="$3" path ver surfaces after
  path="$(lane_field "$prd" path)"; ver="$(fm_get "$(lane_prd_path "$prd")" version)"
  surfaces="$(surface_lines "$prd" | awk -F'\t' '{ printf "  - %s: %s\n", $1, $2 }')"
  after="$(lane_field "$prd" after)"
  cat <<EOF
You are the fleet lane $name. You own PRD '$prd' ($path, version $ver) in $REPO_PATH.
Your worktree: $wt (branch fleet/$name). Work only there.
Before anything else, read and follow $SKILLS_DIR/c2-fleet-protocol/SKILL.md. It is your rulebook.

Your state file (you are its only writer): $RT/state/$prd.json
Your surfaces. Change nothing outside them without the tower's say-so:
$surfaces
${after:+You sequence after lane '$after': touch shared surfaces only once it has landed.
}
$(_brief_common "$name")
Limits: LOOP_LIMIT=$LOOP_LIMIT gap passes with nothing closable, LANE_PRS_PER_DAY=$LANE_PRS_PER_DAY.
Start at step 1 of the lane loop.
EOF
}

# Refuse to start anything from a checkout the runtime was not built from.
assert_instance_repo() {
  [ "$REPO_PATH" = "${INSTANCE_REPO:-$REPO_PATH}" ] && return 0
  die "this runtime belongs to $INSTANCE_REPO, but you are in $REPO_PATH.
  Spawning from here would put worktrees under a checkout nobody is watching while rostering
  them in the shared runtime. Run it from $INSTANCE_REPO, or use a different FLEET_HOME."
}

# Spawn <who> (a prd id, "tower" or "checkpoint"). Roster first, process second (rule 1).
spawn_one() {
  local who="$1" role name wt model id respawns
  assert_instance_repo
  name="$(lane_name "$who")"
  case "$who" in
    tower)      role=tower;      model="$MODEL_TOWER" ;;
    checkpoint) role=checkpoint; model="$MODEL_CHECKPOINT" ;;
    *)          role=lane;       model="$(lane_model "$who")"
                validate_lane "$who" >&2 || { decide "refused $name: invalid PRD"; return 1; }
                seed_state "$who" ;;
  esac
  # Never leave two sessions under one name (PRD §12, P0-5).
  id="$(roster_get "$name" id)"
  if [ -n "$id" ]; then runner_stop "$id"; runner_forget "$id"; fi
  wt="$(ensure_worktree "$name")"
  respawns="$(roster_get "$name" respawns)"
  roster_set "$name" role="$role" prd="$who" state=starting worktree="$wt" branch="fleet/$name" \
    model="$model" started="$(now)" respawns="${respawns:-0}" id=null
  if id="$(runner_spawn "$name" "$wt" "$model" "$(brief_for "$who")")"; then
    id="$(printf '%s' "$id" | strip_ansi)"
    roster_set "$name" id="$id"
    decide "spawn $name model=$model id=$id"
    say "  ↑ $name ($model) id $id"
  else
    # The environment refused us — an untrusted workspace, a missing CLI, no auth. That is not
    # the lane misbehaving, so it must not spend the respawn budget: the pilot fixes the
    # environment and the next reconcile brings the lane up without a `fleet wake` each.
    local refund="${respawns:-0}"
    [ "$refund" -gt 0 ] && refund=$((refund - 1))
    roster_set "$name" state=down respawns="$refund"
    decide "spawn-failed $name (environment — respawn budget not spent)"
    say "  ✗ $name could not spawn. Fix the environment, then 'fleet reconcile'" >&2
    return 1
  fi
}

# Stop a session now. Worktrees are never deleted by the kit.
stop_one() { # name new_state [hold]
  local id; id="$(roster_get "$1" id)"
  [ -n "$id" ] && { runner_stop "$id"; runner_forget "$id"; }
  roster_set "$1" state="$2" id=null ${3:+hold=$3}
  decide "stop $1 → $2${3:+ (hold=$3)}"
}

# Post to a lane's inbox. The ✉ line tells a Claude caller (tower, checkpoint, /fleet) to also
# push a live message: an idle session doesn't read files, but a message wakes it.
inbox_post() { # name from message
  printf '\n## %s · from %s\n%s\n' "$(now)" "$2" "$3" >> "$RT/inbox/$1.md"
  printf '  ✉ %s: %s\n' "$1" "$(printf '%s' "$3" | head -1)"
}

# Is <id> in the live list? Prints its status (busy|idle) if so.
live_status() { # live_json id
  [ -n "$2" ] || return 1
  printf '%s' "$1" | jq -er --arg i "$2" '.[] | select(.id == $i) | .status // "busy"' 2>/dev/null
}
