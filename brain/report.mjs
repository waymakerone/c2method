#!/usr/bin/env node
// Turns a brain graph into a worklist: what to do to raise coverage and shrink dark code.
// usage: node report.mjs <graph.json> <out.md>
import { readFileSync, writeFileSync } from 'node:fs'

const [graphPath, outPath] = process.argv.slice(2)
const g = JSON.parse(readFileSync(graphPath, 'utf8'))
const gv = g.stats.governance, w = g.stats.worklist
if (!w) { console.error('This graph has no worklist (it was made with --public).'); process.exit(1) }
const n = x => x.toLocaleString('en')
const L = []
L.push(`# ${g.name}: governance worklist`, '', `Generated ${g.generated}${g.head ? ' at ' + g.head : ''}. This file names files in the repo. Do not post it.`, '')
L.push('## Where it stands', '',
  `| Number | Now | Meaning |`, `|---|---|---|`,
  `| Coverage | ${gv.coverage}% | source files a South or West document governs by name (${gv.coverageWithFolder}% counting folders) |`,
  `| Dark code | ${gv.darkCode}% | source files no South or West document points at |`,
  `| Dead context | ${gv.deadContext}% | East documents nothing refers to |`,
  `| Declared links | ${n(gv.declaredLinks)} | governs links written in a document's frontmatter. The rest are inferred |`, '')
L.push('Work the list in order. Step 1 is cheap and makes the numbers honest. Step 2 is where coverage is won.', '')

L.push(`## 1. Declare what you already have (${w.declare.length} documents)`, '',
  'Each of these South or West documents already names code. Read the document, keep only the paths it',
  'really binds, and paste the block into its frontmatter. Remove a path the document only mentions in passing.', '')
for (const d of w.declare) {
  L.push(`### \`${d.doc}\` (${d.compass})`, '', '```yaml', 'governs:', ...d.governs.map(p => `  - ${p}`), '```', d.more ? `\n${d.more} more inferred paths not shown.\n` : '')
}

L.push(`## 2. Light the darkest folders (${w.darkFolders.length} listed)`, '',
  'Each folder below has source files nothing governs. Write one South document (a pattern, a decision, a gotcha)',
  'or one West document (a runbook) that says what is true there, cite the records it came from, and give it a',
  '`governs:` line. One document per folder is enough to start.', '',
  '| Folder | Dark | Files | East records | Start from | Nearest South or West |', '|---|---|---|---|---|---|')
for (const f of w.darkFolders) L.push(`| \`${f.path}/\` | ${n(f.dark)} | ${n(f.files)} | ${n(f.eastRecords)} | ${f.promoteFrom.map(p => '`' + p + '`').join('<br>') || 'nothing written yet'} | ${f.nearest.map(p => '`' + p + '`').join('<br>') || 'none'} |`)
L.push('')

L.push(`## 3. Experience with no knowledge (${w.promote.length} files)`, '',
  'These dark files are the ones your session briefs and reviews keep coming back to. The lessons exist. They have',
  'not been written down as a rule. They are the best candidates for a gotcha or a pattern.', '',
  '| File | East records that name it |', '|---|---|', ...w.promote.map(p => `| \`${p.file}\` | ${p.eastRecords} |`), '')

L.push(`## 4. Too broad to count (${w.broad.length} documents)`, '',
  `These documents seem to govern more than ${w.broadAt} places each. That is an index or a backlog, not a rule. Do not`,
  'declare them. If one hides a real rule, move the rule into its own document and declare that.', '',
  '| Document | Places it names |', '|---|---|', ...w.broad.map(b => `| \`${b.doc}\` | ${n(b.targets)} |`), '')

L.push(`## 5. Dead East (${n(w.deadEast.total)} records)`, '',
  'Records of past work that nothing refers to. Nothing here needs fixing one by one. Before archiving a folder,',
  'check whether step 2 or 3 should draw on it.', '',
  '| Folder | Unreferenced records |', '|---|---|', ...Object.entries(w.deadEast.byFolder).map(([k, c]) => `| \`${k}/\` | ${n(c)} |`), '')

L.push('## Then', '', 'Run the brain again and compare the four numbers. Coverage should rise and dark code should fall.', '')
writeFileSync(outPath, L.join('\n'))
console.log(`worklist → ${outPath}`)
