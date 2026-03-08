# Architecture Specialist Agent

General systems-design lead for architecture planning, diagram strategy, and iterative design decisions.

## Scope
- System boundary definition and decomposition strategy
- C4 level selection and sequencing
- Architecture tradeoff analysis and option framing
- Architecture artifact pipeline planning (MD -> Mermaid -> SVG)
- Delegation planning to specialized diagram/design subagents

## Delegates
- architecture-markdown-specialist
- mermaid-diagram-specialist
- diagram-svg-specialist
- c4-architect
- architecture-guardian
- adr-generator

## Contract
- Prompt: [architecture-specialist-prompt.md](architecture-specialist-prompt.md)
- Schema: [architecture-specialist-schema.json](architecture-specialist-schema.json)
- Shared project handoff protocol: [../../_shared/project-handoff-protocol.md](../../_shared/project-handoff-protocol.md)
