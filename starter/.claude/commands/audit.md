---
name: adopt-audit
type: command
description: Run this with your AI agent on an existing repo. It scores the project against C² and hands back a gap report plus a prioritised adoption plan. Free — a markdown practice, not a package.
tags: [adopt, audit, migrate, onboarding]
---

# Adopt C² — repo audit & migration plan

> **What this is.** Already have a project? Point your AI coding agent at it and
> it will tell you where you stand against C² and exactly how to adopt it —
> quick wins first, structural moves later. Paste the prompt below, or wire this
> file as a skill / slash command (e.g. `.claude/skills/c2-audit/SKILL.md`, or
> `.claude/commands/audit.md` for Claude Code).

---

## Run it

> **Prompt to your agent:**
> "Audit this repository against the C² method using the rubric below. **Inspect
> the actual files — don't assume.** Score each item 0 (absent), 1 (partial),
> 2 (full). Then produce the report in the *Output format* at the bottom. Be
> specific: cite the files you found, or the absence you noted, for every score."

---

## What to inspect

- **Router** — a `CLAUDE.md` / `AGENTS.md` / `GEMINI.md` at the repo root? Does it link to active work, the knowledge index, and the pilot rules?
- **Structure** — a `docs/` with planning / working / knowledge layers? a `03-knowledge/` for gotchas, patterns, decisions?
- **The Cascade** — Platform & Feature PRDs? Prompt Briefs (with scope exclusions + testable acceptance criteria)? Session Briefs (one per session)?
- **Knowledge capture** — is `03-knowledge/` populated and growing? are discoveries committed in the same session that found them?
- **Execution quality** — a brief quality gate? tests for new files / a CI gate?
- **Governance** — a monthly PRD review? a WIP cap (≤5 in-progress PRDs)? estimation fields?

---

## The rubric — score each 0 / 1 / 2 (max 60)

**Layer 1 — Foundation (max 12)**
- Router exists at repo root (CLAUDE.md / AGENTS.md / equivalent)
- Router links to active PRDs, knowledge index, current session brief, methodology
- A `docs/` directory separates planning, working, and knowledge layers
- A knowledge directory (`03-knowledge/`) has gotchas / patterns / decisions
- Planning docs carry YAML frontmatter (`id`, `title`, `created`, `updated`, `status`)
- Status values are consistent (`backlog` / `in-progress` / `review` / `done`)

**Layer 2 — The Cascade (max 16)**
- Feature PRDs exist for active features (not just a platform PRD)
- PRDs are living documents (recent `updated` dates, not just `created`)
- ≤ 5 PRDs in `in-progress` at once (the WIP cap)
- No `in-progress` PRD without ≥ 1 Prompt Brief (brief-before-active)
- Prompt Briefs exist for in-flight work (not bare tickets)
- Briefs state explicit scope exclusions (what is NOT being built)
- Briefs have testable acceptance criteria
- Autonomous briefs include a pre-flight with file paths + line ranges
- Session Briefs are written consistently (≥ 1 per session)
- Session Briefs cover: done / blockers / decisions / key discovery / next start state

**Layer 3 — Knowledge capture (max 12) — highest-compounding; weight heavily**
- Knowledge index has entries (not empty)
- Entries added regularly (≥ 1 per active week)
- Entries are structured: problem, root cause, fix, prevention
- Session briefs with a "Key Discovery" have a knowledge file in the same commit
- Knowledge entries reference the session brief they came from
- The Router loads the knowledge index before sessions touching relevant code

**Layer 4 — Execution quality (max 12)**
- All briefs pass a 6-item quality gate before execution
- The gate is documented and applied consistently
- Autonomous briefs have a blocker limit (e.g. 45 min before surfacing)
- Briefs with 4+ items include a mid-brief checkpoint after item 3
- Tests exist for new source files (documented policy)
- Coverage is enforced mechanically (CI gate), not by culture alone

**Layer 5 — Metrics & governance (max 8)**
- A monthly PRD review runs, logged
- Stale in-progress PRDs get moved to backlog at review time
- Prompt Brief frontmatter has `estimated_hours` / `actual_hours`, populated
- Estimation accuracy is read and used (script / dashboard / review)

---

## Scoring bands

| Score | Rating | Interpretation |
|---|---|---|
| 54–60 (90–100%) | **C² Certified** | Full implementation. Compounding is running. |
| 48–53 (80–89%) | **C² Strong** | Minor gaps — close them in priority order. |
| 36–47 (60–79%) | **C² Developing** | Core present, key mechanisms missing. Focus Layers 2 & 3. |
| 24–35 (40–59%) | **C² Early** | Foundation incomplete. Layer 1, then Layer 2. |
| 0–23 (<40%) | **Pre-C²** | Not implemented yet. Start from the quick-start guide. |

## Prioritise by leverage

- **Layer 3 gaps cost the most** — uncaptured knowledge compounds negatively every session. Usually low effort to fix (a template + commit habit).
- **Layer 1 gaps block everything** — no Router means every session starts blind. One file fixes it.
- **Layer 2** (briefs/PRDs) is the pilot/crew handoff — without it, sessions drift.
- Layers 4 & 5 are quality/calibration — important, but after 1–3 are in place.

---

## Output format

Produce exactly this:

1. **C² Score** — number out of 60 and the rating band.
2. **Layer breakdown** — subtotal per layer with one line of evidence each.
3. **Top 3 gaps** — highest-leverage, in priority order, each with the cost of leaving it open.
4. **Quick wins** — fixable this week (a template, one new file, a habit).
5. **Structural investments** — need planning (CI gate, practice change).
6. **First move** — the single next action, naming the exact file to create and what to put in it (usually: write the Router).
