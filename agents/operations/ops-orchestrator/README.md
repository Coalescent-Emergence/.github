# General Troubleshooter Agent

Top-level troubleshooting entrypoint for the organization.

## Responsibilities
- Accept first-pass incident context
- Identify dominant domain quickly
- Delegate to software or infrastructure architect
- Preserve evidence chain through standardized handoff objects
- Recommend lifecycle handoff only when design/process change is needed

## Manual Usage (Current)
- Start all troubleshooting here; do not auto-run chained agents.
- Provide symptom, environment, affected components, recent changes, and any known evidence.
- Use the routed `handoff_input` with the selected child agent and continue one hop at a time.
- After each hop, manually validate suggested commands and update evidence before escalating/rerouting.
- Escalate to lifecycle only when operational diagnosis is complete and a planning/design gap remains.

### Findable Fast-Validation Path
- For app image hotfixes, run the fail-fast local validation ladder before cluster redeploy.
- Source of truth: [em-infra/docs/guides/troubleshooting-runbook.md](../../../../../em-infra/docs/guides/troubleshooting-runbook.md) → "Fast Validation Before Push/Deploy (Fail Fast)".
- If local container behavior is the main question, prefer routing through infra-architect to docker-troubleshooter before k8s rollout.

## Agent Hierarchy

ops-orchestrator  
├── software-architect  
│   ├── go-specialist  
│   ├── python-specialist  
│   ├── javascript-specialist  
│   ├── iac-specialist  
│   ├── shell-specialist  
│   └── dsa-specialist  
└── infra-architect  
    ├── k8s-troubleshooter  
    ├── talos-troubleshooter  
    └── docker-troubleshooter

Lifecycle bridge (advisory only): mvp-clarifier, story-generator, technical-decomposer, architecture-guardian, adr-generator, refactor-auditor.

## Contract
- Prompt: [ops-orchestrator-prompt.md](ops-orchestrator-prompt.md)
- Schema: [ops-orchestrator-schema.json](ops-orchestrator-schema.json)
- Shared handoff protocol: [../../_shared/handoff-protocol.md](../../_shared/handoff-protocol.md)
