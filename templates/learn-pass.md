---
name: learn-pass
type: command
description: The Learn loop — capture discoveries during a session, then consolidate them into the contextbase. Run it WITH your agent; it's a practice, not an installed tool.
tags: [learn, knowledge, compaction, contextbase]
---

# Learn Pass — capture & consolidate

> **What this is.** C²'s third compaction mechanism (alongside the Session Brief
> and the Router). It keeps the contextbase — and the Router's index — current
> without sprawl. You run it *with* the agent. It is a markdown practice, not a
> package: paste a mode below as a prompt, or wire it as a slash command for
> your agent (e.g. `.claude/commands/learn.md` for Claude Code).

---

## Mode 1 — Capture (during the session)

Use the moment you discover something reusable, so it's never lost mid-flow.

> **Prompt:** "Capture this learning: `<one or two sentences>`. Classify it,
> write it to the right `03-knowledge/` file using the matching template, and
> add a link to it from the Router's knowledge index."

**Classification — type → destination:**

| Type | Signal | Destination |
|---|---|---|
| `gotcha` | tricky, watch out, surprising, took 30+ min to figure out | `docs/03-knowledge/gotchas/` |
| `pattern` | reusable, "do it this way", best practice | `docs/03-knowledge/patterns/` |
| `decision` (ADR) | "we chose X over Y because…", trade-off | `docs/03-knowledge/decisions/` |

Rules of thumb:
- "I'll probably hit this again" → capture it.
- "Someone else will hit this" → capture it.
- "Just project state, not reusable" → that belongs in the **Session Brief**, not here.

One file per learning. Use the `knowledge-gotcha.md` / `knowledge-pattern.md` /
`knowledge-adr.md` templates. Commit it in the **same commit** as the session brief.

---

## Mode 2 — Consolidate (periodic)

Run at the end of a week, before a big feature push, or when the knowledge base
feels scattered.

> **Prompt:** "Review recent `03-knowledge/` entries. Merge duplicates into the
> canonical docs, archive anything stale, and refresh the Router's knowledge
> index so its links are current and lean. Show me what you changed."

This is the step that keeps the Router a tight living index rather than a pile of
loose notes — continuous compaction of the contextbase itself.

---

## Session Brief vs Learning

| Session Brief | Learning |
|---|---|
| "What happened, what's next" | "Knowledge that applies broadly" |
| Temporal, project-specific | Permanent, reusable |
| `docs/02-working/sessions/` | `docs/03-knowledge/` |

> If a single session's working set still overflows the window, add in-session
> compaction (research → plan → implement, keep utilisation lean). The Learn
> loop handles the durable, cross-session half.
