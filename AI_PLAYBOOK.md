AI Playbook — Roles, Prompts, and Guardrails

Purpose
- Provide a concise, reusable AI playbook to assist the solo founder with decomposition, review, and ADR drafting. All AI outputs are advisory and require human review.

Roles & Responsibilities
- MVP Clarifier: Convert an idea into minimal success criteria and 3 prioritized stories.
- C4 Architect: Produce C4-context and container-level descriptions (textual) and identify components to implement.
- Story Generator: Create atomic user stories with acceptance tests.
- Technical Decomposer: Produce ordered tasks, tests, and CI considerations.
- Architecture Guardian: Check a change against ADRs and list violations (advisory).
- Refactor Auditor: Evaluate refactor diffs for regression risks and required tests.
- ADR Generator: Produce MADR-style ADR drafts given a decision summary.

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

Example outputs & schema
- For decomposition: { "tasks": [{"id":"T1","title":"...","estimate":"...","depends_on":[] }], "tests":[...], "confidence": 72 }
- For ADR drafts: Provide a complete MADR-style markdown ready to copy to `docs/decisions/`.

Operational notes
- Configure AI workflows to run only for same-repository PRs.
- Label AI suggestions with `ai:suggestion`; they are advisory only.
