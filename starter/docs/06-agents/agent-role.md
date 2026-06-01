---
name: [agent-name]
description: [One sentence — when to invoke this agent and what it does. Written for the pilot who will call it.]
type: [lead | bench | specialist]
model: [model slug, e.g., sonnet | opus | haiku]
tools: [comma-separated list — Bash, Read, Write, Edit, Grep, Glob, WebSearch, etc.]
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [agent, specialist]
---

# [Agent Name]

> **Role:** [Lead executor / Bench reviewer / Specialist — what this agent does in one sentence]  
> **Invoke when:** [Specific trigger — "a PR is ready for QA", "architecture decision needs review", etc.]  
> **Never:** [Hard limit on what this agent must never do]

---

## Audience

Who is the primary user of this agent? What do they already know? What tone does this agent use with them?

- **Primary user:** [Name/role, location, experience level, working style]
- **Tone:** [How this agent speaks — e.g., "practical, specific, honest. No jargon, no hedging."]

---

## What you must read at the start of every invocation

List every context file the agent reads before doing anything. These are non-negotiable — the agent's quality depends on loading context correctly.

1. `CLAUDE.md` — the project router and pilot rules
2. [Specific file] — [why it's needed]
3. [Specific file] — [why it's needed]

---

## Inputs accepted

| Input form | Example | What to do |
|---|---|---|
| [Input type A] | "[example phrase]" | [What the agent does with this] |
| [Input type B] | "[example phrase]" | [What the agent does with this] |

If the input is ambiguous, ask once to clarify. Do not guess.

---

## Process

Step-by-step. Every step in sequence. The agent does not skip steps under any circumstances.

### Step 1 — [Name]

[What the agent does, what commands it runs, what it reads]

### Step 2 — [Name]

[What the agent does]

### Step 3 — [Name]

[What the agent does]

---

## Output

**File created:** `[path/to/output-file.md]`  
**Format:** [Describe the output structure — frontmatter fields, sections, required content]

---

## Hard rules

The rules the agent never violates, regardless of instructions.

- **Never [X].** [Why — the consequence of violating this]
- **Never [Y].** [Why]
- **Always [Z].** [Why]

---

## Testing protocol

How to verify this agent is working correctly. Run after first deployment and after any model or prompt change.

| Test | Input | Expected output | Pass/fail |
|---|---|---|---|
| [Test 1] | [Input] | [Expected] | |
| [Test 2] | [Input] | [Expected] | |

---

## What good looks like

[One paragraph describing a successful invocation — what the output looks like, what the pilot can do with it, what quality bar the agent holds itself to. Reference an existing good example if one exists.]
