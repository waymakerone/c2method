# shellcheck shell=bash
# Runner adapter: any agent CLI that takes a prompt and runs until it stops.
# Use this for Codex, Gemini CLI, Grok, Aider, opencode, a local model runner, or anything else
# with a command line. Set in .fleet/fleet.config:
#
#   FLEET_RUNNER="exec"
#   AGENT_CMD='codex exec --model {model} "$(cat {prompt_file})"'
#
# Placeholders: {name} {model} {cwd} {prompt_file} {log_file}
# Examples:
#   codex   AGENT_CMD='codex exec --model {model} --cd {cwd} "$(cat {prompt_file})"'
#   gemini  AGENT_CMD='gemini --model {model} --yolo --prompt "$(cat {prompt_file})"'
#   grok    AGENT_CMD='grok --model {model} --prompt "$(cat {prompt_file})"'
#
# What you give up next to the Claude runner: there is no live message that wakes an idle agent,
# and no busy/idle signal. Neither is fatal, because **every bit of fleet state is in files**.
# A lane that has stopped is simply started again; it reads its PRD, state file and inbox and
# carries on. So with this runner, `fleet hail` writes the inbox and the next `fleet wake` (or
# the tower's next tick) delivers it.

_exec_dirs() { mkdir -p "$RT/pids" "$RT/logs" "$RT/prompts"; }
_exec_pidfile() { echo "$RT/pids/$1.pid"; }
_exec_logfile() { echo "$RT/logs/$1.log"; }

runner_check() { [ -n "${AGENT_CMD:-}" ]; }

runner_spawn() { # name cwd model prompt → prints the pid as the id
  local name="$1" cwd="$2" model="$3" pf lf cmd pid
  _exec_dirs
  pf="$RT/prompts/$name.txt"; lf="$(_exec_logfile "$name")"
  printf '%s' "$4" > "$pf"
  cmd="$AGENT_CMD"
  cmd="${cmd//\{name\}/$name}"; cmd="${cmd//\{model\}/$model}"; cmd="${cmd//\{cwd\}/$cwd}"
  cmd="${cmd//\{prompt_file\}/$pf}"; cmd="${cmd//\{log_file\}/$lf}"
  printf '\n=== %s · %s ===\n' "$(now)" "$name" >> "$lf"
  nohup bash -c "cd '$cwd' && exec $cmd" >> "$lf" 2>&1 &
  pid=$!
  echo "$pid" > "$(_exec_pidfile "$name")"
  echo "$pid"
}

runner_list() { # only processes that are actually alive
  local f name pid out='[]'
  _exec_dirs
  for f in "$RT"/pids/*.pid; do
    [ -f "$f" ] || continue
    name="$(basename "$f" .pid)"; pid="$(cat "$f")"
    kill -0 "$pid" 2>/dev/null || continue
    out="$(printf '%s' "$out" | jq -c --arg n "$name" --arg p "$pid" \
      '. + [{name: $n, id: $p, pid: ($p | tonumber), status: "busy", state: "working", cwd: null}]')"
  done
  printf '%s' "$out"
}

runner_stop() { # id is the pid
  local i=0
  kill -0 "$1" 2>/dev/null || return 0
  kill -TERM "$1" 2>/dev/null || true
  while kill -0 "$1" 2>/dev/null && [ $i -lt 20 ]; do i=$((i + 1)); sleep 0.5; done
  kill -0 "$1" 2>/dev/null && kill -KILL "$1" 2>/dev/null || true
}

runner_forget() { # drop the pid file that holds this id
  local f
  for f in "$RT"/pids/*.pid; do
    [ -f "$f" ] && [ "$(cat "$f")" = "$1" ] && rm -f "$f"
  done
  return 0
}

runner_attach() { # follow that agent's log
  local f
  for f in "$RT"/pids/*.pid; do
    [ -f "$f" ] && [ "$(cat "$f")" = "$1" ] && exec tail -f "$(_exec_logfile "$(basename "$f" .pid)")"
  done
  die "no running session with id $1"
}
