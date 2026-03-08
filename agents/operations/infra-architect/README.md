# Infra Architect Agent

Domain lead for infrastructure troubleshooting — delegates to k8s, Talos, and Docker specialists.

## Scope
- Infrastructure failure triage and domain routing
- Cluster topology and networking diagnosis
- Cross-cutting infrastructure concerns (DNS, TLS, storage)
- Delegation to k8s-troubleshooter, talos-troubleshooter, docker-troubleshooter

## Delegates
- k8s-troubleshooter
- talos-troubleshooter
- docker-troubleshooter

## Contract
- Prompt: [infra-architect-prompt.md](infra-architect-prompt.md)
- Schema: [infra-architect-schema.json](infra-architect-schema.json)
- Shared handoff protocol: [../../_shared/handoff-protocol.md](../../_shared/handoff-protocol.md)
