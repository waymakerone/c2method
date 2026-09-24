# shellcheck shell=bash
# Runner adapter: Claude Code background sessions (claude --bg). Verified on 2.1.278 (PRD §12).
# Another agent CLI plugs in by providing the same six functions in runner-<name>.sh.

# A `claude` subcommand run inside a Claude session inherits that session's variables and is
# treated as a chat prompt instead (gotcha: claude-subcommands-inside-a-session). Strip them.
_claude() {
  env -u CLAUDECODE -u CLAUDE_PID -u CLAUDE_EFFORT \
      -u CLAUDE_CODE_ENTRYPOINT -u CLAUDE_CODE_SESSION_ID -u CLAUDE_CODE_CHILD_SESSION \
      -u CLAUDE_CODE_MESSAGING_SOCKET -u CLAUDE_CODE_MESSAGING_TOKEN \
      -u CLAUDE_CODE_BRIDGE_SESSION_ID -u CLAUDE_CODE_SESSION_ATTENDED -u CLAUDE_CODE_SSE_PORT \
      claude "$@"
}

runner_check() { command -v claude >/dev/null 2>&1; }

# runner_spawn <name> <cwd> <model> <prompt>  → prints the session id
runner_spawn() {
  local out id
  out="$(cd "$2" && _claude --bg -n "$1" --model "$3" --permission-mode "$PERMISSION_MODE" "$4" </dev/null 2>&1)" || {
    printf '%s\n' "$out" >&2; return 1; }
  # From inside a session (the tower) `claude --bg` colours the id. Stored coloured, it never
  # matches `claude agents --json`, so the next reconcile calls a live lane lost and spawns a twin.
  id="$(printf '%s\n' "$out" | strip_ansi | awk '$1 == "backgrounded" { print $3; exit }')"
  case "$id" in ''|*[!0-9a-f]*) printf '%s\n' "$out" >&2; return 1 ;; esac
  echo "$id"
}

# runner_list → JSON array of live sessions: [{name, id, pid, status, state, cwd}]
# Fails when it cannot see. It never answers '[]' for "I couldn't look": to reconcile, an empty
# list means every lane died, and it would respawn all of them.
runner_list() {
  local out
  out="$(_claude agents --json </dev/null 2>/dev/null)" || return 1
  printf '%s' "$out" | jq -c '[.[] | select(.kind == "background") | {name, id, pid, status, state, cwd}]' 2>/dev/null
}

runner_stop()   { _claude kill "$1" </dev/null >/dev/null 2>&1 || true; }
runner_forget() { _claude rm "$1" </dev/null >/dev/null 2>&1 || true; }
runner_attach() { exec env -u CLAUDECODE -u CLAUDE_CODE_ENTRYPOINT -u CLAUDE_CODE_SESSION_ID \
                    -u CLAUDE_CODE_CHILD_SESSION -u CLAUDE_PID claude attach "$1"; }
