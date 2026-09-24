# C² Fleet: `.fleet`

Run a C² repo with a fleet of agents. Each PRD gets its own agent (a **lane**) in its own
terminal and worktree. A **tower** (repo-ops) runs the fleet and does all merging. A
**checkpoint** (pr-review) reviews every PR in a fresh context. Each lane loops
*gap → brief → build → PR → review → merge → close* until its PRD's acceptance anchors pass, then
lands. Bump the PRD's version and the lane flies again.

**New to it? [`ADOPTING.md`](ADOPTING.md)** is the 20-minute path to a fleet on your own repo.

**[`RULES.md`](RULES.md) is the canon** — the rules every agent follows, each with the failure
that wrote it. Read that first; the rulebooks in `skills/` enforce them.

The design and the reasoning are in the PRD:
[`docs/01-planning/product-requirements/fleet-prd.md`](../docs/01-planning/product-requirements/fleet-prd.md).

## Install

Needs `git`, `jq`, `gh` (logged in) and an agent CLI. Claude Code ≥ 2.1.278 works out of the
box; for Codex, Gemini, Grok or anything else see [Using an agent other than Claude
Code](#using-an-agent-other-than-claude-code). No tmux.

```bash
ln -s "$PWD/fleet/bin/fleet" ~/.local/bin/fleet              # the CLI
claude --plugin-dir "$PWD"                                   # /fleet + every C² skill in a session
```

## Fly

```bash
cd your-c2-repo
fleet init                                     # .fleet/ + gitignore the lane worktrees
fleet enlist docs/01-planning/prds/purchasing.md --files 'apps/purchasing/**' --data 'migrations/*purchasing*' --priority 1
fleet enlist docs/01-planning/prds/eom.md --files 'apps/eom/**' --priority 2
git add .fleet .gitignore && git commit -m "fleet: enlist purchasing, eom"
fleet preflight                                # all ✓?
fleet launch                                   # tower, checkpoint, lanes up to the ceiling (default 3)
fleet radar                                    # the board
```

A PRD needs `prd_id:` and `version:` in its frontmatter and an acceptance section whose items
name their anchors.

## Commands

| Command | What it does |
|---|---|
| `fleet candidates` | Every PRD that could fly, and what each still needs |
| `fleet preflight` | Checks the machine and repo. Changes nothing |
| `fleet launch` | Tower + checkpoint + one lane per enlisted PRD, staggered, up to the ceiling |
| `fleet radar` | Every lane's state, what it says, PRD version, items, PR, heartbeat, then **waiting on pilot** |
| `fleet enlist <prd.md> --files …` | Adds a PRD. Refused if the PRD is invalid or a surface overlaps (use `--after <prd>` to sequence two lanes that share one) |
| `fleet decide "<ruling>"` | Records a pilot decision agents can verify, instead of trusting a relay |
| `fleet scale <n>` | Sets how many lanes fly at once. The pilot can raise it any time; it warns if things aren't healthy |
| `fleet hail <prd\|all\|tower\|checkpoint> "msg"` | Message a lane |
| `fleet cockpit <prd>` / `fleet tower` | Open that agent's terminal |
| `fleet wake <prd>` | Fly a landed or failed lane again |
| `fleet land <prd> [--retire]` | Land one lane safely (`--retire` also removes it from `lanes.json`) |
| `fleet ground` / `fleet ground --now` | Land everything safely / kill switch: stop every session now |
| `fleet blackbox [prd]` | The decision log |
| `fleet reconcile` · `fleet brief <prd>` · `fleet beat <prd> <status>` | Plumbing the tower and lanes use |

Inside Claude Code, `/fleet <verb>` runs the same commands and also pushes lane messages live.
Idle agents only wake on a message.

## What lives where

| | Where | Committed |
|---|---|---|
| Fleet config, lane list and surfaces | `.fleet/fleet.config`, `.fleet/lanes.json` | yes |
| PRDs | wherever the repo keeps them | yes |
| Roster, lane state, inboxes, decisions log | `~/.fleet/<instance>/` | no: live, shared by every worktree |
| Lane worktrees | `.claude/worktrees/<prefix>-<prd>` on branch `fleet/<prefix>-<prd>` | ignored |
| What lanes learn | gotchas and session briefs, merged with each PR | yes |

## Kit layout

The skills and the `/fleet` command live at the **repo root**, not in here, so the whole kit is
one plugin with one skills directory:

```
../skills/       c2-fleet (the pilot's agent) · c2-fleet-protocol (lanes) · c2-repo-ops (tower)
                 c2-pr-review (checkpoint) · c2-gardener · flight-plan (the method skill)
../commands/     fleet.md — the /fleet slash command

fleet/
├── bin/fleet                  dispatcher
├── lib/                       common, roster (single writer), lanes, reconcile, commands
│   ├── runner-claude.sh       Claude Code background sessions (strips CLAUDE* env; see gotchas)
│   ├── runner-exec.sh         any other agent CLI (Codex, Gemini, Grok, …) via AGENT_CMD
│   └── runner-fake.sh         no-token runner for the tests
├── templates/                 fleet.config.example
└── test/                      acceptance.sh (fake runner) · runner-exec.sh
```

## Using an agent other than Claude Code

The method is agent-agnostic and so is the kit. Everything the fleet knows lives in files
(PRDs, `lanes.json`, the roster, lane state, inboxes), so any agent that can read a prompt and
use a shell can fly a lane. Two runners ship:

| Runner | For | Set |
|---|---|---|
| `claude` (default) | Claude Code | nothing |
| `exec` | Codex, Gemini CLI, Grok, Aider, opencode, a local model, anything with a CLI | `FLEET_RUNNER="exec"` and `AGENT_CMD` in `.fleet/fleet.config` |

```bash
FLEET_RUNNER="exec"
AGENT_CMD='codex exec --model {model} --cd {cwd} "$(cat {prompt_file})"'
# gemini: AGENT_CMD='gemini --model {model} --yolo --prompt "$(cat {prompt_file})"'
# grok:   AGENT_CMD='grok --model {model} --prompt "$(cat {prompt_file})"'
```

Placeholders: `{name} {model} {cwd} {prompt_file} {log_file}`. The exec runner starts the agent
in its own worktree, keeps a pid and a log per lane, restarts it when it dies, and `fleet
cockpit <prd>` follows its log.

**What you give up without Claude Code:** no live message to wake an idle agent, and no
busy/idle signal. Neither breaks the fleet, because the state is in files: a lane that has
stopped is simply started again and reads its way back to where it was. With `exec`,
`fleet hail` writes the inbox and the lane picks it up on its next run.

**Mixing runners** (say Claude for the tower and Codex for lanes) needs one more adapter per
agent; a runner is picked per fleet today.

**Writing your own runner:** add `lib/runner-<name>.sh` with six functions — `runner_check`,
`runner_spawn name cwd model prompt` (prints an id), `runner_list` (JSON array of
`{name,id,pid,status,state,cwd}`), `runner_stop id`, `runner_forget id`, `runner_attach id` —
and set `FLEET_RUNNER=<name>`. The rulebooks in `skills/` are plain markdown that any agent can
be pointed at; only the Claude runner loads them as installed skills.

## Test

```bash
fleet/test/acceptance.sh        # 48 checks on a fake runner, no tokens
fleet/test/runner-exec.sh       # the exec runner against a stand-in agent
```
