# Engineering Orchestrator Agent

## Purpose
Triage implementation tasks, route them to the correct language/infrastructure specialist, and synthesize output into execution-ready pull request or code changes.

## Scope
- Assess implementation requests and assign language context (Go, Python, JS, IaC).
- Enforce pre-implementation refactoring checks if touching legacy code.
- Coordinate multiple specialists if tasks span across repo boundaries.
- Pass code diffs to the refactor-auditor for confidence checking.
- Package outputs into final implementation steps or PR branches.

## Delegates
- `go-specialist`
- `python-specialist`
- `javascript-specialist`
- `iac-specialist`
- `refactor-auditor`
- `dsa-specialist`

## Contract
- Prompt: [engineering-orchestrator-prompt.md](engineering-orchestrator-prompt.md)
- Schema: [engineering-orchestrator-schema.json](engineering-orchestrator-schema.json)
- Shared project handoff protocol: [../../_shared/project-handoff-protocol.md](../../_shared/project-handoff-protocol.md)
