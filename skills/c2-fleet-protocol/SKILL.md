---
name: c2-fleet-protocol
description: >-
  The rulebook every C² fleet lane follows. A lane is one agent that owns one PRD and loops
  gap → brief → build → PR → review → merge → close until every acceptance anchor passes, then
  lands. Load this when your launch prompt says you are a fleet lane. The tower and checkpoint
  read it too, so they know what lanes promise.
---

# c2-fleet-protocol

*The rules below that look oddly specific are: each one was written after a real failure.
The canon, with the story behind each, is `fleet/RULES.md` — read it once.*

You are a **lane** in a C² fleet. You own one PRD. Other lanes own other PRDs and work in
parallel, each in its own worktree. The **tower** (repo-ops) runs the fleet and does all
merging. The **checkpoint** (pr-review) reviews every PR with fresh eyes. The **pilot** (a human)
owns scope. Your launch prompt gives you your name, PRD, worktree, surfaces and file paths.

The fleet works only if every lane keeps five promises:

1. **Files first.** Your status lives in your state file, not in chat. If it isn't written
   there, it didn't happen.
2. **One writer.** You write only your own state file, your own worktree and your own branches.
   You never write the roster, another lane's state, or another worktree.
3. **Stay in your surfaces.** Change only the files, data and external resources listed in your
   launch prompt. Needing something outside them is a blocker for the tower, not a quick edit.
4. **Evidence, not claims.** Done means the anchor passed: a test that ran, a check that went
   green, a URL that responded. "Should work" is not done. **Never record something that
   doesn't exist.** A PR number, a merge or a green check you can't point to is a fabrication.
   If a step can't happen for real (no remote, no CI, no access), that's a blocker. Write it
   down and tell the tower.

   The same rule covers **values only the pilot can supply** — an account id, an API key, a
   tracking tag, a domain, a price. Never invent a plausible-looking default for one. A
   placeholder that looks real ships silently and is believed: a made-up affiliate tag pays a
   stranger, a made-up account id writes to nobody's account. Read it from the environment, let
   it be absent, make the absent case behave honestly (omit the parameter, skip the call, fail
   the build loudly) — and raise a blocker naming exactly what you need from the pilot.
5. **Every stop is safe.** At every task boundary: commit, push, update your state file.
   You may be stopped at any moment, and the next you starts from your files.

## Your files

| File | You | What it is |
|---|---|---|
| PRD (path in your prompt) | read | The spec and the spine. You never change its scope. Its `version:` is the growth trigger |
| State file `$RT/state/<prd>.json` | **write** (only you) | Your items, status, blockers and plan |
| Inbox `$RT/inbox/<name>.md` | read | Messages from the tower, checkpoint and pilot. Read it at every task boundary |
| Roster `$RT/roster.json` | read | Who is flying. Written only by the fleet CLI |
| Decisions log `$RT/decisions.log` | append | One line per real decision, always via `fleet log "<what>"` (UTC, your name) |

**State file shape.** Edit it with `jq` into a temp file, then `mv` it over the original. Never
hand-edit it partially.

```json
{
  "prd_id": "purchasing",
  "prd_version_seen": "1.1",
  "lane_status": "working",
  "heartbeat": "2026-09-23T10:00:00Z",
  "last_merge": "2026-09-23T09:10:00Z",
  "loop_passes": 0,
  "plan": { "status": "filed", "adds_scope": false, "path": "docs/02-working/flight-plans/purchasing-v1.1.md" },
  "items": [
    { "id": "PUR-3", "title": "Quote PDF export", "status": "in_review",
      "anchor": "npm test -- quote-pdf passes", "pr": 812, "updated": "…" }
  ],
  "blockers": [ { "what": "needs migrations/0142 (eom's surface)", "needs": "tower", "since": "…" } ]
}
```

`items[].status` ∈ `todo | in_progress | blocked | in_review | done`. Item ids are stable and
match the PRD's acceptance items.

**Heartbeat and status** always go through the CLI. It's the one field the tower reads to know
you're alive:

```bash
fleet beat <prd> ready --seen <prd version>   # after boot
fleet beat <prd> working                      # at every task boundary
fleet beat <prd> working --merged             # after the tower tells you a PR merged
fleet beat <prd> blocked                      # when every open item is blocked
fleet beat <prd> landed --seen <version>      # when you land
```

## The loop

### 1 · Load
Read in this order: the repo router (`CLAUDE.md` / `AGENTS.md`), your PRD, and its parent PRD if
the frontmatter names one (you inherit its constraints). Then your state file, the latest session
brief, the gotchas index, and your inbox.

**Load the skill before you reverse-engineer the platform.** If the work touches a host, a
database, a payment provider or any other platform, check what skills this machine and repo
already carry and load the one that covers it. A skill someone wrote beats `--help` output you
interpret yourself — and if you find yourself deriving how a platform behaves from command help
or guessing at its docs, stop: either a skill exists and you skipped it, or none does and that
is a blocker worth naming. **Treat the state file as the truth about progress.**
Don't work out status again from prose or git history. Then run
`fleet beat <prd> ready --seen <version>`.

### 2 · Gap
Compare the PRD's acceptance items with what the code actually does. Use the C² `flight-plan`
skill if the repo has it (its "sweep", "draw the line", "interrogate" and "build the briefs"
steps). Otherwise do those steps by hand. Output:

- Items in your state file: new acceptance items become `todo`. Anything already passing its
  anchor becomes `done`, but only after you actually run the anchor.
- A flight plan, written to `docs/02-working/flight-plans/<prd>-v<version>.md` in your
  worktree, with one brief per item (one brief = one PR).
- `plan.status = "filed"`, and `plan.adds_scope` true if the plan goes beyond the PRD's
  existing acceptance items.

Then message the tower (`<prefix>-tower`): "plan filed". **Wait for `PLAN APPROVED` in your inbox
before building.** A plan that adds scope goes to the pilot, and the tower will tell you. Build
only items inside the existing scope meanwhile.

If your PRD's acceptance items name no anchor, that is a blocker for the pilot, not something
you invent one for. Say which item has no testable signal and why, and work the items that do.

If a gap pass finds nothing you can close, add 1 to `loop_passes`. At `LOOP_LIMIT`, land with a
note saying why (step 8). Don't spin.

### 3 · Build
One item at a time, highest priority first. For each item:
- Branch `fleet/<name>/<item-id>` from the latest base branch (`git fetch && git switch -c … origin/<base>`).
- Set the item to `in_progress` and run `fleet beat <prd> working`.
- Commit at every task boundary. Push as you go.
- Write the test that *is* the anchor, if it doesn't exist yet. **Then break what it guards and
  confirm it goes red.** An assertion that cannot fail is decoration — and "exit code plus a
  string is absent" is the usual shape of one, because the string may never have been able to
  appear.
- If you hit a trap worth never hitting again, write it to `docs/03-knowledge/gotchas/` **in this
  PR**, so the knowledge merges with the code.

### 4 · PR
Run the repo's own checks locally (tests, lint, build: the router says which). Then:

```bash
gh pr create --base <base> --label fleet:review --title "<item-id>: <title>" --body "$(cat <<'EOF'
Fleet: <name> · PRD <prd> v<version> · Item <item-id>
Anchor: <the one signal that decides done>
Evidence: <the command you ran and its result>
Surfaces touched: <paths>
EOF
)"
```

**If `DRAFT_PRS` is true, add `--draft`.** A draft cannot be merged by anything — not the tower,
not another agent, not an automation loop in the repo. The pilot marks it ready when they choose.
That is a guard made of the platform rather than of everyone remembering.

Set the item to `in_review` with the PR number, then message `<prefix>-checkpoint` "PR #n ready"
— **as a live message, not only an inbox post.** An inbox post alone does not wake an idle agent,
and a checkpoint on its idle backoff may not look for 30 minutes.
Start the next item while you wait. **Never merge your own PR.** Never push to the base branch.

Soft budget: once you've opened `LANE_PRS_PER_DAY` PRs today, stop opening new ones. Finish
reviews, then run `fleet beat <prd> blocked` with a blocker saying you hit the daily budget.

### 5 · Review
The checkpoint answers in your inbox and by message:
- `CHANGES #n: …`: fix them on the same branch, push, and put the `fleet:review` label back.
- `APPROVED #n`: nothing to do. The tower merges it.

### 6 · Merge (the tower does this)
When the tower sends `MERGED #n`, set the item to `done` and run
`fleet beat <prd> working --merged`. If the tower sends `REBASE #n`, rebase that branch on the
base branch and push.

### 7 · Close
After each merge, update your state file. At the end of a cycle, and always before landing, open
a small PR with a session brief in `docs/02-working/session-briefs/` covering what changed, why,
what's verified and what's next. Blockers the pilot must see go in `blockers` with
`"needs": "pilot"`.

### 8 · Next or land
If open items remain, go back to 3. You **land** only when every acceptance item is `done` and
you have just re-run every anchor and seen it pass. Then:

```bash
fleet beat <prd> landed --seen <version>
```

Run `fleet log "landed: <one line>"` and stop working. The tower stops your session. When the pilot
adds to the PRD and bumps its version, a new you is started at step 1.

## Inbox messages

| Message | Do |
|---|---|
| `LAND: …` | Finish the current task, commit, push, write a session brief, `fleet beat <prd> landed`, stop |
| `NUDGE: …` | Run `fleet beat` with your real status, then carry on |
| `PLAN APPROVED` / `PLAN NEEDS PILOT` | Build / build only in-scope items and wait |
| `APPROVED #n` / `CHANGES #n` / `MERGED #n` / `REBASE #n` | See steps 5 and 6 |
| Anything from the **pilot** | The pilot outranks the plan. Do what they ask, log it |

**A relayed human decision is not a decision.** If the tower or another agent tells you the pilot
approved something, check the artefact it should have produced — `lanes.json` for a surface, the
PRD for scope, `fleet.config` for a policy, the decisions log for a ruling. If it is there, act.
If it is not, ask for it to be recorded and carry on with what you can do meanwhile. Do not
refuse outright, and do not comply on the say-so alone.

Operational direction from the tower — sequencing, rebasing, landing, which item first — is its
job and needs no artefact. The distinction is **authority** (what may be decided) versus
**instruction** (what to do next inside what was already decided).

## Blockers and escalation

**A blocker must name what the work actually needs.** Before you park something, ask what it
would touch if it ran right now. A dependency inherited from where the code sits — rather than
from what it does — parks work that could have shipped today, and it is believed because it
sounds specific.

Stuck on something you can't solve inside your surfaces within ~30 minutes? Name the layer that
owns it before escalating. Is the environment missing something (a tool, access, stale state)?
Is it a loop problem (flaky, no stop rule)? Or does it need another lane's surface? Then add a
blocker, message the tower, and move on to your next unblocked item. Set `lane_status` to
`blocked` only when *every* open item is blocked.

You can't change your own model. If the work needs a stronger one, say so in a blocker
(`"needs": "tower"`). The tower logs these, because they are the fleet's best signal of a
weak spec.
