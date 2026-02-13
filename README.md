# Coalescent-Emergence

Welcome to the Coalescent-Emergence organization. This repository contains the organization-level governance, automation, and shared resources used by the projects under the Coalescent-Emergence umbrella.

This repo is intentionally focused on non-code governance artifacts and developer tooling that apply across multiple repositories:

- Organization policies and contribution guidelines
- Shared GitHub Actions workflows and CI templates
- AI agent definitions and automated agent workflows
- Standard ADR templates and organization-level decisions
- Issue and PR templates, labels, and scripts for repo bootstrapping

Why this repo exists
--------------------
Centralizing governance and automation reduces duplication, enforces consistent practices, and speeds new repository setup. New projects should follow conventions documented here to ensure compliance, reproducibility, and a smoother developer experience.

Quick links
-----------
- Contribution guidelines: `CONTRIBUTING.md`
- Labels and scripts: `scripts/` and `LABELS.md`
- AI Playbook and agents: `AI_PLAYBOOK.md` and `agents/`
- ADR templates and organization decisions: `docs/decisions/`
- CI and validation workflows: `workflows/`

Using the AI agents
-------------------
We provide several AI agents as documented in `agents/`. They are intended to assist with planning, ADR drafting, PR reviews, and task decomposition. Workflows are available under `workflows/` to run agents automatically on issues and PRs when labeled.

Security & compliance
---------------------
This repo documents organization-level security and compliance guidance. Do not store secrets in repository files; use repository/organization secrets and approved secret management processes.

How to create a new repo following org conventions
-------------------------------------------------
1. Read `docs/REPOSITORY_SETUP.md` for step-by-step instructions.
2. Use the `scripts/configure-labels.sh` to apply standard labels.
3. Copy or reference `docs/decisions/template.md` when creating repo-specific ADRs.
4. Add repo-specific workflows only when necessary; prefer shared workflows when possible.

Support
-------
If you need assistance with organization policies or automation, open an issue in this repository describing the problem and tag `team:platform`.

License & usage
---------------
This repository contains governance and automation resources for Coalescent-Emergence projects. It does not include proprietary product code; treat product repositories as private as appropriate.

---
_Maintainers: Coalescent-Emergence platform team._
