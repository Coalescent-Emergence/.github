#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

dryrun=false
event_name="pull_request_opened"
workflow_path=".github/workflows/ci.yml"
job_name=""

resolve_event_type() {
  local name="$1"
  case "$name" in
    pull_request*)
      echo "pull_request"
      ;;
    push*)
      echo "push"
      ;;
    schedule)
      echo "schedule"
      ;;
    workflow_dispatch*)
      echo "workflow_dispatch"
      ;;
    *)
      echo "$name"
      ;;
  esac
}

usage() {
  cat <<'EOF'
Usage: scripts/workflows/act.sh [--dryrun] [--event <name>] [--workflow <path>] [--job <job-id>]
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dryrun)
      dryrun=true
      shift
      ;;
    --event)
      event_name="${2:-}"
      shift 2
      ;;
    --workflow)
      workflow_path="${2:-}"
      shift 2
      ;;
    --job)
      job_name="${2:-}"
      shift 2
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

event_file=".github/test-events/${event_name}.json"
secrets_file=".github/test-events/.secrets"
example_secrets=".github/test-events/.secrets.example"
event_type="$(resolve_event_type "$event_name")"

if [[ ! -f "$workflow_path" ]]; then
  echo "Workflow file not found: $workflow_path" >&2
  exit 1
fi

if [[ ! -f "$event_file" ]]; then
  echo "Event fixture not found: $event_file" >&2
  exit 1
fi

if [[ ! -f "$secrets_file" && "$dryrun" != true ]]; then
  echo "Missing $secrets_file" >&2
  if [[ -f "$example_secrets" ]]; then
    echo "Copy $example_secrets to $secrets_file and fill local test secrets before running live mode." >&2
  fi
  exit 1
fi

act_cmd=(
  act
  "$event_type"
  -W "$workflow_path"
  -e "$event_file"
  --container-architecture linux/amd64
  -P ubuntu-latest=catthehacker/ubuntu:act-latest
)

if [[ -f "$secrets_file" ]]; then
  act_cmd+=(--secret-file "$secrets_file")
fi

if [[ -n "$job_name" ]]; then
  act_cmd+=(-j "$job_name")
fi

if [[ "$dryrun" == true ]]; then
  act_cmd+=(-n)
fi

if command -v act >/dev/null 2>&1; then
  "${act_cmd[@]}"
  exit 0
fi

if command -v nix-shell >/dev/null 2>&1; then
  printf -v escaped_act_cmd '%q ' "${act_cmd[@]}"
  nix-shell -p act --run "cd \"$repo_root\" && ${escaped_act_cmd}"
  exit 0
fi

echo "act is required. Install act or run via nix-shell." >&2
exit 1
