---
id: [generate]
title: "Agent Team — [Project Name]"
type: agent-team
project: [project name]
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [agents, team, c-squared]
---

# Agent Team — [Project Name]

> The agent team design is a pilot decision. Document it here so every session knows who's on the team, what they're responsible for, and what the rules of engagement are. Update this when agents change, budgets change, or a new specialist is added.
>
> C² is agent-agnostic. This team works with whatever agents best fit the project's stack, budget, and workflow — not a commitment to a specific vendor.

---

## Lead Agent

| Field | Value |
|---|---|
| **Agent** | [e.g., Claude Code — claude-sonnet-4-x] |
| **Role** | Lead executor — reads contextbase, writes code, manages git, extracts knowledge, writes session briefs |
| **Scope** | All active PRDs and Prompt Briefs |
| **Model** | [specific model version] |
| **Toolchain** | [e.g., Claude Code CLI, VS Code extension] |
| **Session start** | Reads CLAUDE.md → most recent session brief → relevant knowledge files → active PB |
| **Session end** | Commits work → writes session brief → extracts knowledge (if Key Discovery) → updates CLAUDE.md |

**Why this agent:** [One sentence on why this is the right lead for this project]

---

## Bench Agents

Bench agents review, never execute. They are invoked for high-stakes decisions and their output is always saved with an `Actions Taken` table.

### [Bench Agent Name]

| Field | Value |
|---|---|
| **Agent** | [e.g., Grok — grok-3] |
| **Role** | Independent reviewer — PRDs, security, architecture, second opinions |
| **Budget cap** | $[X]/month, [N] calls/day maximum |
| **Invocation triggers** | PRD approval, security-sensitive code, architectural decisions, anything where the lead's bias could be a problem |
| **Output location** | `docs/06-agents/[agent-name]/reviews/` |
| **Required output format** | Findings + mandatory `Actions Taken` table (close the loop — what was done with each finding) |
| **What it never does** | Touches the codebase, runs tests, commits anything |

---

## Specialist Agents

Scoped subagents with a tightly defined role and documented protocol for repeatable high-value tasks.

| Agent | Role | Invocation | Definition |
|---|---|---|---|
| [qa-reviewer] | Scaffolds structured test notes for PRs | `karlo says "I'm testing PR #N"` | [[.claude/agents/qa-reviewer.md]] |
| [release-author] | Drafts internal release notes from commit history | `"draft release note for PR #N"` | [[.claude/agents/release-author.md]] |
| [agent-name] | [Role] | [When invoked] | [[link to definition]] |

---

## Rules of engagement

1. **One agent per surface.** The lead agent and bench agents never work on the same file at the same time.
2. **Bench reviews are sequential, not parallel.** Lead executes → bench reviews → lead acts on review. Not concurrent.
3. **Budget enforcement is the pilot's responsibility.** Check the bench agent's call count before invoking. A bench review that blows the monthly budget because nobody checked is a pilot error.
4. **All bench reviews are saved and actioned.** A review with no `Actions Taken` table is a review that didn't happen. Save it, write the table, commit it.
5. **Specialist agents have their own protocols.** Read the agent definition before invoking. Don't invoke a specialist without understanding what it will do.

---

## Agent changelog

| Date | Change | Reason |
|---|---|---|
| YYYY-MM-DD | Initial team design | Project start |
| YYYY-MM-DD | [Changed X to Y] | [Why — model upgrade, cost, capability gap] |
