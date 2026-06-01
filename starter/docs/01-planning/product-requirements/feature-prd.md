---
id: [generate]
title: "PRD — [Feature Name]"
type: feature-prd
status: backlog
area: [feature area]
owner: [name]
created: YYYY-MM-DD
updated: YYYY-MM-DD
last_reviewed: YYYY-MM-DD
completion_percent: 0
completion_rationale: ""
estimated_weeks: 
tags: [prd]
---

# PRD — [Feature Name]

> **Status:** `backlog` → `in-progress` → `review` → `done`  
> **Brief-before-active:** This PRD cannot move to `in-progress` without at least one Prompt Brief in `docs/02-working/prompt-briefs/`.  
> **WIP cap:** Check that fewer than 5 PRDs are in `in-progress` before moving this one.

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

## Prompt Briefs

| Brief | Status | Scope |
|---|---|---|
| [[docs/02-working/prompt-briefs/in-progress/PB-001]] | in-progress | [one line] |

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
