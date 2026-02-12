#!/bin/bash
# GitHub Label Configuration Script
# Applies the complete label taxonomy defined in LABELS.md
# Requires: GitHub CLI (gh) authenticated with repo access
#
# Usage:
#   ./configure-labels.sh [OWNER/REPO]
#
# Example:
#   ./configure-labels.sh Coalescent-Emergence/sandbox-mvp

set -e

REPO="${1:-Coalescent-Emergence/sandbox-mvp}"

echo "🏷️  Configuring labels for repository: $REPO"
echo ""

# Function to create or update a label
create_label() {
  local name="$1"
  local color="$2"
  local description="$3"
  
  # Remove '#' from color if present
  color="${color#\#}"
  
  # Try to update first (if exists), otherwise create
  if gh label list --repo "$REPO" --json name --jq ".[] | select(.name == \"$name\")" | grep -q "$name" 2>/dev/null; then
    echo "  ↻ Updating: $name"
    gh label edit "$name" --repo "$REPO" --color "$color" --description "$description" 2>/dev/null || true
  else
    echo "  ✓ Creating: $name"
    gh label create "$name" --repo "$REPO" --color "$color" --description "$description" 2>/dev/null || true
  fi
}

# Function to delete deprecated labels
delete_label() {
  local name="$1"
  
  if gh label list --repo "$REPO" --json name --jq ".[] | select(.name == \"$name\")" | grep -q "$name" 2>/dev/null; then
    echo "  ✗ Deleting deprecated: $name"
    gh label delete "$name" --repo "$REPO" --yes 2>/dev/null || true
  fi
}

echo "📦 Step 1: Remove deprecated labels..."
echo ""

delete_label "type:chore"
delete_label "area:infra"
delete_label "area:api"
delete_label "area:ui"
delete_label "ai:suggestion"
delete_label "ai:reviewed"
delete_label "status:review"

echo ""
echo "🎨 Step 2: Create/update TYPE labels..."
echo ""

create_label "type:bug" "d73a4a" "Bug report or defect"
create_label "type:feature" "0e8a16" "New feature or enhancement"
create_label "type:refactor" "fbca04" "Code refactoring or cleanup"
create_label "type:infra" "1d76db" "Infrastructure, tooling, CI/CD"
create_label "type:architecture" "5319e7" "Architectural decision or ADR"

echo ""
echo "🔥 Step 3: Create/update PRIORITY labels..."
echo ""

create_label "p0" "d73a4a" "Blocker / Hotfix / Production outage"
create_label "p1" "ff9800" "High priority / Significant impact"
create_label "p2" "ffc107" "Medium priority / Normal flow"
create_label "p3" "4caf50" "Low priority / Nice to have"

echo ""
echo "📊 Step 4: Create/update STATUS labels..."
echo ""

create_label "status:triage" "ededed" "Newly filed, needs acceptance criteria"
create_label "status:in-progress" "0052cc" "Active development underway"
create_label "status:blocked" "e11d21" "Blocked by external dependency"
create_label "status:on-hold" "f9d0c4" "Paused, deprioritized"
create_label "status:needs-review" "fbca04" "Ready for human review"
create_label "status:done" "0e8a16" "Completed and merged"

echo ""
echo "⚡ Step 5: Create/update EFFORT labels..."
echo ""

create_label "effort:S" "c2e0c6" "Small: < 4 hours, single file"
create_label "effort:M" "fef2c0" "Medium: 1-2 days, multiple files"
create_label "effort:L" "f9d0c4" "Large: 3+ days, cross-cutting change"

echo ""
echo "🗂️  Step 6: Create/update AREA labels..."
echo ""

create_label "area:backend" "d4c5f9" "API, database, business logic"
create_label "area:frontend" "c5def5" "UI, UX, client-side"
create_label "area:platform" "bfdadc" "Infra, CI/CD, deployment"
create_label "area:architecture" "5319e7" "Cross-cutting, ADRs"
create_label "area:unspecified" "ededed" "Default for triage, needs clarification"

echo ""
echo "👥 Step 7: Create/update TEAM & ONBOARDING labels..."
echo ""

create_label "team:ready" "0e8a16" "Prepped for delegation: clear ACs, effort estimated"
create_label "good-first-issue" "7057ff" "Onboarding task, pair programming recommended"
create_label "help-wanted" "008672" "External contribution welcome"

echo ""
echo "🤖 Step 8: Create/update AI WORKFLOW labels..."
echo ""

create_label "ai:clarify" "e99695" "MVP Clarifier output attached"
create_label "ai:decompose" "f9d0c4" "Story/task decomposition generated"
create_label "ai:review" "fef2c0" "Architecture/refactor review posted"
create_label "ai:generate" "d4c5f9" "ADR or code generated"
create_label "ai:approved" "0e8a16" "Human accepted AI suggestion"

echo ""
echo "🔧 Step 9: Create/update DEBT labels..."
echo ""

create_label "debt:technical" "fbca04" "Code quality, architecture smell"
create_label "debt:security" "d73a4a" "Security vulnerability or hardening needed"
create_label "debt:ux" "c5def5" "User experience friction"
create_label "debt:docs" "ededed" "Missing or outdated documentation"

echo ""
echo "🔐 Step 10: Create/update META labels..."
echo ""

create_label "meta:security" "b60205" "Private security issue (see SECURITY.md)"
create_label "meta:process" "c2e0c6" "Workflow or policy question"
create_label "meta:compliance" "5319e7" "SOC2/HIPAA audit requirement"

echo ""
echo "🌍 Step 11: Create/update ENVIRONMENT labels..."
echo ""

create_label "env:development" "1d76db" "Development environment only"
create_label "env:staging" "fbca04" "Staging environment issue"
create_label "env:production" "d73a4a" "Production environment issue"

echo ""
echo "✅ Label configuration complete for $REPO!"
echo ""
echo "📋 Summary:"
gh label list --repo "$REPO" --json name,color,description --jq 'length' | xargs -I {} echo "   Total labels: {}"
echo ""
echo "🔗 View labels: https://github.com/$REPO/labels"
echo ""
