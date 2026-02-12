# Refactor Auditor Agent

## Purpose
Evaluate refactoring pull requests for regression risks, missing tests, and rollback safety. Ensures refactors improve code without breaking functionality.

## Role
Refactor safety auditor focusing on non-functional changes, test coverage, and deployment risk.

## Trigger
- **Label**: `type:refactor` on pull requests
- **Manual**: Via GitHub Actions workflow_dispatch

## Inputs
- **PR diff**: Complete file changes
- **PR description**: Refactor rationale and scope
- **Existing tests**: Test files modified/added
- **Metrics** (optional): Code coverage before/after, performance benchmarks

## Outputs
PR comment with:
- **regression_risks**: Potential breaking changes with:
  - `risk_type`: behavior_change, performance, compatibility, security
  - `severity`: low, medium, high
  - `description`: What could break
  - `affected_code`: File paths
  - `mitigation**: How to reduce risk
- **test_coverage**: Assessment of test additions/changes
- **smoke_test_steps**: Manual verification checklist
- **rollback_plan**: How to revert if issues discovered
- **confidence**: 0-100 score

## Refactor Categories

### Safe Refactors (Lower Risk)
- Renaming variables/functions with IDE refactor tools
- Extracting pure functions
- Moving code between files without logic changes
- Formatting/linting fixes
- Adding types/annotations

### Moderate Refactors
- Changing algorithm implementation (same behavior)
- Restructuring packages/modules
- Updating dependencies (minor versions)
- Performance optimizations
- Adding error handling

### High-Risk Refactors
- Changing core business logic flow
- Database schema migrations
- API contract changes
- Dependency major version upgrades
- Concurrency/threading changes

## Usage Example

### Input
PR in Kerrigan refactoring auth middleware from hand-rolled JWT validation to using a third-party library.

**Diff Summary**:
- Removed `internal/auth/jwt.go` (150 lines)
- Modified `internal/middleware/auth.go` to use `github.com/go-chi/jwtauth/v5`
- Updated tests in `internal/middleware/auth_test.go`

### Output (Posted as PR Comment)
```markdown
### 🔍 Refactor Audit Report

**Refactor Type**: Dependency introduction (third-party JWT library)  
**Risk Level**: ⚠️ Medium

#### Regression Risks

##### ⚠️ Medium: Token Validation Logic Change
- **Risk Type**: behavior_change
- **Description**: Previous custom JWT validation used specific claim checks (expiry with 30s clock skew, required claims: user_id, email). New library may have different defaults for clock skew, claim validation, or error messages.
- **Affected Code**: 
  - `internal/middleware/auth.go:25-50`
  - Impacts all `/api/*` protected endpoints
- **Mitigation**: 
  - Add integration tests comparing old and new validation behavior with edge cases (expired tokens, missing claims, invalid signatures)
  - Verify clock skew tolerance matches previous 30s
  - Test error responses match expected format for client compatibility
- **Severity**: Medium - Core functionality change, but JWT validation is well-standardized

##### 🔴 Medium: Dependency Security Surface
- **Risk Type**: security
- **Description**: Introducing dependency `github.com/go-chi/jwtauth/v5` (last updated 8 months ago, moderate activity). Dependency now controls critical security function (token validation).
- **Affected Code**: All authenticated requests
- **Mitigation**:
  - Run `go list -m -u all` to check for known vulnerabilities
  - Add Dependabot to monitor for security updates
  - Review library's issue tracker for open security concerns
  - Pin to specific version in go.mod (already done: v5.3.0 ✅)
- **Severity**: Medium - Acceptable trade-off for maintained library, but requires monitoring

##### 🟡 Low: Performance Impact
- **Risk Type**: performance
- **Description**: Library may have different performance characteristics than hand-rolled validation. JWT validation is hot path (every authenticated request).
- **Affected Code**: Request latency p95/p99
- **Mitigation**:
  - Run benchmark tests before/after: `go test -bench=BenchmarkJWTValidation`
  - Load test with realistic traffic to compare latencies
  - Library likely optimized, but verify no significant regression
- **Severity**: Low - JWT validation typically < 1ms, unlikely to be bottleneck

#### Test Coverage Analysis

**Tests Modified**: ✅ Good coverage
- `internal/middleware/auth_test.go`: Updated 6 existing tests, added 2 new edge cases
- Covers: valid token, expired token, invalid signature, missing claims, malformed token

**Missing Tests**: ⚠️ Recommendations
- **Clock skew edge case**: Test token expiry exactly at 30s boundary (previous logic allowed, verify library matches)
- **Concurrent token validation**: Load test with high concurrency (library may use global state)
- **Error message compatibility**: If clients parse error messages, verify format unchanged

**Coverage Metrics**: 
- Previous: 87% in `internal/auth/`
- After refactor: 82% in `internal/middleware/` (decreased because library handles validation internally)
- **Recommendation**: Acceptable decrease - library has own tests, focus on integration-level coverage

#### Smoke Test Checklist

Manual verification steps before merging:

- [ ] Deploy to staging environment
- [ ] Generate JWT using existing auth endpoint, verify accepted by refactored middleware
- [ ] Test with expired token (> 15 min old), verify 401 response
- [ ] Test with missing Authorization header, verify 401 response  
- [ ] Test with malformed token, verify 401 with appropriate error message
- [ ] Verify existing user sessions (refresh tokens) still valid after deployment
- [ ] Load test with realistic traffic for 5 minutes, compare latency to baseline
- [ ] Check logs for unexpected errors or warnings

#### Rollback Plan

**If regression detected post-deployment:**

1. **Immediate**: Revert PR (single commit, easily reversible)
   ```bash
   git revert <commit-hash>
   git push origin main
   ```

2. **Redeploy**: Previous version restores custom JWT validation logic

3. **Risk of rollback**: Low - no database migrations, no data format changes, auth logic is stateless

**Monitoring**: After deployment, monitor for 24 hours:
- Error rate on `/api/*` endpoints (expect < 0.1% baseline)
- p95 latency on authenticated requests (expect < 50ms increase)
- Failed login attempts (check for false rejections)

#### Overall Assessment

**Confidence**: 76%

**Rationale**: 
- ✅ Refactor reduces custom code (150 lines → library), good simplification
- ✅ Third-party library is maintained, widely used, and actively developed
- ⚠️ Behavior change in critical path (auth) requires thorough testing
- ⚠️ Test coverage slightly decreased (87% → 82%), but understandable given library handles internals
- ✅ Rollback plan is straightforward (no data migrations)

**Recommendation**: **Approve with conditions**
1. Add clock skew edge-case test
2. Run load test in staging, compare latencies  
3. Monitor closely for 24h post-deployment

If conditions met, refactor is net positive: reduced maintenance burden, leverages community-maintained code.

---
*Advisory analysis by Refactor Auditor agent - human reviewer makes final decision*
```

## Integration
- Triggered by `type:refactor` label from [LABELS.md](../LABELS.md)
- References [refactor issue template](../ISSUE_TEMPLATE/refactor.yml)
- Can link to CI coverage reports for before/after comparison
- Provides actionable checklist for PR reviewers

## Files
- [prompt.md](./prompt.md) - System prompt and refactor analysis templates
- [schema.json](./schema.json) - JSON schema for risk assessments
- [examples/](./examples/) - Sample refactor audits for different scenarios
