# Story Generator Agent

## Purpose
Create atomic, independently deliverable user stories from high-level features. Each story includes acceptance criteria and estimated complexity (S/M/L).

## Role
Senior product manager with expertise in vertical slice architecture and testable story decomposition.

## Trigger
- **Label**: `ai:generate` on feature issues
- **Manual**: Via GitHub Actions workflow_dispatch
- **Automatic**: Can be invoked by MVP Clarifier output

## Inputs
- **Feature text**: Description from issue body or MVP Clarifier output
- **Repository**: Target repository
- **Constraints**: Timeline, team size
- **Existing stories**: Related stories to avoid duplication

## Outputs
Structured JSON or new GitHub issues:
- **stories**: Array of 3+ atomic stories with:
  - `title`: User-facing story in "User can..." format
  - `acceptance_criteria`: Specific, testable conditions
  - `complexity`: S (1-2 days), M (3-5 days), L (1-2 weeks)
  - `dependencies`: Other stories that must complete first
  - `test_strategy`: Unit, integration, or E2E tests needed
- **confidence**: 0-100 score

## Story Quality Criteria
- **Atomic**: Deliverable in one PR, single purpose
- **Testable**: Acceptance criteria verifiable via automated tests
- **Vertical**: Touches all layers (UI → API → DB if applicable)
- **Independent**: Minimal dependencies on other stories
- **Valuable**: Delivers user-visible or technical value

## Usage Example

### Input
```
Feature: User authentication for Kerrigan backend

From MVP Clarifier:
- User can register with email/password
- User can login and receive JWT
- User can refresh expired JWT

Repository: Kerrigan
Constraints: 2 weeks, solo developer
```

### Output
```json
{
  "stories": [
    {
      "title": "User can register with email and password",
      "acceptance_criteria": [
        "POST /auth/register accepts JSON with email and password fields",
        "Returns 201 with user ID on success",
        "Returns 400 if email already exists",
        "Returns 422 if email invalid or password < 8 characters",
        "Password stored as bcrypt hash (cost 12)",
        "Email uniqueness enforced at database level with unique index",
        "Audit log records registration event with timestamp and source IP"
      ],
      "complexity": "M",
      "dependencies": [],
      "test_strategy": "Unit tests for validation logic, integration tests for POST /auth/register endpoint, verify DB constraint enforcement",
      "repository": "Kerrigan",
      "labels": ["type:feature", "area:auth", "effort:medium"]
    },
    {
      "title": "User can login and receive JWT token",
      "acceptance_criteria": [
        "POST /auth/login accepts email and password",
        "Returns 200 with JWT (15min expiry) and refresh token (7 day expiry) on valid credentials",
        "Returns 401 on invalid credentials with generic message",
        "JWT includes user ID, email, issued-at, and expiry claims",
        "Refresh token stored hashed in database with user association",
        "Rate limited to 5 login attempts per minute per IP",
        "Audit log records all login attempts (success and failure)"
      ],
      "complexity": "M",
      "dependencies": ["User can register with email and password"],
      "test_strategy": "Unit tests for JWT generation and validation, integration tests for login flow, load tests for rate limiting",
      "repository": "Kerrigan",
      "labels": ["type:feature", "area:auth", "effort:medium"]
    },
    {
      "title": "User can refresh JWT using refresh token",
      "acceptance_criteria": [
        "POST /auth/refresh accepts refresh token in request body",
        "Returns 200 with new JWT and new refresh token on valid refresh token",
        "Returns 401 if refresh token invalid or expired",
        "Old refresh token invalidated (one-time use)",
        "New refresh token has refreshed 7-day expiry",
        "Audit log records refresh events"
      ],
      "complexity": "S",
      "dependencies": ["User can login and receive JWT token"],
      "test_strategy": "Integration tests for refresh flow, verify token invalidation, test expired token handling",
      "repository": "Kerrigan",
      "labels": ["type:feature", "area:auth", "effort:small"]
    },
    {
      "title": "Protected endpoints validate JWT in Authorization header",
      "acceptance_criteria": [
        "Middleware extracts JWT from 'Authorization: Bearer <token>' header",
        "Returns 401 if JWT missing, malformed, or expired",
        "Returns 403 if JWT valid but user lacks required permissions (future-proofing)",
        "Populates request context with authenticated user ID",
        "Middleware applied to all /api/* routes except /auth/*",
        "Performance: JWT validation adds < 5ms p95 latency"
      ],
      "complexity": "M",
      "dependencies": ["User can login and receive JWT token"],
      "test_strategy": "Unit tests for middleware logic, integration tests with mock protected endpoint, load tests for latency",
      "repository": "Kerrigan",
      "labels": ["type:feature", "area:auth", "effort:medium"]
    }
  ],
  "confidence": 88,
  "rationale": "Standard authentication pattern decomposed into independent stories. Each story is vertical (endpoint → validation → database) and testable. Added middleware story to make auth actually usable - not in original MVP Clarifier output but necessary for completeness. Complexity estimates based on typical Go implementation with standard libraries. S=1-2 days, M=3-5 days."
}
```

## Integration
- Maps to [feature issue template](../ISSUE_TEMPLATE/feature.yml)
- Uses label taxonomy from [LABELS.md](../LABELS.md)
- Can create child issues automatically if `create_issues: true`
- Links to [Technical Decomposer](../agents/technical-decomposer/) for further task breakdown

## Files
- [prompt.md](./prompt.md) - System prompt and story generation templates
- [schema.json](./schema.json) - JSON schema for story outputs
- [examples/](./examples/) - Sample story generation outputs
