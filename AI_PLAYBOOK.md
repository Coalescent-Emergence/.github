AI Playbook — Roles, Prompts, and Guardrails

Purpose
- Provide a concise, reusable AI playbook to assist the solo founder with decomposition, review, and ADR drafting. All AI outputs are advisory and require human review.

Roles & Responsibilities
- General Troubleshooter: Single troubleshooting entrypoint; routes incidents to software-architect or infra-architect.
- Software Architect: Software-domain triage lead; routes to language/performance specialists.
- Infra Architect: Infrastructure-domain triage lead; routes to k8s/talos/docker troubleshooters.
- Project Manager: Lifecycle entrypoint for planning/governance; routes to project specialists.
- DSA Specialist: Performance and bottleneck specialist across all runtime languages.
- Go Specialist: Language specialist for Kerrigan and KUI.
- Python Specialist: Language specialist for em-audio and Python tooling.
- JavaScript Specialist: Language specialist for progress-tracker and JS tooling.
- IaC Specialist: Terraform + Ansible specialist for em-infra.
- Shell Specialist: Script/CI specialist for shell-based automation.
- MVP Clarifier: Convert an idea into minimal success criteria and 3 prioritized stories.
- C4 Architect: Produce C4-context and container-level descriptions (textual) and identify components to implement.
- Story Generator: Create atomic user stories with acceptance tests.
- Technical Decomposer: Produce ordered tasks, tests, and CI considerations.
- Architecture Guardian: Check a change against ADRs and list violations (advisory).
- Refactor Auditor: Evaluate refactor diffs for regression risks and required tests.
- ADR Generator: Produce MADR-style ADR drafts given a decision summary.

Troubleshooting Hierarchy
- general-troubleshooter
  - software-architect
    - go-specialist
    - python-specialist
    - javascript-specialist
    - iac-specialist
    - shell-specialist
    - dsa-specialist
  - infra-architect
    - k8s-troubleshooter
    - talos-troubleshooter
    - docker-troubleshooter

Project Hierarchy
- project-manager
  - mvp-clarifier
  - c4-architect
  - story-generator
  - technical-decomposer
  - architecture-guardian
  - refactor-auditor
  - adr-generator

Handoff protocol
- Use shared contract at `agents/_shared/handoff-protocol.md`.
- Delegate with `handoff_input` including evidence_gathered and layers_cleared.
- Every troubleshooting output must include `escalation`, `confidence`, and `rationale`.
- Use `lifecycle_handoff` only when diagnosis points to design/process work instead of an operational fix.

Lifecycle bridge (advisory)
- Troubleshooting agents should hand off to `project-manager` first for lifecycle routing.
- Troubleshooting agents can also directly recommend: mvp-clarifier, c4-architect, story-generator, technical-decomposer, architecture-guardian, adr-generator, or refactor-auditor when target is unambiguous.
- Lifecycle agents remain a separate planning/quality pipeline; do not auto-execute changes.

Project handoff protocol
- Use `agents/_shared/project-handoff-protocol.md` and `agents/_shared/project-handoff-schema.json` for lifecycle routing.
- Project outputs should include `handoff_next`, `confidence`, and `rationale`.

Manual-first operating model
- Do not automate end-to-end agent chains yet; run one step at a time and validate manually.
- Always start at a root router (`general-troubleshooter` for incidents, `project-manager` for lifecycle/planning).
- Treat all agent outputs as advisory until a human validates evidence and next commands.
- A human operator is responsible for running commands, applying changes, and deciding whether to continue handoffs.

Manual workflow (recommended)
1) Pick the correct root entrypoint (`general-troubleshooter` or `project-manager`).
2) Provide minimal, concrete context (symptom/request, environment, evidence, recent changes).
3) Capture structured output and check required fields (`confidence`, `rationale`, plus `escalation` or `handoff_next`).
4) Execute suggested verification commands manually and confirm/deny the hypothesis.
5) If unresolved, pass forward using `handoff_input` and preserve evidence/layers cleared.
6) If root cause is non-operational, route into lifecycle via `project-manager`.
7) Record outcome (confirmed cause, fix, verification) in the active repo docs/tracker.

Prompting conventions (always follow)
- Start with a short system role line.
- Provide limited, relevant artifacts: issue text, diff summary, links to ADRs.
- Limit sensitive data. Never include secrets.
- Request structured output (JSON with keys like summary, tasks, acceptance_criteria).
- Include an explicit "confidence" numeric field and short rationale for each recommendation.

Reusable prompt templates (replace placeholders)
- MVP Clarifier
  System: You are an expert product lead focused on delivering minimal viable value.
  User: Given idea: "{idea}" and constraints: {constraints}, output JSON: { "stories": [{"title": "...","acceptance_criteria":"...","success_metric":"..."}], "risks": [...], "confidence": 0-100 }
- C4 Architect
  System: You are a software architect using C4 models.
  User: From artifacts: {context_docs} and repo README, summarize Context, Containers, and recommend 3 implementation tasks. Output structured text and a short list of components.
- Story Generator
  System: You are a senior PM writing atomic user stories.
  User: From feature: {feature_text}, generate 3 stories with acceptance tests and estimated complexity (S/M/L).
- Technical Decomposer
  System: You are a technical lead who decomposes features into tasks.
  User: For feature: {feature_text}, output an ordered list of tasks with minimal implementation steps, required tests, and CI concerns.
- Architecture Guardian
  System: You are an architecture reviewer referencing ADRs.
  User: For PR diff: {diff_summary} and ADRs in {adr_links}, list potential ADR violations and suggested small corrective changes.
- Refactor Auditor
  System: You are a refactor safety auditor.
  User: For diff: {diff}, list regression risks, missing tests, and smoke test steps.
- ADR Generator
  System: You are an ADR author generator.
  User: Draft an ADR for decision: {title} with context, options, decision, consequences, and verification steps.

AI usage patterns
- Always require human approval for any code or ADR changes.
- Use AI outputs to seed tasks and tests, not to auto-merge.
- Store AI-generated artifacts as comments or issue bodies for traceability.
- Execution Boundaries: For infrastructure repositories, always verify the intended execution environment (e.g., Docker, DevContainer, Makefile wrappers) before suggesting CLI commands. Assume direct host execution is forbidden unless explicitly stated.

Example outputs & schema
- For decomposition: { "tasks": [{"id":"T1","title":"...","estimate":"...","depends_on":[] }], "tests":[...], "confidence": 72 }
- For ADR drafts: Provide a complete MADR-style markdown ready to copy to `docs/decisions/`.

Operational notes
- Configure AI workflows to run only for same-repository PRs.
- Label AI suggestions with `ai:suggestion`; they are advisory only.
