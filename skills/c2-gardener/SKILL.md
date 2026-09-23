---
name: c2-gardener
description: >-
  Scheduled contextbase housekeeping for a C² repo run by a fleet: dedupe gotchas, mark
  superseded knowledge, prune and index session briefs. Runs on a schedule (weekly by default),
  never continuously, and only ever proposes changes by PR.
---

# c2-gardener

A fleet writes a lot of context: every lane files gotchas and session briefs. Unchecked, the
contextbase fills with near-duplicates and stale advice, and lanes start loading noise. The
gardener keeps it dense. It runs **on a schedule** (weekly is the default: a routine, a cron,
or `fleet`'s tower asking for it). It never runs continuously and never commits to the base
branch directly.

## One run

1. **Gotchas** (`docs/03-knowledge/gotchas/`): find entries that describe the same trap. Merge
   them into one file that keeps every symptom, the real cause and the current fix. Delete the
   rest in the same PR, so git history keeps the trail.
2. **Superseded knowledge:** a gotcha whose fix is now enforced by code or CI gets a line at the
   top, `Superseded <date>: <what enforces it now>`. Don't delete it: the history is the point.
3. **Session briefs** (`docs/02-working/session-briefs/`): leave them alone, but make sure the
   router points at the latest one. If the directory has grown past what a lane should scan, add
   or refresh an index with one line per brief.
4. **Recurring observations:** the same finding in three or more briefs or reviews gets
   promoted into a gotcha or pattern, citing where it came from.
5. **Open one PR** labelled `fleet:review` with a summary table (merged, superseded, promoted,
   indexed). The checkpoint reviews it like any other.

**"Nothing to garden this week" is a valid and good outcome.** A gardener that always finds
something to change is broken.
