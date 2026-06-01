# The C² Method

> **Your AI agent forgets everything between sessions. C² fixes that.**

C² is a free, open build method that turns AI coding agents into genuine
development partners — for builders at any level.

Not a theory. Built and battle-tested over two years and 1,000+ agent sessions
shipping production software — SaaS platforms, websites, AI agents, and
ecommerce stores. Every template in this repo came from that build.

**Website & full method:** [c2method.ai](https://c2method.ai)

---

## The problem

Every builder who has used Claude Code, Cursor, or any AI coding agent for more
than a week has felt it: **the agent has no memory between sessions.** It
re-learns your project every time, repeats mistakes it already made, and
improvises where it should follow.

Context is ephemeral. Code is permanent. Most teams pour effort into the code
and let the context evaporate — so the agent never gets smarter, and the work
never compounds.

You don't need a better prompt. You need a method.

---

## The idea in one equation

> **P = aic²** — your output as a builder is **AI** multiplied by the **Context**
> and **Code** you build around it.

Every project runs two parallel systems: a **codebase** (what runs) and a
**contextbase** (what guides — briefs, patterns, gotchas, decisions, committed to
git and read by the AI before it acts). C² treats them as multiplicative. Invest
in context and every session compounds. It's a mnemonic, not a law of physics —
but the exponent is the point: context compounds, and a better model multiplies
whatever you've already built.

---

## Quick start (5 minutes)

1. **Copy the starter into your repo.**

   ```bash
   # from your project root
   cp -r path/to/c2method/starter/. .
   ```

   It carries the **Router** (`AGENTS.md` by default — the cross-agent standard;
   use `CLAUDE.md` for Claude Code or `GEMINI.md` for Gemini) and the brief
   templates. Name it for your agent so it's read automatically — don't rely on
   a rename.

2. **Fill in `CLAUDE.md`** — what the project is, the active work, where the
   knowledge index lives. This is the file your AI reads first, every session.

3. **Write one Prompt Brief** before your next session, and one **Session Brief**
   at the end of it. That's the whole loop. Everything else compounds from there.

Full half-day setup: **[c2method.ai/start](https://c2method.ai/start)**

---

## What's in here

```
c2method/
├── methodology.md   ← the full method        quick-start.md   ← half-day setup
└── starter/         ← copy this into your project (cp -r starter/. your-project/)
    ├── AGENTS.md                      ← the Router (router.md): your AI reads this first
    ├── .claude/commands/             ← learn.md, audit.md (agent commands)
    └── docs/
        ├── 01-planning/product-requirements/   platform-prd.md · feature-prd.md
        ├── 02-working/
        │   ├── prompt-briefs/        prompt-brief-interactive.md · …-autonomous.md
        │   ├── session-briefs/       session-brief.md
        │   ├── release-notes/        release-note.md
        │   └── tasks/                task.md
        ├── 03-knowledge/
        │   ├── gotchas/              knowledge-gotcha.md
        │   ├── patterns/             knowledge-pattern.md
        │   └── decisions/            knowledge-adr.md
        ├── 04-operations/
        │   ├── deployment/           deployment-checklist.md
        │   └── runbooks/             runbook.md
        ├── 05-reference/             tech-stack.md · naming-conventions.md
        └── 06-agents/                agent-team.md · agent-role.md
```

**The starter is the product — every folder ships with a starter template in it.**
Copy it in and you have the structure, the Router, and a template in each folder
ready to fill. The methodology doc is the manual. And it's **adaptive** — add your
own folders and templates as your project needs them; this is a starting shape,
not a cage. Learn how each folder works at [c2method.ai/docs](https://c2method.ai/docs).

---

## The promise

You don't need to be a senior developer to build like one. What you need:

- An AI coding agent (Claude Code, Cursor, or similar)
- A project you're actually building
- The discipline to run one session brief per session

What you get: an agent that learns your project and gets smarter every session,
the ability to run sessions autonomously, and output that looks impossible from
the outside.

---

## License

Licensed under [**CC BY-NC-SA 4.0**](LICENSE). In plain English (see [NOTICE](NOTICE)):

> **Build whatever you want with C² — including things you sell.**
> **Just don't sell C² itself as if it were yours.**

Use it, copy the templates, adapt it, share it — at no charge. Keep it credited,
keep it open, and don't repackage the method itself as a paid product.

---

C² was built by **Stuart Leo** ([stuartleo.com](https://stuartleo.com)), founder
of **[WaymakerOS](https://waymakeros.com)** — a business OS for SMBs.
