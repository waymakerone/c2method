
# C² Quick Start — Setting Up a New Project

C² (C-Squared) can be set up on a new or existing project in half a day. This guide walks you through the steps in sequence. Don't skip the foundation — it's what makes everything else work.

**Time to minimal running state:** 2–3 hours  
**Time to full implementation:** 1–2 weeks of active sessions

---

## Step 1 — Copy the starter (5 minutes)

You don't build the structure by hand — the `starter/` folder **is** the
structure, with a template already in every folder. Copy it into your repo root:

```bash
cp -r path/to/c2method/starter/. .
```

You now have:

```
AGENTS.md                ← the Router (rename for your agent if needed)
.claude/commands/        ← learn.md, audit.md
docs/
├── 01-planning/product-requirements/   platform-prd.md · feature-prd.md
├── 02-working/
│   ├── prompt-briefs/    prompt-brief-interactive.md · prompt-brief-autonomous.md
│   ├── session-briefs/   session-brief.md
│   ├── release-notes/    release-note.md
│   └── tasks/            task.md
├── 03-knowledge/{gotchas, patterns, decisions}/   knowledge-*.md
├── 04-operations/{deployment, runbooks}/          deployment-checklist.md · runbook.md
├── 05-reference/         tech-stack.md · naming-conventions.md
└── 06-agents/            agent-team.md · agent-role.md
```

Every folder ships with a starter template — you fill them in, you don't create
them. And it's **adaptive**: add folders (a `07-metrics/`, sub-folders under
`01-planning/`, whatever your project needs). This is a starting shape, not a
cage. Each folder is explained at [c2method.ai/docs](https://c2method.ai/docs).

---

## Step 2 — Design your agent team (20 minutes)

Before writing a line of code, decide who's on the team. Open `docs/06-agents/agent-team.md` (already in your repo from Step 1) and fill in:

- **Lead agent** — which AI coding agent runs the terminal sessions? (Claude Code, Grok CLI, Gemini CLI, Codex, etc.)
- **Bench agent(s)** — which agent(s) provide independent review on PRDs, security, and architecture? Set budget caps now, before you need them.
- **Specialist agents** — any repeatable high-value tasks (QA scaffolding, release note authoring) that warrant a dedicated subagent definition?

C² is agent-agnostic. You are not committing to a vendor — you are committing to roles. Document the current team and update it when it changes.

---

## Step 3 — Set up the Router (45 minutes)

The Router is the single file every AI session starts from — the living index of your contextbase. `AGENTS.md` is already in your repo from Step 1; **name it for your agent** so it's read automatically: keep it `AGENTS.md` (the cross-agent default — Codex, Cursor, and most), or rename to `CLAUDE.md` for Claude Code / `GEMINI.md` for Gemini. Then fill in:

- Project name and one-line description
- The current active PRDs (link to `docs/01-planning/product-requirements/`)
- The most recent session brief (link to `docs/02-working/session-briefs/`)
- The knowledge index (link to `docs/03-knowledge/`)
- The tech stack summary (link to `docs/05-reference/tech-stack.md`)

**Rule:** If the Router doesn't link to it, the AI won't find it. Keep it current — update it at the end of every session, and it becomes your project's living wiki.

---

## Step 4 — Write the Platform PRD (30 minutes)

One Platform PRD per product. This is the strategic layer everything inherits from. Fill in `docs/01-planning/product-requirements/platform-prd.md`.

Answer these questions, and stop when you have them:
- What does this product do in one sentence?
- Who uses it, in what context?
- What are the 3 things it must do well?
- What is explicitly out of scope?

It lives at `docs/01-planning/product-requirements/platform-prd.md`.

---

## Step 5 — Write your first Feature PRD (30 minutes)

Pick one feature you're actively working on. Fill in `docs/01-planning/product-requirements/feature-prd.md` (copy it once per feature). Fill in the Problem, Users, Goals, and Non-goals sections. Leave the rest for later — a Feature PRD is a living document, not a requirements spec.

Status: `in-progress` (if already started) or `backlog` (if not).

Set its `status:` to `in-progress` or `backlog` in the frontmatter — status is a field, not a folder.

**WIP cap reminder:** Maximum 5 PRDs at `status: in-progress` at any time. If you already have 5, set one back to `backlog` before starting another.

---

## Step 6 — Write your first Prompt Brief (30 minutes)

Pick one concrete piece of work to do in this first session. Use `docs/02-working/prompt-briefs/prompt-brief-interactive.md` (if you'll be present) or `prompt-brief-autonomous.md` (if not).

**Run the 6-item quality gate before doing anything:**

1. Goal — one sentence, measurable done state
2. Scope exclusions — what are you explicitly NOT building?
3. Testable acceptance criteria — how will you verify it works?
4. Non-goals — what problems are out of scope for this brief?
5. Testing approach — unit tests, integration, or manual?
6. Definition of done — when is this committed and closed?

If you can't answer all 6, don't start. Write the answers first.

Commit the brief to `docs/02-working/prompt-briefs/`.

---

## Step 7 — Run the session, write the Session Brief (30 minutes)

Run your first C² session. At the end, fill in `docs/02-working/session-briefs/session-brief.md`:

- What was done (per item, linked to the PB)
- Decisions made and why
- Blockers encountered and how they were resolved
- Key Discovery — **if this section has content, a `03-knowledge/` entry is required in this same commit**
- Next session start state (what will the AI need to know at the start of next time?)

Commit the session brief to `docs/02-working/session-briefs/`.

---

## Step 8 — Extract the first knowledge entry (15 minutes)

If your session produced a Key Discovery — a gotcha, a pattern, a decision that will matter again — use the matching template already in `docs/03-knowledge/{gotchas,patterns,decisions}/` and commit it in the same commit as the session brief.

If there was no Key Discovery, skip this step. Never force it.

This capture-then-consolidate habit is the **Learn loop**: grab discoveries fast during the session so nothing is lost, then periodically (end of week, before a big push) have the agent review recent learnings, merge duplicates into canonical docs, and refresh the Router's links. You run it *with* the agent — see `.claude/commands/learn.md` — not as an installed tool.

---

## You're running C². Now the compounding starts.

After your first session, you have:
- A Router (AGENTS.md / CLAUDE.md) that loads context automatically
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
| Writing PRDs but not Prompt Briefs | PRDs in "in-progress" with no execution path | A PRD needs ≥1 PB before moving to in-progress (brief-before-active) |
| >5 PRDs in in-progress (WIP cap exceeded) | Create-not-finish drift | Move stale ones to backlog immediately |
| Checking the gotcha box without committing the file | Knowledge evaporates | Key Discovery = knowledge file in the same commit |
| Updating CLAUDE.md only occasionally | AI starts sessions with stale context | Update CLAUDE.md at end of every session |

---

## The monthly governance check (30 minutes)

Once a month, walk every PRD in `in-progress/`:

1. Is there active work against it? (recent session briefs referencing it?)
2. Is `last_reviewed` current?
3. Is `completion_percent` honest? Write the `completion_rationale` — if you can't, the PRD isn't in-progress.
4. Should this be in `backlog/` instead?

Move stale PRDs to backlog. Thirty minutes. The WIP cap enforces itself if you let the monthly review run.
