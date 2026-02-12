# Technical Decomposer Agent

## Purpose
Break down user stories into ordered implementation tasks with tests and CI considerations. Provides a clear execution plan for developers.

## Role
Technical lead who decomposes stories into actionable tasks, identifies dependencies, and ensures test coverage.

## Trigger
- **Label**: `ai:decompose` on story/feature issues
- **Manual**: Via GitHub Actions workflow_dispatch

## Inputs
- **Feature/Story text**: From issue body
- **Repository**: Target repository
- **Tech stack**: Programming language, frameworks
- **Existing code structure**: Related files/packages

## Outputs
Structured JSON with:
- **tasks**: Ordered array of implementation steps with:
  - `id`: Unique identifier (T1, T2, ...)
  - `title`: Short task description
  - `description`: Detailed implementation notes
  - `depends_on`: IDs of prerequisite tasks
  - `estimate`: Hours or story points
  - `files_affected`: Expected files to create/modify
- **tests**: Required test coverage with:
  - `type`: unit, integration, e2e
  - `description`: What to test
  - `coverage_target`: Percentage
- **ci_considerations**: CI/CD pipeline impacts
- **confidence**: 0-100 score

## Usage Example

### Input
```
Story: User can login and receive JWT token

Repository: Kerrigan
Tech Stack: Go 1.23, Chi router, pgx (PostgreSQL), golang-jwt/jwt
```

### Output
```json
{
  "tasks": [
    {
      "id": "T1",
      "title": "Add JWT dependencies to go.mod",
      "description": "Add github.com/golang-jwt/jwt/v5 and golang.org/x/crypto/bcrypt to go.mod, run go mod tidy",
      "depends_on": [],
      "estimate": "0.5 hours",
      "files_affected": ["go.mod", "go.sum"]
    },
    {
      "id": "T2",
      "title": "Create auth package structure",
      "description": "Create internal/auth/ with files: handler.go (HTTP handlers), service.go (business logic), repository.go (DB access), jwt.go (token generation/validation), types.go (request/response structs)",
      "depends_on": ["T1"],
      "estimate": "1 hour",
      "files_affected": [
        "internal/auth/handler.go",
        "internal/auth/service.go",
        "internal/auth/repository.go",
        "internal/auth/jwt.go",
        "internal/auth/types.go"
      ]
    },
    {
      "id": "T3",
      "title": "Implement JWT generation and validation functions",
      "description": "In jwt.go: GenerateToken(userID, email) returns signed JWT with 15min expiry, ValidateToken(tokenString) returns claims or error. Use HS256 algorithm, read secret from env var JWT_SECRET",
      "depends_on": ["T2"],
      "estimate": "2 hours",
      "files_affected": ["internal/auth/jwt.go"]
    },
    {
      "id": "T4",
      "title": "Create login handler and route",
      "description": "Implement POST /auth/login handler: parse LoginRequest, call service.Authenticate(), return LoginResponse with JWT. Add route to main.go router",
      "depends_on": ["T2", "T3"],
      "estimate": "3 hours",
      "files_affected": [
        "internal/auth/handler.go",
        "internal/auth/types.go",
        "cmd/server/main.go"
      ]
    },
    {
      "id": "T5",
      "title": "Implement authentication service logic",
      "description": "In service.go: Authenticate(email, password) queries user from DB via repository, compares password with bcrypt.CompareHashAndPassword, generates JWT on success, returns error on failure. Use constant-time comparison to prevent timing attacks",
      "depends_on": ["T2"],
      "estimate": "2 hours",
      "files_affected": ["internal/auth/service.go"]
    },
    {
      "id": "T6",
      "title": "Implement user repository query",
      "description": "In repository.go: GetUserByEmail(email) queries users table with pgx, returns User struct with ID, email, password_hash. Handle not found error explicitly",
      "depends_on": ["T2"],
      "estimate": "1.5 hours",
      "files_affected": ["internal/auth/repository.go"]
    },
    {
      "id": "T7",
      "title": "Add audit logging for login attempts",
      "description": "Create internal/audit package, implement LogAuthEvent(userID, event, success, IP). Call from auth service on login success/failure. Write to audit_logs table",
      "depends_on": ["T5"],
      "estimate": "2 hours",
      "files_affected": [
        "internal/audit/logger.go",
        "internal/auth/service.go"
      ]
    },
    {
      "id": "T8",
      "title": "Implement rate limiting middleware",
      "description": "Create internal/middleware/ratelimit.go using golang.org/x/time/rate. Limit by IP to 5 req/min. Apply to /auth/* routes. Return 429 on limit exceeded",
      "depends_on": [],
      "estimate": "2.5 hours",
      "files_affected": [
        "internal/middleware/ratelimit.go",
        "cmd/server/main.go"
      ]
    }
  ],
  "tests": [
    {
      "type": "unit",
      "description": "Test JWT generation and validation with valid/invalid/expired tokens",
      "files": ["internal/auth/jwt_test.go"],
      "coverage_target": 90
    },
    {
      "type": "unit",
      "description": "Test service.Authenticate with correct/incorrect passwords, nonexistent user",
      "files": ["internal/auth/service_test.go"],
      "coverage_target": 85
    },
    {
      "type": "integration",
      "description": "Test POST /auth/login end-to-end with test database, verify JWT structure",
      "files": ["internal/auth/handler_test.go"],
      "coverage_target": 80
    },
    {
      "type": "integration",
      "description": "Test rate limiting with rapid login attempts, verify 429 response",
      "files": ["internal/middleware/ratelimit_test.go"],
      "coverage_target": 75
    }
  ],
  "ci_considerations": [
    "Add JWT_SECRET to GitHub Actions secrets for CI test runs",
    "May need Docker Compose with PostgreSQL for integration tests in CI",
    "Rate limit tests may be flaky in slow CI environments - use time mocking",
    "Audit log tests need database cleanup between runs"
  ],
  "confidence": 83,
  "rationale": "Standard Go backend task decomposition following repository pattern. Tasks ordered to minimize blocking - JWT utils can be built in parallel with repository layer. Estimates based on typical developer velocity (assumes familiarity with Go). Main uncertainty is rate limiting complexity - golang.org/x/time/rate may need custom wrapper for IP-based limiting. Test coverage targets slightly lower than ideal due to time constraints, focus on critical paths first."
}
```

## Integration
- References code structure from repository architecture.md
- Links to [CI workflow](../../workflows/ci.yml) for automation
- Can trigger issue sub-tasks if `create_subtasks: true`
- Coordinates with [Story Generator](../agents/story-generator/) output

## Files
- [prompt.md](./prompt.md) - System prompt and decomposition templates
- [schema.json](./schema.json) - JSON schema for task outputs
- [examples/](./examples/) - Sample task breakdowns for different tech stacks
