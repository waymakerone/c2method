# Putting a fleet on a repo

Twenty minutes for the first one, five for the next. This is the order that works, and the
two places people get stuck.

## Once per machine

```bash
# from wherever you cloned the C² kit
ln -s "$PWD/fleet/bin/fleet" ~/.local/bin/fleet
```

Claude Code ≥ 2.1.278 (or any agent CLI — see the README's runner section), plus `git`, `jq`
and `gh` logged in.

## Once per repo

```bash
cd your-repo
fleet init                      # .fleet/ + a fleet section in the router
gh label create fleet:review; gh label create fleet:approved; gh label create fleet:changes
```

Then open `.fleet/fleet.config` and set the four that actually matter:

```bash
LANE_CEILING=2                # start at 2 or 3. It is a trust dial, not a capacity limit
MERGE_REQUIRES_PILOT=true     # on any repo where a merge deploys
DRAFT_PRS=true                # if anything else in the repo merges PRs — a bot, a watcher loop
NEVER_TOUCH="..."             # the repo's dangerous edges: migrations, workflows, published
                              # packages, edge functions, routers, env files
```

`NEVER_TOUCH` is the one people skip and regret. Write it before the first launch, not after a
lane touches something expensive. Ask the person who knows the repo best what would be costly
even in an unmerged PR — that is the list.

## Per PRD, before it can be a lane

A PRD joins the fleet when it has three things:

```yaml
---
prd_id: purchasing          # stable slug; the lane is named after it
version: 1.0                # bump this and the lane re-plans. This is the growth trigger
---
```

...plus an **acceptance section whose items name their anchors**. An anchor is the signal that
decides done, and it has to be something that can fail:

```markdown
- **PUR-1 · Quote PDF export.** …
  *Anchor:* `npm test -- quote-pdf` passes, green in CI.
```

**A PRD with no anchors cannot be flown.** Not a technicality: without one, "done" is whatever
the agent says, and you have bought nothing. If a PRD has no testable signal, that is a
conversation with yourself about the spec, not a fleet problem.

Then enlist it. The surface is everything the work touches — **including where the anchor
lives**: the script the check runs, the component that renders the thing, the test.

```bash
fleet enlist docs/prds/purchasing.md --files 'apps/purchasing/**,scripts/check-purchasing.ts' \
  --data 'migrations/*purchasing*' --priority 1
fleet enlist docs/prds/eom.md --files 'apps/eom/**' --priority 2 --after purchasing
git add .fleet && git commit -m "fleet: enlist purchasing, eom"
```

Two lanes may not share a surface. If they must, `--after` sequences them.

## Fly

```bash
fleet preflight      # all ✓ before anything starts
fleet launch
fleet deck           # then in the IDE: Run Task → "Fleet: open the deck"
fleet radar          # the board, ending with what is waiting on you
```

## The two places people get stuck

**1. Surfaces too narrow.** The lane stops on its first pass with a blocker, because the anchor
lives somewhere it cannot write. That is the system working, and it costs a cycle. Widen with
another `fleet enlist` and hail the lane.

**2. Nothing wakes an idle agent but a message.** `fleet hail` writes the inbox and prints a
`✉` line. Whoever ran it — the tower, the checkpoint, or `/fleet` in your own session — must
also send a live message. Skip that and work sits until the next tick.

## What to expect on the first run

- A lane will hit the edge of its surfaces and stop. Good.
- A lane will ask for something only you can supply — a key, an account id, a decision. It
  should raise a blocker, never invent a value. If it invents one, that is a bug worth reporting.
- The reviewer will bounce work that looks fine. Read the reason before overriding it.
- The first cycle finds things nobody was looking for. On the two runs so far: a lint script
  broken repo-wide for a month, a fabricated affiliate tag, an unwired migration, a test harness
  that could reach production, and a 200 response that meant failure.

## What it costs

Every agent boots with ~20-30k tokens of context, and idle ticks are not free — the tower and
checkpoint back off after 3 quiet ticks for exactly that reason. Start at 2-3 lanes and measure
before widening. The limit is how much you can review, not how many agents will run.

## The rules

Read [`RULES.md`](RULES.md) once. Every rule there came from a real failure, with the story
attached. You do not need to teach them to the agents — the rulebooks carry them — but knowing
what they are tells you what the fleet will and will not do on your behalf.
