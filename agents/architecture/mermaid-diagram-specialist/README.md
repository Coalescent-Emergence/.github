# Mermaid Diagram Specialist Agent

Specialist for turning architecture specs into valid, readable Mermaid diagrams (C4 and supporting flow/sequence views).

## Scope
- Convert architecture markdown/specs into Mermaid syntax
- Produce C4 Context/Container/Component diagrams when requested
- Produce flowchart or sequence diagrams for interaction paths
- Validate syntax and readability constraints

## Delegates
- none

## Contract
- Prompt: [mermaid-diagram-specialist-prompt.md](mermaid-diagram-specialist-prompt.md)
- Schema: [mermaid-diagram-specialist-schema.json](mermaid-diagram-specialist-schema.json)
- Shared project handoff protocol: [../../_shared/project-handoff-protocol.md](../../_shared/project-handoff-protocol.md)
