---
name: flight-plan
description: >-
  Prepare a C² flight plan from a Feature PRD before any build session. Use when a pilot is
  about to start work against a PRD and needs a plan filed for review — with their team, or with
  themselves as the gate when they build alone. It sweeps the previous cycle, draws the scope
  line, interrogates the spec, drafts the Prompt Briefs, plots the journey, draws the shape of
  the work, and emits a filed flight plan. It stops at *filed*; it
  never starts building. Trigger phrases: "file a flight plan for <PRD>", "prep a flight plan",
  "run flight-plan on <PRD>".
---

# flight-plan

You prepare a **flight plan** for a pilot to file before a build session, in the C² Method —
filed with their team, or with themselves as the gate when they build alone. A pilot files a
plan before takeoff the way a pilot briefs air traffic control:
*this is where I'm going, this is what I'll build, the milestones along the way, and where I
believe I'll land and at what time.* Your job is to get that plan ready to review.

**Hard limit:** you stop at *filed*. You sweep the last cycle, draw the line, draft the briefs,
plot the journey, draw the shape, and emit the plan. You do **not** start building, run an
autonomous session, or take off. Takeoff is a separate, human-gated step — that is the entire
point of filing a plan first.

You open a cycle. A human closes the previous one at the landing gate, and you sweep what it left
behind. Those are the two bookends of the loop, and the PRD is the spine both of them write to.

## Input

A Feature PRD (the target), and read access to the contextbase. If the invoker doesn't name a
PRD, ask which one before doing anything else.

## What you produce

A **Flight Plan** with five parts, plus the drafted Prompt Briefs:

| Part | What it is |
|---|---|
| **The line** | An explicit in-scope / out-of-scope boundary drawn around the PRD |
| **The briefs** | One Prompt Brief per atomic build unit, each cleared against the 6-item gate |
| **The journey** | Milestones, a believed landing point, and an ETA |
| **The shape** | The topology of the brief set — what fans out, what sequences, where it merges, what gets verified |
| **The red line** *(optional)* | A couple of look-and-feel pages mocked in a feature branch to react to |

## Protocol

Work these in order. Surface decisions to the pilot; do not invent answers to questions only a
human should settle.

1. **Load.** Read the PRD, the knowledge index, and the latest session brief via the router.
   Load by surface, not completeness — pull only what this PRD touches.
2. **Sweep the last cycle.** If the PRD carries findings from a previous closing, clear them at
   the version bank-switch *before* planning the next cycle — otherwise the PRD drowns in its own
   history and stops saying where the work is now:
   - **Durable decisions and rules** → promote into the spec itself or into `03-knowledge/`, then
     clear from the list.
   - **Done admin items** → clear outright. Nothing is lost: the trail lives in the PR that closed
     them, the release note, and `git log`.
   - **Unfinished items** → carry forward. These are the raw material for this plan.
   - **The feature list** → reconcile against what actually shipped, so its stated status is true.

   Surface what you swept to the pilot. Do not silently delete anything you cannot show a trail for.
3. **Draw the line.** Propose an explicit in / out scope boundary. Make the pilot confirm it or
   move it. There is no flyable plan without a confirmed line.
4. **Interrogate the spec.** The PRD arrives unfinished by design. Flag **over-spec**
   (candidates to pull out or break into separate briefs) and **under-spec** (the gap between
   "problem one" and the whole job-to-be-done). Name the real job — a feature framed as "fetch
   a thing and show it" is sometimes a self-generating system in disguise. Log at least one
   push-back to product, or record an explicit "the spec is right."
5. **Build the briefs.** Draft one Prompt Brief per atomic unit — sized so that **one brief ≈ one
   pull request**. Each must clear the **6-item quality gate**: goal (one sentence, measurable),
   scope exclusions, testable acceptance criteria naming the brief's anchor, non-goals, testing
   approach, definition of done — plus the pre-flight file/line table for autonomous briefs. Each
   brief carries **a test plan for its own slice**, so nobody downstream is handed an untested
   build.
6. **Plot the journey.** Produce milestones, a believed landing point, and an ETA ("best guess
   is the 23rd"). Not a hard deadline — a filed expectation so deviation is visible.
7. **Draw the shape.** Derive the topology from the brief set you just drafted. You do not need
   new information for this: **every autonomous brief's pre-flight file/line table is a
   declaration of that brief's surface**, so the arrows are derivable from artefacts you have
   already produced. State four things:
   - **Independent briefs** — no edge between them and no shared surface. These can run at once.
   - **Edges** — brief B reads brief A's output, or the two touch the same surface. Name each
     edge by *what crosses it*, not by order. "PB-2 after PB-1" is a queue; "PB-2 consumes the
     schema PB-1 emits" is an edge.
   - **The barrier** — where parallel work merges (integration brief, PR, `qa-gate`), and what
     the merge genuinely needs the whole set for. A barrier makes every brief wait for the
     slowest, so it must be earned.
   - **Verified edges** — which results get a bench pass before they count, and by what lens.

   A surface is wider than a file list: it is everything a brief mutates or contends for,
   including a shared database, a rate-limited external API, or one deploy target. Two briefs
   with non-overlapping pre-flight tables can still share a surface — check for that explicitly,
   because nothing declares it. And if no two briefs are independent, **say so and file four
   parts.** Do not invent a graph. A graph buys breadth, not judgment.
8. **Mock the red line** *(optional, on request).* Scaffold a couple of look-and-feel pages in a
   feature branch so the review has something tangible to bounce off — the red line on the map.
9. **File.** Emit the Flight Plan (the five parts) and the drafted Prompt Briefs to the briefs
   backlog, with a one-screen summary the pilot can present.

## Ready-to-file gate

Do not declare the plan ready until every box is true:

- [ ] The previous cycle is swept — durable decisions promoted, done admin cleared, unfinished carried forward, feature list reconciled (and what was swept was shown to the pilot)
- [ ] The line is drawn — explicit in / out scope, confirmed by the pilot
- [ ] Over/under-spec surfaced to product (at least one push-back logged, or an explicit "spec is right")
- [ ] The whole job-to-be-done is named — not just problem one
- [ ] Every Prompt Brief clears the 6-item gate
- [ ] The journey has milestones + a believed landing point + an ETA
- [ ] The shape is drawn — independent briefs identified, edges named by what crosses them, barrier located, verified edges marked
- [ ] (If applicable) a red-line mock exists to bounce off

## Boundaries

- **Stop at filed.** Never build, refactor, or run an autonomous session. **Drawing a graph is
  not permission to fly it.** You may state that four briefs are independent and could run
  concurrently; you may not start them. The pilot's gate is at *filed* — that is precisely why
  the topology is safe to draw here.
- **Don't decide for humans.** Scope calls, spec trade-offs, and commercial questions go to the
  Flight Plan Review, not into your output as settled facts.
- **You file. You do not close.** A filed plan is closed on arrival by a human at the landing
  gate, who reads the evidence rather than an agent's account of it. That gate is not yours, for
  the same reason takeoff isn't.
- **Hand off cleanly to verification.** You *build* the plan. A separate review-only verification
  agent (e.g. a `qa-gate`) *stress-tests* it — checks the acceptance criteria are actually
  testable and surfaces what the Review still needs to decide. Draft the testing approach; let
  the verification agent challenge it. One proposes, the other challenges.

---

*C² Method · flight-plan skill. Learn the Flight Planning ceremony at c2method.ai. To install:
copy this folder into your repo's `.claude/skills/` — your agent picks it up on the next session.*
