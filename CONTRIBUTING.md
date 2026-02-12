CONTRIBUTING

Purpose
- This document defines the lightweight, opinionated workflow for a solo-founder, AI-assisted MVP development process.
- Designed to scale from solo founder to 3-5 specialized engineers within 12 months while maintaining SOC2/HIPAA compliance.

Principles
- No code without an issue.
- Every issue must include clear acceptance criteria.
- Favor the smallest vertical slice that delivers value.
- Simplicity bias: prefer simple, verifiable solutions.
- AI is advisory: human approval required for architecture or production changes.
- Least-privilege access: team members have minimum permissions needed for their role.
- Audit trail: all changes via reviewed PRs (even admins) for compliance evidence.

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

Team structure
Current state: Solo founder (@jay13jay)

Scaling path (activate as team grows):
- @org/engineering - Parent team for all engineers (visibility/mentions only, no direct permissions)
- @org/backend - Owns /api/, /services/, /migrations/, database code → Write access
- @org/frontend - Owns /ui/, /web/, /components/, client code → Write access  
- @org/platform - Owns /infra/, /.github/, CI/CD, deployments → Write access

Area ownership:
- Backend: API services, database migrations, backend logic
- Frontend: UI components, web applications, client-side code
- Platform: Infrastructure, CI/CD, GitHub workflows, deployment configs
- Governance: ADRs, SECURITY.md, CODEOWNERS (founder retains approval)

Team activation triggers:
- First hire (mo 3-6): Individual ownership in CODEOWNERS, no teams yet
- 3+ engineers: Create GitHub teams, activate area-based CODEOWNERS patterns
- 5+ engineers: Replace catch-all owner with @org/engineering

Permission levels
Admin (1 person max)
- Who: @jay13jay (founder only)
- Access: Full repository control, manage teams/secrets, emergency access
- Restrictions: Must use PR workflow for code changes (compliance requirement)

Maintain (Tech Leads at 5+ engineers)
- Who: Senior engineers leading specific areas
- Access: Manage issues/PRs, branch management (except main), push tags
- Restrictions: Cannot manage secrets, cannot bypass branch protection

Write (Core team members after 90-day proving period)
- Who: Full-time engineers with proven track record
- Access: Push to feature branches, merge approved PRs, standard development
- Restrictions: Cannot push to main directly, cannot manage workflows/secrets

Triage (New hires <90 days, contractors, part-time contributors)
- Who: Team members in onboarding period or contract/part-time roles
- Access: Manage issues/labels, assign reviewers, close/reopen issues
- Restrictions: Cannot merge PRs, cannot push code, cannot access secrets
- Graduation: Move to Write after 90 days with manager approval

Read (External auditors, advisors, board observers)
- Who: Non-engineering stakeholders needing visibility
- Access: View private repository only
- Restrictions: Cannot interact with issues/PRs

Permission graduation criteria (Triage → Write):
- 90 days minimum tenure
- Completed 5+ reviewed PRs with quality bar met
- Demonstrated understanding of workflow and ADR process
- Manager approval documented in CHANGELOG_PERMISSIONS.md

Onboarding checklist
For hiring manager adding new team member:

Pre-start (IT setup):
- [ ] Add to GitHub organization with Triage access initially
- [ ] Add to appropriate team channels (Slack/Discord/etc)
- [ ] Grant access to staging environment (read-only)
- [ ] Add to password manager for shared credentials
- [ ] Schedule pairing session with team lead

Week 1 (orientation):
- [ ] Review CONTRIBUTING.md, SECURITY.md, AI_PLAYBOOK.md
- [ ] Review LABELS.md and issue templates
- [ ] Review 3 recent merged PRs to understand quality bar
- [ ] Complete first issue (label: good-first-issue) with pair programming
- [ ] Confirm understanding of branch protection and why it exists

Week 2-4 (initial contributions):
- [ ] Solo work on 2-3 small issues with code review feedback
- [ ] Shadow 1 ADR approval process if available
- [ ] Review deployment process (observe, don't execute)

Day 90 review (graduation to Write):
- [ ] Manager approves quality of contributions
- [ ] Upgrade to Write access
- [ ] Document permission change in CHANGELOG_PERMISSIONS.md with date and reason
- [ ] Grant access to production logs (read-only) if role appropriate

Offboarding checklist
For departing team member (required for SOC2 compliance):

Immediate (day of departure):
- [ ] Remove from GitHub organization (revokes all access)
- [ ] Remove from team channels
- [ ] Revoke access to staging/production environments
- [ ] Remove from password manager
- [ ] Deactivate SSH keys and personal access tokens
- [ ] Remove from on-call rotation if applicable

Within 24 hours:
- [ ] Transfer assigned issues to active team member
- [ ] Transfer in-progress PRs (close or reassign for completion)
- [ ] Document knowledge transfer in team wiki/notes
- [ ] Rotate any secrets they had access to (production API keys, etc.)
- [ ] Document offboarding completion in CHANGELOG_PERMISSIONS.md

Within 1 week:
- [ ] Review merged PRs for undocumented decisions
- [ ] Update CODEOWNERS if they were area owner
- [ ] Archive any personal branches after review

Getting help
- For process questions, open an issue labeled `process`.
- To change this policy, propose an ADR and update this file.
