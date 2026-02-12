# GitHub Teams Setup Guide

**Purpose**: Step-by-step guide for creating GitHub teams when scaling from solo founder to 3+ engineers.

**When to Execute**: When you reach 3 engineers in a single area (backend, frontend, or platform).

---

## Prerequisites

- GitHub organization exists (not just a personal account)
- At least 3 engineers hired and onboarded
- Team members have completed 90-day onboarding period (Triage → Write graduation)

---

## Creating Teams via GitHub Web UI

### Step 1: Create Parent Team (@org/engineering)

1. Navigate to your GitHub organization page: `https://github.com/orgs/YOUR_ORG/teams`
2. Click **"New team"**
3. Configure:
   - **Team name**: `engineering`
   - **Description**: "All engineering team members for visibility and mentions"
   - **Visibility**: **Visible** (team members can see who's on the team)
   - **Team notifications**: Disabled (this is just a parent group)
   - **Parent team**: None
4. Click **"Create team"**
5. Do NOT add repositories to this team (it's just for grouping)

### Step 2: Create Area-Specific Child Teams

Repeat for each area as needed:

#### Backend Team (@org/backend)

1. Click **"New team"**
2. Configure:
   - **Team name**: `backend`
   - **Description**: "Backend engineers owning API, services, and database code"
   - **Visibility**: **Visible**
   - **Parent team**: `engineering`
3. Click **"Create team"**
4. Go to team settings → **Repositories**
5. Click **"Add repository"** → Select your repository → Choose **Write** permission
6. Add team members:
   - Click **"Members"** tab
   - Click **"Add a member"**
   - Search for GitHub usernames and add backend engineers
7. Configure team settings:
   - **Code review assignment**: Enable when team ≥3 members
     - Algorithm: Round robin or load balance
     - Never assign more than: 2 team members per PR

#### Frontend Team (@org/frontend)

1. Repeat Step 2 process with:
   - **Team name**: `frontend`
   - **Description**: "Frontend engineers owning UI, web, and client-side code"
   - **Parent team**: `engineering`
   - **Permission**: Write
   - Add frontend engineers as members

#### Platform Team (@org/platform)

1. Repeat Step 2 process with:
   - **Team name**: `platform`
   - **Description**: "Platform engineers owning infrastructure, CI/CD, and deployments"
   - **Parent team**: `engineering`
   - **Permission**: Write
   - Add platform/DevOps engineers as members
   - **IMPORTANT**: Founder (@jay13jay) should be a member of this team for oversight

---

## Creating Teams via GitHub CLI

For automation or reproducibility:

```bash
# Set variables
ORG="your-org-name"
REPO="sandbox-mvp"

# Create parent team
gh api -X POST /orgs/$ORG/teams \
  -f name="engineering" \
  -f description="All engineering team members" \
  -f privacy="closed"

# Create backend team (child of engineering)
gh api -X POST /orgs/$ORG/teams \
  -f name="backend" \
  -f description="Backend engineers owning API and services" \
  -f privacy="closed" \
  -f parent_team_id=$(gh api /orgs/$ORG/teams/engineering --jq '.id')

# Add repository to backend team with Write permission
gh api -X PUT /orgs/$ORG/teams/backend/repos/$ORG/$REPO \
  -f permission="push"

# Add member to backend team
gh api -X PUT /orgs/$ORG/teams/backend/memberships/USERNAME \
  -f role="member"

# Repeat for frontend and platform teams
```

---

## Updating CODEOWNERS After Team Creation

Once teams are created, activate the team-based ownership patterns:

1. Open `.github/CODEOWNERS`
2. Uncomment the relevant sections:

```ruby
# Backend team owns these areas:
/api/ @org/backend
/services/ @org/backend
/migrations/ @org/backend
/database/ @org/backend

# Frontend team owns these areas:
/ui/ @org/frontend
/web/ @org/frontend
/components/ @org/frontend
/client/ @org/frontend

# Platform team owns these areas (with founder oversight):
/infra/ @org/platform @jay13jay
/terraform/ @org/platform @jay13jay
/k8s/ @org/platform @jay13jay
/.github/ @org/platform @jay13jay
/deployments/ @org/platform @jay13jay
```

3. Update the catch-all owner when team ≥5:
   - Change: `* @jay13jay`
   - To: `* @org/engineering`

4. Commit and push the CODEOWNERS update
5. Document the change in CHANGELOG_PERMISSIONS.md

---

## Enabling Team-Based Code Review

### Update Branch Protection Rules

1. Navigate to: **Settings → Branches → Edit `main` protection rule**
2. Enable: **"Require review from Code Owners"**
3. Save changes

**Effect**: When a PR touches `/api/**`, GitHub will auto-request review from @org/backend team

### Configure Review Assignment

For each team:

1. Go to team page: `https://github.com/orgs/YOUR_ORG/teams/TEAM_NAME/settings`
2. Click **"Code review"**
3. Enable **"Enable auto assignment"**
4. Configure:
   - **How many team members should be assigned to review?**: 1 (or 2 for critical paths)
   - **Routing algorithm**: 
     - **Round robin** - Evenly distributes reviews
     - **Load balance** - Considers existing assignments (recommended)
   - **Never assign certain team members**: Check if someone is on leave
   - **Don't auto-assign if a team member has already been requested**: Enabled

---

## Team Membership Management

### Adding a Team Member

1. Navigate to team page
2. Click **"Members"** → **"Add a member"**
3. Search for GitHub username
4. Assign role:
   - **Member** - Standard team member (can't manage team settings)
   - **Maintainer** - Can add/remove members and update team settings
5. Document in CHANGELOG_PERMISSIONS.md:
   ```
   2026-XX-XX | @jay13jay | Team Member Added | @username | Added to @org/backend team
   ```

### Removing a Team Member

1. Navigate to team page → **Members**
2. Click X next to member's name
3. Confirm removal
4. Follow offboarding checklist in CONTRIBUTING.md
5. Document in CHANGELOG_PERMISSIONS.md

### Promoting to Team Maintainer

1. Navigate to team page → **Members**
2. Hover over member → Gear icon → **Change role...**
3. Select **Maintainer**
4. Document in CHANGELOG_PERMISSIONS.md:
   ```
   2026-XX-XX | @jay13jay | Role Change | @username | Promoted to Maintainer of @org/backend team - leading team code reviews
   ```

**When to promote**:
- Team ≥5 members and needs distributed leadership
- Senior engineer proven to maintain code quality bar
- Founder needs to delegate review management

---

## Team Notifications and Integrations

### Slack/Discord Integration

If using team chat:

1. Install GitHub app in Slack/Discord
2. Link team to channel:
   - Backend team → #backend channel
   - Frontend team → #frontend channel
   - Platform team → #platform channel
3. Configure notifications:
   - PRs touching team's areas
   - Review requests
   - Deployment notifications

### Team Mentions in Issues

With teams created, you can now:
- Mention `@org/backend` in issues to notify all backend engineers
- Use labels + team mentions together:
  - Label `area:backend` + mention `@org/backend` → routes to right team
- Auto-assign issues to teams (via GitHub Actions or project automation)

---

## Verification Checklist

After creating teams, verify:

- [ ] All teams are children of @org/engineering parent team
- [ ] Each team has Write access to the repository (not Admin)
- [ ] CODEOWNERS updated with team mentions for relevant paths
- [ ] "Require review from Code Owners" enabled in branch protection
- [ ] Code review auto-assignment configured for teams ≥3 members
- [ ] All team creations documented in CHANGELOG_PERMISSIONS.md
- [ ] Team members notified of their team assignment
- [ ] Slack/Discord integration working (if applicable)
- [ ] Test PR to verify auto-assignment works

---

## Testing Team Setup

Create a test PR to verify configuration:

1. Create a branch: `git checkout -b test/team-assignment`
2. Make a small change in backend area: `echo "// test" >> api/test.js`
3. Commit and push: `git commit -am "test: verify team assignment" && git push`
4. Open PR
5. Verify:
   - PR auto-requests review from @org/backend team
   - 1-2 specific team members assigned (not the whole team)
   - CODEOWNERS file shows team ownership in PR
6. Close PR without merging

---

## Common Issues and Solutions

**Problem**: Team created but not showing in @org/team mentions  
**Solution**: Verify team **Visibility** is set to "Visible" not "Secret"

**Problem**: CODEOWNERS not auto-requesting team reviews  
**Solution**: 
1. Verify CODEOWNERS path patterns match changed files
2. Ensure "Require review from Code Owners" enabled in branch protection
3. Check team has at least **Read** access to repository

**Problem**: Too many team members assigned to PRs  
**Solution**: Adjust "How many team members" setting in Code review auto-assignment to 1

**Problem**: Wrong team members always assigned  
**Solution**: Check Code review routing algorithm; switch to "Load balance" to consider existing workload

**Problem**: Team member can't see private repository  
**Solution**: Verify team has repository access; individual members inherit team permissions

---

## Rollback Plan

If team structure causes issues:

1. **Immediate**: Edit branch protection to disable "Require review from Code Owners"
2. **Temporary**: Revert CODEOWNERS to individual assignments
3. **Investigation**: Review GitHub audit log to see what changed
4. **Communication**: Notify team of temporary individual assignments
5. **Fix Forward**: Address root cause, then re-enable teams
6. **Document**: Add incident to CHANGELOG_PERMISSIONS.md

---

## Next Steps After Team Creation

1. **Week 1**: Monitor PR review distribution; adjust auto-assignment settings if lopsided
2. **Week 2**: Gather team feedback on auto-assignment; fine-tune as needed
3. **Month 1**: Review CHANGELOG_PERMISSIONS.md; verify all team changes documented
4. **Quarter 1**: First quarterly access review with teams in place

---

**Created**: 2026-02-12 by @jay13jay  
**Next Review**: When reaching 3 engineers in first area (estimated 4-6 months)
