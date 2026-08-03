---
id: [generate]
title: "PB — [Feature / Task Name]"
type: prompt-brief-autonomous
prd_ref: [PRD id or path]
status: backlog
owner: [name]
created: YYYY-MM-DD
updated: YYYY-MM-DD
estimated_hours: 
actual_hours: 
tags: [prompt-brief, autonomous]
---

# PB — [Feature / Task Name]

> **Autonomous brief.** The pilot will not be present for this session. The AI executes without interruption. Precision in this document is execution quality — a vague pre-flight produces a vague outcome. Every item in the pre-flight must be specific enough to act on without asking.
>
> **Size it to one pull request.** One brief ≈ one PR. A brief that can't be expressed as a single reviewable PR is really two briefs.

---

## Quality gate — complete before handing off

- [ ] **Goal** — What does done look like? (one sentence, measurable)
- [ ] **Scope exclusions** — What is explicitly NOT being built?
- [ ] **Testable acceptance criteria** — Specific, verifiable, not subjective. **Name the anchor:** the one signal that decides done, which the agent cannot produce by asserting it
- [ ] **Non-goals** — What problems are out of scope?
- [ ] **Testing approach** — What tests will be written as part of this brief?
- [ ] **Definition of done** — When is this committed and closed?
- [ ] **Pre-flight** — Every file listed with specific line ranges and reason for reading

---

## Goal

[One sentence. Measurable done state.]

---

## Pre-flight — read before touching anything

The AI reads these before writing a single line. List only what is directly relevant to this brief.

| File | Lines | Why |
|---|---|---|
| `path/to/file.ts` | 1–80 | [Specific reason — e.g., "auth middleware — don't break the session pattern on line 45"] |
| `path/to/file.ts` | 120–200 | [Specific reason] |
| `docs/03-knowledge/gotchas/relevant-gotcha.md` | all | [Specific reason] |

**Relevant context docs:**
- PRD: [[prd_ref]]
- Most recent session brief: [[link]]

---

## Scope

**What's being built:**

- [Item 1]
- [Item 2]

**What's explicitly NOT being built:**

- [Exclusion 1]
- [Exclusion 2]

---

## Acceptance criteria

**The anchor:** [the one signal that decides done — a test that actually ran, a query that returned rows, a deploy that resolved, a metric that moved. "The agent says it's done" is not an anchor. Do not loop on confidence. Loop on evidence.]

**Frozen rules for this surface:** [rules that are non-negotiable *because* they are the ones under pressure here — the ones an optimiser would bend to win. Or "none beyond the project defaults".]

- [ ] [AC 1 — specific and testable]
- [ ] [AC 2]
- [ ] [AC 3]

---

## Items

Each item follows the READ → IMPL → REVIEW → VERIFY → COMMIT cycle. Do not start the next item until the current one is committed.

**45-minute limit:** If blocked on any item for more than 45 minutes without a clear path forward, stop, write what you know in the session brief, and surface the blocker. Do not proceed to the next item on a broken foundation.

**Name the layer before you surface it.** *Cannot operate* — missing tool, stale state, bad permissions, no visibility → **the environment**. *Almost works but unreliable* — close-but-weak output, inconsistent success, no proof of completion → **the loop and its stop rule**. *The process itself is complex* — branching, approvals, parallel paths → **the topology**. A blocker reported without its layer usually gets debugged at the wrong one.

---

### Item 1 — [Name]

**READ:** [What to read before implementing this item]  
**IMPL:** [What to build]  
**REVIEW:** [What to check before marking done — correctness, edge cases, security]  
**VERIFY:** [How to verify it works — test command, manual check, etc.]  
**COMMIT:** `type: [description of what this commit does]`

---

### Item 2 — [Name]

**READ:** [What to read]  
**IMPL:** [What to build]  
**REVIEW:** [What to check]  
**VERIFY:** [How to verify]  
**COMMIT:** `type: [description]`

---

### Item 3 — [Name]

**READ:** [What to read]  
**IMPL:** [What to build]  
**REVIEW:** [What to check]  
**VERIFY:** [How to verify]  
**COMMIT:** `type: [description]`

---

> **Checkpoint (required for briefs with 4+ items):** Before proceeding to Item 4, write one paragraph in the session brief draft: Is the approach taken in Items 1–3 consistent with the goal and the pre-flight constraints? Has anything unexpected been discovered that changes the approach for Items 4+? If yes, pause and surface it. Do not build Items 4+ on a foundation that has drifted.

---

### Item 4 — [Name]

**READ:** [What to read]  
**IMPL:** [What to build]  
**REVIEW:** [What to check]  
**VERIFY:** [How to verify]  
**COMMIT:** `type: [description]`

---

## Testing

**The test plan for this slice.** Every brief carries its own, so nobody downstream is handed an untested build. This is what the verification gate checks against — and what the independent verifier reads, along with the diff and the evidence journal.

Tests written as part of this brief:

- [ ] [Test 1 — what it tests and where it lives]
- [ ] [Test 2]

Deferred tests (with reason — will be tracked in session brief `test_debt`):

- [Deferred test — reason]

---

## Definition of done

- [ ] All items committed to the correct branch
- [ ] All acceptance criteria verified
- [ ] Tests committed alongside implementation
- [ ] Session brief written and committed
- [ ] PRD `updated` date and `completion_percent` updated
- [ ] Any Key Discovery committed to `03-knowledge/` in the same commit as the session brief
- [ ] CLAUDE.md updated to point to this session brief

---

## Session brief

[[docs/02-working/sessions/YYYY-MM/YYYY-MM-DD-session-brief]] — AI writes this at session end
