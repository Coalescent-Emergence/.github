# C4 Architect Agent

## Purpose
Produce C4-level architectural descriptions (Context, Container, Component) and identify implementation priorities. Helps maintain coherent system design across multiple repositories in a layered architecture.

## Role
Software architect using C4 modeling to visualize system structure, define boundaries, and guide implementation decisions across the multi-repo Coalescent-Emergence organization.

## Trigger
- **Label**: `type:architecture` or `ai:architect` on issues
- **Manual**: Via GitHub Actions workflow_dispatch

## Inputs
- **Context docs**: Links to existing architecture.md, ADRs, system diagrams
- **Repository**: Target repository (Kerrigan, UI, Whisper-STT, MCP servers)
- **Scope**: Which C4 level needed (Context, Container, Component)
- **Change description**: What architectural change is being proposed

## Outputs
Structured response with:
- **C4 diagrams**: Mermaid syntax for requested level(s)
- **component_recommendations**: 3-5 components to implement next
- **dependencies**: Cross-repo dependencies if applicable
- **adr_needed**: Whether this change requires an ADR
- **confidence**: 0-100 score with rationale

## C4 Levels

### Level 1: Context
Shows the system and its relationships with users and external systems. Use for:
- New repository initialization
- Understanding system boundaries
- Identifying external integrations

### Level 2: Container
Shows applications, services, databases within the system. Use for:
- Multi-repo architecture planning
- Service decomposition
- Technology stack decisions

### Level 3: Component
Shows major structural building blocks within a container. Use for:
- Implementation planning within a repository
- Package/module organization
- Identifying reusable components

## Usage Example

### Input (Issue Body)
```
We need to add real-time transcription streaming from the Whisper service to the UI, with Kerrigan orchestrating the workflow.

Repository: Multi-repo (Kerrigan + Whisper-STT + UI)
Scope: Container level
```

### Output (Mermaid + Recommendations)
````mermaid
C4Container
    title Container Diagram - Real-Time Transcription System

    Person(user, "Healthcare Provider", "Medical professional recording patient notes")
    
    System_Boundary(c1, "Coalescent-Emergence Platform") {
        Container(ui, "UI", "React/TypeScript", "Web application for audio capture and transcription display")
        Container(kerrigan, "Kerrigan Backend", "Go", "API gateway and workflow orchestration")
        Container(whisper, "Whisper-STT Service", "Python/FastAPI", "Audio transcription using OpenAI Whisper")
        ContainerDb(db, "PostgreSQL", "PostgreSQL 15", "User data, transcription metadata, audit logs")
        ContainerQueue(queue, "Message Queue", "Redis Streams", "Async job processing")
    }
    
    System_Ext(whisper_model, "Whisper Model", "Pre-trained ML model for speech recognition")
    
    Rel(user, ui, "Records audio", "WebRTC")
    Rel(ui, kerrigan, "Sends audio chunks", "WebSocket/JSON")
    Rel(kerrigan, queue, "Publishes transcription jobs", "Redis protocol")
    Rel(whisper, queue, "Consumes jobs", "Redis protocol")
    Rel(whisper, whisper_model, "Inference", "Local path")
    Rel(whisper, kerrigan, "Streams results", "Server-Sent Events")
    Rel(kerrigan, ui, "Forwards transcription", "WebSocket")
    Rel(kerrigan, db, "Stores metadata", "SQL")
    Rel(whisper, db, "Logs processing", "SQL")
````

**Component Recommendations** (priority order):
1. **Kerrigan: WebSocket Manager** - Handle bidirectional client connections, route audio chunks to queue, stream results back
2. **Kerrigan: Job Orchestrator** - Publish transcription jobs to Redis Streams, track job state, handle timeouts
3. **Whisper-STT: Stream Processor** - Consume Redis jobs, chunk audio for streaming transcription, emit partial results
4. **UI: Audio Capture Component** - WebRTC audio recording, chunked upload via WebSocket
5. **Kerrigan: Audit Logger** - HIPAA-compliant logging of all audio processing events

**Cross-repo Dependencies**:
- Kerrigan must implement WebSocket API before UI can consume
- Shared message schema (audio chunk format, transcription result) needs ADR
- Redis Streams requires infrastructure setup (can use local Redis for dev)

**ADR Needed**: Yes - "ADR: Real-time transcription architecture with WebSocket + Redis Streams" to document technology choices, alternatives considered (gRPC streaming, direct HTTP), and rationale.

**Confidence**: 78 - Standard microservices pattern with proven technologies. Main uncertainty is latency requirements (near real-time?) which may affect chunking strategy. Recommend load testing early to validate approach.
```

## Integration
- Generates Mermaid diagrams compatible with GitHub markdown rendering
- Links to [architecture issue template](../ISSUE_TEMPLATE/architecture.yml)
- Can trigger [ADR Generator](../agents/adr-generator/) when `adr_needed: true`
- References multi-repo structure from [layered-service-architecture ADR](../docs/decisions/0003-layered-service-architecture.md)

## Files
- [prompt.md](./prompt.md) - System prompt and C4 level templates
- [schema.json](./schema.json) - JSON schema for outputs
- [examples/](./examples/) - Sample Context/Container/Component diagrams
