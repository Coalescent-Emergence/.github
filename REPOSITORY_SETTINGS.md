# Repository Settings Configuration Guide

**Purpose**: Document all GitHub repository settings required for SOC2/HIPAA compliance and scalable team collaboration.

**Target Audience**: Repository administrators (@jay13jay initially, then operations team)

**When to Apply**: 
- Initial setup: Now (solo founder)
- First hire: Review and verify settings
- Pre-audit: Validate all settings match this document

---

## General Settings

Navigate to: **Settings → General**

### Repository Visibility
- [x] **Private** (required for SOC2/HIPAA - protects proprietary code and customer data)

### Features
- [x] **Issues** - Enabled (required for "No Code Without Issue" workflow)
- [x] **Preserve this repository** - Optional (GitHub Archive Program)
- [ ] **Wikis** - Disabled (use docs/ directory or external wiki if needed)
- [ ] **Sponsorships** - Disabled (not applicable for private business repo)
- [x] **Projects** - Enable if using GitHub Projects for roadmap
- [ ] **Discussions** - Disabled (use issues for now; enable if team grows >10 people)

### Pull Requests
- [x] **Allow squash merging** - Enabled (preferred for linear history on `main`)
- [ ] **Allow merge commits** - Disabled (prevents merge bubbles)
- [x] **Allow rebase merging** - Enabled (alternative to squash for maintaining commits)
- [x] **Always suggest updating pull request branches** - Enabled (keeps PRs current)
- [x] **Allow auto-merge** - Disabled (human verification required per governance)
- [x] **Automatically delete head branches** - Enabled (reduces branch clutter)

### Archives
- [ ] **Include Git LFS objects in archives** - Configure based on project needs

---

## Branch Protection Rules

Navigate to: **Settings → Branches → Add branch protection rule**

### Rule for `main` branch

**Branch name pattern**: `main`

#### Protect matching branches
- [x] **Require a pull request before merging**
  - [x] **Require approvals**: 1 (minimum for audit trail)
  - [x] **Dismiss stale pull request approvals when new commits are pushed** - Enabled
  - [ ] **Require review from Code Owners** - Optional initially; enable when teams created
  - [x] **Restrict who can dismiss pull request reviews**: Repository administrators only
  - [ ] **Allow specified actors to bypass** - DISABLED (critical for SOC2 - no bypass even for admins)
  - [x] **Require approval of the most recent reviewable push** - Enabled

- [x] **Require status checks to pass before merging**
  - [x] **Require branches to be up to date before merging** - Enabled (prevents race conditions)
  - **Required status checks**: Add these as they appear in PRs:
    - `ci` - Must pass (from .github/workflows/ci.yml)
    - `pr-linked-issue` - Must pass (from .github/workflows/pr-validation.yml)
    - `adr-lint` - Must pass when ADR files modified (from .github/workflows/adr-guard.yml)

- [x] **Require conversation resolution before merging** - Enabled (ensure all feedback addressed)

- [x] **Require signed commits** - Optional (enable if org policy requires commit signing)
  - Note: Requires developers to configure GPG keys
  - Recommended for compliance; can defer to first hire if too burdensome solo

- [x] **Require linear history** - Enabled (enforces squash or rebase, cleaner git log)

- [x] **Require deployments to succeed before merging** - Disabled initially
  - Enable when you have deployment automation tied to environments

#### Rules applied to administrators
- [x] **Include administrators** - ENABLED (critical for SOC2/HIPAA audit trail)
  - Even @jay13jay must go through PR review process
  - Emergency exception: Use "Revert commit" feature if needed, then PR the fix

#### Restrictions
- [ ] **Restrict who can push to matching branches** - Leave empty
  - With "Require PR" enabled, no one needs direct push access
  - Workflow automation can still push via GITHUB_TOKEN

#### Additional Settings
- [ ] **Allow force pushes** - DISABLED (protects git history integrity)
- [ ] **Allow deletions** - DISABLED (prevents accidental `main` deletion)

---

## Collaborators and Teams

Navigate to: **Settings → Collaborators and teams**

### Current State (Solo Founder)
- @jay13jay - **Admin** role

### When First Hire Joins (Onboarding Period)
- @jay13jay - **Admin** role
- @new-hire - **Triage** role (for first 90 days per CONTRIBUTING.md)

### After 90-Day Onboarding Completion
- @jay13jay - **Admin** role
- @new-hire - **Write** role (if graduation criteria met)

### At 3+ Engineers (Team Structure Activated)
1. Create teams in Settings → Teams (organization level, not repository level)
2. Add teams to repository with Write access:
   - @org/engineering - **Read** (for visibility)
   - @org/backend - **Write**
   - @org/frontend - **Write**
   - @org/platform - **Write**
3. Keep @jay13jay as sole **Admin**

---

## Secrets and Variables

Navigate to: **Settings → Secrets and variables → Actions**

### Repository Secrets (Current)
- `OPENAI_API_KEY` - Used by .github/workflows/pr-validation.yml for AI advisory comments
  - Scope: Repository secrets (not environment-specific)
  - Access: Workflows running on same-repo PRs only (fork PRs blocked)

### When Deploying to Staging/Production
Create **Environments** instead of repository secrets:

1. Navigate to **Settings → Environments**
2. Create environments:
   - `development` - No protection rules, auto-deploy from feature branches
   - `staging` - No required reviewers initially; auto-deploy from `main`
   - `production` - **Required reviewers**: @jay13jay only until team ≥4

3. Add environment-specific secrets:
   - `production` environment:
     - `DEPLOY_KEY` - SSH key for production deployment
     - `DATABASE_URL` - Production database connection string
     - `API_KEYS` - Third-party API keys for production services
   - `staging` environment:
     - Same secrets with staging values
   - `development` environment:
     - Local/mocked versions or omit entirely

4. Environment protection rules for `production`:
   - [x] **Required reviewers**: @jay13jay (or future Maintain-role tech leads at 5+ engineers)
   - [x] **Wait timer**: 0 minutes (can add 5-10 min cooling-off period if desired)
   - [ ] **Deployment branches**: Only `main` (prevents deploying from feature branches)

---

## Code Security and Analysis

Navigate to: **Settings → Code security and analysis**

### Dependency Graph
- [x] **Enabled** - Auto-enabled for public repos; ensure enabled for private

### Dependabot Alerts
- [x] **Enabled** - Notifies of known vulnerabilities in dependencies

### Dependabot Security Updates
- [x] **Enabled** - Auto-creates PRs to update vulnerable dependencies

### Dependabot Version Updates
- [ ] **Disabled initially** - Can enable later with `.github/dependabot.yml` config
- When team ≥2, create `.github/dependabot.yml`:
  ```yaml
  version: 2
  updates:
    - package-ecosystem: "npm" # or pip, bundler, etc.
      directory: "/"
      schedule:
        interval: "weekly"
      open-pull-requests-limit: 5
      reviewers:
        - "@jay13jay" # or @org/platform when team created
  ```

### Code Scanning (GitHub Advanced Security)
- **Requires**: GitHub Advanced Security license (for private repos)
- If available:
  - [x] **CodeQL analysis** - Enable for automatic vulnerability detection
  - Configure via `.github/workflows/codeql-analysis.yml`

### Secret Scanning
- [x] **Enabled** - Detects accidentally committed secrets
- **Requires**: GitHub Advanced Security for private repos
- If not available on current plan, use pre-commit hooks or third-party tools

### Push Protection
- [x] **Enabled** - Blocks pushes containing detected secrets
- **Requires**: GitHub Advanced Security

---

## GitHub Actions

Navigate to: **Settings → Actions → General**

### Actions Permissions
- [x] **Allow all actions and reusable workflows** - Current setting
- Alternative (more restrictive for compliance):
  - [x] **Allow <org> actions and reusable workflows**
  - [x] **Allow actions created by GitHub**
  - Specify allow-list of verified actions if SOC2 auditor requires

### Workflow Permissions
- [x] **Read repository contents and packages permissions** - DEFAULT
  - All workflows start with `contents: read` by default
  - Must explicitly grant `contents: write` or `pull-requests: write` in workflow file
  - **Rationale**: Least-privilege principle for SOC2/HIPAA

- [ ] **Read and write permissions** - DO NOT SELECT
  - Too permissive; violates least-privilege principle

- [x] **Allow GitHub Actions to create and approve pull requests** - Disabled
  - Prevents automation from bypassing human review requirement

### Artifact and Log Retention
- **Default**: 90 days
- **For compliance**: Consider extending to 1 year (365 days) for audit evidence retention

---

## Notifications

Navigate to: **Settings → Notifications** (personal settings, not repository)

### For @jay13jay (Admin)
- [x] **Participating** - Enabled (mentions, assignments, reviews requested)
- [x] **Watching** - Configure to watch critical repos automatically
- [x] **Dependabot alerts** - Enabled, email + web notification

### For Team Members
- Encourage enabling:
  - Review requests
  - Mentions
  - Dependabot alerts for assigned areas

---

## Integrations

Navigate to: **Settings → Integrations** (organization level)

### GitHub Apps to Consider
- **Dependabot** - Pre-installed by GitHub
- **Slack/Discord** - Integrate for team notifications when team ≥2
- **Terraform Cloud** - If using infrastructure-as-code for deployments
- **Sentry/Datadog** - Error tracking and monitoring integrations

### App Permissions Review
- Annually review installed GitHub Apps
- Remove apps no longer in use
- Verify minimal scope for each app (least-privilege)

---

## Pages (Optional)

Navigate to: **Settings → Pages**

- **Use case**: Public documentation site (not for private business code)
- If enabled:
  - Source: Deploy from `gh-pages` branch or `docs/` folder on `main`
  - Custom domain: Configure DNS CNAME if applicable
  - HTTPS: Enforce HTTPS (enabled by default)

---

## Verification Checklist

After configuring settings, verify:

- [ ] Repository is Private
- [ ] Branch protection on `main` includes administrators
- [ ] Minimum 1 approval required for PRs
- [ ] Status checks required: `ci`, `pr-linked-issue`, `adr-lint`
- [ ] Auto-delete head branches enabled
- [ ] Dependabot alerts enabled
- [ ] Secret scanning enabled (if license allows)
- [ ] Workflow default permissions set to `contents: read`
- [ ] `OPENAI_API_KEY` stored in repository secrets
- [ ] Settings match CHANGELOG_PERMISSIONS.md audit requirements

---

## Applying Settings via GitHub CLI or API

For reproducibility and infrastructure-as-code, you can apply settings via:

### GitHub CLI (gh)

```bash
# Enable branch protection (example - customize as needed)
gh api -X PUT /repos/:owner/:repo/branches/main/protection \
  --input protection-config.json

# Add team to repository
gh api -X PUT /orgs/:org/teams/:team/repos/:owner/:repo \
  -f permission=write

# Create environment
gh api -X PUT /repos/:owner/:repo/environments/production

# Add environment secret
gh secret set DEPLOY_KEY --env production < deploy-key.txt
```

### Terraform (for Advanced Users)

Use `integrations/terraform/github` provider to manage repository settings as code:

```hcl
resource "github_repository" "main" {
  name        = "sandbox-mvp"
  visibility  = "private"
  
  has_issues   = true
  has_wiki     = false
  
  allow_squash_merge = true
  allow_merge_commit = false
  allow_rebase_merge = true
  delete_branch_on_merge = true
}

resource "github_branch_protection" "main" {
  repository_id = github_repository.main.node_id
  pattern       = "main"
  
  required_pull_request_reviews {
    required_approving_review_count = 1
    dismiss_stale_reviews = true
  }
  
  required_status_checks {
    strict = true
    contexts = ["ci", "pr-linked-issue"]
  }
}
```

---

## Troubleshooting

**Problem**: Branch protection blocks emergency hotfix  
**Solution**: Use "Revert" button on merged PR to revert via web UI (creates compliant PR), then fix forward

**Problem**: Status check won't pass / shows as pending forever  
**Solution**: Check workflow logs; may need to mark check as required in branch protection only after first successful run

**Problem**: CODEOWNERS not auto-requesting reviews  
**Solution**: Verify file is named `CODEOWNERS` (not `.github/CODEOWNERS.md`), and "Require review from Code Owners" is enabled in branch protection

**Problem**: Workflow can't write to PR (permission denied)  
**Solution**: Add explicit `pull-requests: write` permission to workflow job, verify workflow is from same repo (not fork)

**Problem**: Secret not available in workflow  
**Solution**: Check secret name matches exactly (case-sensitive), verify workflow has access to environment if using environment secrets

---

## References

- [GitHub Branch Protection Documentation](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)
- [GitHub Environments Documentation](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment)
- [GitHub CODEOWNERS Documentation](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners)
- [GitHub Security Best Practices](https://docs.github.com/en/code-security/getting-started/securing-your-repository)
- [SOC 2 Compliance Guide for GitHub](https://github.com/resources/articles/software-development/soc-2-compliance)

---

**Last Updated**: 2026-02-12 by @jay13jay  
**Next Review**: 2026-05-12 (quarterly review, or when first hire joins)
