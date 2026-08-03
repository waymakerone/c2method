---
id: [generate]
title: "Closing — [PRD / Feature Name]"
type: flight-plan-closing
prd_ref: [PRD id or path]
plan_ref: [the filed flight plan this closes]
status: open
closed_by: [who owns the intent] + [who owns the implementation]
created: YYYY-MM-DD
closed: YYYY-MM-DD
tags: [flight-planning, closing]
---

# Closing — [PRD / Feature Name]

> **The landing gate.** A filed flight plan must be closed on arrival. This is the moment where
> what was filed is reconciled with what landed, and someone with the authority to reject says
> *this is done* or *this is not.* Not a demo. Not a retro. A gate.
>
> **Throwaway, like the plan.** This is a meeting agenda, not a third source of truth. The PRD,
> its briefs, and the contextbase hold the truth. Fold the decisions back into them and bin this.

---

## 1 · The landing

*"This is what I said I'd build; this is what landed."*

| The line as filed | What landed |
|---|---|
| in: [scope in] | [what shipped] |
| out: [scope out] | [anything that crept in, and why] |

**Briefs filed:** [PB-1, PB-2, …] — **completed:** [which] — **still open:** [which, and where they went]

---

## 2 · The deviation

*"Here's where I flew off the filed route, and what I decided in the air."*

Zero judgment. The plan exists to make drift visible, not to punish it.

| Where the route changed | The call I made | Why |
|---|---|---|
| [e.g. PB-3 grew a migration] | [what was decided] | [what forced it] |

**Did the shape hold?** [Did the briefs that were filed as independent stay independent? Any
surface that turned out to be shared and wasn't declared?]

---

## 3 · The anchor

*"Here's the signal, not my account of the signal."*

The evidence that decides done. Something no agent in the run can produce by asserting it.

- [ ] **[The anchor named in the brief]** — [the actual result: tests run and passed, the query
      that returned rows, the deploy that resolved, the metric that moved]
- [ ] Acceptance criteria verified against the anchor, not against the agent's report
- [ ] `qa-gate` (or equivalent) verification matrix attached: [link] — GREEN / RED

> "The agent says it is done" is not a stop condition. Do not loop on confidence. Loop on evidence.

---

## 4 · The learning

*"Here's what the next session shouldn't have to rediscover."*

This is why the ceremony exists — the contextbase does not write itself at the moment a team
feels finished.

### The findings — written back onto the PRD

Not into this doc. This doc gets binned. **Findings land on the PRD in one section**, structured
so they survive the room and can be swept later:

| ID | FIX / ADD | Surface | Finding | Raised by |
|---|---|---|---|---|
| BR-1 | FIX | [surface] | [what's wrong today] | [who] |
| BR-2 | ADD | [surface] | [new capability the review surfaced] | [who] |

- **FIX** is wrong today. **ADD** is a new capability. Don't conflate them — that's how a bug list
  turns into a roadmap and nothing gets fixed.
- **Flag the keystone** — the one that unblocks the rest — and sequence from there: keystone,
  then the trust fixes, then the high-value adds, then the design pass.
- **The PR that resolves one references its ID** (`closes BR-2`), so the trail runs
  review → PRD → PR → shipped and is auditable from git alone.
- These are the **seed for the next flight plan**, which will also sweep whatever is left.

**Keystone:** [BR-n, and why it unblocks the others]

### Into the contextbase

- **Gotchas → `03-knowledge/gotchas/`:** [file, or "none"]
- **Patterns → `03-knowledge/patterns/`:** [file, or "none"]
- **ADRs → `03-knowledge/adrs/`:** [file, or "none"]
- **PRD `completion_rationale`:** [one honest sentence on why this is closed]
- **Estimated vs actual:** [X h estimated · Y h actual] — [what the gap says about the next estimate]
- **Session brief:** [[link]] — the output of this closing, and the edge that carries state forward

---

## The call

- [ ] **Closed — this is done.** [Signed: intent owner · implementation owner]
- [ ] **Not closed — back in the air.** Reason: [what has to be true before it closes]

*A plan that is never closed triggers a search. An open plan nobody closed is create-not-finish
drift with better paperwork.*
