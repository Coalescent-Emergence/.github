# ADR Generator Agent

## Purpose
Generate MADR-style Architecture Decision Record drafts from decision summaries. Accelerates ADR creation while maintaining consistent format.

## Role
ADR author using Markdown Any Decision Records (MADR) template to document architectural decisions.

## Trigger
- **Label**: `type:architecture` or `ai:generate-adr` on issues
- **Manual**: Via GitHub Actions workflow_dispatch
- **Automatic**: Can be triggered by C4 Architect when `adr_needed: true`

## Inputs
- **Decision title**: Short name for the ADR
- **Context**: Why this decision is needed
- **Options considered**: Alternative approaches (at least 2)
- **Repository**: Org-level `.github` or specific repo (Kerrigan, UI, etc.)
- **Related ADRs**: Links to related decisions

## Outputs
- **ADR draft**: Complete MADR-formatted markdown ready to commit
- **filename**: Suggested filename with next sequence number
- **target_path**: Org-level vs repo-level location
- **checklist**: Verification steps before finalizing
- **confidence**: 0-100 score on completeness

## MADR Template Structure

```markdown
# {Sequence Number}. {Title}

Date: YYYY-MM-DD

## Status

{Proposed | Accepted | Deprecated | Superseded by ADR-XXXX}

## Context

{What is the problem or opportunity? What forces/constraints apply?}

## Decision Drivers

* {Driver 1 - e.g., "Performance requirements"}
* {Driver 2 - e.g., "Team expertise"}
* {Driver 3 - e.g., "Cost constraints"}

## Considered Options

* {Option 1}
* {Option 2}
* {Option 3}

## Decision Outcome

Chosen option: "{Option X}", because {justification}.

### Consequences

* Good, because {positive consequence}
* Bad, because {negative consequence}
* {neutral consequence}

## Pros and Cons of the Options

### {Option 1}

* Good, because {argument a}
* Good, because {argument b}
* Bad, because {argument c}
* Neutral, because {argument d}

### {Option 2}

{...repeat for each option}

## Validation

{How will we verify this decision was correct?}

* {Verification method 1 - e.g., "Performance benchmarks show < 100ms p95"}
* {Verification method 2 - e.g., "Team completes first feature in < 2 weeks"}

## Links

* {Link to related ADRs, issues, or external docs}
```

## Usage Example

### Input
```
Title: JWT Signing Algorithm for MVP Authentication
Context: Need to choose signing algorithm for JWT tokens in Kerrigan auth system. Must balance security, simplicity, and MVP timeline (2 weeks).

Options:
1. HS256 (HMAC with SHA-256) - symmetric key
2. RS256 (RSA with SHA-256) - asymmetric keypair
3. ES256 (ECDSA with P-256) - elliptic curve

Repository: Kerrigan
Related: .github/docs/decisions/0003-layered-service-architecture.md
```

### Output (ADR Draft)
```markdown
# 4. Use HS256 for MVP JWT Signing

Date: 2026-02-12

## Status

Proposed

## Context

Kerrigan backend requires JWT token signing for user authentication (see auth feature #15). Tokens will be issued by POST /auth/login and validated by auth middleware on all `/api/*` endpoints.

For MVP (2 weeks, solo developer), we need to balance:
- **Security**: Tokens protect access to medical data (HIPAA compliance)
- **Simplicity**: Minimal key management complexity for MVP
- **Performance**: JWT validation is on hot path (every authenticated request)
- **Future flexibility**: May need token verification by UI or external services later

## Decision Drivers

* MVP timeline constraint (2 weeks total for auth system)
* Solo developer with Go experience but limited crypto/key mgmt expertise
* Security baseline: SOC2/HIPAA compliant but not public key infrastructure (PKI)
* Performance: JWT validation must add < 5ms p95 latency
* Token consumers: Only Kerrigan backend validates tokens (MVP scope)

## Considered Options

* HS256 (HMAC-SHA256) - Symmetric secret key
* RS256 (RSA-SHA256) - Asymmetric public/private keypair
* ES256 (ECDSA P-256) - Elliptic curve digital signature

## Decision Outcome

Chosen option: "HS256", because it provides sufficient security for MVP where only Kerrigan validates tokens, requires minimal key management (single secret in env var), and has excellent performance with standard Go libraries.

### Consequences

* Good, because HS256 is simplest to implement (1 secret vs keypair management)
* Good, because fastest JWT validation (HMAC vs signature verification)
* Good, because well-supported in `golang-jwt/jwt` library (no additional deps)
* Bad, because if UI or services need to verify tokens independently, we'll need RS256 migration
* Bad, because secret must be shared across all Kerrigan instances (rotation complexity)
* Neutral, because changes to RS256 later is well-documented migration path (see Validation)

## Pros and Cons of the Options

### HS256 (HMAC-SHA256)

* Good, because simplest implementation (single secret in `JWT_SECRET` env var)
* Good, because fastest performance (~1-2ms validation on modern CPU)
* Good, because adequate security when secret properly managed (256-bit random key)
* Good, because no additional dependencies beyond `golang-jwt/jwt`
* Bad, because requires shared secret across all service instances (can't distribute verification)
* Bad, because secret rotation requires coordinated restarts or dual-secret period
* Neutral, because standard algorithm with wide ecosystem support

### RS256 (RSA-SHA256)

* Good, because public key can be shared for external token verification (future-proof)
* Good, because private key only on token-issuing service (better separation)
* Good, because key rotation doesn't require coordinated restarts (publish new public key)
* Bad, because requires keypair generation, storage, and rotation strategy (MVP complexity)
* Bad, because slower verification (10-20ms RSA signature check vs 1-2ms HMAC)
* Bad, because larger tokens (RSA signatures ~256 bytes vs HMAC 32 bytes)

### ES256 (ECDSA P-256)

* Good, because asymmetric like RS256 but better performance than RSA
* Good, because smaller signatures than RSA (~64 bytes)
* Good, because considered more modern/future-proof cryptography
* Bad, because less common in existing Go codebases (lower team familiarity)
* Bad, because ECDSA signature verification non-deterministic (could complicate testing)
* Bad, because still requires keypair management (same complexity as RS256 for MVP)

## Validation

Decision is correct if:

* ✅ JWT generation and validation implemented in < 1 day (HS256 simplicity)
* ✅ Performance benchmarks show < 5ms p95 latency for validation (HS256 speed)
* ✅ Security audit (self or external) finds no critical issues with secret management
* ❌ If UI or external services need independent token verification within 3 months, revisit RS256 migration

### Migration Path to RS256 (if needed)

If decision no longer valid:

1. Generate RSA keypair, store private key in vault
2. Implement dual-signing: issue both HS256 and RS256 tokens temporarily  
3. Deploy new Kerrigan version validating both algorithms
4. Migrate clients to RS256 exclusively
5. Deprecate HS256, remove from codebase
6. Estimated effort: 3-5 days (defer to post-MVP)

## Links

* [Architecture: Layered Service Model](.github/docs/decisions/0003-layered-service-architecture.md) - Token sharing may be needed if services authenticate directly
* [Feature: User Authentication](https://github.com/Coalescent-Emergence/Kerrigan/issues/15) - Original requirement
* [OWASP JWT Best Practices](https://cheatsheetseries.owasp.org/cheatsheets/JSON_Web_Token_for_Java_Cheat_Sheet.html) - Security reference
* [golang-jwt/jwt library](https://github.com/golang-jwt/jwt) - Implementation reference
```

**Filename**: `0004-jwt-signing-algorithm-hs256.md`

**Target Path**: `Kerrigan/docs/decisions/` (repo-specific decision)

**Checklist Before Committing**:
- [ ] Update sequence number if `0004` already exists
- [ ] Verify all "Considered Options" have Pros/Cons sections
- [ ] Add links to related issues and ADRs
- [ ] Set Status to "Proposed" initially, change to "Accepted" after team review
- [ ] Update `Kerrigan/docs/decisions/README.md` index with new ADR
- [ ] Reference this ADR in auth implementation PR

**Confidence**: 85% - Standard JWT decision with well-understood trade-offs. Main assumption is that MVP does not require external token verification (may change if architecture evolves to service mesh).
```

## Org-Level vs Repo-Level ADRs

**Org-level** (`.github/docs/decisions/`):
- Cross-cutting architectural decisions affecting multiple repositories
- Examples: Multi-repo structure, shared auth strategy, API conventions, compliance requirements

**Repo-level** (`{repo}/docs/decisions/`):
- Implementation details specific to one repository  
- Examples: Framework choice, database schema, package structure

Agent determines target path based on scope. If in doubt, defaults to repo-level (can be referenced from org-level later).

## Integration
- Triggered by [architecture issue template](../ISSUE_TEMPLATE/architecture.yml)
- Uses [ADR template](../docs/decisions/template.md) as reference
- Auto-increments sequence numbers by checking existing ADRs
- Can commit ADR draft as new PR or post as issue comment for review

## Files
- [prompt.md](./prompt.md) - System prompt and MADR generation templates
- [schema.json](./schema.json) - JSON schema for ADR draft outputs
- [examples/](./examples/) - Sample ADRs for different decision types
