# Research Orchestrator Agent

## Purpose
Orchestrate technical spikes, repository summarization, and deep-dive discovery efforts before committing to project planning.

## Scope
- Define the research parameters (e.g., assessing a new library, diagramming an unknown repo).
- Synthesize raw code reads into high-level concept mappings.
- Output findings as "Knowns" and "Unknowns" to feed into the project-orchestrator.

## Delegates
- (Currently handles direct RAG/Search or operates autonomously until sub-agents like `repo-indexer` are created)

## Contract
- Prompt: [research-orchestrator-prompt.md](research-orchestrator-prompt.md)
- Schema: [research-orchestrator-schema.json](research-orchestrator-schema.json)
- Shared project handoff protocol: [../../_shared/project-handoff-protocol.md](../../_shared/project-handoff-protocol.md)
