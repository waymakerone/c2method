# The C² Method

> **Your AI agent forgets everything between sessions. C² fixes that.**

C² is a free, open source build method that turns AI coding agents into genuine
development partners — for builders at any level.

Not a theory. Built and battle-tested over two years and 1,000+ agent sessions
shipping a production SaaS. Every template in this repo came from that build.

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

   It carries the **.md Router** (`CLAUDE.md` — rename to `AGENTS.md` for Codex
   or `GEMINI.md` for Gemini CLI) and the brief templates.

2. **Fill in `CLAUDE.md`** — what the project is, the active work, where the
   knowledge index lives. This is the file your AI reads first, every session.

3. **Write one Prompt Brief** before your next session, and one **Session Brief**
   at the end of it. That's the whole loop. Everything else compounds from there.

Full half-day setup: **[c2method.ai/start](https://c2method.ai/start)**

---

## What's in here

```
c2method/
├── methodology.md     ← the full method
├── quick-start.md     ← set up C² on a project in half a day
├── starter/           ← drop this into any project today
│   └── CLAUDE.md       ← the .md Router: your AI's entry point
└── templates/         ← the contextbase artefacts
    ├── platform-prd.md
    ├── feature-prd.md
    ├── prompt-brief-interactive.md
    ├── prompt-brief-autonomous.md
    ├── session-brief.md
    ├── release-note.md
    ├── knowledge-gotcha.md
    ├── knowledge-pattern.md
    ├── knowledge-adr.md
    ├── agent-team.md
    └── agent-role.md
```

**The starter folder is the product. The methodology doc is the manual.**

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
