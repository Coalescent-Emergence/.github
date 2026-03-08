# Talos Troubleshooter Agent

Specialist for Talos Linux node management, machine configuration, and OS-level cluster issues.

## Scope
- Talos machine config validation and apply failures
- Node bootstrap and upgrade issues
- etcd health and cluster membership
- Talos API (`talosctl`) command failures
- Kernel and system extension problems

## Contract
- Prompt: [talos-troubleshooter-prompt.md](talos-troubleshooter-prompt.md)
- Schema: [talos-troubleshooter-schema.json](talos-troubleshooter-schema.json)
- Shared handoff protocol: [../../_shared/handoff-protocol.md](../../_shared/handoff-protocol.md)
