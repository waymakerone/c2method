#!/usr/bin/env node
// Repo Brain extractor (prototype v2). Reads a repo and emits one graph of its two halves:
//   context side = the contextbase (docs + the Router)      code side = the codebase
// nodes = files and the folders that hold them; links = the folder tree plus every reference
// one file makes to another. Structure only: no file bodies leave the repo.
//
// usage: node extract.mjs <repo> <out.json> [--public] [--config <brain.config.json>]
import { execFileSync } from 'node:child_process'
import { readFileSync, writeFileSync, existsSync, statSync } from 'node:fs'
import { join, basename, posix } from 'node:path'

const argv = process.argv.slice(2)
const [repo, out] = argv
const PUBLIC = argv.includes('--public')
const cfgArg = argv.includes('--config') ? argv[argv.indexOf('--config') + 1] : join(repo, 'brain.config.json')

// ---- config: everything a repo may want to vary (brain.config.json overrides any key) ----
const DEFAULTS = {
  name: basename(repo),
  context: ['docs'],                 // contextbase roots; groups = whatever folders exist under them
  router: ['CLAUDE.md', 'AGENTS.md'],
  codeExtensions: ['ts', 'tsx', 'js', 'jsx', 'mjs', 'cjs', 'swift', 'rs', 'py', 'go', 'rb', 'java', 'kt', 'cs', 'php',
    'sql', 'sh', 'css', 'scss', 'html', 'vue', 'svelte', 'md', 'mdx'],
  exclude: ['node_modules/', 'dist/', 'build/', 'out/', '.next/', '.wrangler/', 'vendor/'],
  // first matching rule names a context document's kind
  kinds: [
    ['router', '^(CLAUDE|AGENTS)\\.md$'],
    ['session-brief', '/sessions?/|session-brief'],
    ['prompt-brief', '/prompts/'],
    ['prd', '/product-requirements/|-prd(-v[\\d.]+)?\\.md$'],
    ['adr', '/decisions/'],
    ['gotcha', '/gotchas/'],
    ['pattern', '/patterns/'],
    ['runbook', '/runbooks/|/RUN-'],
    ['review', '/reviews?/|/audit/'],
    ['task', '/tasks/'],
    ['template', 'templates?/'],
  ],
  tagKeys: ['tags', 'area', 'category', 'topic'],
  refKeys: ['prd', 'prd_id', 'pb', 'depends_on', 'related', 'supersedes', 'superseded_by', 'build'],
  // The Context Compass: which kind of memory a document is. Archived paths are East; then the
  // kind decides; then the first matching path rule; South if nothing matches.
  archivePaths: '(^|/)(\\d+-)?archived?/|/completed/|/superseded',
  compassKinds: { 'session-brief': 'east', review: 'east', prd: 'south', adr: 'south', pattern: 'south', gotcha: 'south',
    runbook: 'west', router: 'west', template: 'west', 'prompt-brief': 'north', task: 'north' },
  compassPaths: [['east', '/sessions?/'], ['north', 'working/'], ['west', 'operations/|/skills?/|templates?/']],
  doneStatuses: ['done', 'completed', 'complete', 'archived', 'superseded', 'shipped', 'closed', 'merged'],
  apps: null,                         // app folders, e.g. ["apps/*", "services/api"]; null looks in appFolders, then for manifests
  appFolders: ['apps', 'native', 'services', 'clients'], // folders whose direct children are apps
  minAppFiles: 12,                    // an app smaller than this folds into its top-level folder
  minGroupFiles: 20,                  // shared code smaller than this joins "Other"
  theme: null,                        // see build.mjs for the shape and the default look
}
const user = existsSync(cfgArg) ? JSON.parse(readFileSync(cfgArg, 'utf8')) : {}
// a repo's own kinds are tried first and the defaults after, so a config only lists what it adds
const cfg = { ...DEFAULTS, ...user, kinds: [...(user.kinds ?? []), ...DEFAULTS.kinds], compassKinds: { ...DEFAULTS.compassKinds, ...user.compassKinds } }
const kindRules = cfg.kinds.map(([k, re]) => [k, new RegExp(re, 'i')])
const compassRules = cfg.compassPaths.map(([d, re]) => [d, new RegExp(re, 'i')])
const archived = new RegExp(cfg.archivePaths, 'i')
const declaredGlobs = new Map() // doc id -> the globs in its `governs:` frontmatter
const LANG = { ts: 'typescript', tsx: 'typescript', js: 'javascript', jsx: 'javascript', mjs: 'javascript', cjs: 'javascript',
  md: 'content', mdx: 'content', sh: 'shell', css: 'styles', scss: 'styles', rs: 'rust', py: 'python', kt: 'kotlin', rb: 'ruby' }

const git = (...a) => execFileSync('git', ['-C', repo, ...a], { encoding: 'utf8', maxBuffer: 1 << 29 })
const dir = p => (p.includes('/') ? p.slice(0, p.lastIndexOf('/')) : '')
const ext = p => (/\.([A-Za-z0-9]+)$/.exec(p)?.[1] ?? '').toLowerCase()

// ---- which files are in the brain ----
const inContext = f => cfg.context.some(r => f.startsWith(r + '/'))
const files = git('ls-files', '-z').split('\0').filter(f => {
  if (!f || cfg.exclude.some(p => f.startsWith(p) || f.includes('/' + p))) return false
  if (cfg.router.includes(f)) return true
  if (inContext(f)) return /\.mdx?$/.test(f)
  return cfg.codeExtensions.includes(ext(f))
})

// first-added date per path, one git pass. A rename is followed back to the original file, so
// moving a folder does not make everything in it look new.
const added = new Map()
{
  const born = new Map(), from = new Map()
  let d = null
  for (const line of git('log', '-M', '--diff-filter=AR', '--name-status', '--format=@%as').split('\n')) {
    if (line.startsWith('@')) { d = line.slice(1); continue }
    const [st, a, b] = line.split('\t')
    if (!st || !d) continue
    if (st[0] === 'A') born.set(a, d)            // log is newest-first, so the last write wins = earliest
    else if (st[0] === 'R' && !from.has(b)) from.set(b, [a, d])
  }
  for (const f of new Set([...born.keys(), ...from.keys()])) {
    let p = f, date = born.get(f) ?? null
    for (let hop = 0; hop < 20 && from.has(p); hop++) { const [old, when] = from.get(p); if (!date || when < date) date = when; p = old; if (born.has(p) && born.get(p) < date) date = born.get(p) }
    if (date) added.set(f, date)
  }
}

// ---- parse helpers ----
function frontmatter(src) {
  if (!src.startsWith('---\n')) return [{}, src]
  const end = src.indexOf('\n---', 4)
  if (end < 0) return [{}, src]
  const fm = {}
  let key = null
  for (const line of src.slice(4, end).split('\n')) {
    const m = /^([A-Za-z_][\w-]*):\s*(.*)$/.exec(line)
    if (m) {
      key = m[1]
      const v = m[2].trim()
      if (v.startsWith('[')) fm[key] = v.replace(/^\[|\]$/g, '').split(',').map(s => s.trim().replace(/^["']|["']$/g, '')).filter(Boolean)
      else fm[key] = v.replace(/^["']|["']$/g, '')
    } else if (key && /^\s+-\s+/.test(line)) {
      const item = line.replace(/^\s+-\s+/, '').trim().replace(/^["']|["']$/g, '')
      fm[key] = Array.isArray(fm[key]) ? [...fm[key], item] : [item]
    }
  }
  return [fm, src.slice(end + 4)]
}
const list = v => (v == null || v === '' ? [] : Array.isArray(v) ? v : [v])
const norm = t => String(t).toLowerCase().trim().replace(/\s+/g, '-')
// ---- apps: each app in the repo is its own sphere. By default an app is a folder directly inside an
// app container (apps/, native/, services/, clients/). A repo with no such container falls back to
// folders that carry their own manifest. `apps` in the config names them outright (a path, or a path
// with * for one folder level). Packages, workers, scripts and the like are shared code, not apps. ----
const MANIFESTS = new Set(['package.json', 'Cargo.toml', 'pyproject.toml', 'go.mod', 'Package.swift', 'deno.json', 'deno.jsonc',
  'pubspec.yaml', 'wrangler.toml', 'Gemfile', 'pom.xml', 'build.gradle', 'build.gradle.kts', 'composer.json'])
const codeFiles = files.filter(f => !(cfg.router.includes(f) || inContext(f)))
const appRoots = (() => {
  const roots = new Set()
  if (cfg.apps?.length) {
    const res = cfg.apps.map(a => new RegExp('^' + a.replace(/\/$/, '').split('*').map(x => x.replace(/[.+?^${}()|[\]\\]/g, '\\$&')).join('[^/]+') + '(?=/)'))
    for (const f of codeFiles) for (const re of res) { const m = re.exec(f); if (m) { roots.add(m[0]); break } }
  } else {
    for (const f of codeFiles) { const seg = f.split('/'); if (seg.length > 2 && cfg.appFolders.includes(seg[0])) roots.add(seg[0] + '/' + seg[1]) }
    if (!roots.size) for (const f of git('ls-files', '-z').split('\0')) { const i = f.lastIndexOf('/')
      if (i > 0 && MANIFESTS.has(f.slice(i + 1)) && !cfg.exclude.some(p => f.startsWith(p) || f.includes('/' + p)) && !inContext(f)) roots.add(f.slice(0, i)) }
  }
  // the shallowest wins; an app too small to read as a sphere folds back into its top-level folder
  const top = [...roots].filter(r => ![...roots].some(o => o !== r && r.startsWith(o + '/')))
  const size = new Map(top.map(r => [r, 0]))
  for (const f of codeFiles) { const r = top.find(r => f.startsWith(r + '/')); if (r) size.set(r, size.get(r) + 1) }
  return top.filter(r => size.get(r) >= cfg.minAppFiles)
})()
const appOf = p => appRoots.find(r => p === r || p.startsWith(r + '/'))
const looseTops = new Set(codeFiles.filter(f => !appOf(f) && f.includes('/')).map(f => f.split('/')[0]))
const groupOf = (p, side) => {
  if (side === 'code') {
    const q = p.replace(/\/$/, ''), app = appOf(q)
    if (app) return app
    // a folder that only holds apps belongs to none of them
    if (p.endsWith('/') && appRoots.some(r => r.startsWith(q + '/')) && !(looseTops.has(q))) return '(shared)'
    return p.includes('/') ? p.split('/')[0] : '(root)'
  }
  if (cfg.router.includes(p)) return '(router)'
  const root = cfg.context.find(r => p === r || p.startsWith(r + '/'))
  const rest = p.slice(root.length + 1).split('/')
  return p === root || rest.length < 2 && !p.endsWith('/') && rest[0].includes('.') ? '(root)' : rest[0]
}

// ---- file nodes ----
const nodes = [], bodies = [], byPath = new Map(), prdIds = new Map()
for (const f of files) {
  let src = ''
  try { if (statSync(join(repo, f)).size < 1_500_000) src = readFileSync(join(repo, f), 'utf8') } catch { continue }
  const side = cfg.router.includes(f) || inContext(f) ? 'context' : 'code'
  const fileDate = /(20\d\d)-?(\d\d)-?(\d\d)/.exec(basename(f)) ?? /^(\d\d)(\d\d)(\d\d)-/.exec(basename(f))
  let date = added.get(f) ?? null
  if (fileDate) {
    const d = `${fileDate[1].length === 2 ? '20' + fileDate[1] : fileDate[1]}-${fileDate[2]}-${fileDate[3]}`
    if (!Number.isNaN(Date.parse(d)) && d > '2015' && (!date || d < date)) date = d
  }
  const n = { id: nodes.length, side, type: 'file', path: f, group: groupOf(f, side), kind: 'doc', title: '', status: '', tags: [], date, words: 0 }
  if (side === 'context') {
    const [fm, body] = frontmatter(src)
    const h1 = /^#\s+(.+)$/m.exec(body)
    n.title = (fm.title || h1?.[1] || basename(f).replace(/\.mdx?$/, '')).replace(/[*_`]/g, '').slice(0, 110)
    n.tags = [...new Set(cfg.tagKeys.flatMap(k => list(fm[k])).map(norm).filter(t => t && t.length < 40 && !/^tag\d$/.test(t)))]
    n.kind = kindRules.find(([, re]) => re.test(f))?.[0] ?? (fm.type && norm(fm.type).length < 24 ? norm(fm.type) : 'doc')
    n.status = fm.status ? norm(fm.status).slice(0, 24) : ''
    n.words = body.split(/\s+/).length
    if (fm.prd_id) prdIds.set(norm(fm.prd_id), n.id)
    // North is what is in flight: a brief or task that is finished has become East
    let c = archived.test(f) ? 'east' : cfg.compassKinds[n.kind] ?? compassRules.find(([, re]) => re.test(f))?.[0] ?? 'south'
    if (c === 'north' && cfg.doneStatuses.includes(n.status)) c = 'east'
    n.compass = c
    if (list(fm.governs).length) declaredGlobs.set(n.id, list(fm.governs).map(String))
    bodies.push([fm, body])
  } else {
    n.title = f.split('/').slice(-2).join('/')
    n.kind = LANG[ext(f)] ?? ext(f)
    n.words = src ? src.split('\n').length : 0 // lines, for code
    bodies.push([{}, src])
  }
  byPath.set(f, n.id)
  nodes.push(n)
}
const nFiles = nodes.length

// ---- folder nodes + the tree ----
const edges = new Map() // "a>b" -> kind
const add = (a, b, kind) => { if (a !== b && b != null) { const k = a + '>' + b; if (!edges.has(k)) edges.set(k, kind) } }
const dirId = new Map()
function folder(p, side) {
  if (dirId.has(p)) return dirId.get(p)
  const id = nodes.length
  nodes.push({ id, side, type: 'folder', path: p, group: groupOf(p + '/', side), kind: 'folder', title: p.split('/').slice(-2).join('/') + '/', status: '', tags: [], date: null, words: 0 })
  dirId.set(p, id)
  if (dir(p)) add(folder(dir(p), side), id, 'tree')
  return id
}
for (let i = 0; i < nFiles; i++) { const d = dir(nodes[i].path); if (d) add(folder(d, nodes[i].side), i, 'tree') }
// a folder is as old as the first thing put in it
for (let i = 0; i < nFiles; i++) {
  const n = nodes[i]
  for (let d = dir(n.path); d && n.date; d = dir(d)) { const f = nodes[dirId.get(d)]; if (!f.date || n.date < f.date) f.date = n.date }
}

// ---- references ----
const byBase = new Map()
for (let i = 0; i < nFiles; i++) if (nodes[i].side === 'context') {
  const b = basename(nodes[i].path).replace(/\.mdx?$/, '').toLowerCase()
  byBase.set(b, [...(byBase.get(b) ?? []), i])
}
const adrByNum = new Map()
for (let i = 0; i < nFiles; i++) { const m = /\/decisions\/(?:adr-)?0*(\d+)-/i.exec(nodes[i].path); if (m) adrByNum.set(Number(m[1]), i) }

function resolve(from, tok, allowBase) {
  tok = tok.replace(/[#?].*$/, '').replace(/^\.\//, '').replace(/[.,:;)]+$/, '')
  if (!tok) return null
  const direct = tok.replace(/^\//, '')
  for (const c of [direct, posix.normalize(posix.join(dir(from), tok))]) if (byPath.has(c)) return byPath.get(c)
  if (allowBase || /\.mdx?$/.test(tok)) {
    const b = byBase.get(basename(tok).replace(/\.mdx?$/, '').toLowerCase())
    if (b?.length === 1) return b[0] // an ambiguous basename is not a link
  }
  // a path into the codebase that names no file: the deepest folder that exists
  for (let p = direct.replace(/\/$/, ''); p.split('/').length >= 2; p = dir(p)) {
    const id = dirId.get(p)
    if (id != null && nodes[id].side === 'code') return id
  }
  return null
}
const TOKEN = /(?<![\w/.@-])\/?((?:[\w@.{}\[\]-]+\/)+[\w@.{}\[\]-]*|[\w.-]+\.mdx?)/g
let unresolved = 0
for (let i = 0; i < nFiles; i++) {
  const [fm, body] = bodies[i], n = nodes[i], from = n.path
  if (n.side === 'code') { // code that cites its context
    for (const m of body.matchAll(/\bdocs\/[\w./-]+\.mdx?/g)) { const t = resolve(from, m[0]); if (t != null) add(i, t, 'mention') }
    continue
  }
  for (const m of body.matchAll(/\]\((?!https?:|mailto:|#)([^)\s]+)\)/g)) { const t = resolve(from, m[1]); t == null ? unresolved++ : add(i, t, 'link') }
  for (const m of body.matchAll(/\[\[([^\]|#]+)/g)) { const t = resolve(from, m[1].trim(), true); t == null ? unresolved++ : add(i, t, 'link') }
  for (const m of body.matchAll(TOKEN)) { const t = resolve(from, m[1]); if (t != null) add(i, t, nodes[t].side === 'code' ? 'code' : 'mention') }
  for (const m of body.matchAll(/\bADR[- ]0*(\d{1,3})\b/g)) add(i, adrByNum.get(Number(m[1])), 'adr')
  for (const k of cfg.refKeys) for (const v of list(fm[k])) {
    const t = prdIds.get(norm(v)) ?? resolve(from, String(v), true)
    if (t != null && nodes[t].side === 'context') add(i, t, 'meta')
  }
}

// code that belongs to no app and is too small to be a sphere of its own gathers in one "(other)" sphere
{ const size = new Map(); for (let i = 0; i < nFiles; i++) if (nodes[i].side === 'code') size.set(nodes[i].group, (size.get(nodes[i].group) ?? 0) + 1)
  for (const n of nodes) if (n.side === 'code' && n.group !== '(shared)' && !appRoots.includes(n.group) && (size.get(n.group) ?? 0) < cfg.minGroupFiles) n.group = '(other)' }

// ---- governance: the needle. A South or West document governs the code it points at. ----
// Declared (`governs:` frontmatter, paths or globs) wins; until a document declares, naming a code
// file or folder is taken as governing it. A link to a folder covers the files directly in it;
// a declared `dir/**` covers the whole subtree (deep).
const durable = n => n.compass === 'south' || n.compass === 'west'
const flags = new Map() // "a>b" -> { declared, deep }
for (const [k, kind] of edges) if (kind === 'code' && durable(nodes[+k.split('>')[0]])) edges.set(k, 'governs')
const globRe = g => new RegExp('^' + g.split('**').map(p => p.split('*').map(x => x.replace(/[.+?^${}()|[\]\\]/g, '\\$&')).join('[^/]*')).join('.*') + '$')
let declaredUnmatched = 0
for (const [id, globs] of declaredGlobs) for (let g of globs) {
  g = g.replace(/^\.?\//, '')
  const bind = (t, deep) => { if (t === id) return; const k = id + '>' + t; edges.set(k, 'governs'); flags.set(k, { declared: true, ...(deep && { deep: true }) }) }
  const base = g.replace(/\/\*\*$/, '').replace(/\/$/, '')
  if (g.endsWith('/**') && dirId.has(base)) bind(dirId.get(base), true)
  else if (byPath.has(g)) bind(byPath.get(g))
  else if (dirId.has(base) && !g.includes('*')) bind(dirId.get(base))
  else { const re = globRe(g); let hit = 0; for (let i = 0; i < nFiles; i++) if (nodes[i].side === 'code' && re.test(nodes[i].path)) { bind(i); hit++ } if (!hit) declaredUnmatched++ }
}
const parentOf = new Map()
for (const [k, kind] of edges) if (kind === 'tree') { const [a, b] = k.split('>').map(Number); parentOf.set(b, a) }
const gFile = new Set(), gFolder = new Set(), gDeep = new Set()
for (const [k, kind] of edges) if (kind === 'governs') {
  const t = +k.split('>')[1]
  if (nodes[t].type === 'file') gFile.add(t); else (flags.get(k)?.deep ? gDeep : gFolder).add(t)
}
for (let i = 0; i < nFiles; i++) { const n = nodes[i]; if (n.side !== 'code') continue
  let gov = gFile.has(i) ? 'direct' : gFolder.has(parentOf.get(i)) ? 'folder' : 'dark'
  for (let p = parentOf.get(i); gov === 'dark' && p != null; p = parentOf.get(p)) if (gDeep.has(p)) gov = 'folder'
  n.gov = gov
}

// ---- public mode: keep the shape, drop every name that came from a file ----
if (PUBLIC) for (const n of nodes) { n.title = n.kind; n.path = ''; n.tags = [] }

const links = [...edges].map(([k, kind]) => { const [s, t] = k.split('>').map(Number); return { s, t, kind, ...flags.get(k) } })
const count = (arr, f) => Object.fromEntries([...arr.reduce((m, x) => m.set(f(x), (m.get(f(x)) ?? 0) + 1), new Map())].sort((a, b) => b[1] - a[1]))
const fileNodes = nodes.slice(0, nFiles), refs = links.filter(l => l.kind !== 'tree')
const deg = new Array(nodes.length).fill(0)
for (const l of refs) { deg[l.s]++; deg[l.t]++ }
// ---- the four numbers ----
const src = fileNodes.filter(n => n.side === 'code' && n.kind !== 'content') // source files; prose shipped with the code is not "code"
const ctxDocs = fileNodes.filter(n => n.side === 'context')
const referenced = new Set(refs.map(l => l.t))
const east = ctxDocs.filter(n => n.compass === 'east'), sw = ctxDocs.filter(durable)
const eastIds = new Set(east.map(n => n.id))
const citesEast = new Set(refs.filter(l => durable(nodes[l.s]) && eastIds.has(l.t)).map(l => l.s))
const since = new Date(Date.now() - 90 * 864e5).toISOString().slice(0, 10)
const pct = (a, b) => (b ? Math.round((1000 * a) / b) / 10 : 0)
const governance = {
  sourceFiles: src.length,
  coverage: pct(src.filter(n => n.gov === 'direct').length, src.length),          // % governed by name
  coverageWithFolder: pct(src.filter(n => n.gov !== 'dark').length, src.length),   // % governed by name or by folder
  darkCode: pct(src.filter(n => n.gov === 'dark').length, src.length),
  deadContext: pct(east.filter(n => !referenced.has(n.id)).length, east.length),   // % of East nothing refers to
  // provisional: there is no agreed definition of promotion yet (Context Governance v1, open question 2)
  compounding: { southWestCitingEast: pct(citesEast.size, sw.length), newSouthWest90d: sw.filter(n => n.date >= since).length, newEast90d: east.filter(n => n.date >= since).length },
  declaredLinks: [...flags.values()].length, declaredUnmatched,
  compass: count(ctxDocs, n => n.compass),
}
// ---- the worklist: what to do about the numbers. It names files, so public mode never carries it. ----
const BROAD = 40 // a document that seems to govern more than this is an index, not a rule
const worklist = PUBLIC ? null : (() => {
  const top3 = p => p.split('/').slice(0, 3).join('/')
  const home = n => (n.type === 'folder' ? top3(n.path) : top3(n.path.split('/').slice(0, -1).join('/')) || '(root)')
  const names = (m, k = 3) => [...m].sort((a, b) => b[1] - a[1]).slice(0, k).map(([i]) => nodes[i].path)
  // 1. documents that already describe code and have not declared it: ready-made governs: blocks
  const byDoc = new Map()
  for (const l of links) if (l.kind === 'governs' && !l.declared) (byDoc.get(l.s) ?? byDoc.set(l.s, []).get(l.s)).push(l.t)
  const target = j => (nodes[j].type === 'folder' ? nodes[j].path + '/' : nodes[j].path)
  const declare = [...byDoc].filter(([, t]) => t.length <= BROAD).sort((a, b) => deg[b[0]] - deg[a[0]]).slice(0, 25)
    .map(([i, t]) => ({ id: i, doc: nodes[i].path, compass: nodes[i].compass, governs: t.slice(0, 15).map(target), more: Math.max(0, t.length - 15) }))
  const broad = [...byDoc].filter(([, t]) => t.length > BROAD).sort((a, b) => b[1].length - a[1].length).slice(0, 10)
    .map(([i, t]) => ({ id: i, doc: nodes[i].path, targets: t.length }))
  // 2. the darkest folders, with the records of past work that could be turned into a rule for them
  const folders = new Map()
  for (const n of src) { const k = home(n); const f = folders.get(k) ?? folders.set(k, { path: k, files: 0, dark: 0, east: new Map(), near: new Map() }).get(k); f.files++; if (n.gov === 'dark') f.dark++ }
  for (const l of refs) { const s = nodes[l.s], t = nodes[l.t]; if (s.side !== 'context' || t.side !== 'code') continue
    const f = folders.get(home(t)), m = f && (durable(s) ? f.near : s.compass === 'east' ? f.east : null); if (m) m.set(l.s, (m.get(l.s) ?? 0) + 1) }
  const darkFolders = [...folders.values()].filter(f => f.dark).sort((a, b) => b.dark - a.dark).slice(0, 15)
    .map(f => ({ id: dirId.get(f.path) ?? null, path: f.path, files: f.files, dark: f.dark, eastRecords: f.east.size, promoteFrom: names(f.east), nearest: names(f.near) }))
  // 3. experience with no knowledge: dark files that the records of past work keep coming back to
  const hits = new Map()
  for (const l of refs) if (eastIds.has(l.s) && nodes[l.t].type === 'file' && nodes[l.t].gov === 'dark') hits.set(l.t, (hits.get(l.t) ?? 0) + 1)
  const promote = [...hits].sort((a, b) => b[1] - a[1]).slice(0, 20).map(([i, c]) => ({ id: i, file: nodes[i].path, eastRecords: c }))
  // 4. East that nothing refers to, by folder
  const dead = east.filter(n => !referenced.has(n.id))
  return { broadAt: BROAD, declare, broad, darkFolders, promote, deadEast: { total: dead.length, byFolder: Object.fromEntries(Object.entries(count(dead, n => top3(n.path.split('/').slice(0, -1).join('/')))).slice(0, 8)) } }
})()
const stats = {
  governance,
  ...(worklist && { worklist }),
  docs: fileNodes.filter(n => n.side === 'context').length,
  code: fileNodes.filter(n => n.side === 'code').length,
  folders: nodes.length - nFiles,
  links: refs.length,
  bridges: refs.filter(l => nodes[l.s].side !== nodes[l.t].side).length,
  words: fileNodes.reduce((a, n) => a + (n.side === 'context' ? n.words : 0), 0),
  lines: fileNodes.reduce((a, n) => a + (n.side === 'code' ? n.words : 0), 0),
  unresolved,
  codeNeverMentioned: fileNodes.filter(n => n.side === 'code' && deg[n.id] === 0).length,
  byEdge: count(links, l => l.kind),
}
writeFileSync(out, JSON.stringify({ name: cfg.name, generated: new Date().toISOString().slice(0, 10), public: PUBLIC, apps: appRoots.slice().sort(), head: git('rev-parse', '--short', 'HEAD').trim(), theme: cfg.theme, stats, nodes, links }))
console.log(JSON.stringify({ ...stats, worklist: undefined }, null, 1))
if (!PUBLIC) {
  console.log('--- context groups', JSON.stringify(count(fileNodes.filter(n => n.side === 'context'), n => n.group)))
  console.log('--- code groups', JSON.stringify(count(fileNodes.filter(n => n.side === 'code'), n => n.group)))
  console.log('--- most connected'); for (const [d, i] of deg.map((d, i) => [d, i]).sort((a, b) => b[0] - a[0]).slice(0, 14)) console.log(String(d).padStart(5), nodes[i].type === 'folder' ? nodes[i].path + '/' : nodes[i].path)
}
