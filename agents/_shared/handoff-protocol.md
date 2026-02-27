# Agent Handoff Protocol

## Purpose
Define a single, reusable communication contract so troubleshooting agents can delegate, escalate, and return findings without losing context.

## Required Principles
- Preserve evidence chain across all handoffs.
- Prefer smallest useful escalation target.
- Keep outputs advisory and structured.
- Include confidence and rationale in every terminal response.

## Handoff Input Contract
```json
{
  "from_agent": "general-troubleshooter",
  "to_agent": "software-architect",
  "reason": "Issue likely in software design or implementation",
  "priority": "high",
  "context": {
    "symptom": "Short symptom statement",
    "environment": "local|cluster|both|ci",
    "affected_components": ["kerrigan"],
    "recent_changes": "Optional change summary",
    "error_text": "Optional exact error",
    "evidence_gathered": [
      {
        "source": "kubectl logs",
        "finding": "No infra faults found"
      }
    ],
    "layers_cleared": ["infra.k8s.container", "infra.k8s.service"],
    "hypothesis": "Likely business-logic regression"
  }
}
```

## Standard Escalation Object (in every agent output)
```json
{
  "needed": true,
  "direction": "up",
  "target_agent": "general-troubleshooter",
  "reason": "Need cross-domain arbitration",
  "context_to_pass": {
    "evidence_gathered": [
      {
        "source": "go test",
        "finding": "Race detected in streaming handler"
      }
    ],
    "layers_cleared": ["software.api_contract", "software.data_flow"],
    "current_best_hypothesis": "Concurrency bug in stream fan-out"
  }
}
```

## Escalation Directions
- `down`: Parent delegates to child specialist.
- `up`: Child returns to parent for synthesis/reroute.
- `lateral`: Child requests sibling specialist.
- `lifecycle`: Troubleshooting completed; handoff recommended to planning/ADR workflow.

## Lifecycle Bridge Object
```json
{
  "lifecycle_handoff": {
    "needed": true,
    "suggested_agent": "adr-generator",
    "justification": "Root cause is architectural gap requiring formal decision record"
  }
}
```

## Evidence Accumulation Rules
1. Never overwrite prior evidence; append findings.
2. Mark each cleared layer explicitly.
3. Keep findings atomic and testable.
4. Include at least one verification command in final recommendation.

## Output Minimum (all troubleshooting agents)
```json
{
  "root_cause": "...",
  "evidence": ["..."],
  "fix": "...",
  "verification": "...",
  "confidence": 0,
  "rationale": "...",
  "escalation": {},
  "lifecycle_handoff": {}
}
```
