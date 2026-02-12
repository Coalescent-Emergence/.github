# Label Configuration Scripts

This directory contains tools to apply the complete label taxonomy defined in [LABELS.md](../LABELS.md).

## Files

- **`configure-labels.sh`** - Shell script using GitHub CLI to create/update labels
- **`labels.json`** - Declarative label configuration for API-based deployment
- **`README.md`** - This file

---

## Quick Start

### Option 1: Using GitHub CLI (Recommended)

**Prerequisites**: [GitHub CLI](https://cli.github.com/) installed and authenticated

```bash
# Make the script executable
chmod +x configure-labels.sh

# Apply labels to your repository
./configure-labels.sh Coalescent-Emergence/sandbox-mvp
```

The script will:
1. Delete deprecated labels (`type:chore`, `area:infra`, `area:api`, `area:ui`, `ai:suggestion`, `ai:reviewed`, `status:review`)
2. Create or update all 46 labels with correct colors and descriptions
3. Provide a summary of the configuration

### Option 2: Using GitHub API

Use the `labels.json` file with custom automation:

```bash
# Example: Create labels via GitHub API
REPO="Coalescent-Emergence/sandbox-mvp"

jq -c '.labels[]' labels.json | while read label; do
  NAME=$(echo $label | jq -r '.name')
  COLOR=$(echo $label | jq -r '.color')
  DESC=$(echo $label | jq -r '.description')
  
  gh api repos/$REPO/labels \
    -X POST \
    -f name="$NAME" \
    -f color="$COLOR" \
    -f description="$DESC" \
    || echo "Label $NAME already exists (update with PUT)"
done
```

### Option 3: Manual Import

1. Go to `https://github.com/OWNER/REPO/labels`
2. Use the GitHub web UI to create labels manually
3. Reference `labels.json` for exact names, colors, and descriptions

---

## Label Categories

The taxonomy includes 10 categories with 46 total labels:

| Category | Count | Example |
|----------|-------|---------|
| Type | 5 | `type:bug`, `type:feature`, `type:refactor`, `type:infra`, `type:architecture` |
| Priority | 4 | `p0`, `p1`, `p2`, `p3` |
| Status | 6 | `status:triage`, `status:in-progress`, `status:needs-review`, `status:done` |
| Effort | 3 | `effort:S`, `effort:M`, `effort:L` |
| Area | 5 | `area:backend`, `area:frontend`, `area:platform`, `area:architecture` |
| Team | 3 | `team:ready`, `good-first-issue`, `help-wanted` |
| AI | 5 | `ai:clarify`, `ai:decompose`, `ai:review`, `ai:generate`, `ai:approved` |
| Debt | 4 | `debt:technical`, `debt:security`, `debt:ux`, `debt:docs` |
| Meta | 3 | `meta:security`, `meta:process`, `meta:compliance` |
| Environment | 3 | `env:development`, `env:staging`, `env:production` |

---

## Migration from Old Labels

If you have existing repositories with the old label taxonomy:

### Deprecated Labels → New Labels

| Old | New | Notes |
|-----|-----|-------|
| `type:chore` | `type:infra` | Merged for clarity |
| `area:infra` | `area:platform` | Aligns with team structure |
| `area:api` | `area:backend` | Aligns with team structure |
| `area:ui` | `area:frontend` | Aligns with team structure |
| `ai:suggestion` | `ai:decompose` or `ai:review` | Context-dependent |
| `ai:reviewed` | `ai:approved` | Clearer terminology |
| `status:review` | `status:needs-review` | More explicit |

### Migration Script

```bash
# Update labels on existing issues (example for one label)
REPO="Coalescent-Emergence/sandbox-mvp"

# Get all issues with old label
gh issue list --repo $REPO --label "area:api" --limit 1000 --json number --jq '.[].number' | while read issue; do
  # Remove old label
  gh issue edit $issue --repo $REPO --remove-label "area:api"
  # Add new label
  gh issue edit $issue --repo $REPO --add-label "area:backend"
  echo "Migrated issue #$issue: area:api → area:backend"
done
```

**Warning**: Test migration on a few issues first before bulk updating!

---

## Automation Integration

### Issue Templates

Update issue templates (`.github/ISSUE_TEMPLATE/*.yml`) to use new label names:

```yaml
labels:
  - "type:feature"
  - "status:triage"
  - "area:unspecified"  # Changed from area:unspecified
```

### GitHub Actions

Reference labels in workflows using new names:

```yaml
# Example: Auto-apply labels based on file changes
- name: Label PR
  if: contains(github.event.pull_request.changed_files, 'src/api/')
  run: gh pr edit ${{ github.event.pull_request.number }} --add-label "area:backend"
```

### Status Automation (Future)

Planned workflow automations:

- **On branch create**: `status:triage` → `status:in-progress`
- **On PR open**: `status:in-progress` → `status:needs-review`  
- **On PR merge**: `status:needs-review` → `status:done`

---

## Validation

After applying labels, verify:

```bash
# List all labels
gh label list --repo Coalescent-Emergence/sandbox-mvp

# Count labels by category
gh label list --repo Coalescent-Emergence/sandbox-mvp --json name \
  | jq '[.[] | .name | split(":")[0]] | group_by(.) | map({category: .[0], count: length})'

# Check for deprecated labels still in use
gh issue list --repo Coalescent-Emergence/sandbox-mvp --label "area:api" --limit 1
```

Expected output: 46 total labels across 10 categories.

---

## Troubleshooting

### Error: Label already exists

The `configure-labels.sh` script attempts to update existing labels. If you see errors, the label may already have the correct configuration.

### Error: gh: command not found

Install GitHub CLI: https://cli.github.com/manual/installation

### Error: Insufficient permissions

Ensure you have `write` or `admin` access to the repository. Authenticate with:

```bash
gh auth login
gh auth status
```

### Color formatting issues

Colors in `labels.json` are hex codes **without** `#` prefix (e.g., `d73a4a` not `#d73a4a`). The shell script handles both formats.

---

## References

- **[LABELS.md](../LABELS.md)** - Complete label taxonomy documentation
- **[AI_PLAYBOOK.md](../AI_PLAYBOOK.md)** - AI role definitions mapped to `ai:*` labels
- **[TEAMS_SETUP.md](../TEAMS_SETUP.md)** - Team structure mapped to `area:*` labels
- **[CONTRIBUTING.md](../CONTRIBUTING.md)** - Workflow lifecycle mapped to `status:*` labels

---

## License

Part of Coalescent-Emergence/.github repository governance framework.
