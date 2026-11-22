# Context Governance: the needle on the Compass

**Version 1.0. 2026-11-22.**

A statement of what makes a contextbase powerful, how to measure it, and what the measurement is
for. It belongs to the C² Method and builds on the Context Compass. The tool that measures it is
[`brain/`](brain/README.md).

## The claim

**The power of a contextbase is not how much it holds. It is how much of the work it governs.**

A team that builds with agents writes a great deal of context: plans, briefs, decisions, lessons.
It is natural to count it, and to feel that more is better. Counting it measures the wrong thing.
A repository can hold nine million words of context and still leave most of its code governed by
nothing a future agent will ever read.

## The Compass: four kinds of memory

The Context Compass says that memory is not one thing. It has four kinds, and each answers a
different question.

| Direction | Kind of memory | The question | In a C² repository |
|---|---|---|---|
| **North** | Working | What is in flight right now? | active prompt briefs and tasks; the agent's own context |
| **East** | Episodic | What happened? | session briefs, reviews, finished work |
| **South** | Semantic | What is true? | requirements, decisions, patterns, gotchas |
| **West** | Procedural | How do we do things here? | runbooks, playbooks, skills, the Router |

The four kinds come from cognitive science by way of *Cognitive Architectures for Language Agents*
(CoALA), by Sumers, Yao, Narasimhan and Griffiths of Princeton University (2023; Transactions on
Machine Learning Research, 2024). CoALA divides an agent's memory into working memory and three
long-term memories: episodic, semantic and procedural. The Compass gives each a direction.

The Compass tells you where a piece of context sits. It does not tell you what that context is
*for*. A pattern document and the code it was written about can sit in the same repository for a
year without anything saying that one binds the other.

## Governance is the needle

**Governance is what points a specific piece of South or West at a specific piece of work.**

It is not a fifth direction. The four directions are where memory sits. Governance is the needle:
the thing that says *this* decision binds *that* code, *this* runbook is how *that* job is done.

A pattern that says how every server function must authenticate governs those functions. A decision
that fixes an identifier format governs every table that carries one. Without the needle, South and
West are a library. With it, they are law.

Volume mostly measures East. A brain becomes powerful when East is turned into South and West, and
South and West are pointed at the work.

## Governance is declared

Whether a document governs a piece of work should not be a guess.

A South or West document declares what it binds, in its own frontmatter:

```yaml
governs:
  - src/api/**
  - lib/auth.ts
```

Until a document declares, governance can be inferred: a South or West document that names a file,
or the folder a file sits in, is taken to govern it. Inference gives every repository a number on
its first day. It is only a proxy. The rules that matter most often apply by scope and name no file
at all, and inference cannot see them. Declaring is how the number becomes honest.

## The needle fills North

Declared governance is more than a measurement. It is a lookup.

North is working memory: what an agent holds at the moment it acts. It is small, and what goes
into it decides what gets built. If the contextbase knows which documents govern a file, then an
agent about to change that file can be handed exactly those documents, most specific first. That is
the needle doing its job: moving the right South and West into North, at the moment of action.

Today a person maintains that routing by hand, in a Router file, and hopes the agent follows the
pointers. With declared governance the route is computed from the context itself.

This is why the picture of the brain matters less than the links in it. A graph you can look at is
a visualisation. A graph that decides what an agent reads before it writes is part of the factory.

## Four numbers

One number invites gaming. Four numbers describe a brain. Each is a reading of the Compass.

| Number | Question it answers | On the Compass |
|---|---|---|
| **Coverage** | What share of the work is governed? | how far South and West reach |
| **Dark code** | What work does nothing govern? | where the needle points at nothing |
| **Compounding rate** | How much experience became knowledge this period? | East turned into South and West |
| **Dead context** | What is never recalled? | East that never returns to North |

Coverage and dark code describe reach. Compounding rate describes whether a team is learning or
only logging: CoALA describes the same step as an agent reflecting on episodic memory to produce
new semantic knowledge. Dead context describes waste.

## Closing the gap

A number with no next step is a dashboard. Each of the four numbers has a move.

1. **Declare what you already have.** Most repositories hold documents that already describe
   code. Give each a `governs:` line, keeping only what it really binds. This costs little and
   turns a guess into a claim someone checked.
2. **Light the darkest folders.** Take the folder with the most ungoverned code. Write one
   pattern, decision or runbook that says what is true there, and point it at the folder.
3. **Turn experience into knowledge.** Where records of past work keep naming the same dark
   file, the lesson exists and has not been written as a rule. Write it, and cite the records it
   came from. That is compounding, done on purpose.
4. **Leave the broad ones alone.** A document that names everything is an index. Declaring it
   raises the number and tells an agent nothing.

Then measure again. Coverage is not the goal. An agent that is handed the right rule before it
writes is the goal, and coverage is how you see whether that is getting more likely.

## What this predicts

The intuition that started this was that a repository moves, over time, from little context and
much code toward much context and little code. Measured by volume, that is not what happens: on the
repository measured below, documents per code file fell over five quarters, from 1.44 to 0.88.
Context and code grew together.

Restated in terms of governance, the intuition holds as a goal:

**In a healthy repository, coverage rises and dark code falls. Volume matters little.**

A team that is compounding converts what it learned last month into South and West that govern what
it builds this month. A team that is only logging writes more East every week and governs no more
than it did.

## What one repository showed

Measured on one production monorepo on 2026-11-22: 6,126 context documents and 6,014 source files,
built largely by agents over about sixteen months. Governance was inferred, because nothing was
declared yet. Each document was placed on the Compass by its kind: 1,008 North, 3,286 East, 1,518
South and 314 West.

- Some document named 42% of source files directly. A South or West document named 10%.
- 32% of source files were named by East or North and by no South or West document at all.
- Counting a file as reached when a document named its folder, any context reached 82%, and South
  and West reached 47%. That leaves 53% as dark code.
- A year earlier South and West named 18% of the code that existed then. On the day measured it
  was 10%. The code grew faster than the governance.
- A South or West document named 1.1 code locations on average. An East document named 2.2, and a
  North document 4.3.
- 67% of East documents were referred to by nothing. For South and West it was 20%.
- In the last 90 days the repository gained 791 East documents and 275 South and West documents.

Read plainly: this brain remembers far more than it governs, and most of what it remembers is never
recalled. That is the gap the method exists to close.

One limit on these figures. They understate governance wherever a rule applies by scope without
naming a file, which is the limit of inference and the reason to declare.

## What is not settled

Version 1 leaves these open.

1. **Specificity.** A document that claims to govern everything would read as full coverage. A
   document that governs twenty files should count for more than one that governs two thousand.
   The rule that makes this so is not written yet.
2. **Promotion.** Compounding rate needs a definition of when East has become South or West: a new
   South document that cites the briefs it came from is the obvious signal, and it is untested.
3. **Staleness.** A document that governed code a year ago may not describe it now. The needle
   should weaken when the code changes and the document does not.
4. **Beyond code.** The Compass applies to a company, a department and a person as well as a
   repository. What South and West govern there, where the work is not code, is not worked out.
5. **Code as memory.** CoALA counts an agent's own code as part of its procedural memory. Here the
   code is the work being governed. Whether some code belongs on the West of the Compass is open.
6. **Only one repository has been measured.** Every figure above is one data point.

## Summary

- Count what the context governs, not how much there is.
- The Compass names four kinds of memory: North is now, East is what happened, South is what is
  true, West is how we do things.
- Governance is the needle: it points a specific piece of South or West at a specific piece of work.
- Governance is declared in the document, and inferred only until it is.
- The needle fills North: it decides what an agent reads before it writes.
- Watch four numbers: coverage, dark code, compounding rate, dead context.

## Source

Sumers, T. R., Yao, S., Narasimhan, K., and Griffiths, T. L. *Cognitive Architectures for Language
Agents.* Princeton University. arXiv:2309.02427 (2023); Transactions on Machine Learning Research
(2024). https://arxiv.org/abs/2309.02427
