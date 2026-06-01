---
id: [generate]
title: "Deployment Checklist — [app/service]"
type: deployment-checklist
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [operations, deployment]
---

# Deployment Checklist — [app/service]

> How this project ships. Keep it current — a stale deploy doc is worse than
> none. The agent reads this before it touches anything deploy-related.

## How we deploy

[One line: e.g., "push to `main` → CI builds → deploys to <host>".]

## Pre-flight

- [ ] Tests pass
- [ ] Migrations applied (if any)
- [ ] Env vars present in the target environment
- [ ] [project-specific check]

## Steps

1. [Step]
2. [Step]

## Rollback

[How to undo a bad deploy, fast.]

## Gotchas

[Anything that's bitten us before — link to `03-knowledge/gotchas/`.]
