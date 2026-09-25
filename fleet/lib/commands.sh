# shellcheck shell=bash
# The fleet verbs. Pilot verbs first, then the single-lane verbs, then plumbing.

cmd_init() {
  REPO_PATH="$(find_repo)" || die "not inside a git repo"
  local dir="$REPO_PATH/.fleet" gi="$REPO_PATH/.gitignore" f
  mkdir -p "$dir"
  if [ ! -f "$dir/fleet.config" ]; then
    sed "s/^INSTANCE_NAME=\"\"/INSTANCE_NAME=\"$(basename "$REPO_PATH")\"/" \
      "$FLEET_KIT/templates/fleet.config.example" > "$dir/fleet.config"
    say "created .fleet/fleet.config"
  fi
  [ -f "$dir/lanes.json" ] || { echo '{"lanes":[]}' > "$dir/lanes.json"; say "created .fleet/lanes.json"; }
  if ! git -C "$REPO_PATH" check-ignore -q .claude/worktrees/x 2>/dev/null; then
    printf '\n# fleet lane worktrees\n.claude/worktrees/\n' >> "$gi"; say "added .claude/worktrees/ to .gitignore"
  fi
  load_config
  _init_router
  say "runtime: $RT"
  say ""
  cmd_candidates
  say "Next: enlist the ones you want, commit .fleet/, then 'fleet preflight' and 'fleet launch'."
}

# Teach this repo's router that the fleet exists, so any agent reading it knows the verbs.
_init_router() {
  local f
  for f in CLAUDE.md AGENTS.md GEMINI.md; do
    [ -f "$REPO_PATH/$f" ] || continue
    grep -q "<!-- fleet -->" "$REPO_PATH/$f" && continue
    [ "${FLEET_INIT_NO_ROUTER:-}" = 1 ] && continue
    cat >> "$REPO_PATH/$f" <<EOF

<!-- fleet -->
## The fleet

This repo can be run by a **C² fleet**: a tower (repo-ops), a checkpoint (pr-review) and one
lane per PRD, each in its own worktree. Config in \`.fleet/\`; live state in \`$RT\`.

\`\`\`bash
fleet candidates             # which PRDs can fly, and what the rest still need
fleet radar                  # the board, ending with what is waiting on the pilot
fleet launch | ground        # start everything | land everything safely
fleet enlist <prd.md> --files 'glob,…'
fleet scale <n>              # how many lanes fly at once — the pilot's dial
fleet hail <prd> "msg"       # message a lane (then push it live, or it sleeps through it)
fleet deck                   # open every lane as a terminal in your IDE
\`\`\`

A PRD joins the fleet when it has \`prd_id:\`, \`version:\` and acceptance items that name their
anchors. Bump a PRD's \`version:\` and its lane re-plans against the new spec. Scope, merging
and the ceiling are the pilot's, never an agent's. Full rulebooks: \`$SKILLS_DIR/\`.
EOF
    say "added a fleet section to $f"
  done
}

# Every PRD in the repo that could become a lane, and what each still needs.
# A PRD is flyable when it has prd_id, version, and acceptance items naming an anchor.
cmd_candidates() {
  local f id ver anchor seen="" ready="" close="" cold=0 n
  for f in $(git -C "$REPO_PATH" ls-files '*.md' | grep -iE 'prd|product-requirement|requirements/' ; git -C "$REPO_PATH" grep -l '^prd_id:' -- '*.md' 2>/dev/null); do
    [ -f "$REPO_PATH/$f" ] || continue
    case "$f" in *archive*|*superseded*|*completed*|*deprecated*|*retired*|*/README.md) continue ;; esac
    case " $seen " in *" $f "*) continue ;; esac
    seen="$seen $f"
    id="$(fm_get "$REPO_PATH/$f" prd_id)"; ver="$(fm_get "$REPO_PATH/$f" version)"
    anchor=""; grep -qiE '^[[:space:]]*\*?\*?anchor' "$REPO_PATH/$f" && anchor=1
    if [ -n "$id" ] && [ -n "$ver" ] && [ -n "$anchor" ]; then
      ready="$ready$id	$f
"
    elif [ -n "$anchor" ] || grep -qiE '^#+ .*(acceptance|success criteria|requirements)' "$REPO_PATH/$f"; then
      close="$close$(basename "$f" .md)	$f	$([ -n "$id" ] || printf 'prd_id ')$([ -n "$ver" ] || printf 'version ')$([ -n "$anchor" ] && printf '' || printf 'anchors')
"
    else
      cold=$((cold + 1))
    fi
  done

  say "READY TO FLY"
  if [ -n "$ready" ]; then
    printf '%s' "$ready" | while IFS="$(printf '\t')" read -r id f; do
      [ -n "$id" ] || continue
      say "  ✓ $id"
      say "      fleet enlist $f --files '<glob>' --priority <n>"
    done
  else
    say "  none yet — see below"
  fi

  say ""
  say "ONE CONVERSATION AWAY"
  say "  These have a spec worth flying. They are missing only the frontmatter and anchors."
  say ""
  if [ -n "$close" ]; then
    printf '%s' "$close" | head -12 | while IFS="$(printf '\t')" read -r name f missing; do
      [ -n "$name" ] || continue
      say "  · $name — needs: $missing"
      say "      $f"
    done
    n="$(printf '%s' "$close" | grep -c . )"
    [ "$n" -gt 12 ] && say "  … and $((n - 12)) more"
    say ""
    say "  Ask your agent, naming the ones you want:"
    say ""
    say "      \"Read <prd path> and draft the fleet frontmatter and acceptance anchors from"
    say "       its own scope — prd_id, version, and one anchor per acceptance item that can"
    say "       actually fail. Show me before you write anything.\""
    say ""
    say "  You approve the anchors. That conversation is where you find out whether the spec"
    say "  was real — a PRD with no signal that can fail cannot be flown, and should not be."
  else
    say "  none"
  fi

  [ "$cold" -gt 0 ] && { say ""; say "$cold other markdown files look PRD-shaped but have no acceptance section at all."; }
  return 0
}

cmd_preflight() {
  local fails=0 v prd out others o
  ok()  { printf '  ✓ %s\n' "$*"; }
  bad() { printf '  ✗ %s\n' "$*"; fails=$((fails + 1)); }
  say "fleet preflight · $REPO_PATH"
  command -v git >/dev/null && ok "git" || bad "git missing"
  command -v jq  >/dev/null && ok "jq"  || bad "jq missing"
  if runner_check; then ok "runner: ${FLEET_RUNNER:-claude}"; else bad "runner ${FLEET_RUNNER:-claude} not available"; fi
  if [ "${FLEET_RUNNER:-claude}" = claude ]; then
    v="$(_claude --version </dev/null 2>/dev/null | awk '{print $1}')"
    if printf '%s\n2.1.278\n' "$v" | sort -t. -k1,1n -k2,2n -k3,3n | head -1 | grep -qx 2.1.278; then
      ok "claude $v (≥ 2.1.278)"; else bad "claude ${v:-?} is older than 2.1.278"; fi
    if runner_list | jq -e 'type == "array"' >/dev/null; then ok "claude agents --json answers from inside a session"
    else bad "claude agents --json failed"; fi
  fi
  if command -v gh >/dev/null && gh auth status >/dev/null 2>&1; then ok "gh authenticated"
  else bad "gh missing or not logged in (the tower merges through it)"; fi
  if [ "${FLEET_RUNNER:-claude}" = claude ] && [ -f "$HOME/.claude.json" ]; then
    local untrusted="" d
    for d in "$REPO_PATH" "$WORKTREE_ROOT"; do
      [ -d "$d" ] || continue
      jq -e --arg d "$d" '(.projects[$d].hasTrustDialogAccepted // false) == true' "$HOME/.claude.json" >/dev/null 2>&1 \
        || untrusted="$untrusted $d"
    done
    if [ -z "$untrusted" ]; then ok "workspace trusted"
    else
      bad "workspace not trusted — every spawn will fail. Run this once in each and accept:"
      for d in $untrusted; do say "      (cd $d && claude)"; done
    fi
  fi
  if command -v gh >/dev/null && gh auth status >/dev/null 2>&1; then
    local labels; labels="$(cd "$REPO_PATH" && gh label list --limit 200 --json name -q '.[].name' 2>/dev/null || true)"
    if printf '%s\n' "$labels" | grep -qx fleet:review && printf '%s\n' "$labels" | grep -qx fleet:approved \
       && printf '%s\n' "$labels" | grep -qx fleet:changes; then ok "PR labels fleet:review / approved / changes"
    else bad "PR labels missing. Create them: for l in review approved changes; do gh label create fleet:\$l; done"; fi
  fi
  git -C "$REPO_PATH" rev-parse --verify -q "refs/heads/$BASE_BRANCH" >/dev/null && ok "base branch $BASE_BRANCH" \
    || bad "base branch $BASE_BRANCH not found"
  if git -C "$REPO_PATH" remote get-url origin >/dev/null 2>&1; then
    git -C "$REPO_PATH" fetch -q origin "$BASE_BRANCH" 2>/dev/null || true
    local behind
    behind="$(git -C "$REPO_PATH" rev-list --count "$BASE_BRANCH".."origin/$BASE_BRANCH" 2>/dev/null || echo 0)"
    ok "lanes branch from origin/$BASE_BRANCH${behind:+$([ "${behind:-0}" -gt 0 ] && echo " (local $BASE_BRANCH is $behind behind — harmless)")}"
  else
    ok "no origin — lanes branch from local $BASE_BRANCH"
  fi
  git -C "$REPO_PATH" check-ignore -q .claude/worktrees/x && ok ".claude/worktrees/ is gitignored" \
    || bad ".claude/worktrees/ is not gitignored"
  [ -w "$RT" ] && ok "runtime $RT writable" || bad "runtime $RT not writable"
  jq -e '.lanes | type == "array"' "$LANES_FILE" >/dev/null && ok "lanes.json valid" || bad "lanes.json invalid"
  for f in c2-fleet-protocol c2-repo-ops c2-pr-review; do
    [ -f "$SKILLS_DIR/$f/SKILL.md" ] || bad "skill $f missing from the kit"
  done
  for prd in $(lanes_active); do
    if out="$(validate_lane "$prd")"; then ok "lane $prd: PRD valid"; else bad "lane $prd:"; say "$out"; fi
    # A lane sequenced either way is not an overlap: check both directions.
    others=""
    for o in $(lanes_active); do
      [ "$o" = "$prd" ] && continue
      [ "$(lane_field "$prd" after)" = "$o" ] && continue
      [ "$(lane_field "$o" after)" = "$prd" ] && continue
      others="$others $o"
    done
    if ! out="$(find_overlaps "$prd" $others)"; then
      bad "lane $prd overlaps a lane it is not sequenced with (use --after):"; say "$out"
    fi
  done
  if [ "${FLEET_RUNNER:-claude}" = claude ]; then
    say "  · not checked here: lanes surviving sleep / reboot (PRD §12, P0-8)"
  fi
  [ $fails -eq 0 ] && { say "preflight: clear to launch"; return 0; }
  say "preflight: $fails problem(s)"; return 1
}

cmd_launch() {
  [ -n "$(lanes_active)" ] || die "no lanes enlisted. Run 'fleet enlist <prd.md> --files <glob>' first"
  touch "$RT/launched"
  # A launch clears holds the pilot set by grounding; landed-because-done lanes stay landed.
  local name
  for name in $(roster_names); do
    [ "$(roster_get "$name" hold)" = pilot ] && roster_set "$name" hold=null state=queued respawns=0
    [ "$(roster_get "$name" state)" = failed ] && roster_set "$name" state=queued respawns=0
  done
  decide "launch (ceiling $LANE_CEILING)"
  say "launching $INSTANCE_NAME · ceiling $LANE_CEILING"
  FLEET_ACTOR=pilot reconcile
}

cmd_radar() {
  local live name prd rstate id lstatus ver seen items pr hb model flying n waiting=""
  live="$(runner_list)" || { warn "cannot list live sessions — liveness below is unknown"; live='[]'; }
  flying="$(_flying | wc -l | tr -d ' ')"
  printf 'FLEET %s · %s/%s lanes flying · tower %s · checkpoint %s%s\n' "$INSTANCE_NAME" "$flying" "$LANE_CEILING" \
    "$(_role_mark tower "$live")" "$(_role_mark checkpoint "$live")" "$([ -f "$RT/launched" ] || echo ' · GROUNDED')"
  printf '%-26s %-9s %-8s %-9s %-11s %-7s %-7s %-10s\n' LANE STATE SAYS PRD-VER "ITEMS d/all" PR BEAT MODEL
  for prd in $(lanes_active); do
    name="$(lane_name "$prd")"; rstate="$(roster_get "$name" state)"; id="$(roster_get "$name" id)"
    lstatus="$(state_get "$prd" lane_status)"
    ver="$(fm_get "$(lane_prd_path "$prd")" version)"; seen="$(state_get "$prd" prd_version_seen)"
    items="$(jq -r '"\(.items | map(select(.status == "done")) | length)/\(.items | length)"' "$(state_file "$prd")" 2>/dev/null || echo -)"
    pr="$(jq -r '[.items[] | select(.status == "in_review") | .pr // empty] | first // "-" | tostring' "$(state_file "$prd")" 2>/dev/null || echo -)"
    [ "$pr" = "-" ] || pr="#$pr"
    hb="$(ago "$(state_get "$prd" heartbeat)")"
    model="$(roster_get "$name" model)"; model="${model:-$(lane_model "$prd")}"
    [ -n "$rstate" ] && [ -n "$id" ] && ! live_status "$live" "$id" >/dev/null && rstate="$rstate?"
    printf '%-26s %-9s %-8s %-9s %-11s %-7s %-7s %-10s\n' "$name" "${rstate:-new}" "${lstatus:--}" \
      "${ver:-?}${seen:+/$seen}" "$items" "$pr" "$hb" "$model"
    n="$(jq -r '.blockers // [] | length' "$(state_file "$prd")" 2>/dev/null || echo 0)"
    [ "${n:-0}" -gt 0 ] && waiting="$waiting$(jq -r --arg l "$name" '.blockers[] | "  · \($l) blocked: \(.what // .)"' "$(state_file "$prd")")
"
    [ "$(printf '%s' "${rstate%\?}")" = failed ] && waiting="$waiting  · $name failed $MAX_RESPAWNS times. Look in 'fleet blackbox $prd', then 'fleet wake $prd'
"
    jq -e '.plan.adds_scope == true and .plan.status == "filed"' "$(state_file "$prd")" >/dev/null 2>&1 \
      && waiting="$waiting  · $name filed a plan that adds scope: $(jq -r '.plan.path // "see state"' "$(state_file "$prd")")
"
  done
  [ "${MERGE_REQUIRES_PILOT:-false}" = true ] && say "MERGE POLICY: the tower hands you approved PRs — it does not merge"
  n="$(jq -r 'map("\(.prd) (\(.reason))") | join(", ")' "$RT/queue.json")"
  [ -n "$n" ] && say "QUEUED: $n"
  waiting="$waiting$(jq -r '.escalations // [] | .[] | select(.open != false) | "  · tower: \(.what // .)"' "$RT/tower.json" 2>/dev/null || true)"
  say "WAITING ON PILOT:"
  if [ -n "$(printf '%s' "$waiting" | tr -d '[:space:]')" ]; then printf '%s\n' "$waiting" | sed '/^$/d'; else say "  nothing. Fly on"; fi
}

_role_mark() {
  local name id; name="$(lane_name "$1")"; id="$(roster_get "$name" id)"
  if live_status "$2" "$id" >/dev/null; then printf '✓'; else printf '✗'; fi
}

cmd_enlist() {
  local path="" prd priority=5 model="" after="" files="" data="" external="" retire=0 out others
  while [ $# -gt 0 ]; do
    case "$1" in
      --files) files="$2"; shift ;;  --data) data="$2"; shift ;;  --external) external="$2"; shift ;;
      --priority) priority="$2"; shift ;;  --model) model="$2"; shift ;;  --after) after="$2"; shift ;;
      -*) die "enlist: unknown option $1" ;;
      *) path="$1" ;;
    esac; shift
  done
  [ -n "$path" ] || die "usage: fleet enlist <prd.md> --files 'glob,glob' [--data ..] [--external ..] [--priority n] [--model m] [--after prd]"
  [ -f "$path" ] || [ -f "$REPO_PATH/$path" ] || die "no such PRD file: $path"
  [ -f "$path" ] && path="$(cd "$(dirname "$path")" && pwd -P)/$(basename "$path")" || path="$REPO_PATH/$path"
  path="${path#"$REPO_PATH"/}"
  prd="$(fm_get "$REPO_PATH/$path" prd_id)"
  [ -n "$prd" ] || die "$path has no prd_id: in its frontmatter"
  [ -n "$files" ] || die "a lane needs a files surface: --files 'src/area/**,tests/area/**'"
  _csv() { jq -nc --arg s "$1" '$s | split(",") | map(gsub("^ +| +$"; "")) | map(select(. != ""))'; }
  local entry
  entry="$(jq -n --arg prd "$prd" --arg path "$path" --argjson pr "$priority" --arg model "$model" --arg after "$after" \
    --argjson f "$(_csv "$files")" --argjson d "$(_csv "$data")" --argjson e "$(_csv "$external")" \
    '{prd: $prd, path: $path, priority: $pr, active: true, surfaces: {files: $f, data: $d, external: $e}}
     + (if $model != "" then {model: $model} else {} end) + (if $after != "" then {after: $after} else {} end)')"
  cp "$LANES_FILE" "$LANES_FILE.bak"
  jq --argjson e "$entry" '.lanes = ([.lanes[] | select(.prd != $e.prd)] + [$e])' "$LANES_FILE.bak" > "$LANES_FILE"
  others="$(lanes_active | grep -vx "$prd" | grep -vx "${after:-^$}" || true)"
  if ! out="$(validate_lane "$prd")" || ! out="$out$(find_overlaps "$prd" $others)"; then
    mv "$LANES_FILE.bak" "$LANES_FILE"
    say "refused: $prd"; say "$out"
    [ -n "$(printf '%s' "$out" | grep overlaps)" ] && say "  Two lanes may share a surface only in order: add --after <prd>."
    return 1
  fi
  rm -f "$LANES_FILE.bak"
  decide "enlist $prd ($path) priority=$priority${after:+ after=$after}"
  say "enlisted $prd → lane $(lane_name "$prd"). Commit .fleet/lanes.json so the fleet config compounds."
  # Enlisting never spawns. Adding a PRD to the list and putting an agent in the air are two
  # decisions, and only one of them is reversible by editing a file.
  [ -f "$RT/launched" ] && say "It flies at the next 'fleet reconcile' — or now, with 'fleet wake $prd'."
  return 0
}

cmd_scale() {
  local n="${1:-}" flying blocked warn=""
  case "$n" in ''|*[!0-9]*) die "usage: fleet scale <n>" ;; esac
  flying="$(_flying | wc -l | tr -d ' ')"
  if [ "$n" -gt "$LANE_CEILING" ]; then
    blocked=0
    for prd in $(lanes_active); do [ "$(state_get "$prd" lane_status)" = blocked ] && blocked=$((blocked + 1)); done
    [ -n "$(roster_lanes_in lane failed)" ] && warn="a lane has failed"
    [ "$flying" -gt 0 ] && [ $((blocked * 3)) -gt "$flying" ] && warn="${warn:+$warn; }more than a third of lanes are blocked"
    [ -n "$warn" ] && warn "scaling up while $warn. Your call, pilot"
  fi
  echo "$n" > "$RT/ceiling"; LANE_CEILING="$n"
  decide "scale ceiling → $n"
  say "ceiling is now $n ($flying flying)"
  [ -f "$RT/launched" ] && reconcile
  return 0
}

cmd_land() {
  local prd="${1:-}" retire=0 name id live status wt
  [ "${2:-}" = --retire ] && retire=1
  [ -n "$prd" ] || die "usage: fleet land <prd> [--retire]"
  # tower and checkpoint land too, so a role can be restarted (land, then wake) to pick up a change
  if [ "$prd" = tower ] || [ "$prd" = checkpoint ]; then
    [ $retire = 0 ] || die "the $prd is a role, not a lane: it cannot be retired"
  else lane_enlisted "$prd" || die "no enlisted lane '$prd'"; fi
  name="$(lane_name "$prd")"
  _land_one "$name" pilot
  if [ $retire = 1 ]; then
    jq --arg p "$prd" '.lanes |= map(if .prd == $p then .active = false else . end)' "$LANES_FILE" > "$LANES_FILE.tmp" \
      && mv "$LANES_FILE.tmp" "$LANES_FILE"
    decide "retire $prd from lanes.json"; say "  $prd retired from lanes.json. Commit .fleet/lanes.json"
  fi
}

_land_one() { # name hold
  local name="$1" id live status wt
  id="$(roster_get "$name" id)"; wt="$(roster_get "$name" worktree)"
  live="$(runner_list)" || die "cannot list live sessions — not landing $name blind"
  if ! status="$(live_status "$live" "$id")"; then
    roster_has "$name" && roster_set "$name" state=landed hold="$2" id=null
    say "  $name is not flying. Marked landed"; return 0
  fi
  if [ "$status" = idle ] && ! worktree_dirty "$wt"; then
    stop_one "$name" landed "$2"; say "  ⇣ $name landed"
  else
    inbox_post "$name" pilot "LAND: finish your current task, commit, push, save state, set lane_status landed, then stop."
    roster_set "$name" state=landing hold="$2"; decide "landing $name"
    say "  ⇣ $name is landing: it was asked to checkpoint first$(worktree_dirty "$wt" && echo ' (worktree has uncommitted work)')"
  fi
}

cmd_ground() {
  local name
  if [ "${1:-}" = --now ]; then
    for name in $(roster_names); do
      [ -n "$(roster_get "$name" id)" ] && stop_one "$name" cold pilot
    done
    rm -f "$RT/launched"; decide "ground --now: every session stopped, worktrees kept"
    say "grounded now. Every session stopped; worktrees are untouched."
    return 0
  fi
  rm -f "$RT/launched"; decide "ground"
  for name in $(roster_lanes_in lane "starting,running,queued,down"); do _land_one "$name" pilot; done
  for name in $(lane_name tower) $(lane_name checkpoint); do
    roster_has "$name" && _land_one "$name" pilot
  done
  say "grounding. Run 'fleet reconcile' (or let the tower) to finish landings; 'fleet ground --now' stops everything at once."
}

cmd_cockpit() {
  local name id; name="$(lane_name "${1:?usage: fleet cockpit <prd>}")"; id="$(roster_get "$name" id)"
  [ -n "$id" ] || die "$name is not flying"
  runner_attach "$id"
}

cmd_tower() { cmd_cockpit tower; }

cmd_hail() {
  local target="${1:-}" msg="${2:-}" name names=""
  [ -n "$target" ] && [ -n "$msg" ] || die 'usage: fleet hail <prd|all|tower|checkpoint> "message"'
  if [ "$target" = all ]; then names="$(roster_lanes_in lane "starting,running,landing")"
  else names="$(lane_name "$target")"; fi
  [ -n "$names" ] || die "nobody to hail"
  for name in $names; do inbox_post "$name" "${FLEET_ACTOR:-pilot}" "$msg"; done
  decide "hail $target: $msg"
  say "posted. Lanes read their inbox at each task boundary; push the ✉ lines live to wake idle ones."
}

cmd_wake() {
  local prd="${1:-}" name
  [ -n "$prd" ] || die "usage: fleet wake <prd>"
  lane_enlisted "$prd" || [ "$prd" = tower ] || [ "$prd" = checkpoint ] || die "no enlisted lane '$prd'"
  name="$(lane_name "$prd")"
  case "$(roster_get "$name" state)" in starting|running) die "$name is already flying" ;; esac
  roster_set "$name" hold=null state=queued respawns=0
  decide "wake $name (pilot)"
  [ -f "$RT/launched" ] || { say "$name queued. It flies at the next 'fleet launch'"; return 0; }
  if [ "$prd" = tower ] || [ "$prd" = checkpoint ]; then spawn_one "$prd" && roster_set "$name" state=running; return 0; fi
  reconcile
}

cmd_blackbox() {
  local n="${2:-40}"
  if [ -n "${1:-}" ]; then grep -F "$(lane_name "$1")" "$RT/decisions.log" | tail -n "$n" || say "no entries for $1"
  else tail -n "$n" "$RT/decisions.log"; fi
}

# Plumbing ----------------------------------------------------------------------------------

# Write .vscode/tasks.json so the IDE can open every flying lane as its own terminal.
# The background sessions stay the runtime; a terminal is just a view onto one.
cmd_deck() {
  local dir="$REPO_PATH/.vscode" f tasks names name prd label cmdline
  mkdir -p "$dir"; f="$dir/tasks.json"
  [ -f "$f" ] || echo '{"version":"2.0.0","tasks":[]}' > "$f"
  # Strip comments so a jsonc file still parses, and drop any previous Fleet tasks.
  tasks="$(sed 's@^[[:space:]]*//.*@@' "$f" | jq '{version: (.version // "2.0.0"),
    tasks: [(.tasks // [])[] | select((.label // "") | startswith("Fleet: ") | not)]}')" \
    || die "could not parse $f — move it aside and run 'fleet deck' again"
  names=""
  for prd in $(lanes_active); do
    name="$(lane_name "$prd")"
    case "$(roster_get "$name" state)" in starting|running|landing) ;; *) continue ;; esac
    names="$names $prd"
  done
  [ -n "$names" ] || die "no lanes are flying. Run 'fleet launch' first"
  for prd in tower checkpoint $names; do
    label="Fleet: $prd"
    cmdline="cd '$REPO_PATH' && '$FLEET_KIT/bin/fleet' cockpit $prd"
    [ "$prd" = tower ] && cmdline="cd '$REPO_PATH' && '$FLEET_KIT/bin/fleet' tower"
    tasks="$(printf '%s' "$tasks" | jq --arg l "$label" --arg c "$cmdline" --arg g "$prd" \
      '.tasks += [{label: $l, type: "shell", command: $c, isBackground: true,
        problemMatcher: [], presentation: {echo: false, reveal: "always", focus: false,
        panel: "dedicated", group: "fleet", showReuseMessage: false},
        runOptions: {instanceLimit: 1}}]')"
  done
  tasks="$(printf '%s' "$tasks" | jq --argjson d "$(printf '%s' "tower checkpoint$names" | jq -Rc 'split(" ") | map(select(. != "")) | map("Fleet: " + .)')" \
    '.tasks += [{label: "Fleet: open the deck", dependsOn: $d, dependsOrder: "parallel",
      problemMatcher: [], group: {kind: "build", isDefault: false}}]')"
  printf '%s\n' "$tasks" > "$f"
  decide "deck written for:$names"
  say "wrote $f"
  say ""
  say "In your IDE: Run Task → \"Fleet: open the deck\" opens one terminal per agent, side by side."
  say "  (VS Code: ⇧⌘P → Tasks: Run Task. Bind it to a key if you open it often.)"
  say "Each terminal is attached to a live session — closing it leaves the agent running."
  say "Detach with ctrl-b. Stop an agent with 'fleet land <prd>', never by closing the tab."
}

# Record a pilot decision as a durable artefact, so no agent has to trust a relayed claim.
# fleet decide "<what the pilot decided>"
cmd_decide() {
  [ -n "${1:-}" ] || die 'usage: fleet decide "<what the pilot decided>"'
  FLEET_ACTOR=pilot decide "DECISION: $*"
  say "recorded in $RT/decisions.log — agents can verify this instead of trusting a relay:"
  say "  tail -5 '$RT/decisions.log'"
}

cmd_reconcile() { reconcile; }

# Append one line to the decisions log, in UTC, as the calling agent.
cmd_log() { [ -n "${1:-}" ] || die 'usage: fleet log "<what happened>"'; decide "$*"; }

cmd_brief() { [ -n "${1:-}" ] || die "usage: fleet brief <prd|tower|checkpoint>"; brief_for "$1"; }

# A lane's own write to its state file: heartbeat, lane_status, and optional markers.
# fleet beat <prd> <ready|working|blocked|landed> [--seen <version>] [--merged]
cmd_beat() {
  local prd="${1:-}" st="${2:-}" seen="" merged=0 f
  [ -n "$prd" ] && [ -n "$st" ] || die "usage: fleet beat <prd> <ready|working|blocked|landed> [--seen <ver>] [--merged]"
  case "$st" in ready|working|blocked|landed) ;; *) die "status must be ready|working|blocked|landed" ;; esac
  shift 2
  while [ $# -gt 0 ]; do case "$1" in --seen) seen="$2"; shift ;; --merged) merged=1 ;; esac; shift; done
  seed_state "$prd"; f="$(state_file "$prd")"
  jq --arg s "$st" --arg t "$(now)" --arg v "$seen" --argjson m "$merged" \
    '.lane_status = $s | .heartbeat = $t
     | (if $v != "" then .prd_version_seen = $v else . end)
     | (if $m == 1 then .last_merge = $t else . end)' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
}
