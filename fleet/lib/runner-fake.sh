# shellcheck shell=bash
# Test runner: pretends to be an agent CLI so the acceptance tests cost no tokens.
# Processes live in $FLEET_FAKE_DIR/procs.json; every spawn is logged to spawns.log.

_fake_procs() { local f="$FLEET_FAKE_DIR/procs.json"; [ -f "$f" ] || echo '[]' > "$f"; echo "$f"; }

runner_check() { [ -n "${FLEET_FAKE_DIR:-}" ]; }

runner_spawn() {
  local f id; f="$(_fake_procs)"
  id="$(printf '%08x' $(( (RANDOM << 15) | RANDOM )))"
  jq --arg n "$1" --arg i "$id" --arg c "$2" \
    '. + [{name: $n, id: $i, pid: 1, status: "busy", state: "working", cwd: $c}]' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
  printf '%s\t%s\t%s\n' "$1" "$3" "$id" >> "$FLEET_FAKE_DIR/spawns.log"
  printf '%s' "$4" > "$FLEET_FAKE_DIR/prompt-$1.txt"
  echo "$id"
}

runner_list() { cat "$(_fake_procs)"; }

runner_stop() {
  local f; f="$(_fake_procs)"
  jq --arg i "$1" 'map(select(.id != $i))' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
}
runner_forget() { :; }
runner_attach() { echo "fake attach $1"; }

# Test helper: set a fake session's status (busy|idle).
fake_set_status() {
  local f; f="$(_fake_procs)"
  jq --arg n "$1" --arg s "$2" 'map(if .name == $n then .status = $s else . end)' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
}
