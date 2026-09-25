# Changelog — The C² Method

The method is versioned the way it asks your PRDs to be: each version **absorbs** the last, so
this file says where C² is *now*, built on its history rather than restarting from it.

---

## v1.4.3 — lanes start from the remote (2026-09-25)

A lane's worktree branched from the **local** base branch, which in a working checkout is
whatever it was last time someone checked it out. On the repo this was found in, local `main`
was 11 commits behind `origin/main` — so every lane would have built on stale code and planned
against a stale PRD, and nothing would have looked wrong.

Lanes now branch from `origin/<base>` after a fetch, falling back to the local branch when there
is no remote. `fleet preflight` says which one it will use, and how far behind local is.

60 acceptance checks. Mutation-checked against a real remote.

## v1.4.2 — one checkout, one runtime (2026-09-25)

Found by enlisting two lanes on a real repo:

- **The CLI targeted the wrong repo from a worktree.** A lane calling from its own worktree
  should mean the main checkout; anyone else means the checkout they are standing in. A pilot
  preparing an enlist on a branch was silently retargeted at main, reading the wrong PRD.
- **`enlist` spawned.** On a launched fleet it flew lanes immediately, from whatever checkout ran
  it — two were nearly flown from a throwaway clone while rostered in the shared runtime. Adding
  a PRD to the list and putting an agent in the air are two decisions, and only one is reversible
  by editing a file. Enlisting no longer spawns, and anything that does refuses from a checkout
  the runtime was not built from.
- **A failed lane lost its slot**, so a lower-priority lane quietly overtook it. It holds its
  place until the pilot wakes or retires it.

59 acceptance checks, 7 exec-runner checks. Each new test mutation-checked — three were vacuous
on the first attempt, which is the rule earning its keep on the kit's own tests.

## v1.4.1 — the fix (2026-09-25)

Three bugs in the fleet kit, all found by running it rather than reading it:

- **Twin lanes.** `claude --bg` colours the session id when run from inside a session, so the
  stored id never matched the plain one the API returns. A live lane looked lost, and reconcile
  spawned a second. Deterministic, not flaky.
- **Blind liveness.** The liveness check answered "nothing is running" when it meant "I could not
  look" — one transient failure would have respawned an entire fleet. It now fails closed.
- **A red suite nobody saw.** On macOS the tests were 13 of 38 under the default `TMPDIR`, since
  `git rev-parse` returns `/private/var/…` while `pwd` returns `/var/…`. They had always been run
  with a pre-resolved path, so the green was an artefact of one shell.

Also: `fleet preflight` now checks workspace trust, which Claude Code 2.1.282 requires before
`--bg` will start anything; a spawn the environment refuses no longer spends a lane's respawn
budget; and `fleet land tower|checkpoint` works, so a role can be restarted to pick up config.

52 acceptance checks, 7 exec-runner checks, each new one mutation-checked.

## v1.4 — the fleet (2026-09-23)

**A repo can now be run by a fleet of agents.** One agent per PRD, each in its own worktree, a
lead that merges and keeps the base branch green, and a reviewer that checks every pull request
in a fresh context. Ships as [`fleet/`](fleet/) — a CLI, five role skills, a `/fleet` command,
and the rules the agents follow.

- **[`fleet/ADOPTING.md`](fleet/ADOPTING.md)** — 20 minutes to a fleet on your own repo.
- **[`fleet/RULES.md`](fleet/RULES.md)** — 9 rules, each written after a real failure on a real
  build, with the story attached. They are the reason the kit exists: what a fleet needs is not
  more agents, it is agents that stop when they should.
- **Anchors become load-bearing.** A PRD joins a fleet only when its acceptance items name a
  signal that can actually fail. Without one, "done" is whatever the agent says.
- **Surfaces, not just files.** A lane declares everything it changes or competes for — files,
  data, external resources. Two lanes may not share one; `--after` sequences them.

**Status: experimental.** 2 repos, 12 merged pull requests, and one thing still unproven —
width. Every run so far has been 1 or 2 lanes, so genuine contention between concurrent lanes
has never happened. Start at 2 or 3, and read what it costs before widening.

Kit version: `0.2.0`.

## v1.3 — topology (2026-08-02)

The Cascade is a graph, and the method says so. Agents may run concurrently exactly when no edge
connects them and no surface is shared — a *surface* being everything an agent mutates or
contends for, not merely a file. Flight Planning emits the shape of the work, not just a
schedule. Anchors: the signals that decide done, which no agent can produce by asserting them.
Cost governance for fan-out: spend the expensive model where judgment lives, and earn every
barrier.

## v1.2 — compaction

Three mechanisms keep context lean: the session brief (point in time), the Router (continuous),
and the Learn loop (capture → consolidate). The PM Ambassador pattern.

## v1.1 — the gates

The gotcha-capture gate and CI coverage gate made unskippable. Flight Planning's closing
ceremony: what was learned flows back onto the PRD.

## v1.0 — the method

P = aic². The codebase and the contextbase. The Cascade: Platform PRD → Feature PRD → Prompt
Brief → Task. The Pilot model. The six Principles. Agent-agnostic, plain markdown, in git.
