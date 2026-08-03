---
id: [generate]
title: "PRD — [Feature Name]"
type: feature-prd
status: backlog
version: 1.0
area: [feature area]
owner: [name]
created: YYYY-MM-DD
updated: YYYY-MM-DD
last_reviewed: YYYY-MM-DD
completion_percent: 0
completion_rationale: ""
estimated_weeks: 
blocked: ""
tags: [prd]
---

# PRD — [Feature Name]

> **Status:** `backlog` → `in-progress` → `review` → `done`  
> **Brief-before-active:** this PRD cannot move to `in-progress` without at least one Prompt Brief in `docs/02-working/prompt-briefs/`.  
> **WIP cap:** check that fewer than 5 PRDs are in `in-progress` before moving this one.

> **This document is the spine.** Every ceremony reads it or writes back to it, and nothing lives
> in a second place. It is **living and versioned**: `v1.0 → v1.1 → v2.0`, where each version
> **absorbs** the last — a bank switch — leaving one live artefact that says where the work is
> *now*, built on its history rather than restarting from it. The closing gate appends findings at
> the end of a cycle; the next flight plan sweeps them at the start of the next. That is how it
> compounds without hoarding.

---

## Problem

**What problem does this solve, and for whom?**

[2–4 sentences. Specific user, specific pain. If you can't write this, the PRD isn't ready.]

**Why now?**

[What changed — market, user feedback, technical opportunity — that makes this the right time to build this?]

---

## Users

Who experiences this feature, in what context?

| User | Context | What they need |
|---|---|---|
| [User type] | [Situation] | [Specific need] |

---

## Goals

What does success look like when this ships? Measurable where possible.

- [ ] [Goal 1 — e.g., "Users can complete X without leaving the page"]
- [ ] [Goal 2]
- [ ] [Goal 3]

---

## Non-goals

What is explicitly not being solved here? Saves scope creep arguments.

- [Not building X in this PRD]
- [Not changing Y]
- [Handling Z is a separate PRD]

---

## Design notes

Key UX/UI decisions, or a link to designs. Not a full spec — decisions that constrain implementation.

[Notes or link to Figma / screenshots / reference implementations]

---

## Implementation notes

Architectural decisions, known constraints, relevant prior work in `03-knowledge/`.

- [Constraint or decision 1]
- [Related gotcha: link to knowledge file if relevant]
- [Dependency on another PRD or external service]

---

## Features & status

What this PRD holds, and where each part actually is. This is the honest source of the
`completion_percent` above — swept and reconciled by each new flight plan, so it states what
shipped rather than what was hoped for.

| Feature | Status | Notes |
|---|---|---|
| [Feature] | not started / in progress / shipped | [one line] |

---

## Prompt Briefs

The units of work. **One brief ≈ one pull request** — a brief that can't be expressed as a single
reviewable PR is really two briefs.

| Brief | Status | Scope |
|---|---|---|
| [[docs/02-working/prompt-briefs/in-progress/PB-001]] | in-progress | [one line] |

---

## Blocked

What is stopping this, visible to anyone tracking the work. A blocker that only lives in a session
brief is a blocker nobody can see. Name the layer that owns it — *cannot operate* → the
environment · *almost works but unreliable* → the loop and its stop rule · *the process itself is
complex* → the topology.

- [ ] [Blocker] — [layer] — [what would unblock it, and who owns that]

*(Empty is the normal state. Clear items as they resolve.)*

---

## Closing findings

Written back here by the closing gate at the end of each cycle, and swept by the next flight plan.
**FIX** is wrong today; **ADD** is a new capability. Flag the keystone — the one that unblocks the
rest — and sequence from there: keystone, trust fixes, high-value adds, design pass. The PR that
resolves one references its ID, so the trail runs review → PRD → PR → shipped.

| ID | FIX / ADD | Surface | Finding | Raised by | Status |
|---|---|---|---|---|---|
| BR-1 | FIX | [surface] | [what's wrong today] | [who] | open |

**Keystone:** [BR-n, and why it unblocks the others]

---

## Open questions

Questions that must be answered before or during implementation. Clear these as you go.

- [ ] [Question 1]
- [ ] [Question 2]

---

## Completion

`completion_percent`: 0  
`completion_rationale`: [When updating completion, write a sentence. If you can't write a rationale, the number is wrong.]

---

## Changelog

| Date | Change | Author |
|---|---|---|
| YYYY-MM-DD | Initial version | [name] |
| YYYY-MM-DD | [What changed and why] | [name] |
