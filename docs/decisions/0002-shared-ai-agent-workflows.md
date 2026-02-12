# 2. Shared AI Agent Workflows in Organization `.github` Repository

Date: 2026-02-12

## Status

Accepted

## Context

The AI Playbook defines 7 agent roles (MVP Clarifier, C4 Architect, Story Generator, Technical Decomposer, Architecture Guardian, Refactor Auditor, ADR Generator) to assist a solo developer working across multiple repositories (Kerrigan, UI, Whisper-STT, MCP servers).

We need to decide where to implement these AI agent workflows and how they access repositories.

Key constraints:
- Solo developer using AI agents as "virtual team members"
- Agents must work consistently across all organization repositories
- Workflows require OpenAI API access (secrets management)
- Each repository should not duplicate agent implementation
- Agents need to read org-level and repo-level ADRs for consistency checks

## Decision Drivers

* DRY principle: 7 agents × 5 repositories = 35 workflow files if repo-specific (high maintenance)
* Consistency: Agent behavior should be identical across all repos (same prompts, schemas)
* Secrets management: `OPENAI_API_KEY` should be organization secret, not repository secret
* Governance: Agents enforce organization-wide patterns (labels, ADRs, issue templates)
* Future extensibility: Adding new repository should automatically inherit all agents

## Considered Options

* **Org-level workflows**: AI agents in `.github/.github/workflows/`, triggered across all repos
* **Repo-level workflows**: Each repository has its own copy of agent workflows
* **Reusable workflows**: Workflows in `.github`, repositories call them via `uses:`
* **GitHub App**: Custom GitHub App with agents, installed on organization

## Decision Outcome

Chosen option: "Org-level workflows in `.github/.github/workflows/`", because GitHub automatically runs these workflows for events in all organization repositories, eliminating duplication and ensuring consistency.

### Consequences

* Good, because single source of truth for all agent implementations (7 workflows, not 35)
* Good, because adding new repository immediately inherits all agent functionality
* Good, because organization-level `OPENAI_API_KEY` secret accessible to all workflows
* Good, because agent documentation (prompts, schemas) lives with implementation in `.github/agents/`
* Good, because updates to agent logic apply to all repositories instantly
* Bad, because workflows must handle multi-repo context (different tech stacks, file structures)
* Bad, because debugging is harder (workflow runs under `.github` repository, not target repo)
* Bad, because can't easily customize agent behavior per repository (unless added as explicit feature)
* Neutral, because requires understanding of GitHub organization workflow inheritance

## Pros and Cons of the Options

### Org-level Workflows

Workflows in `.github/.github/workflows/agent-*.yml` automatically run for all org repositories.

* Good, because zero configuration for new repositories (inherited automatically)
* Good, because consistent agent behavior across all repositories
* Good, because single update affects all repos (bug fixes, prompt improvements)
* Good, because organization secrets accessible without per-repo configuration
* Good, because reduces total workflow count (7 vs potentially 35+)
* Bad, because workflows must detect repository context and adapt (tech stack, structure)
* Bad, because accidental changes affect all repositories (higher blast radius)
* Bad, because workflow runs show up in `.github` repository, not target repository (less visible)

### Repo-level Workflows

Each repository has `.github/workflows/agent-*.yml` copied from template.

* Good, because repository-specific customization is straightforward
* Good, because workflow runs visible in repository where they execute
* Good, because failures isolated to one repository
* Bad, because requires manual workflow copying to each new repository
* Bad, because updates to agent logic require updating 5+ repositories
* Bad, because secrets must be configured per repository (or use organization secret)
* Bad, because high duplication (7 workflows × 5 repos = 35 files to maintain)
* Bad, because drift risk (repositories may customize independently, breaking consistency)

### Reusable Workflows

Define workflows in `.github/.github/workflows/` as reusable, repositories call with `uses:`.

* Good, because reduces duplication (single workflow definition)
* Good, because repositories can pass custom inputs (partial customization)
* Good, because workflow runs show in calling repository (better visibility)
* Bad, because each repository still needs caller workflow files (less automatic than org-level)
* Bad, because requires maintaining both reusable workflow and caller workflows
* Bad, because more complex: two workflow files to understand (caller + reusable)

### GitHub App

Custom GitHub App with webhook handlers for issue labels, PR events.

* Good, because most flexible: can implement complex agent logic in code (not YAML)
* Good, because can maintain state across events (not possible in workflows)
* Good, because hosted separately from repository (independent deployment)
* Bad, because requires hosting infrastructure (server, database)
* Bad, because higher development overhead (write app code, not just workflows)
* Bad, because organization must install app explicitly (not automatic like org workflows)
* Bad, because overkill for current use case (workflows adequate for stateless agents)

## Validation

Decision is correct if:

* ✅ All 7 agents work consistently across Kerrigan, UI, and Whisper-STT repositories without per-repo configuration (within 1 month)
* ✅ Adding new repository (e.g., MCP server) inherits all agent functionality automatically (within 1 day of creation)
* ✅ Updating agent logic (e.g., improving prompt) applies to all repositories with single commit (within 1 day)
* ✅ Agent workflows can detect repository context (Go vs TypeScript vs Python) and adapt accordingly (within 3 months)
* ❌ If > 30% of agent invocations fail due to lack of repository-specific customization, reconsider reusable workflows approach

### Revisit Criteria

* If repository-specific agent customization becomes a frequent requirement
* If debugging org-level workflow failures becomes a significant pain point
* If GitHub changes organization workflow behavior or limits

## Links

* [GitHub Organization Workflows](https://docs.github.com/en/actions/using-workflows/sharing-workflows-secrets-and-runners-with-your-organization)
* [AI_PLAYBOOK.md](../../AI_PLAYBOOK.md) - Agent role definitions
* [agents/](../../agents/) - Agent documentation and schemas
* Implementation: See [workflows/](../../workflows/) for 7 agent workflows
* Related: [ADR-0001: Multi-Repository Architecture](./0001-multi-repo-architecture.md)
