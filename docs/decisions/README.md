# Architecture Decision Records

This directory contains **organization-wide** architectural decision records (ADRs) that apply across all repositories in the Coalescent-Emergence organization.

## What Goes Here vs Repository-Level

**Organization-level ADRs** (this directory):
- Cross-cutting architectural patterns affecting multiple repositories
- Multi-repo communication and integration standards
- Organization-wide technology choices (auth strategy, API conventions)
- Compliance and security requirements (SOC2/HIPAA)
- Shared infrastructure and deployment patterns

**Repository-level ADRs** (`{repo}/docs/decisions/`):
- Implementation-specific choices (framework, database, package structure)
- Repo-specific technology stack decisions
- Internal architecture of a single service/application
- Performance optimizations unique to that repository

## ADR Format

We use the **MADR** (Markdown Any Decision Records) format. See [template.md](./template.md) for the structure.

## ADR Lifecycle

1. **Proposed**: Initial ADR draft, open for review
2. **Accepted**: Team has approved the decision
3. **Deprecated**: Decision is outdated but record kept for history
4. **Superseded**: Replaced by a newer ADR (link included)

## Automation

- **ADR Linting**: [adr-guard.yml](../../workflows/adr-guard.yml) ensures ADRs follow MADR format
- **ADR Generation**: Use `type:architecture` label + `ai:generate-adr` to invoke [ADR Generator agent](../../agents/adr-generator/)
- **Architecture Review**: [Architecture Guardian agent](../../agents/architecture-guardian/) checks PRs against decisions

## Current ADRs

| ADR | Title | Status | Date |
|-----|-------|--------|------|
| [0001](./0001-multi-repo-architecture.md) | Multi-Repository Organization Structure | Accepted | 2026-02-12 |
| [0002](./0002-shared-ai-agent-workflows.md) | Shared AI Agent Workflows | Accepted | 2026-02-12 |
| [0003](./0003-layered-service-architecture.md) | Layered Service Architecture | Accepted | 2026-02-12 |

## Creating New ADRs

### Manual Creation
1. Copy [template.md](./template.md)
2. Increment the sequence number (e.g., `0004`)
3. Fill in all sections with meaningful content
4. Submit as PR with `type:architecture` label
5. Update this README with new entry

### AI-Assisted Creation
1. Create issue with `type:architecture` label
2. Describe the decision context in issue body
3. ADR Generator agent will post draft in comment
4. Review, refine, and commit to this directory
5. Update README

## References

- [MADR Documentation](https://adr.github.io/madr/)
- [AI Playbook](../../AI_PLAYBOOK.md) - Agent roles and prompts
- [Architecture Issue Template](../../ISSUE_TEMPLATE/architecture.yml)
