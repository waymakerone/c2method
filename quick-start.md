
# C² Quick Start — Setting Up a New Project

C² (C-Squared) can be set up on a new or existing project in half a day. This guide walks you through the steps in sequence. Don't skip the foundation — it's what makes everything else work.

**Time to minimal running state:** 2–3 hours  
**Time to full implementation:** 1–2 weeks of active sessions

---

## Step 1 — Create the folder structure (15 minutes)

Create this directory layout in your repo root:

```
docs/
├── 01-planning/
│   ├── prds/
│   │   ├── backlog/
│   │   ├── in-progress/
│   │   ├── done/
│   │   └── archived/
│   └── strategy/
├── 02-working/
│   ├── prompt-briefs/
│   │   ├── backlog/
│   │   ├── in-progress/
│   │   ├── done/
│   │   └── archived/
│   ├── sessions/
│   │   └── YYYY-MM/
│   ├── tasks/
│   └── releases/
├── 03-knowledge/
│   ├── gotchas/
│   ├── patterns/
│   └── decisions/
├── 04-operations/
│   ├── deployment/
│   └── runbooks/
├── 05-reference/
│   ├── tech-stack.md
│   └── naming-conventions.md
├── 06-agents/
│   ├── team.md           ← agent team design (who leads, who reviews, budgets)
│   ├── [lead-agent]/     ← lead agent config and notes
│   ├── [bench-agent]/
│   │   └── reviews/      ← saved bench reviews with Actions Taken tables
│   └── specialist/       ← specialist agent role definitions (see .claude/agents/ for executables)
└── 07-metrics/
    └── velocity/
```

Add a `.gitkeep` to each empty directory so they commit.

**Note on `06-agents/`:** This folder is for team design documents and saved reviews — not executable agent definitions. Executable subagent definitions (for Claude Code's `/agents` feature or equivalent toolchain agents) live in `.claude/agents/` at the repo root. The two folders are complementary: `.claude/agents/` holds *how* an agent works; `docs/06-agents/` holds *why* the team chose it and the record of its outputs.

---

## Step 2 — Design your agent team (20 minutes)

Before writing a line of code, decide who's on the team. Copy `c-squared/templates/agent-team.md` to `docs/06-agents/team.md` and fill in:

- **Lead agent** — which AI coding agent runs the terminal sessions? (Claude Code, Grok CLI, Gemini CLI, Codex, etc.)
- **Bench agent(s)** — which agent(s) provide independent review on PRDs, security, and architecture? Set budget caps now, before you need them.
- **Specialist agents** — any repeatable high-value tasks (QA scaffolding, release note authoring) that warrant a dedicated subagent definition?

C² is agent-agnostic. You are not committing to a vendor — you are committing to roles. Document the current team and update it when it changes.

---

## Step 3 — Write CLAUDE.md (45 minutes)

This is the router — the single file every AI session starts from. Copy the template from `c-squared/starter/CLAUDE.md` and fill in:

- Project name and one-line description
- The current active PRDs (link to `docs/01-planning/prds/in-progress/`)
- The most recent session brief (link to `docs/02-working/sessions/`)
- The knowledge index (link to `docs/03-knowledge/`)
- The tech stack summary (link to `docs/05-reference/tech-stack.md`)

**Rule:** If CLAUDE.md doesn't link to it, the AI won't find it. Keep it current. Update it at the end of every session.

---

## Step 3 — Write the Platform PRD (30 minutes)

One Platform PRD per product. This is the strategic layer everything inherits from. Copy the template from `c-squared/templates/platform-prd.md`.

Answer these questions, and stop when you have them:
- What does this product do in one sentence?
- Who uses it, in what context?
- What are the 3 things it must do well?
- What is explicitly out of scope?

Commit it to `docs/01-planning/strategy/platform-prd.md`.

---

## Step 4 — Write your first Feature PRD (30 minutes)

Pick one feature you're actively working on. Copy `c-squared/templates/feature-prd.md`. Fill in the Problem, Users, Goals, and Non-goals sections. Leave the rest for later — a Feature PRD is a living document, not a requirements spec.

Status: `in-progress` (if already started) or `backlog` (if not).

Commit to `docs/01-planning/prds/in-progress/` or `backlog/` accordingly.

**Rule A reminder:** Maximum 5 PRDs in `in-progress/` at any time. If you already have 5, move one to `backlog/` before adding a new one.

---

## Step 5 — Write your first Prompt Brief (30 minutes)

Pick one concrete piece of work to do in this first session. Copy `c-squared/templates/prompt-brief-interactive.md` (if you'll be present) or `prompt-brief-autonomous.md` (if not).

**Run the 6-item quality gate before doing anything:**

1. Goal — one sentence, measurable done state
2. Scope exclusions — what are you explicitly NOT building?
3. Testable acceptance criteria — how will you verify it works?
4. Non-goals — what problems are out of scope for this brief?
5. Testing approach — unit tests, integration, or manual?
6. Definition of done — when is this committed and closed?

If you can't answer all 6, don't start. Write the answers first.

Commit the brief to `docs/02-working/prompt-briefs/in-progress/`.

---

## Step 6 — Run the session, write the Session Brief (30 minutes)

Run your first C² session. At the end, copy `c-squared/templates/session-brief.md` and fill in:

- What was done (per item, linked to the PB)
- Decisions made and why
- Blockers encountered and how they were resolved
- Key Discovery — **if this section has content, a `03-knowledge/` entry is required in this same commit**
- Next session start state (what will the AI need to know at the start of next time?)

Commit the session brief to `docs/02-working/sessions/YYYY-MM/`.

---

## Step 7 — Extract the first knowledge entry (15 minutes)

If your session produced a Key Discovery — a gotcha, a pattern, a decision that will matter again — copy the appropriate template from `c-squared/templates/knowledge-*.md` and commit it to `docs/03-knowledge/` in the same commit as the session brief.

If there was no Key Discovery, skip this step. Never force it.

---

## You're running C². Now the compounding starts.

After your first session, you have:
- A router (CLAUDE.md) that loads context automatically
- A PRD hierarchy (Platform → Feature)
- A Prompt Brief with scope and acceptance criteria
- A Session Brief that serves as AI memory and team communication
- Optionally: the first entry in your knowledge index

The next session starts from the Session Brief. The one after that builds on the knowledge index. After 20 sessions, the contextbase is denser than the codebase in terms of decision context.

**The only rule that matters:** Every session ends with a Session Brief. Everything else follows from that.

---

## Anti-pattern checklist — common early mistakes

| Mistake | What happens | Fix |
|---|---|---|
| Starting without a Prompt Brief | No scope, no AC — sessions drift | Write the brief first, 6-item gate before starting |
| Skipping the session brief | AI context resets next session | Session ends when brief is committed, not before |
| Writing PRDs but not Prompt Briefs (Rule B) | PRDs in "in-progress" with no execution path | A PRD needs ≥1 PB before moving to in-progress |
| >5 PRDs in in-progress (Rule A violation) | Create-not-finish drift | Move stale ones to backlog immediately |
| Checking the gotcha box without committing the file | Knowledge evaporates | Key Discovery = knowledge file in the same commit |
| Updating CLAUDE.md only occasionally | AI starts sessions with stale context | Update CLAUDE.md at end of every session |

---

## The monthly governance check (Rule C — 30 minutes)

Once a month, walk every PRD in `in-progress/`:

1. Is there active work against it? (recent session briefs referencing it?)
2. Is `last_reviewed` current?
3. Is `completion_percent` honest? Write the `completion_rationale` — if you can't, the PRD isn't in-progress.
4. Should this be in `backlog/` instead?

Move stale PRDs to backlog. Thirty minutes. The WIP cap enforces itself if you let Rule C run.
