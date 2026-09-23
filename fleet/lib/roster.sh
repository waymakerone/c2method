# shellcheck shell=bash
# roster.json: the only writer is this file. Atomic writes (temp + mv) under a mkdir lock,
# and a write that changes nothing leaves the file byte-identical (reconcile must be idempotent).

ROSTER_CHANGES=0

_roster_lock() {
  local i=0
  until mkdir "$RT/.roster.lock" 2>/dev/null; do
    i=$((i + 1))
    [ $i -gt 150 ] && die "roster lock held at $RT/.roster.lock. Remove it if no fleet command is running"
    sleep 0.1
  done
}
_roster_unlock() { rmdir "$RT/.roster.lock" 2>/dev/null || true; }

roster_get()   { jq -r --arg n "$1" --arg f "$2" '.lanes[$n][$f] // empty' "$RT/roster.json"; }
roster_has()   { jq -e --arg n "$1" '.lanes[$n]' "$RT/roster.json" >/dev/null; }
roster_names() { jq -r '.lanes | keys[]' "$RT/roster.json"; }
roster_lanes_in() { # role "state1,state2" → names
  jq -r --arg r "$1" --arg s "$2" '($s | split(",")) as $want | .lanes | to_entries[]
    | select(.value.role == $r and (.value.state as $st | $want | any(.[]; . == $st))) | .key' "$RT/roster.json"
}

# roster_set <name> key=value ...   (value "null" deletes the key)
roster_set() {
  local n="$1" cur="$RT/roster.json" tmp kv k v; shift
  _roster_lock
  tmp="$RT/.roster.$$.tmp"
  cp "$cur" "$tmp"
  for kv in "$@"; do
    k="${kv%%=*}"; v="${kv#*=}"
    if [ "$v" = "null" ]; then
      jq --arg n "$n" --arg k "$k" 'del(.lanes[$n][$k])' "$tmp" > "$tmp.2"
    else
      jq --arg n "$n" --arg k "$k" --arg v "$v" '.lanes[$n][$k] = $v' "$tmp" > "$tmp.2"
    fi
    mv "$tmp.2" "$tmp"
  done
  if cmp -s "$tmp" "$cur"; then
    rm -f "$tmp"
  else
    jq --arg n "$n" --arg t "$(now)" '.lanes[$n].updated = $t' "$tmp" > "$tmp.2" && mv "$tmp.2" "$cur"
    rm -f "$tmp"
    ROSTER_CHANGES=$((ROSTER_CHANGES + 1))
  fi
  _roster_unlock
}

roster_rm() {
  _roster_lock
  jq --arg n "$1" 'del(.lanes[$n])' "$RT/roster.json" > "$RT/.roster.$$.tmp" && mv "$RT/.roster.$$.tmp" "$RT/roster.json"
  _roster_unlock
}

# Write a runtime JSON file only if its content changed.
write_if_changed() { # file json
  if [ ! -f "$1" ] || [ "$(cat "$1")" != "$2" ]; then
    printf '%s\n' "$2" > "$1.tmp" && mv "$1.tmp" "$1"
    ROSTER_CHANGES=$((ROSTER_CHANGES + 1))
  fi
}
