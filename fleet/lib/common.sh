# shellcheck shell=bash
# Shared helpers: config, paths, logging, time, PRD frontmatter, lanes.json access.
# Written for bash 3.2 (macOS default): no associative arrays, no mapfile.

die()  { printf 'fleet: %s\n' "$*" >&2; exit 1; }
warn() { printf 'fleet: warning: %s\n' "$*" >&2; }
say()  { printf '%s\n' "$*"; }
# Remove terminal colour codes. An agent CLI run from inside another session can colour what it
# prints, and a coloured session id never matches the live list (gotcha: coloured-session-id).
strip_ansi() { sed $'s/\033\\[[0-9;]*m//g'; }
now()  { date -u +%Y-%m-%dT%H:%M:%SZ; }
epoch() { date -u +%s; }

iso_to_epoch() {
  [ -n "${1:-}" ] || { echo 0; return; }
  date -u -j -f %Y-%m-%dT%H:%M:%SZ "$1" +%s 2>/dev/null || date -u -d "$1" +%s 2>/dev/null || echo 0
}

# "3m ago" style age for radar.
ago() {
  local t; t="$(iso_to_epoch "${1:-}")"
  [ "$t" -gt 0 ] || { echo "-"; return; }
  local d=$(( $(epoch) - t ))
  if   [ $d -lt 120 ];   then echo "${d}s ago"
  elif [ $d -lt 7200 ];  then echo "$((d / 60))m ago"
  elif [ $d -lt 172800 ]; then echo "$((d / 3600))h ago"
  else echo "$((d / 86400))d ago"; fi
}

need() { command -v "$1" >/dev/null 2>&1 || die "$1 is required but not installed"; }

# Find the main checkout even when called from inside a lane's worktree.
find_repo() {
  local top common
  top="$(git rev-parse --show-toplevel 2>/dev/null)" || return 1
  common="$(git -C "$top" rev-parse --git-common-dir)"
  case "$common" in /*) ;; *) common="$top/$common" ;; esac
  (cd "$common/.." && pwd -P)
}

# Load kit defaults, then .fleet/fleet.config, then runtime overrides.
load_config() {
  REPO_PATH="$(find_repo)" || die "not inside a git repo"
  FLEET_DIR="$REPO_PATH/.fleet"
  [ -f "$FLEET_DIR/fleet.config" ] || die "no .fleet/fleet.config in $REPO_PATH. Run 'fleet init' first"
  # shellcheck disable=SC1091
  . "$FLEET_KIT/templates/fleet.config.example"
  # shellcheck disable=SC1091
  . "$FLEET_DIR/fleet.config"
  : "${INSTANCE_NAME:=$(basename "$REPO_PATH")}"
  : "${NAME_PREFIX:=$INSTANCE_NAME}"
  : "${WORKTREE_ROOT:=$REPO_PATH/.claude/worktrees}"
  [ -n "${FLEET_STAGGER_SEC:-}" ] && STAGGER_SEC="$FLEET_STAGGER_SEC"
  RT="${FLEET_HOME:-$HOME/.fleet}/$INSTANCE_NAME"
  # Skills live beside the kit (repo root), so the whole thing is one plugin.
  SKILLS_DIR="$FLEET_KIT/../skills"
  [ -d "$SKILLS_DIR" ] || SKILLS_DIR="$FLEET_KIT/skills"
  SKILLS_DIR="$(cd "$SKILLS_DIR" && pwd)"
  # Agents may not inherit our environment, so briefs spell out the exact CLI call.
  FLEET_CMD="$FLEET_KIT/bin/fleet"
  [ -n "${FLEET_HOME:-}" ] && FLEET_CMD="FLEET_HOME='$FLEET_HOME' $FLEET_CMD"
  mkdir -p "$RT/state" "$RT/inbox"
  [ -f "$RT/roster.json" ] || echo '{"lanes":{}}' > "$RT/roster.json"
  [ -f "$RT/queue.json" ]  || echo '[]' > "$RT/queue.json"
  [ -f "$RT/tower.json" ]  || echo '{"escalations":[]}' > "$RT/tower.json"
  touch "$RT/decisions.log"
  [ -f "$RT/ceiling" ] && LANE_CEILING="$(cat "$RT/ceiling")"
  LANES_FILE="$FLEET_DIR/lanes.json"
  [ -f "$LANES_FILE" ] || echo '{"lanes":[]}' > "$LANES_FILE"
}

# Append-only decision journal: time, actor, what happened.
# The log records WHO RAN THE COMMAND, which it cannot authenticate — an agent that sets
# FLEET_ACTOR=pilot is recorded as the pilot. So the log is a trail, never proof of authority.
# Authority-bearing artefacts are the ones with provenance you cannot fake from inside a
# session: a git commit, a GitHub label or review, a pushed config change.
decide() { printf '%s\t%s\t%s\n' "$(now)" "${FLEET_ACTOR:-unsigned-shell}" "$*" >> "$RT/decisions.log"; }

# Read one key from a markdown file's YAML frontmatter (flat keys only).
fm_get() {
  awk -v k="$2" '
    NR == 1 && $0 != "---" { exit }
    NR > 1 && $0 == "---"  { exit }
    NR > 1 && index($0, k ":") == 1 {
      v = substr($0, length(k) + 2)
      sub(/[ \t]+#.*$/, "", v)
      gsub(/^[ \t"\047]+|[ \t"\047]+$/, "", v)
      print v; exit
    }' "$1"
}

# One name everywhere: session name, worktree folder, roster key and branch fleet/<name>.
lane_name() { echo "$NAME_PREFIX-$1"; }

# lanes.json accessors. A lane entry: {prd, path, priority, model, after, active, surfaces:{files,data,external}}
lanes_active()  { jq -r '.lanes | map(select(.active != false)) | sort_by(.priority // 9) | .[].prd' "$LANES_FILE"; }
lane_field()    { jq -r --arg p "$1" --arg f "$2" '.lanes[] | select(.prd == $p) | .[$f] // empty' "$LANES_FILE"; }
lane_enlisted() { jq -e --arg p "$1" '.lanes[] | select(.prd == $p)' "$LANES_FILE" >/dev/null; }
lane_prd_path() { local p; p="$(lane_field "$1" path)"; echo "$REPO_PATH/$p"; }
lane_model()    { local m; m="$(lane_field "$1" model)"; echo "${m:-$MODEL_LANE}"; }

# A lane's own state file (the lane is its only writer; the kit only seeds it).
state_file() { echo "$RT/state/$1.json"; }
state_get()  { local f; f="$(state_file "$1")"; [ -f "$f" ] && jq -r --arg k "$2" '.[$k] // empty' "$f" 2>/dev/null || true; }

seed_state() {
  local f; f="$(state_file "$1")"
  [ -f "$f" ] && return 0
  jq -n --arg p "$1" '{prd_id: $p, prd_version_seen: null, lane_status: null, heartbeat: null,
    last_merge: null, loop_passes: 0, plan: null, items: [], blockers: []}' > "$f"
}

# Static prefix of a glob: everything before the first wildcard.
glob_prefix() { printf '%s' "$1" | sed 's/[][*?{].*//'; }

# Two surface patterns overlap when either prefix contains the other. Conservative on purpose.
patterns_overlap() {
  local a b; a="$(glob_prefix "$1")"; b="$(glob_prefix "$2")"
  case "$a" in "$b"*) return 0 ;; esac
  case "$b" in "$a"*) return 0 ;; esac
  return 1
}

# Print "kind<TAB>pattern" lines for one enlisted lane.
surface_lines() {
  jq -r --arg p "$1" '.lanes[] | select(.prd == $p) | (.surfaces // {}) | to_entries[]
    | .key as $k | (.value // [])[] | [$k, .] | @tsv' "$LANES_FILE"
}

# Report overlaps between <prd> and each lane in the remaining args. Exit 1 if any.
find_overlaps() {
  local prd="$1" other kind pat okind opat hits=0; shift
  for other in "$@"; do
    [ "$other" = "$prd" ] && continue
    while IFS="$(printf '\t')" read -r kind pat; do
      [ -n "$kind" ] || continue
      while IFS="$(printf '\t')" read -r okind opat; do
        [ "$kind" = "$okind" ] || continue
        if patterns_overlap "$pat" "$opat"; then
          say "  $kind surface '$pat' overlaps '$opat' (lane $other)"
          hits=1
        fi
      done <<EOF
$(surface_lines "$other")
EOF
    done <<EOF
$(surface_lines "$prd")
EOF
  done
  return $hits
}
