.PHONY: lint-workflows act-test act-test-live workflow-smoke

EVENT ?= pull_request_opened
WORKFLOW ?= .github/workflows/ci.yml
JOB ?=

lint-workflows:
	./scripts/workflows/lint.sh

act-test:
	./scripts/workflows/act.sh --dryrun --event "$(EVENT)" --workflow "$(WORKFLOW)" $(if $(JOB),--job "$(JOB)",)

act-test-live:
	./scripts/workflows/act.sh --event "$(EVENT)" --workflow "$(WORKFLOW)" $(if $(JOB),--job "$(JOB)",)

workflow-smoke:
	./scripts/workflows/smoke.sh
