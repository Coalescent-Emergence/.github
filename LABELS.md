# Label Taxonomy and Usage

## Philosophy

- **Keep labels small, orthogonal, and machine-friendly**
- **Separate concerns**: type / priority / status / effort / area / team / ai / debt / meta / env
- **Optimize for**: AI-assisted development, velocity tracking, architecture governance, team scaling
- **Design for**: Solo founder → 5-engineer team growth over 12 months

## Label Categories

| Category | Prefix | Mutually Exclusive | Purpose |
|----------|--------|-------------------|---------|
| Type | `type:` | Yes | Issue classification |
| Priority | `p0-p3` | Yes | Urgency level |
| Status | `status:` | Yes | Lifecycle tracking |
| Effort | `effort:` | Yes | Complexity/size estimation |
| Area | `area:` | No | Codebase domain |
| Team | `team:` / onboarding | No | Ownership & delegation |
| AI | `ai:` | No | AI workflow markers (advisory) |
| Debt | `debt:` | No | Technical debt categorization |
| Meta | `meta:` | No | Process/governance/security |
| Environment | `env:` | No | Deployment target |

---

## Complete Label Definitions

### Type Labels (mutually exclusive)

Apply **exactly one** `type:` label per issue.

| Label | Color | Description |
|-------|-------|-------------|
| `type:bug` | `#d73a4a` (red) | Bug report or defect |
| `type:feature` | `#0e8a16` (green) | New feature or enhancement |
| `type:refactor` | `#fbca04` (yellow) | Code refactoring or cleanup |
| `type:infra` | `#1d76db` (blue) | Infrastructure, tooling, CI/CD |
| `type:architecture` | `#5319e7` (purple) | Architectural decision or ADR |

**Note**: `type:chore` was merged into `type:infra` for clarity.

---

### Priority Labels

Apply **at most one** priority label per issue. Maps to issue template severity dropdowns.

| Label | Color | Description | Template Mapping |
|-------|-------|-------------|------------------|
| `p0` | `#d73a4a` (red) | Blocker / Hotfix / Production outage | P0 - production outage |
| `p1` | `#ff9800` (orange) | High priority / Significant impact | P1 - high impact |
| `p2` | `#ffc107` (yellow) | Medium priority / Normal flow | P2 - medium |
| `p3` | `#4caf50` (green) | Low priority / Nice to have | P3 - low |

**Usage**: Applied manually based on issue template severity selection or during triage.

---

### Status Labels (mutually exclusive)

Track issue/PR lifecycle. Apply **exactly one** `status:` label.

| Label | Color | Description |
|-------|-------|-------------|
| `status:triage` | `#ededed` (gray) | Newly filed, needs acceptance criteria |
| `status:in-progress` | `#0052cc` (blue) | Active development underway |
| `status:blocked` | `#e11d21` (red) | Blocked by external dependency |
| `status:on-hold` | `#f9d0c4` (light red) | Paused, deprioritized |
| `status:needs-review` | `#fbca04` (yellow) | Ready for human review |
| `status:done` | `#0e8a16` (green) | Completed and merged |

**Lifecycle**: `triage` → `in-progress` → `needs-review` → `done`

**Future automation**: Workflows can transition `status:in-progress` when branch created, `status:needs-review` when PR opened.

---

### Effort Labels (mutually exclusive)

Complexity estimation for velocity tracking. Maps to AI Story Generator output (S/M/L).

| Label | Color | Description |
|-------|-------|-------------|
| `effort:S` | `#c2e0c6` (light green) | Small: < 4 hours, single file |
| `effort:M` | `#fef2c0` (light yellow) | Medium: 1-2 days, multiple files |
| `effort:L` | `#f9d0c4` (light red) | Large: 3+ days, cross-cutting change |

**Usage**: Applied during triage or after AI decomposition. Used for sprint planning and velocity metrics.

---

### Area Labels (non-exclusive)

Map to codebase domains and future team ownership (see TEAMS_SETUP.md).

| Label | Color | Description | Maps to Team |
|-------|-------|-------------|--------------|
| `area:backend` | `#d4c5f9` (lavender) | API, database, business logic | @org/backend |
| `area:frontend` | `#c5def5` (light blue) | UI, UX, client-side | @org/frontend |
| `area:platform` | `#bfdadc` (teal) | Infra, CI/CD, deployment | @org/platform |
| `area:architecture` | `#5319e7` (purple) | Cross-cutting, ADRs | @org/governance |
| `area:unspecified` | `#ededed` (gray) | Default for triage, needs clarification | — |

**Migration note**: Replaces old `area:infra`, `area:api`, `area:ui` to align with team scaling strategy.

---

### Team & Onboarding Labels (non-exclusive)

| Label | Color | Description |
|-------|-------|-------------|
| `team:ready` | `#0e8a16` (green) | Prepped for delegation: clear ACs, effort estimated |
| `good-first-issue` | `#7057ff` (purple) | Onboarding task, pair programming recommended |
| `help-wanted` | `#008672` (teal) | External contribution welcome |

**Usage**: `team:ready` signals issue can be assigned to junior engineer. `good-first-issue` per CONTRIBUTING.md onboarding workflow.

---

### AI Workflow Labels (non-exclusive, advisory only)

All `ai:*` labels are **advisory markers**. Per CONTRIBUTING.md policy: *"AI is advisory: human approval required for architecture or production changes."*

Maps to 7 AI roles in AI_PLAYBOOK.md:

| Label | Color | Description | AI Role |
|-------|-------|-------------|---------|
| `ai:clarify` | `#e99695` (light red) | MVP Clarifier output attached | MVP Clarifier |
| `ai:decompose` | `#f9d0c4` (peach) | Story/task decomposition generated | Story Generator, Technical Decomposer |
| `ai:review` | `#fef2c0` (light yellow) | Architecture/refactor review posted | Architecture Guardian, Refactor Auditor |
| `ai:generate` | `#d4c5f9` (lavender) | ADR or code generated | ADR Generator |
| `ai:approved` | `#0e8a16` (green) | Human accepted AI suggestion | — |

**Usage**: Applied by workflows (e.g., pr-validation.yml) or manually when pasting AI output. Use for tracking which AI roles provide value.

**Replaces**: Old `ai:suggestion` and `ai:reviewed` labels.

---

### Debt Labels (non-exclusive)

Categorize technical debt for remediation planning. Combine with `type:refactor`.

| Label | Color | Description |
|-------|-------|-------------|
| `debt:technical` | `#fbca04` (yellow) | Code quality, architecture smell |
| `debt:security` | `#d73a4a` (red) | Security vulnerability or hardening needed |
| `debt:ux` | `#c5def5` (light blue) | User experience friction |
| `debt:docs` | `#ededed` (gray) | Missing or outdated documentation |

---

### Meta Labels (non-exclusive)

Process, governance, and security issue markers.

| Label | Color | Description |
|-------|-------|-------------|
| `meta:security` | `#b60205` (dark red) | **Private** security issue (see SECURITY.md) |
| `meta:process` | `#c2e0c6` (light green) | Workflow or policy question |
| `meta:compliance` | `#5319e7` (purple) | SOC2/HIPAA audit requirement |

**Usage**: `meta:security` only in private repository issues per SECURITY.md. `meta:process` for questions per PERMISSION_MODEL.md.

---

### Environment Labels (non-exclusive)

Track deployment-specific work or bugs.

| Label | Color | Description |
|-------|-------|-------------|
| `env:development` | `#1d76db` (blue) | Development environment only |
| `env:staging` | `#fbca04` (yellow) | Staging environment issue |
| `env:production` | `#d73a4a` (red) | Production environment issue |

**Usage**: Apply to bugs occurring in specific environments. Aligns with REPOSITORY_SETTINGS.md environment definitions.

---

## Label Combination Examples

### Complete Feature Issue
```
type:feature + p1 + status:triage + effort:M + area:backend + ai:decompose
```
*Interpretation*: High-priority medium-sized backend feature with AI decomposition attached, awaiting triage/acceptance.

### Security Debt Refactor
```
type:refactor + p0 + status:in-progress + area:architecture + debt:security
```
*Interpretation*: Critical security refactor affecting cross-cutting architecture, actively being worked.

### Onboarding Task
```
type:feature + p2 + effort:S + area:frontend + team:ready + good-first-issue
```
*Interpretation*: Small frontend feature ready for new team member onboarding.

### AI-Generated ADR
```
type:architecture + status:needs-review + area:architecture + ai:generate
```
*Interpretation*: ADR draft produced by AI, awaiting human review before acceptance.

---

## Quick Reference: Label Decision Tree

### When creating an issue:

1. **Type** (required): What kind of work? → `type:bug/feature/refactor/infra/architecture`
2. **Priority** (recommended): How urgent? → `p0/p1/p2/p3`
3. **Status** (auto-applied): → `status:triage`
4. **Area** (recommended): Which domain? → `area:backend/frontend/platform/architecture`

### During triage:

5. **Effort** (add if decomposed): How complex? → `effort:S/M/L`
6. **AI markers** (add if AI used): Which AI role? → `ai:clarify/decompose/review/generate`
7. **Team readiness** (add if delegatable): → `team:ready` or `good-first-issue`

### For special cases:

8. **Debt** (if refactor): What kind? → `debt:technical/security/ux/docs`
9. **Environment** (if env-specific bug): → `env:development/staging/production`
10. **Meta** (if governance): → `meta:security/process/compliance`

---

## Usage Rules

### Mutually Exclusive Labels
- Apply **exactly one** `type:` label per issue
- Apply **at most one** priority (`p0-p3`) per issue
- Apply **exactly one** `status:` label per issue
- Apply **at most one** `effort:` label per issue

### Non-Exclusive Labels
- Multiple `area:` labels allowed (e.g., `area:backend + area:architecture` for cross-cutting API change)
- Multiple `ai:` labels allowed (e.g., `ai:decompose + ai:review` if multiple AI roles engaged)
- Multiple `debt:` labels allowed (rare, but `debt:security + debt:docs` valid)

### Advisory Labels
- All `ai:*` labels are **advisory only** and must not affect required checks or blocking workflows
- `ai:approved` confirms human reviewed and accepted AI output

---

## Automation Hooks (Future Implementation)

### Workflow Triggers
- **On issue create**: Auto-apply `status:triage` + template-defined labels
- **On branch create**: Move `status:triage` → `status:in-progress` if branch name matches `feature/<issue>` or `bugfix/<issue>`
- **On PR open**: Move `status:in-progress` → `status:needs-review`
- **On PR merge**: Move `status:needs-review` → `status:done`, close linked issue

### AI Workflow Integration
- **pr-validation.yml**: Apply `ai:review` when Architecture Guardian posts comment
- **Manual**: Apply `ai:decompose` when pasting Story Generator output into issue
- **Manual**: Apply `ai:approved` after human reviews and accepts AI suggestion

### Priority Auto-Application (Future)
- Parse issue template severity dropdown (P0/P1/P2/P3) and auto-apply corresponding `p0/p1/p2/p3` label
- Requires custom GitHub Action or issue form parser

---

## Migration from Old Labels

### Deprecated Labels → New Labels

| Old Label | New Label | Action |
|-----------|-----------|--------|
| `area:infra` | `area:platform` | Rename |
| `area:api` | `area:backend` | Rename |
| `area:ui` | `area:frontend` | Rename |
| `ai:suggestion` | `ai:decompose` or `ai:review` | Context-dependent rename |
| `ai:reviewed` | `ai:approved` | Rename |
| `status:review` | `status:needs-review` | Rename |
| `type:chore` | `type:infra` | Rename |

### Manual Migration Steps
1. Export existing issues with old labels via GitHub API
2. Batch update using `gh` CLI or GraphQL mutation
3. Create new labels before renaming to avoid orphaned issues
4. Archive old labels (don't delete immediately for audit trail)

---

## Colors & Accessibility

All colors selected for WCAG AA contrast compliance:
- **Red spectrum** (`#b60205` → `#d73a4a` → `#f9d0c4`): Critical → High → Attention
- **Green spectrum** (`#0e8a16` → `#c2e0c6`): Success → Safe
- **Yellow spectrum** (`#fbca04` → `#fef2c0`): Warning → Caution
- **Blue spectrum** (`#0052cc` → `#1d76db` → `#c5def5`): Active → Info → Light
- **Purple spectrum** (`#5319e7` → `#d4c5f9`): Architecture → AI
- **Gray** (`#ededed`): Neutral / Unknown

---

## Compliance & Audit Trail

Per CONTRIBUTING.md and PERMISSION_MODEL.md:
- Label changes are audited via GitHub event log (retained per REPOSITORY_SETTINGS.md)
- `meta:compliance` labels facilitate quarterly access reviews (see CHANGELOG_PERMISSIONS.md)
- SOC2/HIPAA requirement: All production changes must have clear priority and type labels for traceability

---

## References

- **AI_PLAYBOOK.md**: 7 AI role definitions mapped to `ai:*` labels
- **TEAMS_SETUP.md**: Team structure mapped to `area:*` labels
- **CONTRIBUTING.md**: Workflow lifecycle mapped to `status:*` labels
- **SECURITY.md**: Security issue handling via `meta:security` label
- **PERMISSION_MODEL.md**: Process questions via `meta:process` label
- **Issue Templates**: Auto-apply rules for type, status, area labels
