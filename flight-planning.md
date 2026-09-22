# Flight Planning

> **Promoted from production practice, June 2026.** This formalises a ceremony teams had been
> running ad hoc. The methodology already had *pre-flight* as a **section** of the autonomous
> Prompt Brief. Flight Planning is the **human ritual** around producing and reviewing that
> plan before takeoff.

---

## The one-line definition

**Flight Planning is the session where a pilot files their plan before they build** — with the
team, or with themselves as the gate when they build alone. PRD line drawn, Prompt Briefs built,
the journey mapped — reviewed out loud, before a single autonomous session burns.

One ceremony at two weights, not an enterprise ritual with a solo footnote. It holds for a solo
operator with no product function, for an agency, for an MSP, and for a fifty-person team: with
a crew it is a room; alone it is the review where you check the plan says what you actually
want built.

It is the C² equivalent of a pilot briefing air traffic control before takeoff:
*this is where I'm going, this is what I'll build, these are the milestones along the way,
this is where I believe I'll land and at what time.*

---

## From crew to pilot — where this comes from

The methodology's older frame was Pilot vs Crew: a crewman hauls rope, a pilot sets course.
Flight Planning sharpens it into a *progression* — the real shift the AI era forces on a team:

> **You're moving from being a crew member on a single sailboat to being the pilot of your
> own PRD.**

On the sailboat, everyone crews one shared vessel — one sprint, one backlog, you pull a rope
on a boat someone else is steering, and your work only makes sense as part of the whole crew's
effort. As a pilot, you own your own aircraft and your own flight path: **one PRD, one owner,
your route to fly.** That's why PRDs are scoped to one person and roughly a week — a pilot
flies their own plane, they don't share a tiller.

And the moment you give everyone their own aircraft, you need air traffic control. A crew on
one boat coordinates by being in the same hull. A fleet of solo pilots coordinates by **filing
flight plans** — which is exactly the gap this ceremony fills. Flight Planning isn't overhead
on top of pilot-ownership; it's the thing that *makes* a fleet of individually-owned PRDs safe
to fly at once.

This rarely lands the first time it's explained, and that's worth saying plainly. The analogy
stays abstract until someone has flown one plan and felt why the filing mattered — teams
routinely report it "makes sense in hindsight, not when it was first explained." Teach it
expecting that lag, and don't mistake the lag for disagreement.

---

## Why it exists — the ATC analogy

A pilot doesn't take off without filing a plan. Not because the plan is binding — weather
changes, plans change — but because **a filed plan creates shared situational awareness.**

> "If something goes awry with the plan, it's not the end of the world. But if something
> goes awry and you're not where you need to be at the allotted time and *nobody knows* —
> then we start to send out search parties."

That's the whole point. Deviation is fine. **Invisible** deviation is what costs you.
Flight Planning makes the intended route visible, so the team knows where you should be
and when, and a wrong turn surfaces as a question instead of a three-day silence.

Five things the ceremony buys you that a solo PRD read does not:

1. **De-risks the autonomous burn.** A vague plan produces a vague outcome at AI speed. The
   cheapest place to catch a wrong heading is on the ground, not at 30,000 feet mid-session.
2. **Forces the line around the PRD.** You can't file a plan you can't scope. Drawing the
   boundary — in / out — is the act that turns a wish into a route.
3. **Protects the human bounce.** This is the one the AI era quietly erodes. Working alone
   with a capable agent is fast and frictionless — and it's easy to never put the plan in
   front of another human. Flight Planning is the designed moment for the **multidisciplinary
   bounce**: product, software, UX, and (when the work warrants) commercial eyes, each
   stressing the plan from their angle *before* it's built. A PRD improves when more than one
   discipline has touched it. The ceremony makes that interaction structural instead of
   optional, so it doesn't quietly disappear the more productive a solo pilot becomes.
4. **Opens the product↔software dialogue.** The PRD arrives unfinished by design. Flight
   Planning is where software pushes back: *this is over-spec, pull some out or break it up* —
   or *this is under-spec, the real job-to-be-done is bigger than problem one.*
5. **Teaches.** It's a learning ritual. Zero judgment. Watching a peer file a plan and get
   coached on it is how the whole crew levels up at once.

---

## Where it sits in the Cascade

```
Platform PRD
  └── Feature PRD            ← product hands this over, expect it unfinished
       └── ✈ FLIGHT PLANNING ← the pilot files the plan; the team reviews   ◀ THIS CEREMONY
            └── Prompt Brief × N  ← the filed plan, ready to execute
                 └── Session × N  ← takeoff
                      └── Session Brief
```

Flight Planning is the gate between **"product gave me a PRD"** and **"I'm running
autonomous sessions against it."** It is the moment the pilot converts a living PRD into a
flyable route — and the moment the team gets to red-pen the route before fuel is spent.

It does not replace the **pre-flight section** inside each Prompt Brief (the exact files +
line ranges the AI reads before touching anything). Flight Planning *produces* those
briefs; the pre-flight section is what's *in* them.

---

## The two flavours

**1. Flight Plan Filing** — the first, fuller session. The pilot presents the drawn-line
PRD, the draft Prompt Briefs, and the journey. The team probes scope, spec, and the
job-to-be-done. Often ends with: *go refine the PRD and PBs.*

**2. Flight Plan Review** — a shorter follow-up (often next day). Tighter. The pilot comes
back with a revised plan and, ideally, **something tangible to bounce off** — a couple of
pages mocked in a feature branch. This is the "red line on the map."

> "Sometimes there's value in coming back into flight plan with *I've spun up a couple of
> pages in my feature branch to show where things are going.* It doesn't have to be just PRD
> and PBs. It's like looking at a red line on a map going from city to city — it gives us
> something to bounce off. We shouldn't be afraid to enable engineers to mock up a few rounds
> of look-and-feel for the conversation."

---

## When you file one

Flight Planning is the gate for **new PRDs** — file a plan before you build. It is not a tax on
everything:

- **New PRD → file a plan.** This is the default, and it's a must, not a nicety.
- **Work already in flight → execute and close.** Don't retro-fit a plan onto something you're
  already mid-build on; finish it the way you would have.
- **Housekeeping → skip it.** Small tidy-ups, help articles, and the like don't need a ceremony.

Scope the PRD to one owner and roughly a week of work before you plan it. If it's bigger than
that, the first finding is "split this into multiple PRDs," not a plan. And size the ceremony to
the work: a small PRD can be filed and reviewed inside a day; a large, subjective one deserves a
few hours of prep and a fuller room.

---

## What a filed flight plan contains

| Part | What it is | The pilot's line |
|---|---|---|
| **The line** | An explicit scope boundary drawn around the PRD — what's in, what's out | "This is what I'm going to build" |
| **The briefs** | The Prompt Briefs, each cleared against the 6-item quality gate | "Here's how I'll build it, in atomic units" |
| **The journey** | Milestones + believed landing point + ETA | "These are the milestones; this is where I'll land and at what time" |
| **The shape** | The topology of the brief set — what fans out, what sequences, where it merges, what gets verified | "This is the route, not just the queue" |
| **The red line** *(optional)* | A few mocked pages in a feature branch — look-and-feel to react to | "Here's roughly where it's going — bounce off this" |

### The shape — a filed route, not a filed queue

*The journey* says **when**. *The shape* says **how the work is wired**. For the drafted brief
set, state four things:

1. **Independent briefs** — no edge between them and no shared surface. These can run at the
   same time.
2. **Edges** — brief B reads brief A's output, or the two touch the same surface. These
   sequence, and the edge is named by *what crosses it*, not by order. "PB-2 after PB-1" is a
   queue. "PB-2 consumes the schema PB-1 emits" is an edge.
3. **The barrier** — where the parallel work merges (the integration brief, the PR, the
   `qa-gate`) and what the merge genuinely needs the whole set for. A barrier makes every brief
   wait for the slowest, so it has to be earned.
4. **Verified edges** — which results get a bench pass before they count, and by what lens.

This costs almost nothing to add, because the material is already on the table. Every autonomous
brief carries a pre-flight file/line table, and a pre-flight table is a declaration of that
brief's surface. **The topology is derivable from artefacts the ceremony already produces** — the
plan simply stopped short of drawing the arrows.

Remember that a surface is wider than a file list: it is everything a brief mutates or contends
for, including a shared database, a rate-limited external API, or one deploy target. Two briefs
whose pre-flight tables don't overlap can still share a surface, and that is the edge that bites
because nothing declares it.

A pilot files a route, not a queue. Filing the shape is also what makes the plan reviewable as an
*architecture*: the room can argue with an edge that shouldn't exist, or a barrier nobody needed,
in a way it can never argue with a list of dates.

And the caution belongs in the same breath. **If you cannot find two briefs with no edge between
them, there is no shape to draw** — say so, and file four parts. A graph buys breadth. It does not
buy judgment.

### The plan is the execution contract for the brief set

Filing the shape is what makes the flight plan more than a review artefact. It sits *above* the
Prompt Briefs and decides how they run. Three levels, and the plan sets the third:

- **The brief is the node.** One bounded job, one contract — the 6-item gate plus the pre-flight
  table, with an anchor that decides done. C² has shipped this unit since v1.0.
- **Inside a node, execution is a loop.** READ → IMPL → REVIEW → VERIFY → COMMIT, per item, with
  the anchor as its stop condition and the blocker limit as its escape hatch. Also already shipped.
- **Between nodes, the plan draws the graph.** Edges, the barrier, verified edges. This is the
  part the ceremony was missing, and it is the only one of the three that needs a *plan* to decide
  it — a node can't see its siblings, and a loop can't see outside itself.

So: **the plan decides the wiring, and every brief runs its loop inside whatever wiring it is
given.**

One correction worth stating plainly, because it changes what the pilot does: **the shape is
always drawn — sometimes it comes out as a line.** A line is a graph with one edge in and one edge
out. A single brief executed by a lead agent with a bench review is a perfectly good filed shape.
Filing *"this is a line, and here is why"* is a finding. Never asking is the failure.

---

## The plan is a throwaway — the PRD stays the source of truth

The flight plan doc is a **meeting agenda**: a one-screen summary that sits on top of the PRD and
the Prompt Briefs and is easier to talk through than either. It is *not* a third source of truth.

The PRD and its Prompt Briefs remain the single source of truth. After the review, take the
meeting's notes or transcript, update the PRD and the briefs from it, and **bin the flight plan
doc.** If the plan lingers as a parallel record, the team ends up unsure which document is right —
so it is deliberately disposable. One place holds the truth; the plan is scaffolding you throw away
once the build is underway.

---

## Who's in the room — the multidisciplinary crew

A Flight Plan Review is a **cross-disciplinary** room by design. The value isn't one expert
signing off — it's several disciplines bouncing the plan off each other while it's still
cheap to change. A scope problem caught by UX, or a commercial problem caught by sales, is
trivial to fix in the plan and expensive to fix after the build. The point of gathering the
crew is to find those before takeoff.

**Standing crew** (a Filing or a substantive Review should have these):

- **Pilot** — presents the plan. Owns the route and the quality bar. Has done the thinking
  *before* the session, not in it.
- **Product** — gives the PRD (unfinished, deliberately) and receives push-back. The healthy
  state is **product pushing more onto software, and software saying "this is over-spec, pull
  some out."** This negotiation happens out loud, here.
- **Head of Software (or a delegate)** — owns the engineering call: feasibility, sequencing,
  architectural risk, and whether the briefs are flyable. A delegate is fine; the seat is not.
- **UX** — guards the journey and the whole job-to-be-done. UX is where "solve problem one
  now, problem two later" gets challenged before it's baked into the briefs.

**Situational crew** (invite when the work touches them):

- **Sales / commercial** — when the work touches what's sold, demoed, or promised.
- **Finance** — when it touches pricing, cost, billing, or unit economics.
- **Anyone who touches the end work** — support, ops, a key customer's champion. The test is
  simple: *does this person feel the consequences of this plan downstream?* If yes, their lens
  belongs in the room before the build, not in a bug report after it.

Keep the room as small as the work allows — but never so small that a whole discipline only
discovers the plan after it's shipped.

---

## The lessons this ceremony enforces

These are the recurring teaching moments — the reasons the ceremony earns its 30 minutes:

1. **Draw the line first.** No flyable plan without a scope boundary. The line is the work.
2. **The PRD arrives unfinished — push back.** Expect over-spec and under-spec. Software-to-
   product feedback is a feature of C², not a failure of the PRD. *"I'd rather product be
   pushing more onto us."*
3. **Solve the whole job-to-be-done.** Don't shy from the real shape of the problem. The
   instinct to "solve problem one now, problem two later" often hides a system that wants to be
   built whole. A feature framed as "fetch a thing and show it" is sometimes really a
   self-generating system in disguise — its own sub-app inside the app. The plan gets bigger,
   and better, once the real job is named rather than the first slice of it.
4. **Make it tangible.** A mocked page beats a paragraph. Enable engineers to do a few rounds
   of look-and-feel in a feature branch — the red line on the map.
5. **Zero judgment.** It's training. The plan exists to make deviation visible, not to punish
   it. Milestones + ETA so nobody has to send search parties.
6. **Close what you file.** That search-party line is the aviation fact half-stated. A filed
   flight plan must be *closed on arrival* — leave it open and ATC launches search-and-rescue.
   The ceremony has two ends, and the second one is where the contextbase actually gets written.
   See "Closing the Flight Plan" below.

---

## Flying the plan — the pilot owns deviation

A filed plan is not a cage. Plans change in the air, and the pilot is trusted to fly. What you do
when you drift off the route depends on the size of the change:

- **Small to medium, within the guardrails:** you're the pilot — update the plan and keep flying.
  Don't call a meeting for every adjustment. Closing a known gap you discover mid-build is exactly
  the kind of call the owner makes without sign-off.
- **A larger change:** raise it as a roadblock or a **walkthrough** and take it back to the team.
  A real change to the route is a change the crew should see.

And fly like the owner, not just the builder. As you build, look at what you're producing the way
a customer would: is this the right thing, does it feel right, would it pass your own QA? The owner
of the plane checks their own aircraft in flight, so that by the **closing gate** the work is
close to right rather than far off it. Much of what a late review would otherwise catch gets caught
here, by the person who filed the plan.

---

## Closing the Flight Plan — the landing gate

A filed flight plan has to be **closed on arrival**. That is not a metaphor stretched for effect;
it is the aviation fact the ceremony is named after. File a plan, fly it, land without closing it,
and air traffic control starts a search. The plan is complete when someone confirms the aircraft
is down — not when the wheels touch.

C² files a plan before takeoff and, until v1.3, had nothing symmetric at the end. **Closing the
Flight Plan** is that ceremony: the moment where what was filed is reconciled with what landed,
and someone with the authority to reject says *this is done* or *this is not.*

Not a demo. Not a retro. A gate.

### Three gates, at three altitudes — never conflate them

A cycle passes through three human gates, and the most common mistake is treating them as one:

| Gate | Cadence | The question it answers | Who holds the veto |
|---|---|---|---|
| **Flight plan** | per PRD | *Is this the right route, and is the plan flyable?* | The owner of the intent — before any build |
| **Pull request** | per PR | *Does this build do what its brief said?* | Engineering — the QA evidence and a peer |
| **Closing** *(the business review)* | per PRD | *Is the shipped thing right, and what did we learn?* | The same owner who cleared the flight plan |

The middle gate is **correctness**. The outer two are **judgement**, held by one owner, bookending the build. That symmetry is the point: the person who cleared the route is the person who confirms the landing, which is what stops a plan being approved by one standard and accepted by another.

A closing is not a bigger PR review. It sits at a higher altitude — not *is the build correct?* but *is the shipped thing right?* — and it includes the lens engineering review structurally cannot apply: does this actually meet the intent, and does it look right against the design system. Run that lens whether or not a designer is in the room, so it never gets skipped.

### Why the gate belongs in the method

Three framings, one ceremony. The derivation matters, because a ceremony that only makes sense
inside one team's org chart is not methodology:

- **In harness terms.** C² is a harness methodology, and a harness is gather → act → **verify**.
  C² has a ceremony for gather (Flight Planning) and had none at verify. The closing gate is the
  verify step, with a human at it.
- **In loop terms.** Every loop needs a stop condition, and the stop condition has to be evidence
  rather than confidence. The closing gate is where a person checks the evidence instead of the
  agent's account of it.
- **In graph terms.** Every fan-out needs a barrier. The closing gate is the barrier where the
  human sits. A fan-out with no closing gate is the graph agreeing with itself.

That derivation holds for a solo operator with no product function, for an agency, for an MSP,
and for a fifty-person team.

### What a closing contains

| Part | What it is | The pilot's line |
|---|---|---|
| **The landing** | What was actually built, against the line that was drawn | "This is what I said I'd build; this is what landed" |
| **The deviation** | Where the route changed and why — zero judgment, the plan exists to make drift visible | "Here's where I flew off the filed route, and what I decided in the air" |
| **The anchor** | The evidence that decides done: tests that ran, the query that returned rows, the deploy that resolved. Not "the agent says it's done" | "Here's the signal, not my account of the signal" |
| **The learning** | What the contextbase gains — gotchas, patterns, ADRs, the PRD's `completion_rationale`, estimated vs actual hours | "Here's what the next session shouldn't have to rediscover" |

Like the flight plan itself, the closing doc is a **meeting agenda, not a third source of truth.**
The PRD, its briefs, and the contextbase hold the truth. Fold the closing's decisions back into
them and bin the doc.

### The findings need structure, or they evaporate

This is the part most teams lose. A review produces a pile of *we should fix that* and *we should
add that*, and in most rooms it dies in the room. Structure is what stops that, and it is cheap:

- **Every finding gets a stable ID**, written onto the PRD in one section — not scattered through
  a transcript.
- **Tagged FIX or ADD.** *FIX* is wrong today. *ADD* is a new capability. Conflating them is how a
  bug list turns into a roadmap and nothing gets fixed.
- **Grouped by surface, and attributed** — who raised it. Attribution is not blame; it is who to
  ask when the finding is ambiguous three weeks later.
- **The keystone is flagged, and the list is sequenced.** Keystone first — the one that unblocks
  the rest — then the trust fixes, then the high-value adds, then the design pass. An unsequenced
  list of twenty findings is twenty arguments waiting to happen.
- **The closing PR references the ID it closes.** That makes the trail run
  *review → PRD → PR → shipped*, and it is auditable from git alone.

Those findings are the **seed for the next flight plan**. That is the join that makes the loop a
loop rather than two ceremonies that happen to bracket a build.

And if an agent prepares the capture, **it stops at captured.** It writes the section and hands
over a clean, sequenced list. It does not prioritise, and it does not start building. Sequencing
is judgement, and judgement is the pilot's.

### The sweep — and why it belongs to the *next* flight plan

A findings section that only ever grows will drown the PRD in its own history, and the PRD is
meant to say *where the work is now*. So the section is bounded, and the boundary is swept at the
version bank-switch — **by the next flight plan, not by the closing.**

- **Durable decisions and rules** are promoted into the spec itself or into `03-knowledge/`, then
  cleared from the list.
- **Done admin items** are cleared outright. Nothing is lost: the trail lives in the PR that closed
  them, in the release note, and in `git log` forever.
- **Unfinished items** carry forward into the new plan.
- **The feature list is reconciled** so it states what the PRD now holds and each item's real
  status.

So the two ceremonies own the two ends of the lifecycle: **the closing appends at the end of a
cycle; the next flight plan sweeps at the start of the next one.** That is how a PRD compounds
without hoarding — and it is the mechanism behind "living, not frozen", which is otherwise just a
sentiment.

### Who closes it

Whoever owns the intent and whoever owns the implementation. Where those are separate functions
that is two people in a room, both with the authority to reject. In most setups it is one person
wearing both hats. In a solo build it is the pilot checking their own landing — and that pilot is
the reader who most needs this gate and most easily skips it.

Size the ceremony to the work, exactly as the Filing does. With a crew it is a room. Alone it is
**the human review where you check the agent did what you actually wanted.** One ceremony at two
weights, not an enterprise ritual with a solo footnote.

### Why this is the keystone, not a nicety

C² already prescribes every artefact in that last row — the session brief, the `03-knowledge/`
capture, the PRD's `completion_rationale`, `estimated_hours` against `actual_hours` — and until
now prescribed **no ceremony that produces them.** They depended on discipline at the exact moment
a team feels finished, which is the worst possible moment to depend on discipline.

**Flight Planning is where context is spent. Closing is where context is made.** That is the
compounding loop with a ceremony at each end, and it is why an unclosed plan is not a paperwork
failure but a compounding failure: the session happened and nothing was learned from it.

An open plan nobody closed is also precisely the create-not-finish drift the WIP cap and the
monthly review exist to catch. The cap counts what is open; the closing gate is what makes
something *stop* being open.

### The gate moves as the fleet grows

What the pilot checks changes with scale, even though the ceremony does not:

- **One agent, watched.** You read the diff.
- **Several agents in isolation.** You review final diffs rather than keystrokes.
- **More output than you can read.** *"Did you read the code?"* becomes *"what context was the
  model missing, and how do we fix that for next time?"* — which **is** the closing question, and
  its answer goes straight into `03-knowledge/`.

The ceremony is what makes that third stage survivable. Without it, work at that scale is
unreviewed by construction.

---

## The `flight-plan` skill (specialist agent)

A repeatable harness that helps a pilot *prepare to file*. Lives as a specialist agent
(`.claude/agents/flight-plan` in build repos; role doc in `docs/06-agents/specialist/`).
It does not fly the mission — it gets the plan ready for the team to review.

**Trigger:** "file a flight plan for [PRD]", "prep flight plan", invoked at the PRD→build gate.

**Inputs:** a Feature PRD (the target); read access to the contextbase.

**What it does:**

| Stage | Behaviour |
|---|---|
| **Load** | Read the PRD + knowledge index + latest session brief via the router. Don't load everything — load by surface. |
| **Draw the line** | Propose an explicit in-scope / out-of-scope boundary. Make the pilot confirm or move the line. |
| **Interrogate the spec** | Flag **over-spec** (candidates to pull out or break into separate briefs) and **under-spec** (the gap between "problem one" and the whole job-to-be-done). Name the real JTBD. |
| **Build the briefs** | Draft one Prompt Brief per atomic unit, each run against the **6-item quality gate** (goal, scope exclusions, testable AC, non-goals, testing approach, definition of done) + the pre-flight file/line table. |
| **Plot the journey** | Produce milestones, a believed landing point, and an ETA. |
| **Sweep the last cycle** | Before planning the next one, clear the previous cycle's findings at the version bank-switch: promote durable decisions into the spec or `03-knowledge/`, clear done admin outright, carry unfinished items forward, reconcile the feature list against what actually shipped. The unfinished items are the raw material for this plan. |
| **Draw the shape** | Derive the topology from the brief set's own pre-flight tables: which briefs are independent, which are joined by an edge and must sequence, where the barrier sits, which edges get a bench pass. If no two briefs are independent, say so rather than inventing a graph. |
| **Mock the red line** *(optional)* | On request, scaffold a couple of look-and-feel pages in a feature branch so the review has something to bounce off. |
| **File** | Emit the **Flight Plan artefact** (the five parts above) + the drafted PBs, ready for the Filing/Review session. |

**Output:** a Flight Plan doc + filled Prompt Brief templates in
`docs/02-working/prompt-briefs/backlog/`, and a one-screen summary the pilot presents.

**What it must NOT do:** start building. The skill stops at *filed*. Takeoff is a separate,
human-gated step — that's the whole point of filing a plan first.

**Quality gate the skill enforces before it will say "ready to file":**

- [ ] The previous cycle is swept — durable decisions promoted, done admin cleared, unfinished carried forward, feature list reconciled
- [ ] The line is drawn — explicit in/out scope, confirmed by the pilot
- [ ] Over/under-spec surfaced to product (at least one push-back logged, or an explicit "spec is right")
- [ ] The whole job-to-be-done is named — not just problem one
- [ ] Every Prompt Brief clears the 6-item gate
- [ ] Journey has milestones + a believed landing point + an ETA
- [ ] The shape is drawn — independent briefs identified, edges named by what crosses them, barrier located, verified edges marked
- [ ] (If applicable) a red-line mock exists to bounce off

---

## The agent team around Flight Planning

Specialist agents prepare the humans; they don't replace them. Every one of these is
**review-only or draft-only** — it produces something for the crew to react to, and a human
always makes the call. Two roles bracket the ceremony, both drawn from production practice:

| Agent | When | What it produces | Hard limit |
|---|---|---|---|
| **`flight-plan`** | Before Filing | The filed plan — line, briefs, journey, shape (see above) | Stops at *filed*; never takes off. Drawing a graph is not permission to fly it |
| **`qa-gate` — readiness** | Before a Flight Plan Review | A **Flight Plan readiness report**: each acceptance criterion marked READY / NEEDS-CLARIFICATION / AT-RISK, the open questions only humans can decide, which environments are healthy, and the gotchas this surface should account for | Reports readiness; never builds or decides |
| **`qa-gate` — verification** | After takeoff (post-build) | A pass/fail matrix against the brief's acceptance criteria, repro steps for fails, and a plain GREEN / RED recommendation | Review-only; never edits code |

The division of labour matters so the two don't collide: **`flight-plan` *builds* the plan;
`qa-gate` readiness *stress-tests* it.** The skill drafts the briefs and the testing approach;
the readiness agent independently checks whether those criteria are actually testable and what
the Review still needs to decide. One proposes, the other challenges — the same lead/bench
independence the methodology asks for, applied to the plan instead of the code.

**Is there a `close-flight-plan` skill?** Assessed for v1.3: **no, and deliberately.** The four
parts of a closing are retrieval plus judgment, not drafting. *The landing* and *the deviation*
read straight off the filed plan and the git history. *The anchor* is already `qa-gate`
verification's output — a pass/fail matrix against the acceptance criteria. *The learning* is the
session-brief protocol, which C² has prescribed since v1.0. There is no drafting job left large
enough to need a protocol of its own.

The stronger reason is structural: the closing gate exists because a human has to read the
evidence rather than an agent's account of it. A skill that assembles a tidy closing document is
one step from a closing that *looks* closed — the graph agreeing with itself at the one gate
built to stop exactly that. Revisit only if teams start skipping the ceremony because assembling
the four parts is tedious, which would mean the bottleneck is preparation rather than decision.

**Vocabulary:** these agents speak Flight Planning. The pilot analogy *is* the C² frame, so
there is one name for the ceremony — **Flight Planning** (Filing and Review) — and "pre-flight"
refers only to the file/line section inside a Prompt Brief. A readiness agent prepares a crew
member *for the Flight Plan Review*; it is not a separate "pre-flight meeting."

**Where Flight Planning sits in the wider loop:** filing the plan is the first of three human
gates (see "Three gates, at three altitudes"). Between them sits a **mid-build checkpoint**
(change-the-plan, not progress-check), and after them an **outcome review** at PRD level ("did we
do the right thing as a company").

Do not merge the agent-run verification with the human gate it feeds. `qa-gate` is an agent
producing a pass/fail matrix — evidence, gathered. The closing gate is a human reading that
evidence and accepting or rejecting the landing — a decision, made. One supplies the anchor; the
other acts on it. **An agent may never close a flight plan, for the same reason it may never file
one.**

Filing and Closing are the pair. Everything between them is flying — and the next filing sweeps
what the last closing left behind.

---

## Related

- Methodology: [`methodology.md`](methodology.md) — the Cascade, the Pilot model, the pre-flight section
- Prompt Brief templates: `starter/docs/02-working/prompt-briefs/`
- Closing template: `starter/docs/02-working/flight-plans/flight-plan-closing.md` — the four-part landing gate, one screen
- Skill: `skills/flight-plan/SKILL.md` — copy into your repo's `.claude/skills/` to install it

---

*C² Flight Planning. Promoted from production practice, June 2026. Closing the Flight Plan added
v1.3, August 2026. Part of the C² kit — see c2method.ai.*
