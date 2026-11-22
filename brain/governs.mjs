#!/usr/bin/env node
// The needle as a lookup: which documents govern this file? Most specific first.
// Hand the answer to an agent before it changes the file.
// usage: node governs.mjs <graph.json> <path/to/file-or-folder>
import { readFileSync } from 'node:fs'

const [graphPath, target] = process.argv.slice(2)
if (!graphPath || !target) { console.error('usage: node governs.mjs <graph.json> <path>'); process.exit(1) }
const g = JSON.parse(readFileSync(graphPath, 'utf8'))
if (g.public) { console.error('A public graph has no paths. Make one without --public.'); process.exit(1) }
const want = target.replace(/^\.?\//, '').replace(/\/$/, '')
const byPath = new Map(g.nodes.map(n => [n.path, n]))
const node = byPath.get(want)
if (!node) { console.error(`${want} is not in this graph. Run the brain again if the file is new.`); process.exit(1) }
// the file itself, then each folder above it: a folder link reaches the files directly in it, a deep one everything beneath
const chain = [[node.id, 0]]
for (let p = want, up = 1; p.includes('/'); up++) { p = p.slice(0, p.lastIndexOf('/')); const f = byPath.get(p); if (f) chain.push([f.id, up]) }
const depth = new Map(chain)
const rows = []
for (const l of g.links) {
  if (l.kind !== 'governs' || !depth.has(l.t)) continue
  const up = depth.get(l.t)
  if (up > 1 && !l.deep) continue
  rows.push({ doc: g.nodes[l.s], up, declared: !!l.declared })
}
rows.sort((a, b) => a.up - b.up || b.declared - a.declared || a.doc.path.localeCompare(b.doc.path))
if (!rows.length) { console.log(`Nothing governs ${want}. It is dark code.`); process.exit(0) }
for (const r of rows) console.log(`${r.doc.path}\t${r.up === 0 ? 'names it' : r.up === 1 ? 'names its folder' : 'covers the folder above'}\t${r.declared ? 'declared' : 'inferred'}\t${r.doc.compass}`)
