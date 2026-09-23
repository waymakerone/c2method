# C² Method — Skills

**`flight-plan`** is the method skill: file a plan before a build session, fleet or no fleet.
The **`c2-*`** skills are the fleet's role rulebooks — the lane, the tower (repo-ops), the
checkpoint (pr-review), the gardener, and `c2-fleet` for the pilot's own agent. You never load
those by hand: the fleet hands each agent its rulebook at launch. Read
[`../fleet/RULES.md`](../fleet/RULES.md) to know what they enforce.

Installable, agent-agnostic skills for teams running the C² Method. Each skill is a documented
job with a fixed protocol. They are **review-only or draft-only** — they produce something a
human acts on, never the final call.

## Install

Copy the skill folder into your repo's `.claude/skills/` (for Claude Code) or the equivalent
skills directory for your agent. It travels with the repo via git — everyone gets it on pull.

A plugin-marketplace install (`/plugin marketplace add waymakerone/c2method` →
`/plugin install <skill>`) is planned so teams can install across repos without copying.

## Skills

| Skill | What it does |
|---|---|
| [`flight-plan`](flight-plan/SKILL.md) | Prepare a flight plan from a Feature PRD before a build session — draw the scope line, interrogate the spec, draft the Prompt Briefs, plot the journey. Stops at *filed*; never builds. |

Learn the methodology behind these at **c2method.ai**.
