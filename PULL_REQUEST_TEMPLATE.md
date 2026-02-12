Summary
- Brief description of changes (one paragraph).
- Link the issue this PR resolves using "Closes #<issue-number>" (required).

Checklist
- [ ] I have linked this PR to an existing issue (Closes #).
- [ ] CI is green (`ci` status check).
- [ ] I confirmed this change follows architecture decisions or created/updated an ADR in `docs/decisions/` (if applicable).
- [ ] I included/update tests and relevant documentation.
- [ ] I removed debugging code and feature flags are documented.

Architecture & ADR
- ADR required? If this change touches cross-cutting concerns or public APIs, create an ADR in `docs/decisions/` and reference it here.
- If you changed/added an ADR, ensure the ADR passes `adr-lint` check.

AI Review (advisory)
- AI-assisted decomposition requested? (see issue or PR comment)
- If AI suggestions were applied, summarize the changes:
  - AI suggestion ID / comment link:
  - Why accepted or rejected:

Entropy & Scope Reflection
- Estimate scope creep vs original issue: (smaller / same / larger)
- If larger, justify why and list mitigations.
- Identify technical debt introduced (if any) and planned remediation (or link to ticket).

Merge conditions (enforced)
- PR must include `Closes #<issue>` in body.
- Required status checks: `ci`, `pr-linked-issue`, `adr-lint` (if ADR files changed).
- At least one approval required before merge.

Notes
- This template enforces human architectural review; AI outputs are advisory only.
