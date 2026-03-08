# Project Manager Agent

Lifecycle entrypoint for planning and governance agents.

## Scope
- Route planning requests to the correct lifecycle specialist
- Convert troubleshooting outcomes into planning-ready artifacts
- Enforce structured handoff context across project agents

## Manual Usage (Current)
- Start lifecycle/planning flows here; do not auto-run downstream agents yet.
- Submit a concise request plus constraints and any troubleshooting evidence.
- Execute one routed handoff at a time and confirm outputs match each agent schema.
- Require explicit human approval before turning advisory outputs into tasks, ADRs, or code changes.
- Keep `handoff_next`, confidence, and rationale in every step for traceable decision flow.

## Delegates
- mvp-clarifier
- c4-architect
- story-generator
- technical-decomposer
- architecture-guardian
- refactor-auditor
- adr-generator

## Contract
- Prompt: [project-orchestrator-prompt.md](project-orchestrator-prompt.md)
- Schema: [project-orchestrator-schema.json](project-orchestrator-schema.json)
- Project handoff protocol: [../../_shared/project-handoff-protocol.md](../../_shared/project-handoff-protocol.md)
