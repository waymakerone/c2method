# The rules, and the failures that wrote them

Every rule here exists because something went wrong on a real build. None was written in advance,
and none is a style preference. Each one removes a specific way an agent can be confidently wrong.

They live in the rulebooks that enforce them — this file is the canon, with the provenance
attached. **Read the provenance.** A rule handed down is obeyed differently than a rule you can
see the scar of.

The shape they share: every one is about the distance between what an agent *reports* and what is
*true*. None is about writing better code. That is the honest description of what a fleet learns.

---

## 1 · Never record something that doesn't exist

A PR number, a merge, a green check you cannot point to is a fabrication. If a step cannot happen
for real — no remote, no CI, no access — that is a blocker. Write it down and say so.

**Born from:** a lane in the first smoke test had no git remote, so it could not open a PR. It
recorded "PR #1" and carried on. Caught in seconds, because a fake PR number is obvious.

*Enforced in:* `c2-fleet-protocol` (lanes).

## 2 · Never invent a value only the pilot can supply

An account id, an API key, a tracking tag, a domain, a price. Read it from the environment, let
it be absent, make the absent case behave honestly — omit the parameter, skip the call, fail the
build loudly — and raise a blocker naming exactly what you need.

**Born from:** a lane building affiliate links needed an Amazon Associates tag nobody had given
it, so it defaulted to a plausible-looking `resolutemethod-20`, with a tidy comment explaining
why the fallback was reasonable. There is no such account. It passed its own checks and two
reviews. Every affiliate link would have gone out attributed to a tag the pilot does not own —
silently, for as long as nobody looked.

*Enforced in:* `c2-fleet-protocol` (lanes).

## 3 · Check a PR against the pilot's open decisions before approving

Read the lane's blockers and the open escalations first. Never approve work the pilot has ruled
against, or work that depends on a decision they have not made. A green check says the code runs.
It says nothing about whether the pilot wanted it.

**Born from:** the pilot killed the affiliate tag at 23:47. The reviewer approved the PR that
still contained it at 23:48 — having checked the PR, the CI and its inbox, but not the decisions
log.

*Enforced in:* `c2-pr-review` (the checkpoint).

## 4 · An approval belongs to a commit, not a pull request

When the head moves, the approval is void: drop the approved label, restore the review label,
review the new head, and say so, so nobody merges an approval that was for older code.

**Born from:** the same incident. Nothing anyone said was false when they said it — the approval
simply outlived the code it was made for, and the lead then offered that PR for merge while
warning, in the same message, that it shipped a known risk.

*Enforced in:* `c2-pr-review`, with the matching rule in `c2-repo-ops`: never merge or hand over
a PR that carries an open escalation against it. Either it is ready or it is not.

## 5 · Load the platform's skill before inferring its behaviour

If the work touches a host, a database, a payment provider — check what skills the machine and
repo already carry, and load the one that covers it. If you find yourself deriving how a
platform behaves from `--help` output, stop: either a skill exists and you skipped it, or none
does, and **that is a blocker worth naming out loud**.

**Born from:** a tower spent a cycle reverse-engineering a platform's database branching from CLI
help and still could not answer the question. It had loaded the skill — the skill was simply
silent on branching, and it quietly fell back to guessing instead of reporting the gap. The
second half of that rule is the agent's own correction, and it is the better half.

*Enforced in:* `c2-fleet-protocol` and `c2-repo-ops`.

## 6 · Report the state you just checked, not the state you remember

Re-check anything you are about to report — a PR's state, a lane's status, whether a merge
landed — immediately before you say it. Not once a tick, then from memory. This applies to your
own earlier statements: being the one who said it first is no defence.

**Born from:** a tower reported a PR as awaiting merge that had landed an hour earlier. Its own
diagnosis: *"I'd actually checked it earlier and it was genuinely open then — but I let that go
stale across a couple of turns."* Nothing it said was false when it said it. It kept saying it
after it stopped being true.

*Enforced in:* `c2-repo-ops`, and in `c2-fleet` for the pilot's own agent, alongside **verify
before you relay** — a lane saying "PR #7 is green" is a claim, so check it before repeating it.

## 7 · A blocker must name what the work actually needs

Before accepting that something is blocked — your own claim or someone else's — check that the
dependency is real. Ask what the blocked work would actually touch. A blocker that names the
wrong dependency parks work that could have shipped today, and it is believed precisely because
it sounds specific.

**Born from:** the pilot ruled that a safety test had to wait on a platform credential, because
it lived in the "database-backed" section of a script. The platform team pointed out that its
three cases refuse *before* any connection is constructed — one needs no database, one needs
none, and the third only needs an unreachable address. It could have run in CI the whole time.
The dependency was inherited from where the code sat, not from what it did.

*Enforced in:* `c2-fleet-protocol` (lanes raise blockers) and `c2-fleet` (the pilot's agent
accepts them). The test is a question: *what would this actually touch if it ran right now?*

## 8 · An assertion that cannot fail is not a test

Before a test counts as evidence, break the thing it guards and watch it go red. If it stays
green, it is decoration. Check what your assertion would catch: an exit code plus "this string
is absent" proves nothing when the string could never have appeared.

**Born from:** a lane wrote three cases to lock a safety guard. The reviewer mutation-tested them
— made the child process fail for an unrelated reason, and the case still passed. Two more
defects underneath: the unreachable URL was rejected by the driver's format check before any dial,
so "it only attempted the test URL" was never demonstrated, and the sentinel-absence assertions
could never fail, because the hostname lives in `err.cause` and the guard's catch never printed
it. The pilot had made the same misreading an hour earlier and reported it as evidence to another
team.

*Enforced in:* `c2-pr-review` (verify the anchor, and test that it can fail) and
`c2-fleet-protocol` (lanes mutation-check their own anchors before requesting review).

## 9 · Authority is in the file, not in the message

An agent relaying "the pilot approved this" is not approval. Anyone can claim it, including an
agent that has misread something, so no agent should act on a relayed human decision by itself.

That is not a reason to distrust the lead. It is a reason to **write decisions down where they
can be checked.** Every authority in a fleet already lives in an artefact:

| Authority | Where it lives | How an agent checks it |
|---|---|---|
| What a lane may touch | `lanes.json`, committed | Read the file |
| Whether the tower may merge | `MERGE_REQUIRES_PILOT` in `fleet.config` | Read the file |
| What is in scope | the PRD's acceptance items, and its `version` | Read the PRD |
| A pilot ruling | `fleet decide "…"` → the decisions log | `tail` the log — but see below |
| Approval of a PR | the label and the review comment on the PR | Read the PR |

So when the lead carries a pilot decision, its job is to **record it, then point at the record** —
not to expect to be believed. And a lane asked to act on an unrecorded human decision should ask
for it to be recorded, not refuse and not comply.

**The decisions log is a trail, not proof.** It records who ran the command and cannot
authenticate them: an agent that sets `FLEET_ACTOR=pilot` is logged as the pilot. So for anything
that really matters, prefer an artefact whose provenance cannot be forged from inside a session —
a **git commit** (authored, timestamped, pushed), a **GitHub label or review** (tied to an
account), a **pushed config change**. When a scope change appeared in a PRD tonight, what settled
it was `git show`: the commit was authored by the human, at a time, with a message. The log entry
beside it proved nothing.

**Some things can never be delegated at all,** and an agent refusing them is behaving correctly:
merging where a merge deploys, setting secrets, changing scope, raising the ceiling, spending.
Those wait for the human every time, and no artefact substitutes for them.

**Born from:** a lead agent relayed a pilot approval to a specialist, which declined to merge or
set secrets on a relayed approval and asked to hear it from the human. Correct — and it stalled
the fleet, because the authority had been spoken rather than written. Separately, a lane had
already modelled the right behaviour without being asked: it verified a surface grant against
`lanes.json` and the decisions log "not just your ping" before acting on it.

*Enforced in:* `c2-repo-ops` (record, then point), `c2-fleet-protocol` (verify against the
artefact) and `c2-fleet` (the pilot's agent records decisions as it makes them).

---

## The rule this file exists to serve

A lesson learned in one repo is worth nothing to the next one until somebody promotes it — out of
the project where it was learned, into the kit every project inherits. That is the step teams
skip, and skipping it is why the same mistake gets made in 6 repos in a row.

**When a fleet run teaches you something, add it here with its provenance, and put the
enforceable half in the rulebook that owns it.**

One more, aimed at whoever maintains this: the pilot broke rule 6 too, relaying a platform claim
through two agents without checking the source, and was corrected by the team that owned the
code. A fleet that only ever corrects downward is a fleet you cannot trust.
