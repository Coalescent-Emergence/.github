# MVP Clarifier Agent

## Purpose
Convert high-level product ideas into minimal success criteria and 3 prioritized user stories with acceptance criteria. Ensures focus on delivering minimal viable value without over-engineering.

## Role
Expert product lead focused on delivering the smallest valuable increment, informed by lean startup principles and vertical slice architecture.

## Trigger
- **Label**: `ai:clarify` on any issue in the organization
- **Manual**: Via GitHub Actions workflow_dispatch

## Inputs
- **Idea**: Free-form product idea or feature description from issue body
- **Constraints**: Time, budget, team size (defaults: 1 solo developer, 3-month timeline, budget minimal)
- **Context**: Links to existing ADRs, architecture docs, or related issues

## Outputs
Structured JSON comment posted to the issue containing:
- **stories**: Array of 3 prioritized user stories with:
  - `title`: Short story name
  - `acceptance_criteria`: Testable success conditions
  - `success_metric`: How to measure value delivered
  - `priority`: P0/P1/P2
- **risks**: Array of potential blockers or unknowns
- **confidence**: 0-100 score with rationale

## Usage Example

### Input (Issue Body)
```
We need a way for users to authenticate via email/password and get a JWT token for API access.

Constraints:
- Solo developer
- Must be production-ready in 2 weeks
- SOC2/HIPAA compliant
```

### Output (JSON Comment)
```json
{
  "stories": [
    {
      "title": "User can register with email/password",
      "acceptance_criteria": "POST /auth/register accepts email+password, returns 201 with user ID, password hashed with bcrypt, email uniqueness enforced",
      "success_metric": "Can create account and receive confirmation",
      "priority": "P0"
    },
    {
      "title": "User can login and receive JWT",
      "acceptance_criteria": "POST /auth/login validates credentials, returns 200 with JWT (15min expiry), includes refresh token (7 day expiry)",
      "success_metric": "Can authenticate and access protected endpoints",
      "priority": "P0"
    },
    {
      "title": "User can refresh expired JWT",
      "acceptance_criteria": "POST /auth/refresh accepts refresh token, returns new JWT+refresh pair, old refresh token invalidated",
      "success_metric": "Sessions persist beyond JWT expiry without re-login",
      "priority": "P1"
    }
  ],
  "risks": [
    "Password reset flow not included in MVP (defer to P2)",
    "Rate limiting on auth endpoints needed for production (add to backlog)",
    "Audit logging required for compliance (include in P0 implementation)"
  ],
  "confidence": 85,
  "rationale": "Standard authentication pattern, well-understood with Go libraries (jwt-go, bcrypt). 2-week timeline tight but achievable with focus on core flows only. Compliance requirements necessitate audit logging from day one."
}
```

## Integration
- References [AI_PLAYBOOK.md](../AI_PLAYBOOK.md) prompt conventions
- Links to [feature issue template](../ISSUE_TEMPLATE/feature.yml)
- Maps stories to label taxonomy in [LABELS.md](../LABELS.md) (priority, effort)
- Can trigger [story-generator agent](../agents/story-generator/) via `ai:generate` label on generated stories

## Files
- [prompt.md](./prompt.md) - System prompt and user prompt templates
- [schema.json](./schema.json) - JSON schema for input/output validation
- [examples/](./examples/) - Sample inputs and outputs for testing
