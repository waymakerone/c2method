---
id: [generate]
title: "Session Brief — [Feature/Area] — YYYY-MM-DD"
type: session-brief
date: YYYY-MM-DD
trigger: end-of-session | break | meeting | reboot | context-limit | pr
agent: claude-code
pb_ref: [PB id or path]
prd_ref: [PRD id or path]
status: draft
tags: [session-brief]
---

# Session Brief — [Feature/Area] — YYYY-MM-DD

> **This is AI memory.** Write this brief any time the AI context is about to be interrupted or lost — not only at end of day. Triggers: phone call, meeting, work break, closing the laptop, rebooting, switching tasks, hitting the context limit, or ending for the night. The question is not "is the session finished?" but "if I came back to this cold, what would I need to know?"
>
> The async standup is a side effect, not the primary purpose — and only if there's a team to read it. Memory is the purpose.

---

## Session goal

[One sentence — what was this session trying to accomplish?]

**Brief:** [[pb_ref]]  
**PRD:** [[prd_ref]]

---

## What was done

[Summary of what was actually built or changed. Reference specific files and commits where useful.]

| Item | Status | Notes |
|---|---|---|
| [Item 1 from PB] | ✅ Done / ⚠️ Partial / ❌ Not started | [Any relevant notes] |
| [Item 2 from PB] | ✅ Done / ⚠️ Partial / ❌ Not started | [Any relevant notes] |

---

## Decisions made

Decisions that a future session — or a teammate, if you have one — needs to understand. Include the reason.

- **[Decision]:** [Rationale — why this, not something else]
- **[Decision]:** [Rationale]

---

## Blockers

Issues encountered. For each: what it was, how it was resolved (or if unresolved, what's needed next).

Anything still open goes on the **PRD's Blocked field** as well as here — a blocker that only
lives in a session brief is a blocker nobody tracking the work can see. Name the layer that owns
it: *cannot operate* → the environment · *almost works but unreliable* → the loop and its stop
rule · *the process itself is complex* → the topology.

- **[Blocker]:** [Layer] — [Resolution / escalation needed / waiting on X]

---

## Key Discovery

> ⚠️ **Gate:** If this section has content, a `docs/03-knowledge/` file is required in the **same commit** as this session brief. Not optional, not deferred. The knowledge file and this session brief commit together or not at all.

[What was discovered — a gotcha, an unexpected behaviour, a pattern that will matter again. If nothing: "None this session."]

---

## Documentation obligations

Before committing, identify every document this session's work requires. Assign each a due point: **now** (same commit), **PR** (before the PR merges), or **release** (before the feature ships).

### Knowledge documents (due: now — same commit)

These are committed with this session brief or not at all.

| Document | Type | Status |
|---|---|---|
| [[docs/03-knowledge/gotchas/FILENAME]] | gotcha / pattern / ADR | [ ] written [ ] staged |

*(If no knowledge documents are needed, write "None." and remove the table.)*

### Operational documents (due: commit / PR / release)

Deployment steps, runbooks, environment variables, configuration changes, or operational procedures introduced or changed this session.

| Document | Type | Due | Status |
|---|---|---|---|
| [[docs/04-operations/FILENAME]] | runbook / deployment / config | commit / PR / release | [ ] written [ ] staged |

*(If no operational documents are needed, write "None." and remove the table.)*

### Outstanding documentation (carry forward)

Obligations from this session not yet closed. These move to the next session brief's obligations table until resolved.

- [Obligation — what it is, why it's deferred, which session or PR it's due by]

*(If none, write "None.")*

---

## Test debt

Tests that were deferred in this session, with the reason. These are tracked for the monthly review.

- [Test description] — deferred because: [specific reason]

*(If no tests were deferred, write "None.")*

---

## Next session start state

The most important section for continuity. Write this for the AI that will start next time — assume it has read this brief and nothing else.

**Start here:** [What file, function, or task to begin with]

**Context it needs:**
- [Key piece of context — e.g., "The auth middleware on line 45 of middleware.ts cannot be refactored — see gotcha committed this session"]
- [Key piece of context]

**Outstanding work from this session:**
- [Item that's partial or not started — what state it's in, what's needed to finish]

**Suggested first action:** [One specific instruction — e.g., "Read the session brief, then run `npm test` to verify the auth changes are stable before adding the new endpoint"]

---

## Landing zone

Where this PRD is up to, so progress is visible without asking anyone — and without a stand-up, if you have one. Anyone reading the brief trail
can see who is flying what, when they expect to land, and how far in they are.

**Believed landing:** [date — a filed expectation, not a hard deadline]  
**Complete:** [X%]  
**Confidence:** [on track / slipping — and what would change it]

---

## Metrics

**Session duration (approx):** [X hours]  
**Items completed:** [X of Y]  
**PB estimated_hours vs actual:** [Update PB frontmatter after this session]

> **The bar:** one to two briefs on an active build day. If a day of building produced none,
> something got skipped. Hold it mechanically rather than virtuously — a CI check on any PR that
> touches application code, and a local pre-push warning so nobody meets it as a red build.
> Genuinely trivial changes skip with an explicit label, used honestly.
