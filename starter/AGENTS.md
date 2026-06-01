# [Project Name] — AI Router

> **C² Methodology | P = aic²**  
> This is the **Router** — the entry point for every AI session. Read it fully before touching any code.
>
> **Name this file for your agent so it's read automatically.** Keep it
> `AGENTS.md` (the cross-agent default — Codex, Cursor, and most), or use
> `CLAUDE.md` for Claude Code / `GEMINI.md` for Gemini. We call the concept
> `router.md`; ship it under your agent's name — don't rely on a rename you'll
> forget. (Single source of truth? `ln -s router.md AGENTS.md`.)

---

## What this project is

**[One sentence: what does this do, for whom?]**

Tech stack: [e.g., Next.js 15, Supabase, TypeScript, Tailwind]  
Repo layout: `apps/` = runnable code · `docs/` = contextbase

---

## Agent team

> C² is agent-agnostic. Document the current team in `docs/06-agents/team.md`.

- **Lead:** [e.g., Claude Code — claude-sonnet-4-x]
- **Bench:** [e.g., Grok — for PRD review, security, architecture. Budget: $X/month, N calls/day]
- **Specialists:** [e.g., qa-reviewer (.claude/agents/), release-author (.claude/agents/)]

---

## Current active PRDs

> These are the features in active development. Read the relevant PRD before starting work on that area.

- [ ] [[docs/01-planning/prds/in-progress/FEATURE-NAME]] — [one-line description, current status]
- [ ] [[docs/01-planning/prds/in-progress/FEATURE-NAME]] — [one-line description, current status]

**WIP cap:** Maximum 5 PRDs in `in-progress/` at once (C² Rule A). Count before adding new ones.

---

## Most recent session brief

[[docs/02-working/sessions/YYYY-MM/YYYY-MM-DD-BRIEF-NAME]]

Read this first. It is the handoff from the last session — what was done, what was decided, what to start with.

---

## Knowledge index

[[docs/03-knowledge/]] — patterns, gotchas, and decisions extracted from prior sessions.

**Before touching [area X]:** read `docs/03-knowledge/gotchas/[relevant-file]`  
**Before [architectural decision]:** read `docs/03-knowledge/decisions/`

> If your session produces a Key Discovery, a `03-knowledge/` file is required in the same commit as the session brief. Not optional.

---

## Reference

- Tech stack and versions: [[docs/05-reference/tech-stack]]
- Naming conventions: [[docs/05-reference/naming-conventions]]
- Deployment runbook: [[docs/04-operations/deployment/]]
- Platform PRD: [[docs/01-planning/strategy/platform-prd]]

---

## Session start protocol

1. Read this file in full
2. Read the most recent session brief
3. Read any knowledge files relevant to the work area
4. Read the active PRD for the feature being worked on
5. Read the Prompt Brief for this session (if autonomous)
6. Verify the 6-item PB gate before starting (goal, scope exclusions, AC, non-goals, testing approach, definition of done)

## Session end protocol

1. Commit all work-in-progress
2. Write the session brief to `docs/02-working/sessions/YYYY-MM/`
3. If Key Discovery has content → commit `03-knowledge/` file in the same commit
4. Update `updated:` in any PRD or PB you touched
5. Update this CLAUDE.md: point `Most recent session brief` to the one you just wrote
6. Commit the session brief and CLAUDE.md update together

---

## Pilot rules

- **30-minute debug limit.** If blocked for 30 minutes on a single problem, surface it in the session brief and stop. Debugging marathons are crew behaviour, not pilot behaviour.
- **One agent per surface.** Don't run multiple AI agents on the same code path simultaneously.
- **Scope is defined by the PB.** If it's not in the brief, it's not in scope. Surface additions as a new brief, not as scope creep.
- **Session briefs are not optional.** Every session ends with a committed session brief. No exceptions.
