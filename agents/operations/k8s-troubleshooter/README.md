# Kubernetes Troubleshooter Agent

Specialist for Kubernetes scheduling, networking, ingress, and workload failures.

## Scope
- Pod scheduling failures and resource constraints
- Service/Ingress/IngressRoute routing issues
- Persistent volume claims and storage
- RBAC and namespace isolation problems
- Helm chart and manifest debugging

## Contract
- Prompt: [k8s-troubleshooter-prompt.md](k8s-troubleshooter-prompt.md)
- Schema: [k8s-troubleshooter-schema.json](k8s-troubleshooter-schema.json)
- Shared handoff protocol: [../../_shared/handoff-protocol.md](../../_shared/handoff-protocol.md)
