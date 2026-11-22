---
name: c2-govern
description: >-
  Close the governance gap in a C² repository: raise coverage and shrink dark code by declaring
  what documents already govern, writing a rule for the darkest folders, and turning records of
  past work into knowledge. Works from the worklist the brain tool writes. Use after c2-brain,
  or when someone asks what to do about low coverage or dark code. Trigger phrases: "close the
  gap", "raise our coverage", "fix the dark code", "tighten governance", "run c2-govern",
  "what do I do with the brain numbers".
---

# c2-govern

The brain tool measures. You close the gap. You work from the worklist it writes, one item at a
time, with the pilot accepting each change.

**Hard limits.**
- You never change code. You change documents in the contextbase, and only ones the pilot accepts.
- One document per proposal. Show the exact frontmatter or the full new document before writing it.
- You never give a document a `governs:` line wider than what it really binds. `**` at the root, or
  a whole app for a document about one screen, makes the number rise and mean nothing.
- You never delete or archive a record of past work in this skill. You report it.
- Coverage is not the goal. An agent that gets the right rule before it writes is the goal.
  If a path would be declared only to raise the number, leave it dark and say so.

## One session

### 0. Measure

```bash
node <kit>/brain/brain.mjs <repo> --out <repo>-brain.html --json <repo>-brain.json
```

The run writes `<repo>-brain-worklist.md` beside the HTML. Read it. Write down the four numbers
before you change anything: coverage, dark code, dead context, declared links. Agree with the
pilot how far this session goes. A good first session is step 1 for five documents and step 2
for one folder.

### 1. Declare what you already have

The worklist lists South and West documents that already name code, each with a `governs:` block
built from what the document mentions. Mentioning is not binding. For each document:

1. Read the document.
2. For each path, ask: if an agent changed this file, must it read this document first? Keep
   the path if yes. Drop it if the document only mentions it as an example or in passing.
3. Prefer the narrowest form that is still true: a file, then a folder (the files directly in
   it), then `folder/**` (everything beneath it).
4. Show the block and the reason for anything you dropped. Write it into the frontmatter when
   the pilot accepts.

This step costs little and changes what the number means: declared links are a claim someone
checked, not a guess.

### 2. Light the darkest folders

For each folder in the worklist's dark list, most dark files first:

1. Read the code in the folder, enough to know its conventions. Read the East records listed
   under "Start from": they are where the lessons about this folder already are.
2. Check "Nearest South or West". If a document nearly covers the folder, extend that document
   and its `governs:` line. Do not write a second one.
3. Otherwise draft one new document in the repo's own taxonomy. A **pattern** for how code here
   must be written. A **decision** for a choice that is settled. A **gotcha** for a trap. A
   **runbook** (West) for how a job here is done. Keep it short: the rules an agent needs before
   it edits, each one checkable against the code.
4. Cite the session briefs or reviews the rules came from. That citation is what makes this
   compounding: experience turned into knowledge on purpose.
5. Give it a `governs:` line for the folder. Show the whole document. Write it when accepted.

Do not state a rule the code does not follow. If the code is inconsistent, say so in the
document and name the intended rule only if the pilot confirms it.

### 3. Experience with no knowledge

The worklist lists dark files that many records of past work mention. Those are files the team
keeps having to relearn. Read the records, pull out what repeated, and write it as a gotcha or
a pattern with a `governs:` line for that file. One file, one document.

### 4. Leave the broad ones alone

Documents that name more than 40 places are indexes, backlogs or routers. Do not declare them.
If one hides a real rule, propose moving the rule into its own document and declaring that.

### 5. Wire the needle into the work

Governance only pays when an agent reads the governing document before it writes. Offer the
pilot one line for the Router (`CLAUDE.md` or `AGENTS.md`):

> Before changing a file, read the documents that govern it:
> `node <kit>/brain/governs.mjs <repo>-brain.json <path>` lists them, most specific first.

`governs.mjs` answers from the graph JSON, so it is as fresh as the last brain run. Do not edit
the Router yourself unless the pilot asks.

### 6. Measure again and report

Run the brain again. Report the four numbers before and after, the documents you declared, the
documents you wrote, and what you left dark on purpose and why. Record it in the session brief.

## What a good session looks like

Five documents declared, one new pattern for the darkest folder, coverage up a few points, and
a note of what was left alone. Small and true beats a large jump from wide globs.
