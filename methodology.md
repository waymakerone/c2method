
# C² — The AI-Native Development Methodology

> **P = aic²**
>
> Productivity equals AI multiplied by Context squared.
>
> The insight isn't that AI makes developers faster. It's that *context and code together* make AI exponentially more effective — and both compound. C² = Context × Code. The exponent isn't marketing. It's the mechanism.

---

## What C² is

C² (C-Squared) is a document-driven, AI-native software development methodology built on one architectural insight:

**Every software project has two parallel systems: a codebase (what runs) and a contextbase (what guides).**

Traditional methodologies optimise the codebase. C² optimises both. The contextbase — PRDs, session briefs, gotcha logs, decision records, patterns — is written as part of development, lives in the same repository as the code, and is read by AI agents before they touch anything. After 50 sessions it is denser in decision context than the codebase itself. After 200 sessions it is irreplaceable institutional memory.

This is not a documentation culture. It is an **execution infrastructure**.

---

## The equation

**P = aic²**

| Symbol | Meaning |
|---|---|
| P | Productivity — features shipped, quality held, knowledge retained |
| ai | The AI crew — capability of the agents executing under human direction |
| c | **Context** — the contextbase: briefs, patterns, gotchas, decisions |
| c | **Code** — the codebase: the software that runs |
| c² | Context × Code — the two Cs multiply each other |

The name C² is literal: **two Cs**. Context and Code. Every software project runs on both systems simultaneously — the codebase (what executes) and the contextbase (what guides execution). Traditional methodologies optimise only the codebase. C² optimises both, and treats their relationship as multiplicative: if either is zero, productivity collapses regardless of AI capability. A brilliant AI with no contextbase is improvising. A rich contextbase with no working code is documentation. You need both, and the value of each amplifies the other.

**The multiplication works in both directions.** A richer contextbase — more gotchas captured, better PRDs, sharper session briefs — makes AI-generated code more precise and less likely to repeat past mistakes. Better code — cleaner architecture, more consistent patterns — surfaces insights that enrich the contextbase. Context improves Code; Code improves Context. That's the compounding loop the exponent captures.

**Both variables are live levers — not constants.** In Einstein's equation, c (speed of light) is fixed. In P=aic², all three variables improve over time: a better AI model grows `ai`; more sessions and richer documentation grow both Cs. A 2× improvement in AI capability and a 2× improvement in both Context and Code produces 8× productivity (2 × 2² = 8). The methodology is a structural bet that all three will keep improving — and the direction of AI development makes that a good bet.

**What a model release looks like in C² terms:** When a new AI model ships, every project running C² immediately benefits — the contextbase doesn't need to be rebuilt, the templates don't change, the folder structure stays intact. A richer `ai` is now reading the same `c²`. The compounding already done multiplies by a larger number overnight. This is the equation working as designed: the methodology investment is model-agnostic and accrues value every time the AI improves.

---

## Where C² sits — prompt, context, and harness engineering

Three nested layers, each containing the one before: **prompt engineering** (the message — one composed input), **context engineering** (the memory — what a curator keeps or drops in a finite window), **harness engineering** (the machine — the gather → act → verify loop, retrying on failure). **C² is a harness methodology:** the Prompt Brief is its prompt layer, the contextbase and .md Router its context layer, the Cascade and verification chain the harness. "Isn't this just prompt or context engineering?" — no: C² sits at the harness layer and contains both. Full analysis: `research/prompt-context-harness-engineering`.

---

## The Pilot Model

The methodology's core mental model: **the developer is a pilot, not a crew member.**

A crewman hauls rope. A pilot sets course, reads instruments, makes decisions, and directs the crew. AI agents are the crew — they write code, run tests, manage files, generate documentation. The pilot scopes the work, reviews output, makes architectural calls, and owns the quality bar.

This reframe matters structurally. It changes what the human works on:

| Crewman (wrong) | Pilot (right) |
|---|---|
| Writing boilerplate | Writing the brief that constrains the boilerplate |
| Chasing a bug for three hours | Invoking the 30-minute debug limit and escalating |
| Typing out a test | Specifying testable acceptance criteria before a line runs |
| Updating documentation after the fact | Writing the session brief as part of the session |

The crewman measures output in lines written. The pilot measures output in decisions made and outcomes shipped.

---

## The Cascade — 6 tiers

The fundamental building block of C² execution. Every piece of work flows through this chain:

```
Platform PRD
  └── Feature PRD          ← one per feature, a living document
       └── Prompt Brief × N ← the atomic build unit
            └── Task × N    ← zero is fine for small briefs
                 └── Session Brief     ← every session, no exceptions
                      └── Release Note         (optional, on PB completion)
                           └── Weekly Announcement  (optional, Friday roll-up)
```

Each tier has a defined frontmatter contract and a folder lifecycle: `backlog → in-progress → review → done`.

**Feature PRDs are living documents.** Not frozen at creation. They evolve as market, design, and engineering reality changes. One PRD per feature, evolved in place. A PRD that doesn't change is a PRD nobody is reading.

**Prompt Briefs are the atomic build unit.** Where the pilot-to-crew handoff happens. The brief is the pilot's specification: what to build, what not to build, what to read before starting, what the acceptance criteria are. An autonomous brief (pilot absent) requires exact file paths and line ranges in the pre-flight section. An interactive brief (pilot present) requires the same 6-item quality gate. The brief quality is the bottleneck, not the AI's capability.

**Session Briefs are AI memory.** Every session, no exceptions. They serve two purposes simultaneously: AI memory continuity (no persistent memory between sessions) and async team communication (no standup needed). One artefact, two jobs. If the session doesn't have a brief, the knowledge from that session evaporates.

A session brief is written any time the AI's context is about to be interrupted or lost — not just at the end of a working day. Triggers include: a phone call, a meeting, a work break, closing the laptop, rebooting the machine, switching to a different task, or ending for the night. Any break where the AI context resets means a session brief is needed before the break. The question to ask is not "is the session finished?" but "if I came back to this cold, what would I need to know?"

The session brief also serves as the moment to identify documentation obligations created by the session's work. Before committing, the pilot checks:

- **Knowledge documents** — did this session produce a gotcha, pattern, or architectural decision that future sessions will need? If yes, the knowledge file is identified in the brief and committed in the same session.
- **Operational documents** — did this session introduce or change a deployment step, runbook, or operational procedure? If yes, the ops doc is identified and either written now or flagged as a tracked obligation with a due point (commit, PR, or release).
- **Commit obligation** — knowledge documents are committed with the session brief in the same commit, not deferred.
- **PR obligation** — operational documentation that spans multiple sessions may be flagged for completion at PR time, but it must be listed in the brief — not left to memory.

The session brief is the checkpoint between doing and knowing. Work without a brief is work that happened but wasn't learned from.

---

## The Codebase + Contextbase Model

```
project/
├── apps/             ← codebase (what runs)
└── docs/
    ├── 01-planning/  ← PRDs, strategy, methodology
    ├── 02-working/   ← Prompt Briefs, sessions, tasks, releases
    ├── 03-knowledge/ ← Patterns, gotchas, ADRs  ← the self-improving layer
    ├── 04-operations/← Deployment, runbooks, debugging
    ├── 05-reference/ ← Tech stack, naming, constants
    └── 06-agents/    ← Agent team design, roles, protocols, reviews
```

The `03-knowledge/` directory is the methodology's highest-compounding asset. The mechanism:

1. An AI agent discovers something unexpected — a quirk of the framework, a race condition, a gotcha in the auth flow
2. The agent extracts it to `03-knowledge/gotchas/` in the same session
3. The next agent session reads the knowledge index before touching relevant code
4. The gotcha never costs the team time again

After 50+ captures, the knowledge index is a library of battle-tested patterns. It doesn't evaporate when a person leaves. It compounds with every session. Gotcha capture is not optional — a session brief with a non-empty `Key Discovery` is not complete until the knowledge file is committed in the same session.

---

## Context curation — the finite-window problem

The contextbase grows denser than the codebase, so no agent loads all of it into a finite window; "read the context first" becomes a selection problem. The **.md Router is the curator** — it links rather than embeds, so the agent pulls only what the work needs and lazy-loading *is* the compression. As it scales: load by surface, not completeness; read the knowledge *index*, not every file; treat the latest session brief as compressed history. Tracked as v1.2: what to do when even the curated slice exceeds budget — summarising an oversized index, archiving stale patterns, pruning the router.

---

## The Agent Team

**C² is agent-agnostic.** The methodology works with any AI coding agent running in the terminal — Claude Code, Grok CLI, Gemini CLI, Codex, Cursor, or any agent that can read files, write files, and commit to git. The contextbase is plain markdown. Any agent that can read markdown can use it.

This matters. Choosing C² is not a commitment to a specific vendor. It is a commitment to a methodology. When a better agent ships — and they will keep shipping — you adopt it and the contextbase transfers intact. The context you've built doesn't belong to the agent; it belongs to the project.

### Designing your agent team

The pilot's first design decision is the agent team: who leads, who reviews, and who handles specialist tasks. This is documented in `docs/06-agents/team.md` and kept current as the team evolves.

**The Lead Agent — one agent, one codebase surface**

The lead agent reads the contextbase, writes code, manages git, extracts knowledge to `03-knowledge/`, and writes session briefs. It is the primary executor. Choose the agent that best fits your stack, your budget, and your workflow — then commit to it for a feature area. Running 4+ agents simultaneously on the same problem creates conflicting recommendations, worktree conflicts, and session briefs that are impossible to write. One agent leads per surface.

*Examples: Claude Code, Grok CLI, Gemini CLI, Codex CLI*

**Bench Agents — independent review on high-stakes calls**

Bench agents review, never execute. They are invoked for PRDs, security decisions, architecture choices, and any call where a second independent opinion changes the risk profile. Budget-controlled: set a monthly spend cap and a daily call limit. All bench reviews are saved to `docs/06-agents/[agent-name]/reviews/` with a mandatory `Actions Taken` close-the-loop table — the review has no value if the team doesn't record what was done with it.

The value of a bench agent is *independence*. The lead agent has already made decisions about the code it wrote. The bench agent hasn't. That's the point.

*Examples: Grok (second opinion), Gemini (architecture review), a specialist model for security*

**Specialist Agents — scoped subagents for repeatable tasks**

Some tasks are high-value and highly repeatable: QA review, release note authoring, estimation, code review against a specific standard. These are candidates for specialist subagents — agents with a tightly defined role, a specific set of tools, and a documented protocol. Specialist agents live in `.claude/agents/` (for Claude Code subagents) or equivalent directories for other toolchains. Their role definitions, testing protocols, and invocation instructions are documented in `docs/06-agents/specialist/`.

*Examples: qa-reviewer (scaffolds structured test notes for PRs), release-author (drafts internal release notes from commit history), security-reviewer*

### The multi-agent anti-pattern

Running multiple agents simultaneously on the same problem — regardless of which agents — burns cost, produces contradictory outputs, creates worktree conflicts, and makes session briefs impossible to write coherently. The pattern to avoid: two agents both modifying the same files in the same session. The pattern to use: one agent executes, one agent reviews, and they never work concurrently on the same surface.

The anti-pattern most often emerges from urgency. A blocked session, a tight deadline, a complex bug — and the impulse is to throw more agents at it. That impulse is wrong. Clarify the brief, surface the blocker, and let one agent proceed. Multi-agent is a *sequential* practice (lead executes → bench reviews → lead acts on review), not a parallel one.

---

## Anti-Pattern Catchers

Three structural rules built into C² to combat "create-not-finish drift" — the tendency of AI-augmented teams to create faster than they complete:

**Rule A — Max 5 concurrent in-progress PRDs.** Anything above goes to backlog. Forces completion before starting. A team with 20 in-progress PRDs has 15 aspirations and 5 active projects. The cap makes that distinction impossible to ignore.

**Rule B — A PRD must have ≥1 Prompt Brief before moving to in-progress.** If you can't write a single execution brief, it's a thinking document, not active work. This prevents the backlog from filling with half-formed ideas labelled as active.

**Rule C — Monthly 30-minute PRD review.** Walk every in-progress PRD, update `completion_rationale` and `last_reviewed`. Force-move stale ones to backlog. Thirty minutes once a month eliminates the category of "things we're nominally working on but haven't touched in 90 days."

---

## What's better than traditional agile

The closest pre-AI methodological ancestor is **Shape Up** (Basecamp): C² shares its appetite model, outcome focus, and resistance to sprint theatre. The closest AI-native peer is **AWS AI-DLC** (AI-Driven Development Lifecycle, launched re:Invent 2025): both use hierarchical documentation pipelines feeding context to AI agents, both are agent-agnostic, and both report significant productivity gains. The table below covers all three.

| | Scrum | Shape Up | AWS AI-DLC | C² |
|---|---|---|---|---|
| Planning unit | Sprint → Story | Pitch → Scope | Inception → Construction → Operations | PRD → PB → Task |
| Time box | 2-week sprints | 6-week cycles | Phase-gated (hours to weeks) | Weekly (outcome-based, individual PRD ownership) |
| Estimation | Story points | Appetite (fixed budget) | Not specified | PB phase sizing (≤6 items, ≤45 min each) |
| Backlog governance | Groomed, always growing | Betting table | Not specified | Active/backlog folders + Rule A cap (max 5) |
| Ceremonies | Standup, planning, review, retro | Team-defined | Human approval gates at phase handoffs | Session briefs (async daily) + fortnightly team alignment |
| Documentation | Jira + Confluence (rots) | Basecamp | `aidlc-docs/` rule files per phase | Repo-native markdown, git-controlled, AI-readable (compounds) |
| Knowledge management | Tribal / wiki that rots | Tribal | Not specified | `03-knowledge/` in git, agent-written, self-improving |
| Human role | Contributor | Shaper | Approver at gates | Pilot (directing throughout) |
| Completion signal | Story points | Shipped feature | Phase gate sign-off | PRD completion_rationale + session brief chain |
| AI integration | None (tools bolted on) | None | Agent-agnostic execution pipeline | Native — the methodology exists to direct AI effectively |
| Context model | — | — | Context delivery (load and use) | Contextbase (invest and compound) |

**The critical departure from AI-DLC:** AI-DLC positions the human as an approver at phase handoffs — the pipeline runs, the human signs off. C² positions the human as a Pilot directing throughout — writing the brief before the session, reviewing after each item, owning the quality bar continuously. And where AI-DLC treats context as delivery (load the right rules, execute the phase), C² treats context as investment: the contextbase compounds in value across every session, becoming denser than the codebase itself after sustained use.

**The critical departure from Shape Up:** Shape Up was designed for humans directing humans. C² is designed for humans directing AI agents. Every artefact in C² is designed to be machine-readable as well as human-readable. Shape Up has no equivalent of the .md Router, the session brief as AI memory, or the autonomous execution contract.

---

## What's genuinely new

### 1. The Pilot mental model as a structural constraint

The Pilot/Crew framing isn't a metaphor — it's a scope constraint. A pilot doesn't write boilerplate. A pilot doesn't chase a bug for three hours. The framing makes the *wrong* behaviours feel obviously wrong rather than heroic. Traditional methodologies have roles; C² has a mental model that changes what each role considers acceptable.

### 2. The contextbase as a first-class product artefact

Treating `docs/` as equally important to `apps/` — and having the AI write to both — is C²'s most distinctive structural commitment. The contextbase isn't documentation *about* the codebase; it's a parallel system that grows in value as the codebase grows.

### 3. The autonomous execution contract

The autonomous Prompt Brief — particularly the pre-flight section listing specific files with exact line ranges and a reason for reading each — forces the brief author to think like a software architect *before* the agent touches anything. Traditional agile writes a ticket and trusts the developer figures out the approach. The autonomous PB specifies it, making execution reproducible and auditable. The per-item READ→IMPL→REVIEW→VERIFY→COMMIT cycle and the 45-minute blocker limit close the remaining gap.

### 4. The .md Router pattern

A single markdown file at the repo root that every AI session reads first — lazy-loading exactly the context needed rather than pasting everything into every conversation. The router links to docs; the agent pulls what it needs.

The filename is agent-specific: `CLAUDE.md` for Claude Code, `AGENTS.md` for Codex, `GEMINI.md` for Gemini CLI. The pattern is agent-agnostic. What matters is the structure: one entry point, explicit links to active PRDs, the most recent session brief, the knowledge index, and the pilot rules. Every agent that reads files can read a router.

This is a well-engineered solution to a problem most teams are still brute-forcing — pasting entire docs into every prompt, manually restating context at the start of each session, or relying on the agent to remember things it structurally cannot. The router makes context loading systematic and reproducible.

### 5. Knowledge capture to git as compounding institutional memory

Gotchas, patterns, and ADRs — all written by the AI, all read by the AI on the next session. Traditional teams lose this knowledge when people leave. In C², it accumulates. The offshore onboarding test: contributors in a new location can get context from the knowledge index that previously required pairing with a senior engineer.

### 6. Session briefs as AI memory — triggered by context breaks, not the clock

AI agents have no persistent memory between sessions. The session brief is the mechanism that provides it — a committed markdown file the next agent reads before touching anything. What makes C²'s implementation distinct is the trigger model: a session brief is written any time the AI context is about to be interrupted or lost, not just at end of day. Phone call, meeting, machine reboot, hitting the context window limit — any of these triggers a brief. The question is not "is the session finished?" but "if I came back to this cold, what would I need to know?"

The brief also serves as the moment to identify documentation obligations: knowledge files that must be committed in the same session, operational documents due at PR merge, deferred test debt that carries forward until it's closed. One artefact, multiple jobs — and those jobs are explicitly tracked, not left to memory.

Team standup communication is a side effect, not the purpose.

### 7. Multi-AI review as structured practice

Lead agent + bench agent with budget controls, mandatory output saved, and close-the-loop `Actions Taken` tables. This is disciplined multi-agent governance, not ad hoc "ask ChatGPT about the diff."

---

## Methodology landscape and prior art

C² was formalised in May 2026 from production practice. The following methodologies occupy adjacent territory — each is acknowledged here for honest differentiation:

| Methodology | Source | Relationship to C² |
|---|---|---|
| **AWS AI-DLC** | AWS re:Invent Nov 2025 | Closest structural peer. Hierarchical pipeline + agent-agnostic. Key difference: delivery model (approver at gates) vs. Pilot model (director throughout); context delivery vs. contextbase compounding. |
| **Agentsway** | arxiv Oct 2025 | Independently developed AI-native methodology. Focus: specialised agents + LLM fine-tuning within the team loop. No contextbase concept, no router, no Pilot model. |
| **ICM (Interpretable Context Methodology)** | arxiv Mar 2026 | Numbered stage folders + CONTEXT.md router — structurally similar to the .md Router and `03-knowledge/` pattern. C²'s distinct contribution: the lazy-loading framing and the contextbase-as-investment model. |
| **Lore Protocol** | arxiv Mar 2026 | Knowledge capture to git — the same problem C²'s `03-knowledge/` solves, via commit message trailers rather than a separate knowledge folder. Complementary, not competitive. |
| **Context Engineering** | Field term coined mid-2025 (Karpathy) | The broader discipline C²'s contextbase implements. C² does not use this term; "contextbase" is more specific vocabulary for the same domain. |
| **Single Conversation Methodology** | arxiv Jul 2025 | Single-session human-directed AI development. Overlaps the Pilot model and session brief concept; does not address multi-session continuity or git-backed compounding. |
| **Shape Up** | Basecamp | Pre-AI ancestor: appetite model, outcome focus, no sprint theatre. Not AI-native; no contextbase, no router, no autonomous execution contract. |
| **V-Bounce Model** | arxiv Aug 2024 | AI-native SDLC reweighting toward upfront specification. Structural overlap with C²'s emphasis on PRDs before execution; different execution model and no compounding knowledge layer. |

**What remains genuinely novel to C²:** the Pilot/Crew mental model as a structural scope constraint; "contextbase" as vocabulary and investment framing (not just context delivery); P = aic² as an equation encoding the methodology's core mechanism; the .md Router named and framed as lazy-loading architecture; session briefs triggered by context breaks (not the clock); and multi-agent governance (lead/bench/specialist) as a practitioner discipline with budget controls and mandatory close-the-loop tables.

**The practitioner-first claim:** Every methodology in the table above was designed by researchers theorising about AI-augmented development. C² emerged from production software delivery under real commercial pressure and was formalised afterward. That is a different epistemic foundation — and the productivity evidence reflects it.

---

## Productivity evidence

C² has been validated in a production software environment running a real commercial product. The methodology was not designed and then tested; it evolved under delivery pressure and was formalised from working practice.

**Individual lift:** Engineers operating under C² methodology show 3–8× output increase year-over-year on an individual basis, controlling for team size growth.

**Team lift:** Combined team output (commits, PRs shipped, features landed) increased by approximately 10× over the same two-month window compared to equivalent pre-methodology baseline.

**Merge discipline maintained:** Code review speed improved (not degraded) under the higher commit rate — median time-to-merge fell 29% year-over-year. Pace did not erode quality.

**Knowledge accumulation:** 50+ gotchas, patterns, and ADRs captured to `03-knowledge/` across the proving period. Zero of those are in a Confluence page that will rot.

**PM integration:** Product decisions committed directly to the repository alongside code — strategy documents, PRD updates, and architecture decisions live in git alongside implementation. The separation between "product work" and "engineering work" in the repository is eliminated.

---

## The gaps currently being closed (v1.1)

C² v1.0 shipped and worked. These are the v1.1 improvements being folded into the templates:

1. **Gotcha capture gate** — Knowledge extraction moves from checkbox to commit requirement. A session brief with a non-empty Key Discovery is not complete until its `03-knowledge/` file is committed in the same session.

2. **Universal PB quality gate** — The 6-item quality checklist (goal, scope exclusions, testable AC, non-goals, testing approach, definition of done) now applies to all Prompt Briefs — interactive and autonomous. The inconsistency between brief types is removed.

3. **Mid-brief checkpoint** — Autonomous Prompt Briefs with 4+ items include a mandatory checkpoint paragraph after item 3. One paragraph: approach still valid? If not, surface now. Prevents architectural drift in long autonomous runs.

4. **Estimation aggregation** — `estimated_hours` / `actual_hours` frontmatter fields in completed PBs are read by a metrics script and output as estimation accuracy by area. The calibration data exists; the reading of it is now automated.

5. **CI coverage gate** — Policy ("tests are part of the build") is backed by mechanical enforcement. Per-new-file coverage requirement or mandatory test file alongside new source files. The rule becomes unskippable.

---

## Using C² — the quick start

1. **Set up the router.** A single markdown file at the repo root is the pilot's instrument panel — `CLAUDE.md` for Claude Code, `AGENTS.md` for Codex, `GEMINI.md` for Gemini CLI. It links to PRDs, the knowledge index, the current active work, and the pilot rules. Every AI session starts here.

2. **Design your agent team.** Before writing a line of code, decide who's on the team. Document in `docs/06-agents/team.md`: which agent leads (reads context, writes code, manages git), which agent reviews (PRDs, security, architecture — budget-capped, never touches the codebase), and any specialist agents for repeatable tasks. C² is agent-agnostic — you are committing to roles, not vendors.

3. **Write the Platform PRD.** What is this product? Who is it for? What does it not do? This is the strategic layer every feature PRD inherits from.

4. **Create a Feature PRD for each feature.** One PRD per feature, in `docs/01-planning/prds/backlog/` until a Prompt Brief exists for it (Rule B). Then move to `in-progress/` (max 5 at once — Rule A).

5. **Write Prompt Briefs, not tickets.** The brief specifies what to read, what to build, what not to build, and what done looks like. For autonomous execution: include exact file paths and line ranges in pre-flight. For interactive: verify the 6-item gate before starting.

6. **Write a Session Brief whenever context breaks.** Session briefs are AI memory — not an end-of-day ritual. Write one any time the AI context is about to reset: a phone call, a meeting, a break, closing the laptop, hitting the context limit, or ending for the night. If the session produced a Key Discovery, the `03-knowledge/` file is committed in the same session. If it introduced an operational change, the documentation obligation is identified and given a due point (commit, PR, or release).

7. **Run the monthly Rule C review.** Thirty minutes. Walk every in-progress PRD. Move stale ones to backlog. The WIP cap enforces itself if you let it.

---

*C² methodology. First formalised May 2026. v1.2 additions (harness positioning; context curation), May 2026.*
