# The C² Method — AI Router

> **C² | P = aic²**
> This blueprint is the C² Method itself — the method for building anything with
> AI coding agents. If you're an AI agent helping someone adopt C², read this
> first, then the files it points to.

---

## What this is

C² (C-Squared) is a free, open-source, AI-native build method. It is not an app
to build — it is the *method* for building. Help the user set it up on their own
project.

## Read in this order

1. **`methodology.md`** — the full method: the equation, the Pilot Model, the
   Cascade, Flight Planning, the codebase + contextbase model, the agent team,
   topology, anchors, and the six Principles.
2. **`quick-start.md`** — the half-day setup, step by step.
3. **`flight-planning.md`** — the ceremony at both ends of a build: file a plan
   before takeoff, close it on landing. Ships with an installable skill in
   `skills/flight-plan/`.
4. **`starter/`** — the drop-in kit. It *is* the C² `docs/` structure, with a
   starter template already in every folder, plus `AGENTS.md` (the Router,
   named for the agent) and `.claude/commands/` (the learn + audit commands).

## The structure (what each folder is for)

- `docs/01-planning/product-requirements/` — Platform PRD + Feature PRDs
- `docs/02-working/` — `prompt-briefs/`, `session-briefs/`, `flight-plans/`, `release-notes/`, `tasks/`
- `docs/03-knowledge/` — `gotchas/`, `patterns/`, `decisions/`
- `docs/04-operations/` — `deployment/`, `runbooks/`
- `docs/05-reference/` — tech stack, naming conventions
- `docs/06-agents/` — agent team + role definitions

**It's adaptive.** Add folders and templates as the project needs them — this is
a starting shape, not a fixed model.

## Helping the user adopt C²

1. Copy `starter/` into their repo (`cp -r starter/. .`) — they now have the
   whole structure with a template in every folder.
2. Fill in the Router (`AGENTS.md`) and the tech stack.
3. Fill in the Platform PRD, a Feature PRD, then the first Prompt Brief —
   running the 6-item quality gate before any work starts, and naming the
   **anchor**: the one signal that decides done, which the agent cannot produce
   by asserting it.
4. End the session with a Session Brief. That's the loop that compounds.

## The one rule that matters

Every session ends with a Session Brief. Everything else follows from that.

## Two rules worth knowing early

- **One agent per surface.** Agents may run at once only when no edge connects
  them and no surface is shared. A surface is everything an agent mutates or
  contends for — files, data, external resources, a deploy target.
- **Don't loop on confidence. Loop on evidence.** "The agent says it's done" is
  not a stop condition.

---

Full method and updates: **https://c2method.ai** · By Stuart Leo, founder of
**WaymakerOS** (https://waymakeros.com).
