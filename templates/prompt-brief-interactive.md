---
id: [generate]
title: "PB — [Feature / Task Name]"
type: prompt-brief-interactive
prd_ref: [PRD id or path]
status: backlog
owner: [name]
created: YYYY-MM-DD
updated: YYYY-MM-DD
estimated_hours: 
actual_hours: 
tags: [prompt-brief, interactive]
---

# PB — [Feature / Task Name]

> **Interactive brief.** The pilot is present for this session. Use this template when you will be actively directing the AI — reviewing output, answering questions, making decisions in real time.

---

## Quality gate — complete before starting

Do not start execution until all 6 items are answered. A brief that can't clear this gate isn't ready.

- [ ] **Goal** — What does done look like? (one sentence, measurable)
- [ ] **Scope exclusions** — What is explicitly NOT being built in this brief?
- [ ] **Testable acceptance criteria** — How will you verify it works? (specific, not "it looks right")
- [ ] **Non-goals** — What problems are out of scope for this brief?
- [ ] **Testing approach** — Unit tests / integration tests / manual verification / none (with reason)?
- [ ] **Definition of done** — When is this committed and closed?

---

## Goal

[One sentence. Measurable done state. e.g., "Users can invite a team member by email from the Settings page and receive a confirmation."]

---

## Context

What should the AI know before starting? Keep it tight — link to docs rather than pasting them.

- **Relevant PRD:** [[prd_ref]]
- **Most recent session brief:** [[link]]
- **Relevant knowledge files:** [[docs/03-knowledge/gotchas/relevant-file]] [or "none"]
- **Key files to understand first:** [list specific files and why, or "none — greenfield"]

---

## Scope

**What's being built:**

- [Item 1]
- [Item 2]

**What's explicitly NOT being built in this brief:**

- [Exclusion 1 — and why (deferred to later, different PRD, out of scope entirely)]
- [Exclusion 2]

---

## Acceptance criteria

Specific, testable. "It works" is not a criterion.

- [ ] [AC 1 — e.g., "Email invitation sends within 5 seconds of clicking Invite"]
- [ ] [AC 2 — e.g., "Invited user appears in team list with status Pending"]
- [ ] [AC 3]

---

## Testing approach

[ ] Unit tests for [which functions / components]  
[ ] Integration test for [which flow]  
[ ] Manual verification: [specific steps to verify in browser / CLI / etc.]  
[ ] No automated tests — reason: [must be a real reason, not "it's complex"]

If any testing is being deferred, add it to `test_debt` in the session brief.

---

## Definition of done

This brief is closed when:
- [ ] [Condition 1 — e.g., "PR merged to develop"]
- [ ] [Condition 2 — e.g., "Session brief written and committed"]
- [ ] [Condition 3 — e.g., "Feature PRD updated"]

---

## Notes

[Anything else the AI needs — design references, related tickets, decisions already made, things to avoid.]

---

## Session brief

[[docs/02-working/sessions/YYYY-MM/YYYY-MM-DD-session-brief]] — fill in after the session
