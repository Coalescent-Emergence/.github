# Project Agent Handoff Protocol

## Purpose
Define a modular handoff contract for product/planning/architecture agents so project workflows can route cleanly from troubleshooting outcomes into execution planning.

## Project Hierarchy
```text
project-orchestrator
├── mvp-clarifier
├── c4-architect
├── story-generator
├── technical-decomposer
├── architecture-guardian
├── refactor-auditor
└── adr-generator
```

## Bridge from Troubleshooting
When software/infra troubleshooting identifies a non-operational gap (scope ambiguity, architectural decision, implementation sequencing, compliance review), route to `project-orchestrator` first.

## Handoff Input Contract
```json
{
  "from_agent": "software-architect",
  "to_agent": "project-orchestrator",
  "reason": "Root cause requires design/task decomposition",
  "priority": "high",
  "context": {
    "problem_summary": "...",
    "affected_repos": ["Kerrigan", "em-infra"],
    "constraints": ["SOC2", "HIPAA"],
    "evidence_gathered": [
      { "source": "k8s logs", "finding": "service healthy but behavior wrong" }
    ],
    "recommended_outcome": "Create implementation-ready task plan"
  }
}
```

## Standard Routing Output
Every project agent returns:
```json
{
  "handoff_next": {
    "needed": true,
    "target_agent": "technical-decomposer",
    "reason": "Stories approved; task breakdown required"
  },
  "escalation": {
    "needed": false,
    "direction": "none",
    "target_agent": "",
    "reason": "",
    "context_to_pass": {}
  }
}
```

## Routing Guidance
- `project-orchestrator` -> selects exactly one next lifecycle agent.
- `mvp-clarifier` -> typically `story-generator`.
- `story-generator` -> typically `technical-decomposer`.
- `c4-architect` -> `adr-generator` when architectural decision record is required.
- `architecture-guardian` / `refactor-auditor` -> may route back to `technical-decomposer` for remediation tasks.

## Output Minimum
All project agents must include:
- `confidence` (0-100)
- `rationale`
- `handoff_next` (or explicit `needed: false`)
