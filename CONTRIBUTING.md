CONTRIBUTING

Purpose
- This document defines the lightweight, opinionated workflow for a solo-founder, AI-assisted MVP development process.

Principles
- No code without an issue.
- Every issue must include clear acceptance criteria.
- Favor the smallest vertical slice that delivers value.
- Simplicity bias: prefer simple, verifiable solutions.
- AI is advisory: human approval required for architecture or production changes.

Workflow
- Create an issue using one of the templates in `.github/ISSUE_TEMPLATE/`.
- Work on a branch named: `feature/<issue-number>-short-name` or `bugfix/<issue-number>-short-name`.
- Open a PR linking the issue with "Closes #<issue-number>".
- CI (`ci`) and `pr-linked-issue` checks must pass.
- At least one human approval (CODEOWNERS will be requested for ADRs/architecture changes).

Branch policy
- Default branch: `main`.
- Branch names: `feature/`, `bugfix/`, `hotfix/`, `chore/`, `docs/`.
- PR merges: squash and merge preferred for linear history.
- Do not force-push to `main`.

ADR expectations
- Major design decisions must be captured as ADRs in `docs/decisions/` using MADR-style structure.
- ADR PRs trigger `adr-lint` and must be reviewed by the architecture owner (`CODEOWNERS`).

Issue & PR quality
- Issues must include acceptance criteria and tests where applicable.
- PRs must reference the issue and include a short entropy/scope reflection.
- Use labels consistently (see LABELS.md).

AI usage standards
- Allowed: AI for decomposition, suggestion, tests, and docs (advisory only).
- Disallowed: AI-only merges or automated LLM changes to production without human review.
- Secrets: Never expose secrets in prompts. Use repository secrets for any API keys; AI steps run only for same-repository PRs.
- Prompt hygiene: include minimal necessary context; prefer structured outputs (JSON/checklist).

Security & dependency policy
- Dependabot enabled for dependency updates.
- Secret scanning enabled.
- Vulnerabilities are disclosed via the process in SECURITY.md.

Getting help
- For process questions, open an issue labeled `process`.
- To change this policy, propose an ADR and update this file.
