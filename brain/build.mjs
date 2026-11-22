#!/usr/bin/env node
// Lays the graph out in three dimensions (d3-force-3d, run once here so the page opens already
// formed and identical every time), resolves the theme, and inlines both into viewer.html.
// usage: node build.mjs <graph.json> <viewer.html> <out.html> [path-to-node_modules]
import { readFileSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'
import { pathToFileURL } from 'node:url'

const [graphPath, viewerPath, outPath, nm] = process.argv.slice(2)
// d3-force-3d comes from this folder's own install (npm install in brain/), or from a node_modules you name
const d3 = await (nm ? import(pathToFileURL(join(nm, 'd3-force-3d/src/index.js')).href) : import('d3-force-3d'))
const g = JSON.parse(readFileSync(graphPath, 'utf8'))

// ---- theme: the C² look (c2method.ai) unless the repo's brain.config.json carries its own ----
const C2 = {
  mode: 'light',
  light: { bg: '#FAFAFA', ink: '#0A0A0A', muted: '#737373', rule: '#E5E5E5', panel: 'rgba(250,250,250,.92)', accent: '#0A0A0A', onAccent: '#FAFAFA' },
  dark: { bg: '#0A0A0A', ink: '#FAFAFA', muted: '#8A8A8A', rule: '#2B2B2B', panel: 'rgba(10,10,10,.88)', accent: '#FAFAFA', onAccent: '#0A0A0A' },
  font: {
    sans: '"IBM Plex Sans", system-ui, -apple-system, "Segoe UI", sans-serif',
    display: '"IBM Plex Serif", Georgia, "Times New Roman", serif',
    mono: '"IBM Plex Mono", ui-monospace, "SF Mono", Menlo, monospace',
  },
  fontHref: 'https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@500&family=IBM+Plex+Sans:wght@400;600&family=IBM+Plex+Serif:wght@600&display=swap',
  // folder colours: the only colour on the page. Deep tones for paper, bright ones for a dark ground.
  palette: {
    light: ['#2F6FB5', '#C2453E', '#2F8F5E', '#D97A1F', '#7C5CC4', '#2E8080', '#A63D5A', '#B8902F', '#3D5AA8', '#3E8E7E', '#9A5CC4', '#E0922F', '#5E7E3E', '#7A6452', '#4E7E80', '#6B5847'],
    dark: ['#6FA8FF', '#FF7A70', '#5FD38D', '#FFA24C', '#9D8CFF', '#5BC0BE', '#F06FA4', '#E6CF5A', '#4FB3E8', '#7FD6C2', '#B98CF0', '#F28F6B', '#8FD14F', '#C9A27E', '#C0C8D4', '#A3B86C'],
  },
}
const t = g.theme ?? {}
g.ball = 0
g.theme = { ...C2, ...t, light: { ...C2.light, ...t.light }, dark: { ...C2.dark, ...t.dark }, font: { ...C2.font, ...t.font }, palette: { ...C2.palette, ...t.palette } }

// ---- layout: one sphere per app. The contextbase is the sphere in the middle and every app is
// its own sphere around it, sized by what it holds. Inside the contextbase each folder is a lobe. ----
const natural = (a, b) => a.localeCompare(b, undefined, { numeric: true })
const S = 26 // sphere radius = S * cbrt(nodes in it), so every sphere has the same density
const loose = n => n.side === 'code' && n.group === '(shared)' // folders that only hold apps: they float between the spheres
const clusterOf = n => (n.side === 'context' ? 'context' : 'code:' + n.group)
const clusters = new Map()
for (const n of g.nodes) { if (loose(n)) continue; const k = clusterOf(n); const c = clusters.get(k) ?? clusters.set(k, { key: k, side: n.side, name: n.side === 'context' ? 'Contextbase' : n.group, n: 0, x: 0, y: 0, z: 0 }).get(k); c.n++ }
for (const c of clusters.values()) c.r = S * Math.cbrt(c.n)
const centre = clusters.get('context')
// a solar system: the contextbase is the sun. Shared code (packages, workers, scripts, the backend)
// circles close in, and the apps are the planets on a wide orbit beyond it, in name order.
const isApp = new Set(g.apps ?? [])
const bodies = [...clusters.values()].filter(c => c !== centre)
const inner = bodies.filter(c => !isApp.has(c.name)).sort((a, b) => natural(a.name, b.name))
const outer = bodies.filter(c => isApp.has(c.name)).sort((a, b) => natural(a.name, b.name))
const Rc = centre ? centre.r : 0, orbits = []
const place = (list, minR, start) => { // spread the bodies round a ring, each given room in proportion to its size
  if (!list.length) return minR
  const big = Math.max(...list.map(c => c.r)), gap = Math.max(90, big * 0.55)
  const arc = list.reduce((a, c) => a + 2 * c.r + gap, 0), R = Math.max(minR + big, arc / (2 * Math.PI))
  let at = start
  for (const c of list) { const half = (2 * c.r + gap) / arc * Math.PI; at += half; c.x = Math.cos(at) * R; c.z = Math.sin(at) * R; c.y = 0; at += half }
  orbits.push(Math.round(R)); return R + big
}
if (centre || bodies.length > 1) { const edge = place(inner, Rc + Math.max(120, Rc * 0.35), -Math.PI / 2); place(outer, edge + Math.max(160, Rc * 0.45), -Math.PI / 2) }
const BALL = Math.max(...[...clusters.values()].map(c => Math.hypot(c.x, c.y, c.z) + c.r))
// a home for every node: its folder's lobe inside the contextbase, or the middle of its app
const lobe = new Map()
if (centre) { const groups = [...new Set(g.nodes.filter(n => n.side === 'context').map(n => n.group))].sort(natural)
  groups.forEach((name, i) => { const y = 1 - (2 * (i + 0.5)) / groups.length, q = Math.sqrt(1 - y * y), a = i * Math.PI * (3 - Math.sqrt(5)), R = Rc * 0.6
    lobe.set(name, { x: Math.cos(a) * q * R, y: y * R, z: Math.sin(a) * q * R }) }) }
const cOf = g.nodes.map(n => (loose(n) ? null : clusters.get(clusterOf(n))))
const homes = g.nodes.map((n, i) => (cOf[i] ? (n.side === 'context' ? lobe.get(n.group) : cOf[i]) : null))
for (let pass = 0; pass < 3; pass++) g.nodes.forEach((n, i) => { // a shared folder sits between the apps beneath it
  if (cOf[i]) return; const kids = g.links.filter(l => l.kind === 'tree' && l.s === i && homes[l.t]).map(l => homes[l.t])
  homes[i] = kids.length ? { x: kids.reduce((a, k) => a + k.x, 0) / kids.length * 0.7, y: kids.reduce((a, k) => a + k.y, 0) / kids.length * 0.7, z: kids.reduce((a, k) => a + k.z, 0) / kids.length * 0.7 } : { x: 0, y: 0, z: 0 } })
let seed = 7
const rnd = () => ((seed = (seed * 16807) % 2147483647) / 2147483647) - 0.5
const nodes = g.nodes.map((n, i) => { const h = homes[i] ?? { x: 0, y: 0, z: 0 }, j = cOf[i] ? cOf[i].r * 0.9 : 40; return { id: n.id, h, c: cOf[i], x: h.x + rnd() * j, y: h.y + rnd() * j, z: h.z + rnd() * j } })
const links = g.links.map(l => ({ source: l.s, target: l.t, tree: l.kind === 'tree', bridge: cOf[l.s] !== cOf[l.t] }))
const pull = 0.045
// inside its sphere the best-connected files sink toward the middle and the loose ends settle near
// the surface: rank by connections, then place by the cube root of the rank so the volume fills evenly
const deg = new Array(g.nodes.length).fill(0)
for (const l of g.links) if (l.kind !== 'tree') { deg[l.s]++; deg[l.t]++ }
const depth = new Array(deg.length).fill(1), members = new Map()
g.nodes.forEach((n, i) => { if (cOf[i]) (members.get(cOf[i]) ?? members.set(cOf[i], []).get(cOf[i])).push(i) })
for (const ids of members.values()) ids.sort((a, b) => deg[b] - deg[a] || a - b).forEach((id, rank) => { depth[id] = Math.cbrt((rank + 1) / ids.length) })
function contain(alpha) {
  for (const n of nodes) { const c = n.c; if (!c) continue
    const dx = n.x - c.x, dy = n.y - c.y, dz = n.z - c.z, r = Math.hypot(dx, dy, dz) || 1, k = (c.r * depth[n.id] - r) / r * 0.3 * alpha
    n.vx += dx * k; n.vy += dy * k; n.vz += dz * k
    if (r > c.r) { const q = c.r / r; n.x = c.x + dx * q; n.y = c.y + dy * q; n.z = c.z + dz * q }
  }
}
const maxR = Math.max(...[...clusters.values()].map(c => c.r))
const sim = d3.forceSimulation(nodes, 3)
  // only links inside a sphere pull. A link between two spheres is drawn, never felt, or thousands of
  // them would drag every app into the contextbase
  .force('link', d3.forceLink(links.filter(l => !l.bridge)).id(d => d.id).distance(l => (l.tree ? 16 : 34)))
  .force('charge', d3.forceManyBody().strength(-16).distanceMax(maxR * 0.6).theta(1.2))
  .force('x', d3.forceX(d => d.h.x).strength(pull))
  .force('y', d3.forceY(d => d.h.y).strength(pull))
  .force('z', d3.forceZ(d => d.h.z).strength(pull))
  .force('contain', contain)
  .stop()
const t0 = Date.now()
for (let i = 0; i < 220; i++) sim.tick()
contain(0)
g.nodes.forEach((n, i) => { n.x = Math.round(nodes[i].x); n.y = Math.round(nodes[i].y); n.z = Math.round(nodes[i].z) })
g.ball = Math.round(BALL)
g.orbits = orbits
// the spheres themselves, so the page can name them
g.spheres = [...clusters.values()].filter(c => c.name[0] !== '(' || c.name === '(other)').map(c => ({ name: c.name === '(other)' ? 'Other' : c.name, app: isApp.has(c.name), side: c.side, n: c.n, x: Math.round(c.x), y: Math.round(c.y), z: Math.round(c.z), r: Math.round(c.r) }))
const html = readFileSync(viewerPath, 'utf8').replace('/*__GRAPH__*/null', () => JSON.stringify(g).replace(/</g, '\\u003c'))
writeFileSync(outPath, html)
console.log(`laid out ${nodes.length} nodes in ${Date.now() - t0}ms → ${outPath} (${(html.length / 1e6).toFixed(1)} MB)`)
