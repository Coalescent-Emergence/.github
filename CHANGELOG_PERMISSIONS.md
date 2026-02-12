# Permission Change Audit Log

**Purpose**: Track all GitHub repository permission changes for SOC2/HIPAA compliance audit trail.

**Requirements**:
- Document every team membership change
- Document every permission level change (Triage → Write, etc.)
- Document every GitHub team creation/deletion
- Include date, person making change, person affected, and business justification
- Review quarterly to verify all access is still appropriate

**Format**: `YYYY-MM-DD | Changed By | Action | Affected User/Team | Justification`

---

## 2026

### February 2026

**2026-02-12 | @jay13jay | Initial Setup | Repository | Established permission model and audit trail**
- Created permission tracking system
- Defined 5 permission tiers: Admin, Maintain, Write, Triage, Read
- Set @jay13jay as sole Admin (founder)
- Repository configured for SOC2/HIPAA compliance from day one
- Branch protection rules applied to `main` branch
- Justification: Solo founder establishing scalable governance before first hire

---

## Team Creation History

| Date | Team Name | Purpose | Initial Members | Created By |
|------|-----------|---------|-----------------|------------|
| TBD | @org/engineering | Parent visibility team | TBD | TBD |
| TBD | @org/backend | Backend area ownership | TBD | TBD |
| TBD | @org/frontend | Frontend area ownership | TBD | TBD |
| TBD | @org/platform | Infrastructure ownership | TBD | TBD |

---

## Access Reviews

**Purpose**: Quarterly verification that all permissions are still appropriate.

### Q1 2026 (Due: March 31, 2026)
- [ ] Review all organization members
- [ ] Verify Admin access limited to 1 person (founder)
- [ ] Confirm no stale personal access tokens
- [ ] Review GitHub App installations and permissions
- [ ] Verify CODEOWNERS accuracy
- Reviewer: ________ Date: ________ Findings: ________

### Q2 2026 (Due: June 30, 2026)
- [ ] Review all organization members
- [ ] Verify permission tier assignments match current roles
- [ ] Check for inactive accounts (no activity >60 days)
- [ ] Review team memberships vs. actual work areas
- [ ] Audit repository secrets access
- Reviewer: ________ Date: ________ Findings: ________

### Q3 2026 (Due: September 30, 2026)
- [ ] Review all organization members
- [ ] Verify separation of duties maintained
- [ ] Check branch protection rules still enforced
- [ ] Review workflow permissions for least-privilege
- [ ] Audit environment protection rules
- Reviewer: ________ Date: ________ Findings: ________

### Q4 2026 (Due: December 31, 2026)
- [ ] Review all organization members
- [ ] Annual permission audit for compliance
- [ ] Review year's permission changes for patterns
- [ ] Update permission policy if gaps found
- [ ] Prepare audit evidence package
- Reviewer: ________ Date: ________ Findings: ________

---

## Examples (Reference Only - Delete When First Real Entry Added)

```
2026-03-15 | @jay13jay | Team Member Added | @alice | First engineering hire as Backend Engineer
- Permission level: Triage (90-day onboarding period)
- Team assignment: None yet (solo work during onboarding)
- Access grants: Read staging environment
- Justification: New hire starting onboarding process per CONTRIBUTING.md

2026-06-15 | @jay13jay | Permission Upgrade | @alice | Completed 90-day onboarding successfully
- Previous: Triage
- New: Write
- Team assignment: No teams created yet (individual CODEOWNERS entry)
- Justification: Completed 8 PRs with strong quality, demonstrated workflow understanding, manager approved

2026-08-01 | @jay13jay | Team Created | @org/backend | Team size reached 3 backend engineers
- Initial members: @alice, @bob, @charlie
- Permission: Write access to /api/, /services/, /migrations/
- CODEOWNERS updated to use team mentions
- Justification: Reached 3-engineer threshold for team creation per scaling plan

2026-08-01 | @jay13jay | Secret Access Granted | @alice | Tech lead promotion
- Access: Production environment secrets (read-only)
- Justification: Leading incident response, needs prod log access for debugging
- Scope: Staging + production logs; NO deploy secrets
```
