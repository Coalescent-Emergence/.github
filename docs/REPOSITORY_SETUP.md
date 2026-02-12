# Repository Setup Guide

This guide provides a standardized process for creating new repositories in the Coalescent-Emergence organization. Following this guide ensures consistency with organizational governance, automatic AI agent support, and compliance with SOC2/HIPAA requirements.

## Quick Reference: Repository Checklist

When creating a new repository (UI, Whisper-STT, MCP servers, etc.):

- [ ] Create repository with appropriate name and description
- [ ] Initialize with README, LICENSE, .gitignore
- [ ] Create standard directory structure (`docs/`, `docs/decisions/`, tech-specific folders)
- [ ] Configure branch protection rules
- [ ] Enable organization workflows
- [ ] Create repository-specific ADR for technology stack
- [ ] Add labels (inherited from org, customize if needed)
- [ ] Configure secrets (if repository-specific secrets needed)
- [ ] Add repository to CODEOWNERS
- [ ] Test AI agent workflows with sample issue

---

## Step 1: Create Repository on GitHub

### Via GitHub Web UI

1. Navigate to https://github.com/organizations/Coalescent-Emergence/repositories/new
2. **Repository name**: Use descriptive, consistent naming:
   - `Kerrigan` - Backend API
   - `UI` - Web frontend
   - `Whisper-STT` - Speech-to-text service
   - `MCP-Server-{Name}` - Model Context Protocol servers
3. **Description**: One-line description of repository purpose
4. **Visibility**: Private (SOC2/HIPAA compliance)
5. **Initialize repository**:
   - ✅ Add a README file
   - ✅ Add .gitignore (select appropriate template: Go, Node, Python, etc.)
   - ✅ Choose a license: **Proprietary** (or organization standard)
6. Click **Create repository**

### Via GitHub CLI

```bash
# Example: Create UI repository
gh repo create Coalescent-Emergence/UI \
  --private \
  --description "Web frontend for healthcare transcription platform" \
  --gitignore Node \
  --license proprietary
```

---

## Step 2: Create Standard Directory Structure

All repositories should follow this structure:

```
{repository}/
├── README.md                   # Project overview, quick start, links to docs
├── LICENSE                     # Proprietary or organization standard
├── .gitignore                  # Tech stack-specific
├── docs/                       # Documentation
│   ├── architecture.md         # C4 diagrams, system design
│   ├── api.md                  # API specifications (if applicable)
│   ├── development.md          # Local dev setup, testing, debugging
│   ├── deployment.md           # Deployment procedures
│   └── decisions/              # Repository-level ADRs
│       ├── README.md           # ADR index with links to org-level ADRs
│       ├── template.md         # Copy from .github/docs/decisions/template.md
│       └── 0001-{decision}.md  # First repo-specific ADR (tech stack)
├── {tech-specific-folders}/    # src/, cmd/, internal/, etc.
└── .github/                    # Repository-specific workflows (if needed)
    └── workflows/
        └── ci.yml              # Tech stack-specific CI
```

### Create Base Structure (Example for Go project)

```bash
cd {repository}

# Documentation structure
mkdir -p docs/decisions
touch docs/architecture.md docs/api.md docs/development.md docs/deployment.md

# Copy ADR template from org .github
curl -o docs/decisions/template.md https://raw.githubusercontent.com/Coalescent-Emergence/.github/main/docs/decisions/template.md

# Create decisions README with link to org ADRs
cat > docs/decisions/README.md << 'EOF'
# Architecture Decision Records

This directory contains **repository-specific** ADRs for [Repository Name].

For **organization-wide** ADRs, see [.github/docs/decisions/](https://github.com/Coalescent-Emergence/.github/tree/main/docs/decisions).

## Current ADRs

| ADR | Title | Status | Date |
|-----|-------|--------|------|
| [0001](./0001-tech-stack-choice.md) | Technology Stack Selection | Accepted | YYYY-MM-DD |

EOF

# Tech-specific structure (example: Go)
mkdir -p cmd/{app-name}
mkdir -p internal/{package1,package2}
mkdir -p api
mkdir -p tests
touch cmd/{app-name}/main.go
```

For TypeScript/React:
```bash
# Use create-vite or create-react-app, then add docs/ structure above
npm create vite@latest . -- --template react-ts
mkdir -p docs/decisions
```

For Python:
```bash
mkdir -p src/{package_name}
mkdir -p tests
touch src/{package_name}/__init__.py
```

---

## Step 3: Create First Repository-Specific ADR

Every repository should document its technology stack choice as the first ADR.

**Example: `docs/decisions/0001-go-backend-language.md`**

```markdown
# 1. Use Go as Primary Language for Kerrigan Backend

Date: 2026-02-12

## Status

Accepted

## Context

Kerrigan is the backend API gateway and orchestration layer. Needs to handle:
- Authentication/authorization (JWT validation on every request)
- HTTP request routing and proxying to services
- Database access for user data and metadata
- HIPAA audit logging
- High concurrency (100+ concurrent users initially)

## Decision Drivers

* Performance requirements: < 50ms p95 latency for API calls
* Solo developer expertise: Strong Go experience
* Concurrency: Native goroutines for handling multiple service calls
* Deployment: Statically compiled binary simplifies Docker deployment
* Ecosystem: Excellent libraries for HTTP routers, PostgreSQL, JWT

## Considered Options

* Go
* TypeScript/Node.js
* Python

## Decision Outcome

Chosen option: "Go 1.23+", because native concurrency, strong typing, and deployment simplicity align with backend requirements.

[... continue with full MADR format ...]
```

---

## Step 4: Configure Branch Protection

Apply branch protection rules to `main` branch (and optionally `dev`).

### Via GitHub Web UI

1. Go to repository **Settings** → **Branches**
2. Click **Add branch protection rule**
3. **Branch name pattern**: `main`
4. Configure required settings:
   - ✅ **Require a pull request before merging**
     - Required approvals: 0 (solo dev), increase to 1-2 when team grows
     - ❌ Dismiss stale pull request approvals (not needed initially)
   - ✅ **Require status checks to pass before merging**
     - Search and add: `ci` (your CI workflow job name)
     - Search and add: `pr-linked-issue` (from org workflow)
     - Search and add: `adr-lint` (if ADRs modified)
   - ✅ **Require conversation resolution before merging**
   - ✅ **Do not allow bypassing the above settings** (even Admin must use PR workflow)
   - ❌ Allow force pushes: **Disabled**
   - ❌ Allow deletions: **Disabled**
5. Click **Create** or **Save changes**

### Via GitHub CLI

```bash
gh api repos/Coalescent-Emergence/{repo-name}/branches/main/protection \
  -X PUT \
  -f required_status_checks='{"strict":true,"contexts":["ci","pr-linked-issue"]}' \
  -f required_pull_request_reviews='{"required_approving_review_count":0}' \
  -f enforce_admins=true \
  -f allow_force_pushes=false \
  -f allow_deletions=false
```

**Reference**: See [REPOSITORY_SETTINGS.md](./REPOSITORY_SETTINGS.md) for complete branch protection configuration.

---

## Step 5: Enable Organization Workflows

Ensure repository can run workflows from `.github` organization repository.

### Via GitHub Web UI

1. Go to repository **Settings** → **Actions** → **General**
2. **Actions permissions**:
   - ✅ Allow all actions and reusable workflows
3. **Workflow permissions**:
   - ✅ Read and write permissions (allows agents to comment on issues/PRs)
   - ✅ Allow GitHub Actions to create and approve pull requests ( for ADR generation)
4. **Fork pull request workflows**:
   - ✅ Run workflows from fork pull requests (if open source later)
5. Click **Save**

**Verify**: Organization workflows (AI agents) should now trigger on labels and PR events.

---

## Step 6: Create Repository-Specific CI Workflow

Each repository needs a CI workflow tailored to its technology stack.

### Example: Go CI (Kerrigan)

Create `.github/workflows/ci.yml`:

```yaml
name: CI

on:
  pull_request:
    branches: [main, dev]
  push:
    branches: [main, dev]

permissions:
  contents: read

jobs:
  ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: actions/setup-go@v5
        with:
          go-version: '1.23'
          
      - name: Install dependencies
        run: go mod download
        
      - name: Run tests
        run: go test ./... -v -race -coverprofile=coverage.out
        
      - name: Check coverage
        run: |
          COVERAGE=$(go tool cover -func=coverage.out | grep total | awk '{print $3}' | sed 's/%//')
          echo "Coverage: $COVERAGE%"
          if (( $(echo "$COVERAGE < 70" | bc -l) )); then
            echo "Coverage below 70% threshold"
            exit 1
          fi
          
      - name: Run linter
        run: |
          go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
          golangci-lint run ./...
          
      - name: Build binary
        run: go build -v ./cmd/...
```

### Example: TypeScript/React CI (UI)

```yaml
name: CI

on:
  pull_request:
    branches: [main, dev]
  push:
    branches: [main, dev]

permissions:
  contents: read

jobs:
  ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Run linter
        run: npm run lint
        
      - name: Run type check
        run: npm run type-check
        
      - name: Run tests
        run: npm test
        
      - name: Build production bundle
        run: npm run build
```

---

## Step 7: Add Repository to CODEOWNERS

Update [.github/CODEOWNERS](../../CODEOWNERS) with repository ownership.

```bash
# Edit .github/CODEOWNERS
# Add line for new repository:

# {Repository} - {Description}
@{your-github-username}
```

**Example**:
```
# Kerrigan Backend - API gateway and orchestration
@joshh

# UI - Web frontend
@joshh
```

When team grows, assign teams:
```
# Kerrigan Backend
@Coalescent-Emergence/backend

# UI
@Coalescent-Emergence/frontend
```

---

## Step 8: Test AI Agent Workflows

Verify organization-wide AI agents work for new repository.

### Test MVP Clarifier

1. Create test issue in new repository
2. Add `ai:clarify` label
3. Verify workflow runs and posts JSON comment with stories
4. Remove test issue

### Test Architecture Guardian

1. Create test PR in new repository
2. Verify Architecture Guardian workflow runs
3. Verify comment posted reviewing against org ADRs
4. Close test PR

---

## Step 9: Update Organization Documentation

After creating repository:

- [ ] Add repository to organization README (if public-facing)
- [ ] Update [ADR-0001: Multi-Repo Architecture](../docs/decisions/0001-multi-repo-architecture.md) if applicable
- [ ] Update [TEAMS_SETUP.md](../TEAMS_SETUP.md) with repository ownership plans

---

## Tech Stack-Specific Guidance

### Go Repositories

**Required files**:
- `go.mod`, `go.sum`
- `cmd/{app}/main.go` - Application entrypoint(s)
- `internal/` - Private application code
- `pkg/` - Public reusable libraries (optional)

**Recommended libraries**:
- Router: `github.com/go-chi/chi/v5`
- Database: `github.com/jackc/pgx/v5`
- JWT: `github.com/golang-jwt/jwt/v5`
- Testing: `github.com/stretchr/testify`

### TypeScript/React Repositories

**Required files**:
- `package.json`, `package-lock.json`
- `tsconfig.json`
- `vite.config.ts` or equivalent bundler config

**Recommended libraries**:
- Framework: React 18+
- Build tool: Vite or Next.js
- State management: TanStack Query + Zustand
- Testing: Vitest + React Testing Library

### Python Repositories

**Required files**:
- `requirements.txt` or `pyproject.toml`
- `src/{package}/`__init__.py`
- `tests/`

**Recommended libraries**:
- Framework: FastAPI (services) or Flask
- Database: SQLAlchemy
- Testing: pytest
- Linting: ruff, mypy

---

## Compliance Notes

### SOC2/HIPAA Requirements

Every repository must:

- [ ] Use **private visibility** (no public repositories for healthcare data)
- [ ] Enable **branch protection** (no direct commits to main)
- [ ] Require **pull requests** (audit trail for all changes)
- [ ] Implement **audit logging** (if handling PHI - Protected Health Information)
- [ ] Store **no secrets** in code (use environment variables, GitHub Secrets)
- [ ] Document **data handling** in security.md or architecture.md

See [SECURITY.md](../SECURITY.md) for complete security policy.

---

## Troubleshooting

### Organization Workflows Not Running

**Symptom**: AI agents don't trigger on labels or PRs

**Solution**:
1. Check repository **Settings** → **Actions** → **General**
2. Verify "Allow all actions and reusable workflows" is enabled
3. Verify "Read and write permissions" enabled for workflow
4. Check `.github` repository workflows are valid YAML (no syntax errors)

### Branch Protection Not Enforced

**Symptom**: Can push directly to main despite protection rules

**Solution**:
1. Verify "Do not allow bypassing" is enabled in branch protection
2. Check status checks are spelled correctly (must match CI job name exactly)
3. Admin bypass may be enabled org-wide - check organization settings

### ADR Guard Not Running

**Symptom**: Can modify ADRs without linting

**Solution**:
1. Verify `docs/decisions/` path exists (guard only runs if ADRs modified)
2. Check ADR guard workflow in `.github/.github/workflows/adr-guard.yml` is valid
3. Ensure branch protection includes `adr-lint` in required status checks

---

## Examples

See these repositories as reference implementations:

- **Kerrigan**: c:\Users\joshh\Projects\github.com\Coalescent-Emergence\Kerrigan (in progress)
- **UI**: (to be created)
- **Whisper-STT**: (to be created)

---

## Next Steps After Repository Creation

1. **Implement MVP features** following vertical slices
2. **Write repository ADRs** for key technical decisions
3. **Set up CI/CD** with deployment automation
4. **Add monitoring** and logging infrastructure
5. **Document API contracts** if repository exposes APIs
6. **Coordinate with other repos** per [Layered Service Architecture ADR](../docs/decisions/0003-layered-service-architecture.md)

---

## Questions?

- Review [AI_PLAYBOOK.md](../AI_PLAYBOOK.md) for AI agent usage
- Check [CONTRIBUTING.md](../CONTRIBUTING.md) for workflow details
- See [REPOSITORY_SETTINGS.md](../REPOSITORY_SETTINGS.md) for complete configuration reference
