Label taxonomy and usage

Philosophy
- Keep labels small, orthogonal, and machine-friendly.
- Separate concerns: type / priority / status / area / ai / debt / architecture.

Core sets

Type (mutually exclusive)
- type:bug — Bug report
- type:feature — New feature / enhancement
- type:refactor — Refactor / cleanup
- type:chore — Maintenance / infra
- type:architecture — Architectural work / ADR

Priority
- p0 — Blocker / Hotfix (red)
- p1 — High (orange)
- p2 — Medium (yellow)
- p3 — Low (green)

Status
- status:triage — Newly filed, needs acceptance criteria
- status:in-progress — Work in progress
- status:blocked — Blocked by external factor
- status:review — Ready for review
- status:done — Completed

AI and automation
- ai:suggestion — AI produced an advisory suggestion (non-blocking)
- ai:reviewed — Human reviewed AI output and accepted/recorded

Architecture & debt
- debt:technical — Technical debt
- debt:security — Security debt
- area:infra — Infra-related
- area:api — API-related
- area:ui — UI-related

Colors & usage notes
- Use clear contrasting colors (choose defaults from GitHub or adjust later).
- Apply one `type:` label and at most one `priority:` label per issue.
- Use `status:` labels to track lifecycle; automation can move labels on PR events.
- `ai:` labels are advisory markers and should not affect required checks.

Automation suggestions
- Add `ai:suggestion` when the AI workflow posts suggestions.
- Move `status:review` when a PR is opened with "ready for review".
- Do not automate owner assignment beyond the CODEOWNERS rules in early stages.
