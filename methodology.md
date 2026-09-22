
# C² — The AI-Native Development Methodology

> **P = aic²**
>
> Productivity comes from AI applied to your two systems — Context and Code.
>
> The insight isn't that AI makes developers faster. It's that *context and code together* make AI far more effective — and both compound. The "²" is the **two Cs** — Context × Code — not a literal exponent. It's a mnemonic: the two systems multiply each other and compound across sessions.

---

## What C² is

C² (C-Squared) is a document-driven, AI-native software development methodology built on one architectural insight:

**Every software project has two parallel systems: a codebase (what runs) and a contextbase (what guides).**

Traditional methodologies optimise the codebase. C² optimises both. The contextbase — PRDs, session briefs, gotcha logs, decision records, patterns — is written as part of development, lives in the same repository as the code, and is read by AI agents before they touch anything. After 50 sessions it is denser in decision context than the codebase itself. After 200 sessions it is irreplaceable institutional memory.

This is not a documentation culture. It is an **execution infrastructure**.

C² runs the same shape at any size — one person with one agent, or a team running many apps. The roles are roles, not headcount: solo, you play them all.

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

**The multiplication works in both directions.** A richer contextbase — more gotchas captured, better PRDs, sharper session briefs — makes AI-generated code more precise and less likely to repeat past mistakes. Better code — cleaner architecture, more consistent patterns — surfaces insights that enrich the contextbase. Context improves Code; Code improves Context. That's the compounding loop at the heart of C².

**All three are live levers — not constants.** Every variable improves over time: a better AI model grows `ai`; more sessions and richer documentation grow both Cs. Stack a 2× gain in AI capability, Context, and Code and they multiply — 2 × 2 × 2 = 8× productivity. The methodology is a structural bet that all three will keep improving — and the direction of AI development makes that a good bet.

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

### The pilot's posture is constant. The pilot's bottleneck is not.

C² says the pilot directs, full stop, and that holds at every scale. What changes is what *constrains* them. These are four stages of one role, not four different roles:

| Stage | The crew | What constrains the pilot | The question being asked |
|---|---|---|---|
| **Assisted** | one agent, a pair | **Your attention.** Trust is low and there is no self-verification, so you read everything and never look away. The work is synchronous — you sit and watch | *Do I need to read this?* |
| **Parallel** | several agents, each isolated | **Review throughput.** You hand-write less and check several streams instead. Each agent verifies its own work before you see it | *Can I review this fast enough?* |
| **Supervised autonomy** | more output than you can read | **Trust in the loop, and decision throughput.** "Did you read the code?" stops being the right question | *What context was the model missing, and how do we fix that for next time?* |
| **Intent-steered** | monitored by exception | **Identifying what to automate**, and matching guardrails to each kind of work | *Is this something an engineer would have done?* |

Two transitions carry the weight, and both are things C² already builds:

- **Assisted → parallel** needs *a self-verification loop you trust* — tests, build, lint, an end-to-end run against a real environment. That is anchors, arrived at from a different direction.
- **Parallel → supervised autonomy** needs *a way for the agent to pull in context: code, decisions, discussion.* That is the contextbase, named as the gating capability for autonomy.

Note that the third stage's question — *what context was the model missing?* — is the closing gate's question. The stage and the ceremony line up, which is why the closing gate is what makes that stage survivable at all.

### Two ladders, not one

Adoption has two axes, and they get confused constantly:

- **Risk of the work** — crawl (tests, small fixes, low-risk refactors) → walk (features behind review) → run (autonomous, well-fenced). This is the ladder C² already publishes, and it is correct.
- **Agent count and the pilot's role** — assisted → parallel → supervised autonomy → intent-steered, above.

They are orthogonal and both true. A team can sit at *run* on risk while still at *assisted* on count: one agent working unattended overnight on well-fenced tasks, with a pilot who reads every diff in the morning. Neither ladder alone explains that team. Ask which axis you are describing before claiming a level.

### The graph gets a rung

**Topology is a parallel → supervised-autonomy capability. If you are not already running concurrent agents behind a self-verification loop you trust, the graph is not your next move — the loop is.**

That is the governor from "Topology is earned, not adopted", stated as something checkable. It is also the honest answer to a reader arriving from the hype wanting to fan out on day one: you can, and it will return twelve confident, unusable outputs, because the node contract and the anchor are what make a fan-out safe and neither exists yet.

---

## The Principles

Six principles. Pilot in command.

AI-augmented teams create faster than they complete — speed without command becomes drift. Six principles keep you the pilot, not a passenger:

**A · Fly the plane — own it.** One human owns each PRD from intent to a verified outcome — accountable for the landing, not just the takeoff. Keep the cockpit small: you can only truly fly a few at once. Done means the result moved, not that code shipped.
> **Guardrails:** a **WIP cap** — max 5 concurrent in-progress PRDs; anything above goes to backlog. (A team with 20 in-progress PRDs has 15 aspirations and 5 active projects — the cap makes that distinction impossible to ignore.) Enforced by a **monthly 30-minute review**: walk every in-progress PRD, update `completion_rationale` and `last_reviewed`, force-move stale ones to backlog.

**B · No takeoff without a flight plan — brief it, trim it.** A PRD becomes active work only as a Prompt Brief the agent can fly — and the brief cuts the mission to what matters, in small legs you can turn back from in minutes. No brief, no flight.
> **Guardrail:** **brief-before-active** — a PRD needs ≥1 Prompt Brief before it moves to in-progress. If you can't write a single execution brief, it's a thinking document, not active work.

**C · Build the autopilot — systematize it.** Never do the work twice. Don't write the blog — embed the system that runs it. Don't work the pipeline by hand — build the agent that runs it. Ship the machine that produces the output, not the output.

**D · Earn the green light — verify it.** An agent hands you confident, wrong code at machine speed. Its output is a proposal, not product: it ships when the tests pass and a human clears it. Verification before velocity.

**E · Every flight makes the next one better — compound it.** Each delivery updates the contextbase, so the next agent starts from the new baseline — not from scratch. The team gets smarter every loop. That's the c².

**F · Fly the formation — govern the spend.** A fleet breaks the arithmetic one agent and a budget-capped bench was built on: the run that cost one call now costs forty. Spend the expensive model where judgment lives, cheap models on bounded repetitive nodes, and plain code on the plumbing. Earn every barrier — it makes every node wait for the slowest. And declare the fan-out width in the plan before the fleet launches.

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

The session brief also carries the **landing zone** — the believed delivery date and how far along the work is. That is what makes progress visible without a stand-up: anyone can see who is flying what, when they expect to land, and how far in they are, by reading the trail rather than by interrupting the pilot.

Set an honest bar and hold it mechanically. **One to two briefs on an active build day**; if a day of building produced none, something got skipped. And make it unskippable rather than virtuous — a CI check on any pull request that changes application code, plus a local pre-push warning so nobody discovers it from a red build. Genuinely trivial changes skip with an explicit label, used honestly. A rule that depends on remembering is a rule that decays.

**The Cascade doesn't terminate. It closes on the PRD.** Release Notes and Weekly Announcements are optional roll-ups, so on paper the chain trails off into artefacts a team may never write. That drawing is wrong in a way that matters: the chain is a **loop**, and the PRD is its spine.

**Read the PRD → write the PRD.** Every ceremony either reads the PRD or writes back to it, and nothing lives in a second place. The loop opens at Flight Planning, runs through the build and the gates, and closes when what was learned lands back on the PRD — which then goes out again, richer, as the next version.

That is what makes a PRD *living* rather than merely long-lived. It is **versioned and compounding**: `v1.0 → v1.1 → v2.0`, where each version **absorbs** the last — a *bank switch* — leaving one live artefact that says where the work is **now**, built on its history rather than restarting from it.

Flight Planning is where context is *spent* — the contextbase is read down through PRD, brief and task. Closing is where context is *made* — gotchas, patterns, decisions and the honest estimate-versus-actual flow back up. Every artefact in that return path was already prescribed by C². What was missing was the ceremony that produces them, at the exact moment a team feels finished and is least inclined to write anything down.

**One brief ≈ one pull request.** The Prompt Brief is the atomic build unit, and the PR is where that unit becomes reviewable. Pinning the two together is what makes the barrier concrete: a brief that can't be expressed as one PR is really two briefs.

**A surfaced blocker needs a destination.** The debug limit says *stop and surface it* — but a blocker surfaced into a conversation is a blocker nobody can see. Give it a field on the PRD, and make that field visible wherever the work is tracked. "Surface it" is only a rule if there is somewhere for it to land.

**Master PRD → child PRDs.** The Router pattern applies here too: for a large surface, a master PRD acts as a router — it holds the map and links down — and any module big enough to deserve its own project gets a child PRD beneath it holding the detail. The master links; it does not duplicate.

The session brief also serves as the moment to identify documentation obligations created by the session's work. Before committing, the pilot checks:

- **Knowledge documents** — did this session produce a gotcha, pattern, or architectural decision that future sessions will need? If yes, the knowledge file is identified in the brief and committed in the same session.
- **Operational documents** — did this session introduce or change a deployment step, runbook, or operational procedure? If yes, the ops doc is identified and either written now or flagged as a tracked obligation with a due point (commit, PR, or release).
- **Commit obligation** — knowledge documents are committed with the session brief in the same commit, not deferred.
- **PR obligation** — operational documentation that spans multiple sessions may be flagged for completion at PR time, but it must be listed in the brief — not left to memory.

The session brief is the checkpoint between doing and knowing. Work without a brief is work that happened but wasn't learned from.

---

## Flight Planning — and Closing the Flight Plan

Two ceremonies, one pair. A pilot files a plan before takeoff and closes it on arrival.

**Filing.** Before an agent burns a build session, the pilot files a plan against the PRD and puts it in front of a few people. Five parts:

1. **The line** — the explicit in-scope / out-of-scope boundary. The act that turns a wish into a route.
2. **The briefs** — one Prompt Brief per atomic unit, each cleared against the 6-item quality gate.
3. **The journey** — milestones, a believed landing point, an ETA. A filed expectation, not a deadline, so deviation is visible.
4. **The shape** — the topology of the brief set: which briefs are independent (fan out), which are joined by an edge and must sequence, where the barrier sits, which edges get a bench pass. The journey says *when*; the shape says *how the work is wired*. It is cheap to add because every brief's pre-flight file/line table already declares that brief's surface — the arrows are derivable from artefacts the ceremony already produces. If no two briefs are independent, say so and file four parts. A graph buys breadth, not judgment.
5. **The red line** *(optional)* — a couple of mocked pages to bounce off.

The plan doc is a **throwaway** — a meeting agenda, not a third source of truth. The PRD and its briefs stay canonical.

**Three gates, at three altitudes — never conflate them.** A cycle passes through three human gates. **Flight plan** (per PRD): *is this the right route, and is the plan flyable?* — held by the owner of the intent, before any build. **Pull request** (per PR): *does this build do what its brief said?* — held by engineering, the QA evidence and a peer. **Closing** (per PRD): *is the shipped thing right, and what did we learn?* — held by the same owner who cleared the flight plan. The middle gate is correctness. The outer two are judgement, held by one owner, bookending the build — which is what stops a plan being approved by one standard and accepted by another.

**Closing.** A filed flight plan must be closed on arrival — leave it open and air traffic control launches a search. C² had a ceremony for takeoff and none for landing. **Closing the Flight Plan** is the gate where what was filed is reconciled with what landed, and someone with the authority to reject says *this is done* or *this is not.* It sits at a higher altitude than the PR gate — not *is the build correct?* but *is the shipped thing right?* — and it carries the lens engineering review structurally can't apply: does this meet the intent, and does it look right against the design system. Run that lens whether or not a designer is in the room, so it never gets skipped. Not a demo, not a retro. Four parts:

- **The landing** — what was actually built, against the line that was drawn.
- **The deviation** — where the route changed and why. Zero judgment; the plan exists to make drift visible.
- **The anchor** — the evidence that decides done: tests that ran, the query that returned rows, the deploy that resolved. Not "the agent says it's done."
- **The learning** — what the contextbase gains: gotchas, patterns, ADRs, the PRD's `completion_rationale`, estimated versus actual.

Why it belongs in the method, derived three ways: a **harness** is gather → act → verify, and C² had a ceremony for gather and none for verify; every **loop** needs a stop condition, and the stop condition must be evidence rather than confidence; every **fan-out** needs a barrier, and the closing gate is the barrier where the human sits.

**Flight Planning is where context is spent. Closing is where context is made.** C² already prescribed every artefact the closing produces — session brief, knowledge capture, `completion_rationale`, estimated versus actual — and prescribed no ceremony that produces them. They depended on discipline at the exact moment a team feels finished. The closing gate is the Cascade's real terminus, and the Session Brief is its output.

**The findings need structure, or they evaporate.** A review produces a pile of *we should fix that* and *we should add that*, and in most rooms it dies in the room. The structure that stops it is cheap: every finding gets a **stable ID**, written onto the PRD in one section; **tagged FIX or ADD** (wrong today versus new capability — conflating them is how a bug list turns into a roadmap and nothing gets fixed); grouped by surface and attributed; **the keystone flagged and the list sequenced** — keystone first, then trust fixes, then high-value adds, then the design pass; and **the PR that resolves one references its ID**, so the trail runs review → PRD → PR → shipped and is auditable from git alone. Those findings are the seed for the next flight plan. If an agent prepares the capture, it **stops at captured** — it does not prioritise and does not build. Sequencing is judgement.

**The sweep belongs to the next flight plan, not to the closing.** A findings section that only grows will drown the PRD in its own history. So it is bounded, and swept at the version bank-switch by the *next* plan: durable decisions promoted into the spec or `03-knowledge/` then cleared, done admin cleared outright (the trail lives in the closing PR, the release note and `git log`), unfinished items carried forward, the feature list reconciled against what shipped. **The closing appends at the end of a cycle; the next flight plan sweeps at the start of the next.** That is how a PRD compounds without hoarding — the mechanism behind "living, not frozen", which is otherwise just a sentiment.

**The ceremony scales, it does not toggle.** With a crew it is a room. Alone it is the human review where you check the agent did what you actually wanted. The solo pilot is the reader who most needs the gate and most easily skips it. An agent may prepare a closing; an agent may never close one, for the same reason it may never file one.

---

## The Codebase + Contextbase Model

```
project/
├── apps/             ← codebase (what runs)
├── docs/
│   ├── 01-planning/  ← PRDs, strategy, methodology
│   ├── 02-working/   ← Prompt Briefs, sessions, tasks, releases
│   ├── 03-knowledge/ ← Patterns, gotchas, ADRs  ← the self-improving layer
│   ├── 04-operations/← Deployment, runbooks, debugging
│   ├── 05-reference/ ← Tech stack, naming, constants
│   └── 06-agents/    ← Agent team design, roles, protocols, reviews
└── <workflows>/      ← saved orchestration graphs  ← also contextbase
```

The workflow directory is agent-specific in name (`.claude/workflows/` for one agent, an equivalent elsewhere) and belongs in the Router alongside `docs/`. A saved orchestration graph does not ship to users — it directs execution — so by C²'s own definition it is contextbase, not code. See "The graph as a contextbase artefact".

The `03-knowledge/` directory is the methodology's highest-compounding asset. The mechanism:

1. An AI agent discovers something unexpected — a quirk of the framework, a race condition, a gotcha in the auth flow
2. The agent extracts it to `03-knowledge/gotchas/` in the same session
3. The next agent session reads the knowledge index before touching relevant code
4. The gotcha never costs the team time again

After 50+ captures, the knowledge index is a library of battle-tested patterns. It doesn't evaporate when a person leaves. It compounds with every session. Gotcha capture is not optional — a session brief with a non-empty `Key Discovery` is not complete until the knowledge file is committed in the same session.

---

## How context stays lean — compaction

The contextbase grows denser than the codebase, so no agent loads all of it into a finite window; "read the context first" becomes a selection problem. C² keeps the working set small with three mechanisms, at different timescales:

1. **The Session Brief — point-in-time compaction.** At every context break, the session is digested down to "what the next agent needs cold" and the raw transcript is dropped. Compaction is triggered by the break, not by the window filling up.

2. **The Router — continuous compaction.** The Router (see below) links rather than embeds and is kept current, so each session loads a lean, curated slice rather than the whole contextbase. Lazy-loading *is* the compression: load by surface, not completeness; read the knowledge *index*, not every file; treat the latest session brief as compressed history.

3. **The Learn loop — capture then consolidate.** During a session, capture discoveries fast — classify each (gotcha, pattern, ADR) and write it to `03-knowledge/` so nothing is lost mid-flow. Periodically (end of week, before a big push), consolidate: merge duplicates into canonical docs, archive stale patterns, and refresh the Router's links. This keeps the contextbase — and the Router's index — current without sprawl. It's a practice you run *with* the agent ("capture this learning"; "review recent learnings and update the canonical docs"), not a tool you install. See `templates/learn-pass.md`.

When a single session's working set still overflows the window even after this, borrow in-session compaction (à la HumanLayer's ACE — research → plan → implement, keep utilisation lean). C²'s three mechanisms handle the durable, cross-session half.

---

## Your Agents

**C² is agent-agnostic.** The methodology works with any AI coding agent running in the terminal — Claude Code, Grok CLI, Gemini CLI, Codex, Cursor, or any agent that can read files, write files, and commit to git. The contextbase is plain markdown. Any agent that can read markdown can use it.

This matters. Choosing C² is not a commitment to a specific vendor. It is a commitment to a methodology. When a better agent ships — and they will keep shipping — you adopt it and the contextbase transfers intact. The context you've built doesn't belong to the agent; it belongs to the project.

### Picking your agents

The pilot's first design decision is the roster: which agent leads, which reviews, and which handles specialist tasks. These are roles, not headcount — solo with one agent, the roster is one line and you play every role yourself. Record it in `docs/06-agents/team.md` (optional at one agent) and keep it current as the roster changes.

**The Lead Agent — one agent, one codebase surface**

The lead agent reads the contextbase, writes code, manages git, extracts knowledge to `03-knowledge/`, and writes session briefs. It is the primary executor. Choose the agent that best fits your stack, your budget, and your workflow — then commit to it for a feature area. Running multiple agents simultaneously on the same surface creates conflicting recommendations, worktree conflicts, and session briefs that are impossible to write. One agent leads per surface — and *surface* is the constraint, not headcount. See "Topology" below.

*Examples: Claude Code, Grok CLI, Gemini CLI, Codex CLI*

**Bench Agents — independent review on high-stakes calls**

Bench agents review, never execute. They are invoked for PRDs, security decisions, architecture choices, and any call where a second independent opinion changes the risk profile. Budget-controlled: set a monthly spend cap and a daily call limit. All bench reviews are saved to `docs/06-agents/[agent-name]/reviews/` with a mandatory `Actions Taken` close-the-loop table — the review has no value if the team doesn't record what was done with it.

The value of a bench agent is *independence*. The lead agent has already made decisions about the code it wrote. The bench agent hasn't. That's the point.

Independence is mechanical, not attitudinal: **the verifier receives the artefact, never the session that produced it** — fresh context, and a real signal to check against rather than the lead's account of itself. Where a finding can fail in more than one way, split the lens: three verifiers asking *is it correct · is it current · is the source real* catch what ten identical passes never will. See "Anchors — what makes a result count".

*Examples: Grok (second opinion), Gemini (architecture review), a specialist model for security*

**Specialist Agents — scoped subagents for repeatable tasks**

Some tasks are high-value and highly repeatable: QA review, release note authoring, estimation, code review against a specific standard. These are candidates for specialist subagents — agents with a tightly defined role, a specific set of tools, and a documented protocol. Specialist agents live in `.claude/agents/` (for Claude Code subagents) or equivalent directories for other toolchains. Their role definitions, testing protocols, and invocation instructions are documented in `docs/06-agents/specialist/`.

*Examples: qa-reviewer (scaffolds structured test notes for PRs), release-author (drafts internal release notes from commit history), security-reviewer*

### The multi-agent anti-pattern

Running multiple agents simultaneously on the same surface — regardless of which agents — burns cost, produces contradictory outputs, creates worktree conflicts, and makes session briefs impossible to write coherently. The pattern to avoid: two agents both mutating the same thing in the same session. The pattern to use: one agent executes, one agent reviews, and they never work concurrently on the same surface.

The anti-pattern most often emerges from urgency. A blocked session, a tight deadline, a complex bug — and the impulse is to throw more agents at it. That impulse is wrong. Clarify the brief, surface the blocker, and let one agent proceed.

### Topology — when agents may run concurrently

The rule above is about **contention**, not **concurrency**. Conflating the two is what made it read as a ban on parallelism:

- **Contention** — two agents mutating the same surface. Real, expensive, correctly forbidden.
- **Concurrency** — N agents doing N bounded jobs that share no surface. Not a failure mode at all.

**The rule: agents may run concurrently exactly when no edge connects them and no surface is shared.** An *edge* means one agent's output is another's input. A *surface* is everything an agent mutates or contends for — files, data, external resources, a deploy target. Two agents on one surface is the anti-pattern, regardless of how urgent the session feels. Twelve agents on twelve disjoint surfaces, each with a brief that clears the quality gate, is the method working. Worktree isolation is the seatbelt for the one topology that needs it — parallel writes — not a tax on every run.

Lead-and-bench stays sequential because there *is* an edge: the bench reviews what the lead produced. Sequence what's connected; run what isn't.

**A surface is wider than a file list.** The failure that catches people is *false independence* — two agents whose briefs never mention each other, colliding over a shared workspace, a shared database, a rate-limited external API, or one deploy target. Anything shared is a hidden edge, and hidden edges bite hardest because no brief says they exist. When you draw the topology, ask what each brief *contends for*, not only what it writes.

**The vocabulary is structural, not tool-specific.** A **node** is one agent doing one bounded job. An **edge** is the artefact that crosses between two of them. A **barrier** is where parallel work merges. **Isolation** stops one node poisoning the others. A **verified edge** is a result that gets an independent pass before it counts. C² already has all five under other names — a Prompt Brief is a node contract, a bench agent is a verifier on an edge, an integration brief or a PR is a barrier, worktrees are isolation. Some agents ship a runner for this; the doctrine belongs to the method, and the runner is one implementation of it.

**Where each level lives.** The three fit together cleanly, and only one of them is new:

- **The brief is the node** — one bounded job, contracted by the 6-item gate plus the pre-flight table, with an anchor that decides done.
- **Inside a node, execution is a loop** — READ → IMPL → REVIEW → VERIFY → COMMIT per item, the anchor as its stop condition, the blocker limit as its escape hatch.
- **Between nodes, the flight plan draws the graph** — edges, the barrier, verified edges. This is the only level that needs a *plan* to decide it: a node can't see its siblings, and a loop can't see outside itself.

That is why Flight Planning is the load-bearing ceremony for all of this. The plan sits above the brief set and is its **execution contract** — it decides the wiring, and every brief runs its loop inside whatever wiring it is given. And **the shape is always drawn; sometimes it comes out as a line.** A line is a graph with one edge in and one edge out, so "this is a line, and here is why" is a filed finding. Never asking is the failure.

### When not to build one

A graph buys breadth. It does not buy judgment. Skip it when the task is small or isolated; when the work is exploratory and you don't yet know what you're looking for, so you need to steer; when the steps genuinely depend on each other; and when you want to approve every step.

The tell: **if you cannot find two briefs with no edge between them, there is no graph to build.** It's a loop — one brief, a lead agent, a bench review — and a loop is the right tool most days.

That last case reads as an objection to the Pilot model, and it deserves a straight answer rather than a dodge: **the pilot's gate is at *filed*, not at every node.** A pilot doesn't approve each aileron movement; they file a route, fly it, and own the deviation. That is what Flight Planning already is, and it is why the ceremony carries the topology — see `flight-planning.md`, "the shape". Approve the topology, not the traffic.

### Cost governance in the graph era

The lead-plus-budget-capped-bench arithmetic breaks the moment a fleet arrives: the same run that cost one call now costs forty. A published figure makes the scale concrete — one large runtime port ran roughly 50 workflows with up to 64 concurrent agents over about eleven days, for roughly **US$165,000** in usage. That is not a cautionary tale, because it bought something close to a year of work. It is the number that turns model tiering from a tip into a budget decision.

Two rules hold it:

- **Spend the expensive model where judgment lives** — and cheap models on bounded, repetitive nodes. Most reduce steps (flatten, dedupe, filter) are plain code, not agents at all. Spending a model call on plumbing is paying rent on your own wiring.
- **Earn every barrier.** A barrier makes every node wait for the slowest, so it is justified only by a genuine cross-node dependency: deduping across the whole set, an early exit on the total, a synthesis that has to compare findings against each other. "It's cleaner" is not a dependency.

C² already caps bench spend daily and monthly. The graph era points the same discipline at *fan-out width*, with the cap declared in the plan before the fleet launches — a filed shape that doesn't say how wide it goes is not a filed shape.

### Topology is earned, not adopted

The most common failure in this whole shift is diagramming a large workflow before observing how the work actually behaves. It produces brittle structure and premature control. The prescribed order is: simpler setup → collect traces → find the stable patterns → formalise only what deserves control.

C² has the answer nobody else can claim: **the contextbase *is* the trace collection.** Session briefs and gotchas are the accumulated record of which surfaces collide, which briefs stalled, and which patterns repeated often enough to be worth freezing into a topology. A team fifty sessions into C² has exactly the evidence base this warns you to gather first. A team on day one should be writing briefs, not drawing graphs.

Worth noticing how much agreement there is on this point. The topology primer says *earn the barrier*. The critique of it says *anchor, or the graph agrees with itself*. The taxonomy piece says *building the graph too early is mistake number one*. The adoption ladder says *don't scale agent count before the loop has earned trust*. Four independent framings, one conclusion: **the graph is the last thing you build, not the first.**
---

## Anchors — what makes a result count

**Do not loop on confidence. Loop on evidence.**

"The agent says it is done" is not a stop condition. Neither is "the review passed", when the review read the builder's own account of the work. Build a system of agents all checking each other's reports and you get something consistent and unverified — it fails exactly the way a single agent fails, only later, more expensively, and with far more green lights on the way down.

An **anchor** is a signal no agent in the run can produce by asserting it. A test that actually ran — not "should pass", *did* pass. A query that returned rows. A deploy that resolved. A metric that moved. The anchor is what the Definition of Done is *for*, and it is the entire reason the word *testable* is in the quality gate.

**Every Prompt Brief names its anchor.** Not a seventh gate item — it folds into the third, because "testable acceptance criteria" was always this idea, stated too politely to survive an agent that wants to be finished. The gate stays six items. Item three now asks *which signal decides, and can the agent fake it?*

### Frozen rules

Some rules are non-negotiable precisely *because* they are the ones under pressure — the rules an optimiser would bend to win. Name them, and mark them frozen. Examples from production:

- the write-path check that runs after any constraint migration — a near-empty table is a broken writer, not low adoption
- the file-size cap
- never fabricate data to make the software look like it works

Every frozen rule exists because it was bent once and something broke. The list is per-project and belongs in the contextbase alongside the gotchas. A system is only as honest as the things inside it that refuse to move.

### Independence is mechanical, not attitudinal

C² has always said the bench agent's value *is* independence — "the lead agent has already made decisions about the code it wrote; the bench agent hasn't." True, and stated as a property rather than as a requirement, which left the mechanism unspecified. The mechanism:

**The verifier receives the artefact, never the session that produced it.** Fresh context, and a real signal to check against — not the lead's account of itself. A review run inside the builder's context is the builder agreeing with itself in a different font.

Three conditions make it mechanical rather than aspirational:

1. **A different model from the one that wrote the code.** Two models catch different blind spots. One model checking itself catches the ones it already missed.
2. **Inputs the author does not control.** Run the verification where the builder cannot touch it — in CI, from the acceptance criteria, the diff, and the evidence journal. An author running the verifier on their own machine, on inputs they assembled, is self-assessment with an extra step.
3. **Teeth.** A dispute blocks the merge. A verifier whose objection is advisory is a verifier that gets overruled at 5pm on a Friday.

That is also the honest answer to "does this replace the tester?" It doesn't — it redistributes the job. **Three moves, three different owners:** the engineer who built it runs the QA and records the evidence; an independent model verifies the pass where the author can't reach it; a peer confirms and approves. A second set of human eyes doesn't disappear. It stops being one person's desk.

**And split the lens.** One skeptic asks one question. Three verifiers asking *is it correct · is it current · is the source real* catch what ten identical passes never will. C² already routes PRDs, security and architecture to the bench as separate call types — naming them as lenses on the same artefact is a small generalisation with real yield on auth, payments, and anything touching row-level security.

### The 30-minute debug limit — name the layer before you escalate

The limit says stop and escalate. It does not say stop and ask *what*. Most stalled sessions are debugged at the wrong layer: a prompt rewritten when the tool was missing, a topology redrawn when the stop rule was never defined.

At thirty minutes, before escalating, name the layer that owns the failure:

| The symptom | The layer that owns it |
|---|---|
| **Cannot operate** — missing tool, stale state, bad permissions, no visibility | The environment |
| **Almost works but unreliable** — close-but-weak output, inconsistent success, no proof of completion | The loop and its stop rule |
| **The process itself is complex** — specialists, approvals, branching, parallel paths | The topology |

This is a diagnostic for *what broke*. It is deliberately **not** C²'s stack of *what you build* — prompt ⊂ context ⊂ harness, where C² sits at the harness layer and contains the other two (see "Where C² sits"). Different question, different three layers. Don't collapse them.

---

## What's better than traditional agile

The closest pre-AI methodological ancestor is **Shape Up** (Basecamp): C² shares its appetite model, outcome focus, and resistance to sprint theatre. The closest AI-native peer is **AWS AI-DLC** (AI-Driven Development Lifecycle, launched re:Invent 2025): both use hierarchical documentation pipelines feeding context to AI agents, both are agent-agnostic, and both report significant productivity gains. The table below covers all three.

| | Scrum | Shape Up | AWS AI-DLC | C² |
|---|---|---|---|---|
| Planning unit | Sprint → Story | Pitch → Scope | Inception → Construction → Operations | PRD → PB → Task |
| Time box | 2-week sprints | 6-week cycles | Phase-gated (hours to weeks) | Weekly (outcome-based, individual PRD ownership) |
| Estimation | Story points | Appetite (fixed budget) | Not specified | PB phase sizing (≤6 items, ≤45 min each) |
| Backlog governance | Groomed, always growing | Betting table | Not specified | Active/backlog folders + WIP cap (max 5) |
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

### 4. The Router

One file your AI session reads first — the living index of the whole contextbase, lazy-loading exactly the context a task needs rather than pasting everything into every conversation. The Router links to docs; the agent pulls only what it needs.

We call the concept `router.md`. On disk you name it for your agent so it's read automatically — `AGENTS.md` (the emerging cross-agent default — Codex, Cursor, and most), `CLAUDE.md` for Claude Code, `GEMINI.md` for Gemini CLI. **Ship it agent-correct from day one; never rely on a rename that gets skipped** (the file silently won't be read). For a single source of truth, symlink the agent file to `router.md`. The pattern is agent-agnostic — every agent that reads files can read a Router.

What matters is the structure *and the upkeep*: one entry point, with explicit links to active PRDs, the latest session brief, the knowledge index, and the pilot rules — kept current as the project grows. Maintained, the Router becomes the project's living wiki: the curated entry point that makes context loading systematic, reproducible, and lean. It's the cure for what most teams still brute-force — pasting entire docs into every prompt, restating context each session, or trusting the agent to remember what it structurally cannot.

### 5. Knowledge capture to git as compounding institutional memory

Gotchas, patterns, and ADRs — all written by the AI, all read by the AI on the next session. Traditional teams lose this knowledge when people leave. In C², it accumulates. The offshore onboarding test: contributors in a new location can get context from the knowledge index that previously required pairing with a senior engineer.

### 6. Session briefs as AI memory — triggered by context breaks, not the clock

AI agents have no persistent memory between sessions. The session brief is the mechanism that provides it — a committed markdown file the next agent reads before touching anything. What makes C²'s implementation distinct is the trigger model: a session brief is written any time the AI context is about to be interrupted or lost, not just at end of day. Phone call, meeting, machine reboot, hitting the context window limit — any of these triggers a brief. The question is not "is the session finished?" but "if I came back to this cold, what would I need to know?"

The brief also serves as the moment to identify documentation obligations: knowledge files that must be committed in the same session, operational documents due at PR merge, deferred test debt that carries forward until it's closed. One artefact, multiple jobs — and those jobs are explicitly tracked, not left to memory.

Team standup communication is a side effect, not the purpose.

### 7. Multi-AI review as structured practice

Lead agent + bench agent with budget controls, mandatory output saved, and close-the-loop `Actions Taken` tables. This is disciplined multi-agent governance, not ad hoc "ask ChatGPT about the diff."

### 8. The graph as a contextbase artefact

A fleet of agents fans out, converges, prints an answer — and the shape that produced it evaporates. Run the same job next month and the topology gets rebuilt from scratch. Nothing compounds. That is the question the graph literature does not ask, and C² is the only method with a native answer, because it already holds that the durable asset is the guidance rather than the output.

**A saved orchestration graph is not code.** It does not ship to users; it directs execution. By C²'s own definition that makes it **contextbase** — and the densest form of it yet identified: a topology that worked once, version-controlled, re-runnable by name by anyone who clones the repo. The workflow directory therefore joins `docs/` as a contextbase surface, and belongs in the Router like any other. The directory is agent-specific (`.claude/workflows/` for one, an equivalent elsewhere); the *claim* is not.

The mechanism, stated as a mechanism rather than a slogan: **a fleet without a contextbase produces twelve findings and forgets all twelve.** Every fan-out node writes what it learned to `03-knowledge/`. The barrier dedupes rather than re-discovers. The session brief is the edge that carries state to the next run. That is the whole difference between *running* a graph and *compounding* one — and it is why the governor above ("topology is earned, not adopted") is not a caution bolted on afterwards but a consequence of the same claim: the contextbase is both what makes a graph worth saving and what tells you a graph is warranted yet.

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

**The practitioner-first claim:** Every methodology in the table above was designed by researchers theorising about AI-augmented development. C² emerged from production software delivery under real commercial pressure and was formalised afterward. That is a different epistemic foundation — and the proof bears it out.

---

## The proof

C² has been validated across real production software — multiple commercial products (SaaS platforms, websites, agents, and ecommerce stores) built and shipped with it, not a lab experiment. The methodology was not designed and then tested; it evolved under delivery pressure and was formalised from what actually held up.

We don't lead with a headline multiplier. The anonymous "Nx productivity" stat is exactly the kind of claim the dev community rejects — and it isn't the point. The proof is qualitative, structural, and verifiable:

- **It shipped real software.** Multiple production products, over two years and 1,000+ AI agent sessions. The method isn't a theory about building — it came out of building.
- **Pace didn't erode quality.** Under a much higher commit rate, code review kept up: merge discipline held rather than degraded.
- **Knowledge compounded instead of evaporating.** Gotchas, patterns, and ADRs accumulated in `03-knowledge/`, in git — institutional memory that doesn't rot when a person leaves, and that no Confluence page can match.
- **Product and engineering merged in the repo.** Strategy, PRD updates, and architecture decisions live in git alongside the code. The separation between "product work" and "engineering work" disappears.

The strongest evidence isn't a number we ask you to trust — it's that the commit history is public.

---

## The gaps being closed

C² v1.0 shipped and worked. Each release folds a short list of improvements into the templates and the doctrine. **The version tag travels with the item, not the section** — a heading stamped with one number goes stale on the next release.

### Shipped

1. **Gotcha capture gate** *(v1.1 — shipped)* — Knowledge extraction moved from checkbox to commit requirement. A session brief with a non-empty Key Discovery is not complete until its `03-knowledge/` file is committed in the same session.

2. **Universal PB quality gate** *(v1.1 — shipped)* — The 6-item quality checklist (goal, scope exclusions, testable AC, non-goals, testing approach, definition of done) applies to all Prompt Briefs, interactive and autonomous. Both templates carry it.

3. **Mid-brief checkpoint** *(v1.1 — shipped)* — Autonomous Prompt Briefs with 4+ items carry a mandatory checkpoint paragraph after item 3. One paragraph: approach still valid? If not, surface now. Prevents architectural drift in long autonomous runs.

4. **The anchor** *(v1.3 — shipped)* — Every Prompt Brief names the one signal that decides done, folded into the gate's testable-acceptance-criteria item rather than added as a seventh. The gate keeps its 6-item identity. See "Anchors — what makes a result count".

5. **The shape** *(v1.3 — shipped)* — Flight Planning emits a topology, not just a schedule. Five parts, and the `flight-plan` skill derives the shape from the brief set's own pre-flight tables.

6. **Closing the Flight Plan** *(v1.3 — shipped)* — the landing gate, and the Cascade's real terminus. A filed plan is closed on arrival. See `flight-planning.md`.

### Open

7. **Estimation aggregation** *(v1.1 — open)* — `estimated_hours` / `actual_hours` exist in the templates and the closing gate now asks for the comparison, but the metrics script that reads them across completed PBs and reports accuracy by area is per-project and still unwritten.

8. **CI coverage gate** *(v1.1 — open)* — policy ("tests are part of the build") backed by mechanical enforcement: a per-new-file coverage requirement, or a mandatory test file alongside new source files. The rule becomes unskippable.

9. **Curated slice still too big** *(v1.4)* — what to do when even the Router-curated slice exceeds the window: summarising an oversized knowledge index, archiving stale patterns, pruning the Router. Carried forward from v1.2 — the three compaction mechanisms handle everything short of this.

10. **The filed plan compiles to a graph** *(v1.4)* — a filed flight plan already names the independent briefs, the edges, the barrier and the verified edges. The next increment emits a runnable orchestration script from it, for whichever runner the team uses. The human gate stays exactly where C² already puts it: **the plan compiles, the pilot still clears takeoff.**

11. **Replayable traces** *(v1.4)* — C² has session briefs, which are narrative. It has no way to replay a run or attribute an improvement to a specific change. A method that tells you to loop on evidence should be able to compare two runs, not only describe them.

12. **Tool-surface discipline** *(v1.4)* — a crowded tool surface causes selection mistakes, noisy context and a wider risk surface. C² has doctrine for what an agent *reads* and none for what it can *reach*. The fix is the Router's own pattern pointed at tools: curate by surface, not by completeness.
---

## Using C² — the quick start

1. **Set up the Router.** One file your agent reads first — the living index of the contextbase. Name it for your agent so it's read automatically (`AGENTS.md` is the cross-agent default; `CLAUDE.md` for Claude Code, `GEMINI.md` for Gemini); ship it agent-correct, don't rely on a rename. It links to PRDs, the knowledge index, the current active work, and the pilot rules. Every AI session starts here.

2. **Pick your agents.** Decide which model plays which role. The default is one lead agent (reads context, writes code, manages git); add a bench reviewer (PRDs, security, architecture — budget-capped, never touches the codebase) when the risk earns it, and a specialist only when a repeatable job appears. Record it in `docs/06-agents/team.md` — solo with one agent that is one line, and optional. C² is agent-agnostic — you are committing to roles, not vendors, and roles are not headcount.

3. **Write the Platform PRD.** What is this product? Who is it for? What does it not do? This is the strategic layer every feature PRD inherits from.

4. **Create a Feature PRD for each feature.** One PRD per feature, in `docs/01-planning/prds/backlog/` until a Prompt Brief exists for it (brief-before-active). Then move to `in-progress/` (max 5 at once — the WIP cap).

5. **Write Prompt Briefs, not tickets.** The brief specifies what to read, what to build, what not to build, and what done looks like. For autonomous execution: include exact file paths and line ranges in pre-flight. For interactive: verify the 6-item gate before starting.

6. **Write a Session Brief whenever context breaks.** Session briefs are AI memory — not an end-of-day ritual. Write one any time the AI context is about to reset: a phone call, a meeting, a break, closing the laptop, hitting the context limit, or ending for the night. If the session produced a Key Discovery, the `03-knowledge/` file is committed in the same session. If it introduced an operational change, the documentation obligation is identified and given a due point (commit, PR, or release).

7. **Run the monthly review.** Thirty minutes. Walk every in-progress PRD. Move stale ones to backlog. The WIP cap enforces itself if you let it.

---

*C² methodology. First formalised May 2026. v1.2 additions (harness positioning; context curation), May 2026. v1.3 additions (topology and the concurrency rule; anchors, frozen rules and mechanical bench independence; Closing the Flight Plan; the graph as a contextbase artefact; the pilot's stages and the two ladders), August 2026.*
