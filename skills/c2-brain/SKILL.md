---
name: c2-brain
description: >-
  Draw a C² repository's brain: its contextbase and codebase as one 3D graph in a single HTML
  file, with the four context-governance numbers (coverage, dark code, compounding rate, dead
  context). Use when someone wants to see or show the brain behind a repo, measure how much of
  the code the context governs, or find dark code. Trigger phrases: "draw the brain", "show me
  the repo brain", "run c2-brain", "what's our context coverage", "find the dark code".
---

# c2-brain

You draw the brain of a repository and report what it governs. The scripts in
[`brain/`](../../brain/README.md) do the counting and the drawing. You do the three things a
script cannot: work out where this repo keeps its context, find its look, and say what the
numbers mean.

**Hard limits.** You never edit the repo's documents or code. You write at most one file into
the repo, `brain.config.json`, and only after showing it. You never publish or upload the
output: a full brain carries every file path and document title, so sharing is the human's call.

## One run

1. **Find the contextbase.** The default is `docs/` plus `CLAUDE.md` and `AGENTS.md`. Look for
   other homes of context (`.context/`, `handbook/`, `notes/`, an `adr/` folder at the root) and
   list them in `context`. Any number of folders is fine: every top-level folder becomes its own
   lobe, in name order.
2. **Find the kinds.** The defaults cover the C² taxonomy (session briefs, prompt briefs, PRDs,
   ADRs, gotchas, patterns, runbooks, reviews, tasks, templates). If the repo has kinds of its
   own, such as standards or playbooks, add a path rule under `kinds` and place each on the
   Compass under `compassKinds`: `north` in flight, `east` what happened, `south` what is true,
   `west` how the work is done.
3. **Find the apps.** Each app is drawn as its own sphere on an orbit around the contextbase, and
   shared code sits on an inner orbit. By default an app is a folder directly inside `apps/`,
   `native/`, `services/` or `clients/`. Ask the pilot to name the products, compare that with the
   list the run prints, and write the real list under `apps` if they differ. A helper folder that
   sits beside the apps (shared code, scripts) is not an app: leave it out.
4. **Find the look.** If the repo has a design system (a Tailwind config, CSS variables, a brand
   document), take the background, ink and accent colours and the font from it and write a
   `theme` block. If it has none, write no theme: the default is the plain black-and-white C²
   look, with colour only on the folders.
5. **Show the config, then write it** to `brain.config.json` at the repo root. Skip this step
   when the defaults already fit. [`brain.config.example.json`](../../brain/brain.config.example.json)
   shows the shape.
6. **Run it.**
   ```bash
   node <kit>/brain/brain.mjs <repo> --out <repo-name>-brain.html
   ```
   First time only: `npm install` inside `<kit>/brain`. Add `--public` for a copy with every
   title, path and tag removed, which is the only version fit to post.
7. **Report.** Give the path to the HTML file and the four numbers, each with one plain sentence:
   - **Coverage**: the share of source files a South or West document governs by name, and the
     share counting its folder.
   - **Dark code**: the share nothing governs. Name the three darkest top-level folders.
   - **Dead context**: the share of East (records of past work) that nothing refers to.
   - **Compounding rate**: new South and West documents against new East documents in the last
     90 days. Say that this one is provisional.
   Then say whether governance was declared or inferred. If nothing declares `governs:`, the
   numbers are inferred from mentions and understate rules that apply by scope.

## Declaring governance

A South or West document says what it binds in its own frontmatter:

```yaml
governs:
  - src/api/**
  - lib/auth.ts
```

A path binds that file, a folder binds the files in it, and `folder/**` binds everything
beneath it. If the pilot asks you to raise coverage, do not add `governs:` lines yourself in
bulk. Propose them one document at a time, most load-bearing first, and let the pilot accept
each: a document that claims to govern everything makes the number meaningless.

## Closing the gap

The run also writes `<repo>-brain-worklist.md`: the documents ready to declare, the darkest
folders with the records to draw on, and the files the team keeps relearning. When the pilot
asks what to do about the numbers, hand over to the [`c2-govern`](../c2-govern/SKILL.md) skill,
which works that list one item at a time.

## What a good run looks like

"Nothing to configure, here is your brain and its four numbers" is a good run. A low coverage
number is a finding, not a failure. Report it as it is.
