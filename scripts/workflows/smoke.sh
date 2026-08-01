#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

./scripts/workflows/lint.sh
./scripts/workflows/act.sh --dryrun --event pull_request_opened --workflow .github/workflows/ci.yml
./scripts/workflows/act.sh --dryrun --event pull_request_opened --workflow .github/workflows/security.yml
./scripts/workflows/act.sh --dryrun --event pull_request_opened --workflow .github/workflows/adr-guard.yml
./scripts/workflows/act.sh --dryrun --event pull_request_opened --workflow .github/workflows/pr-validation.yml
./scripts/workflows/act.sh --dryrun --event pull_request_opened --workflow .github/workflows/agent-refactor-auditor.yml
