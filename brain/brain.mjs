#!/usr/bin/env node
// c2-brain: draw a repository's brain. One command, one self-contained HTML file.
// usage: node brain.mjs [repo] [--out <file.html>] [--public] [--config <brain.config.json>] [--json <graph.json>] [--worklist <file.md>]
import { execFileSync } from 'node:child_process'
import { existsSync, mkdtempSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { dirname, join, resolve, basename } from 'node:path'
import { fileURLToPath } from 'node:url'

const here = dirname(fileURLToPath(import.meta.url))
const argv = process.argv.slice(2)
const opt = name => (argv.includes(name) ? argv[argv.indexOf(name) + 1] : null)
const valued = new Set(['--out', '--config', '--json', '--worklist'])
const repo = resolve(argv.find((a, i) => !a.startsWith('--') && !valued.has(argv[i - 1])) ?? '.')
if (!existsSync(join(repo, '.git'))) { console.error(`${repo} is not a git repository`); process.exit(1) }
if (!existsSync(join(here, 'node_modules', 'd3-force-3d'))) { console.error(`Run "npm install" in ${here} first (one small dependency).`); process.exit(1) }

const isPublic = argv.includes('--public')
const graph = resolve(opt('--json') ?? join(mkdtempSync(join(tmpdir(), 'c2-brain-')), 'graph.json'))
const out = resolve(opt('--out') ?? `${basename(repo)}-brain${isPublic ? '-public' : ''}.html`)
const run = (script, args) => execFileSync(process.execPath, [join(here, script), ...args], { stdio: 'inherit', maxBuffer: 1 << 30 })
run('extract.mjs', [repo, graph, ...(isPublic ? ['--public'] : []), ...(opt('--config') ? ['--config', resolve(opt('--config'))] : [])])
run('build.mjs', [graph, join(here, 'viewer.html'), out])
// the worklist names files, so a public run never writes one
const worklist = isPublic ? null : resolve(opt('--worklist') ?? out.replace(/\.html?$/, '') + '-worklist.md')
if (worklist) run('report.mjs', [graph, worklist])
console.log(`\nOpen ${out}`)
if (worklist) console.log(`What to do next: ${worklist}`)
