# C² Brain

Draw a repository's brain: the contextbase and the codebase as one 3D graph, in one HTML file
you can open anywhere. It also measures **context governance**: how much of the code the
context actually governs.

```bash
cd brain && npm install          # once: one small dependency
node brain/brain.mjs /path/to/repo --out my-brain.html
open my-brain.html
```

Needs `git` and Node 18 or later. It reads the repo through git and writes one self-contained
file. Nothing is uploaded, and no file contents are written out: only names, titles and counts.

Two things to know before you share the file:

- **It names your files.** Without `--public` the page carries every title, path and tag in the
  repo. Share that version only with people who may see them. Use `--public` for anything you post.
- **It makes one outside request.** The page loads its fonts from Google Fonts when opened. Set
  `"theme": { "fontHref": null }` in `brain.config.json` to make none and fall back to system fonts.

## What you get

- **Every document and every code file as a node.** Circles are context, squares are code.
- **A solar system, one sphere per app.** The contextbase is the sphere in the middle. Shared code
  (packages, workers, scripts, the backend) circles close in, and each app is its own sphere on a
  wide orbit beyond it, with the links between them showing how they relate. An app is a folder
  directly inside `apps/`, `native/`, `services/` or `clients/`. A repo with none of those falls
  back to folders that carry their own manifest. Name them yourself under `apps` in the config.
- **Links** from the folder tree, markdown links, mentions of a path or file name, frontmatter
  references and ADR numbers. A name that could mean two files is never linked.
- **Open a folder.** Click a folder in the legend to see its subfolders, each in its own colour.
  The rest of the brain recedes, and a breadcrumb takes you back up. Click the dot to hide a folder.
- **Recenter** returns to the whole brain from any folder, selection or search. Esc does the same.
- **Toggle** context, code or all. **Colour by** folder, Compass, kind or status.
- **Compass colouring keeps your folders.** Each direction is explained and lists the folders that
  fall in it. Governs links are drawn in the colour of the document that governs.
- **A timeline** from the first commit to today, from git history (it follows renames).
- **Search** across titles, paths and tags.
- **Light and dark**, in the plain C² look or your own theme.

## The Compass and governance

Each document is placed on the Context Compass by its kind:

| Direction | Memory | Default kinds |
|---|---|---|
| North | working: what is in flight | prompt briefs and tasks that are not done |
| East | episodic: what happened | session briefs, reviews, anything archived or done |
| South | semantic: what is true | PRDs, ADRs, patterns, gotchas |
| West | procedural: how the work is done | runbooks, templates, the Router |

Governance is the needle: a South or West document governs the code it points at. Declare it in
the document's frontmatter:

```yaml
governs:
  - src/api/**
  - lib/auth.ts
```

Until a document declares, naming a code file or folder counts as governing it. The run prints
four numbers, and the Compass colour mode shows them on the graph:

| Number | Meaning |
|---|---|
| Coverage | share of source files governed by name (and the share counting folders) |
| Dark code | share nothing governs |
| Dead context | share of East that nothing refers to |
| Compounding rate | new South and West against new East in 90 days (provisional) |

## What to do about the numbers

Every run also writes `<repo>-brain-worklist.md`, and the page has the same list behind
**Close the gap**. Each number has an **i** that says what it means and how to move it.

1. **Declare what you already have.** Documents that already name code, each with a `governs:`
   block ready to check and paste.
2. **Light the darkest folders.** The folders with the most ungoverned source files, with the
   records of past work to draw a rule from.
3. **Experience with no knowledge.** Dark files your session briefs keep coming back to.
4. **Too broad to count.** Documents that name more than 40 places are indexes, not rules.
5. **Dead East.** Records nothing refers to, by folder.

The [`c2-govern`](../skills/c2-govern/SKILL.md) skill walks an agent through the list with you.

To ask which documents govern one file, most specific first:

```bash
node brain/brain.mjs /path/to/repo --json my-brain.json
node brain/governs.mjs my-brain.json src/api/users.ts
```

The worklist names files. It is never written with `--public`, and it is not for posting.

## Options

| Flag | What it does |
|---|---|
| `--out <file>` | where to write the HTML (default `<repo>-brain.html`) |
| `--public` | remove every title, path and tag. App and top-level folder names stay. The only version fit to post |
| `--config <file>` | a config other than `<repo>/brain.config.json` |
| `--json <file>` | also keep the graph as JSON |
| `--worklist <file>` | where to write the worklist (default: beside the HTML, `-worklist.md`) |

## Config

Optional. Put `brain.config.json` at the repo root; see
[`brain.config.example.json`](brain.config.example.json). You list only what differs:

- `context`: folders that hold the contextbase (default `["docs"]`). Any number.
- `router`: root files that count as context (default `CLAUDE.md`, `AGENTS.md`).
- `kinds`: extra `[kind, path pattern]` rules, tried before the defaults.
- `compassKinds`: where your extra kinds sit on the Compass.
- `apps`: the folders that are apps, when the default does not say it well. A path, or a path with
  `*` for one folder level: `["apps/*", "native/desktop", "native/ios"]`.
- `appFolders`: folders whose direct children are apps (default `apps`, `native`, `services`, `clients`).
- `minAppFiles`: an app smaller than this folds into its top-level folder (default 12).
- `minGroupFiles`: shared code smaller than this joins "Other" (default 20).
- `theme`: colours and fonts for light and dark. Leave it out for the C² look.

The [`c2-brain` skill](../skills/c2-brain/SKILL.md) has an agent work the config out for you.

## Known limits

- Mouse and trackpad only. No touch yet.
- Tested to about 15,000 nodes at 120 frames a second on a recent laptop. No level of detail
  beyond that.
- Code links to code only through the folder tree. Imports are not read.
- 16 folder colours, so colours repeat past 16 folders. Shape tells context from code.
- Coverage counts every governing document equally. A rule for weighting specific documents
  above broad ones is not written.
- Compounding rate is a provisional measure.
