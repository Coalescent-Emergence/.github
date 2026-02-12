# 1. Multi-Repository Organization Structure

Date: 2026-02-12

## Status

Accepted

## Context

The Coalescent-Emergence platform is a healthcare transcription system with multiple distinct components: backend API (Kerrigan), web UI, Whisper-based speech-to-text service, and Model Context Protocol (MCP) servers. We need to decide how to organize these components across Git repositories.

Starting as a solo developer with plans to scale to 5 engineers within 12 months, the repository structure must balance:
- **Initial simplicity**: One person working across all components
- **Future isolation**: Teams owning specific services with independent deployment
- **Shared governance**: Consistent processes, labels, workflows across projects
- **Compliance**: SOC2/HIPAA audit trails requiring clear component boundaries

## Decision Drivers

* Solo developer today, but need structure that scales to 5-person team
* Different deployment cadences: backend may deploy daily, ML service weekly
* Different technology stacks: Go (backend), TypeScript/React (UI), Python (ML)
* SOC2/HIPAA compliance requires clear component ownership and audit trails
* GitHub workflow automation easier with organization-level `.github` repository
* Future state: different teams may own different repositories (backend team, UI team, platform team)

## Considered Options

* **Monorepo**: All code in single repository with multiple packages
* **Multi-repo**: Separate repository per component (Kerrigan, UI, Whisper-STT, MCP servers)
* **Hybrid**: Core services in monorepo, auxiliary services in separate repos

## Decision Outcome

Chosen option: "Multi-repo with shared organization `.github` repository", because it provides best path for team scaling while maintaining shared governance.

### Consequences

* Good, because each service can be deployed independently with separate CI/CD
* Good, because different teams can own repositories with granular access control
* Good, because CI runs are isolated (UI changes don't trigger backend tests)
* Good, because organization `.github` repo enables shared workflows, labels, and issue templates
* Bad, because cross-repository changes require coordinating multiple PRs
* Bad, because shared libraries need packaging/versioning strategy (can't just import local path)
* Bad, because local development requires cloning multiple repositories
* Neutral, because increases repository count (acceptable trade-off for clear boundaries)

## Pros and Cons of the Options

### Monorepo

Single Git repository with structure like:
```
coalescent-emergence/
├── packages/
│   ├── backend/
│   ├── ui/
│   ├── whisper-stt/
│   └── mcp-servers/
```

* Good, because simpler local development (one clone, one `git pull`)
* Good, because cross-component refactors are atomic (single commit affects all)
* Good, because shared code can be imported directly without packaging
* Good, because easier to enforce consistent tooling (linting, formatting, testing)
* Bad, because CI complexity: need path-based triggers to avoid running all tests on every change
* Bad, because access control is all-or-nothing (can't give UI team access to only UI code)
* Bad, because deployment coupling: harder to deploy services independently
* Bad, because scales poorly with team growth (merge conflicts, slow clones, build times)
* Neutral, because requires tooling like Nx, Turborepo, or Bazel for efficient builds

### Multi-repo

Separate repositories:
- `Coalescent-Emergence/.github` (organization defaults)
- `Coalescent-Emergence/Kerrigan` (backend)
- `Coalescent-Emergence/UI` (web frontend)
- `Coalescent-Emergence/Whisper-STT` (ML service)
- `Coalescent-Emergence/MCP-*` (protocol servers)

* Good, because clear ownership boundaries (backend team owns Kerrigan repo)
* Good, because independent deployment and versioning per service
* Good, because granular access control via repository permissions
* Good, because CI isolation (Kerrigan CI only runs on Kerrigan changes)
* Good, because scales naturally as team grows (fewer merge conflicts)
* Bad, because cross-repo changes require multiple PRs and coordination
* Bad, because local development setup more complex (multiple clones, multiple builds)
* Bad, because shared code requires npm/Go module packaging instead of local imports
* Bad, because need discipline to keep shared governance synchronized (labels, workflows)

### Hybrid

Core business logic in monorepo, auxiliary services separate:
- `Coalescent-Emergence-Core/` (monorepo with backend + UI)
- `Coalescent-Emergence/Whisper-STT` (separate)
- `Coalescent-Emergence/MCP-*` (separate)

* Good, because balances monorepo benefits (backend+UI tight coupling) with multi-repo isolation (ML service)
* Good, because most common changes (backend + UI features) are atomic
* Bad, because inconsistent structure causes cognitive overhead ("where does this belong?")
* Bad, because still has monorepo scaling issues for core repo, multi-repo coordination for others
* Bad, because splits shared libraries across both patterns (confusing)

## Validation

Decision is correct if:

* ✅ Solo developer can efficiently work across all repos with simple setup script (within 3 months)
* ✅ Future teams (backend, UI, platform) can deploy their services independently without blocking others (within 12 months)
* ✅ Organization `.github` repository successfully enforces shared governance (labels, ADRs, workflows) across all repos (within 1 month)
* ✅ SOC2/HIPAA audit trail can clearly attribute changes to specific services and owners (ongoing)
* ❌ If cross-repo changes become > 50% of PRs, reconsider hybrid or monorepo approach

### Revisit Criteria

* If coordinating cross-repo changes becomes primary source of developer friction (measured by PR cycle time)
* If shared library versioning becomes a significant maintenance burden
* If team scaling stalls due to repository structure friction

## Links

* [GitHub Organization `.github` Repository](https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/creating-a-default-community-health-file)
* [Microservices Pattern](https://microservices.io/) - architectural reference
* See repository-level ADRs for implementation:
  - `Kerrigan/docs/decisions/` for backend-specific decisions
  - `UI/docs/decisions/` for frontend-specific decisions
* Related: [ADR-0003: Layered Service Architecture](./0003-layered-service-architecture.md)
