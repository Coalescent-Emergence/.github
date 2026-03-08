# Docker Troubleshooter Agent

Specialist for Docker build failures, container runtime issues, and Compose orchestration problems.

## Scope
- Dockerfile build failures and multi-stage build issues
- Container runtime errors (crash loops, OOM, permission denials)
- Docker Compose service orchestration and networking
- Image layer optimization and caching

## Contract
- Prompt: [docker-troubleshooter-prompt.md](docker-troubleshooter-prompt.md)
- Schema: [docker-troubleshooter-schema.json](docker-troubleshooter-schema.json)
- Shared handoff protocol: [../../_shared/handoff-protocol.md](../../_shared/handoff-protocol.md)
