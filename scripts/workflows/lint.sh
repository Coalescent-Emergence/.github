#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

lint_cmd=(actionlint -color -ignore 'shellcheck reported issue in this script: SC2086' -ignore 'shellcheck reported issue in this script: SC2010')

if command -v actionlint >/dev/null 2>&1; then
  "${lint_cmd[@]}"
  exit 0
fi

if command -v nix-shell >/dev/null 2>&1; then
  printf -v escaped_lint_cmd '%q ' "${lint_cmd[@]}"
  nix-shell -p actionlint --run "cd \"$repo_root\" && ${escaped_lint_cmd}"
  exit 0
fi

echo "actionlint is required. Install actionlint or run via nix-shell." >&2
exit 1
