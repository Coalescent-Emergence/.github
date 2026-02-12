# GitHub Permission Model - Quick Reference

**Solo founder scaling to 3-5 specialized engineers within 12 months**  
**Compliance**: SOC2 + HIPAA ready from day one

---

## Permission Tiers

| Role | When | GitHub Permission | Can Merge PRs? | Access Secrets? | Team Management? |
|------|------|-------------------|----------------|-----------------|------------------|
| **Admin** | Always (1 person) | Admin | Via PR only* | Yes | Yes |
| **Maintain** | At 5+ engineers | Maintain | Via PR only | No | Manage team members |
| **Write** | After 90-day proving | Write | Yes (if approved) | No | No |
| **Triage** | First 90 days | Triage | No | No | No |
| **Read** | External stakeholders | Read | No | No | No |

\* _Even Admin must use PR workflow for audit trail (SOC2 requirement)_

---

## Team Structure Timeline

| Milestone | Team Structure | CODEOWNERS Pattern |
|-----------|----------------|-------------------|
| **Now** (Solo) | @jay13jay (Admin) | `* @jay13jay` |
| **First Hire** (mo 3-6) | Individual assignments | `* @jay13jay`<br>`/api/ @alice` |
| **3 Engineers** (mo 6-9) | Create GitHub teams | `* @jay13jay`<br>`/api/ @org/backend` |
| **5+ Engineers** (mo 10-12) | Full team ownership | `* @org/engineering`<br>`/api/ @org/backend` |

---

## GitHub Teams

| Team | Owns | Members | Permission | Parent |
|------|------|---------|------------|--------|
| @org/engineering | Visibility only | All engineers | Read | None |
| @org/backend | /api/, /services/, /migrations/ | Backend engineers | Write | engineering |
| @org/frontend | /ui/, /web/, /components/ | Frontend engineers | Write | engineering |
| @org/platform | /infra/, /.github/, CI/CD | Platform engineers + founder | Write | engineering |

---

## Branch Protection Rules (main)

✅ **Enabled**:
- Require PR before merging (min 1 approval)
- Require status checks: `ci`, `pr-linked-issue`, `adr-lint`
- Require conversation resolution
- Require linear history (squash/rebase)
- Include administrators (even founder goes through PR process)
- Require branches up to date

❌ **Disabled**:
- Allow bypass (no exceptions - compliance requirement)
- Force push to `main`
- Delete `main` branch

---

## Workflow Permissions (Least-Privilege)

| Workflow | Permissions | Purpose |
|----------|-------------|---------|
| `ci.yml` | `contents: read`<br>`checks: write` | Run tests, publish results |
| `pr-validation.yml` | `contents: read`<br>`pull-requests: write` | Validate PR, AI advisory |
| `adr-guard.yml` | `contents: read`<br>`pull-requests: write` | Lint ADR files |

**Default**: All workflows start with `contents: read` only (configured in Settings → Actions → Workflow permissions)

---

## Secrets & Environments

### Current (Solo Founder)
- **Repository Secret**: `OPENAI_API_KEY` (for AI advisory in PRs)

### When Deploying (Production)
- **Environment**: `production` with required reviewer (@jay13jay)
- **Secrets**: `DEPLOY_KEY`, `DATABASE_URL`, `API_KEYS` (environment-scoped)
- **Protection**: Only `main` branch can deploy to production

---

## Onboarding Path (Triage → Write)

### Day 1
- Add to GitHub org with **Triage** permission
- Assign good-first-issue
- Pair programming session

### Week 1-12 (90-Day Proving Period)
- Complete 5+ reviewed PRs
- Demonstrate workflow understanding
- No merge permission (feedback loop only)

### Day 90 Review
- Manager approves graduation
- Upgrade to **Write** permission
- Document in CHANGELOG_PERMISSIONS.md
- Access production logs (read-only) if needed

---

## Offboarding Checklist

### Immediate (Day of Departure)
- [ ] Remove from GitHub organization
- [ ] Revoke all environment access
- [ ] Transfer assigned issues/PRs
- [ ] Document in CHANGELOG_PERMISSIONS.md

### Within 24 Hours
- [ ] Rotate secrets they accessed
- [ ] Update CODEOWNERS if area owner

---

## Key Files

| File | Purpose |
|------|---------|
| [CODEOWNERS](CODEOWNERS) | Area-based ownership with team patterns ready |
| [CONTRIBUTING.md](CONTRIBUTING.md) | Complete workflow + team structure documentation |
| [REPOSITORY_SETTINGS.md](REPOSITORY_SETTINGS.md) | Step-by-step GitHub settings configuration |
| [TEAMS_SETUP.md](TEAMS_SETUP.md) | How to create teams when scaling to 3+ engineers |
| [CHANGELOG_PERMISSIONS.md](CHANGELOG_PERMISSIONS.md) | Audit trail for all permission changes |

---

## Decision Framework

**When to create GitHub teams?**  
→ When 3+ people share responsibility for an area (backend, frontend, platform)

**When to require 2 reviewers instead of 1?**  
→ For ADR changes, production deployment code, or security-sensitive areas

**When to promote someone to Maintain role?**  
→ At 5+ engineers when founder needs to delegate review management

**When to grant production access?**  
→ Only after Write permission + demonstrated incident response competency

**When to rotate secrets?**  
→ Quarterly + within 24hrs of any team member departure

---

## Compliance Evidence

For SOC2/HIPAA audits, provide:
1. [REPOSITORY_SETTINGS.md](REPOSITORY_SETTINGS.md) - Controls documentation
2. [CHANGELOG_PERMISSIONS.md](CHANGELOG_PERMISSIONS.md) - Access change audit trail
3. GitHub audit log export (Settings → Logs → Export)
4. Branch protection screenshot showing "Include administrators"
5. Quarterly access review completed checklists

---

## Emergency Procedures

**Scenario**: Production down, need urgent hotfix, reviewer unavailable  
**Action**: 
1. Use GitHub "Revert commit" button to revert bad change (creates compliant PR automatically)
2. OR: Fix forward via PR, request emergency review via Slack/phone
3. Document incident and review delay in post-mortem

**Never**: Disable branch protection or force-push to `main`

---

## Quick Commands

```bash
# Check who can access the repo
gh api repos/:owner/:repo/collaborators

# Verify branch protection
gh api repos/:owner/:repo/branches/main/protection

# List organization teams
gh api orgs/:org/teams

# Add team member
gh api -X PUT /orgs/:org/teams/:team/memberships/:username

# Create environment
gh api -X PUT /repos/:owner/:repo/environments/production

# Add environment secret
gh secret set SECRET_NAME --env production
```

---

## Support

- **Process questions**: Open issue with label `process`
- **Permission changes**: Update [CHANGELOG_PERMISSIONS.md](CHANGELOG_PERMISSIONS.md) first
- **Policy changes**: Propose ADR, then update [CONTRIBUTING.md](CONTRIBUTING.md)

---

**Last Updated**: 2026-02-12  
**Owner**: @jay13jay  
**Next Review**: Before first hire OR every 6 months
