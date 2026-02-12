# {Number}. {Title in Imperative Form}

Date: YYYY-MM-DD

## Status

{Proposed | Accepted | Deprecated | Superseded by [ADR-XXXX](./XXXX-title.md)}

## Context

{Describe the problem or opportunity that requires a decision. Include relevant background information, constraints, and forces at play. Answer: What is the issue we're addressing? Why does it matter?}

## Decision Drivers

* {Driver 1 - e.g., "Performance requirements: < 100ms p95 latency"}
* {Driver 2 - e.g., "Team expertise in Go and Python"}
* {Driver 3 - e.g., "Budget constraints: minimize infrastructure costs"}
* {Driver 4 - e.g., "Compliance: SOC2/HIPAA requirements"}

## Considered Options

* {Option 1 - Briefly name the option}
* {Option 2}
* {Option 3}
* ... {additional options as needed}

## Decision Outcome

Chosen option: "{Option X}", because {concise justification that addresses key decision drivers}.

### Consequences

* Good, because {positive outcome or benefit}
* Good, because {another positive outcome}
* Bad, because {negative consequence or trade-off}
* Bad, because {another drawback}
* Neutral, because {non-obvious consequence that's neither clearly good nor bad}

## Pros and Cons of the Options

### {Option 1}

{Optional: Brief description if name wasn't self-explanatory}

* Good, because {argument a}
* Good, because {argument b}
* Bad, because {argument c}
* Neutral, because {argument d}

### {Option 2}

* Good, because {argument a}
* Good, because {argument b}
* Bad, because {argument c}
* Neutral, because {argument d}

### {Option 3}

{... continue for each considered option}

## Validation

{How will we verify this decision was correct? Include measurable success criteria.}

* {Verification method 1 - e.g., "Performance benchmarks show < 100ms p95 latency under realistic load"}
* {Verification method 2 - e.g., "Team completes first feature using this approach in < 2 weeks"}
* {Verification method 3 - e.g., "No security issues found in external audit"}

### Revisit Criteria

{Under what conditions should we reconsider this decision?}

* {Condition 1 - e.g., "If latency exceeds 200ms p95 after 3 months"}
* {Condition 2 - e.g., "If team struggles to implement features using this pattern"}

## Links

* {Link to related ADRs with [ADR-XXXX](./XXXX-title.md) format}
* {Link to relevant issues, e.g., [Feature #123](https://github.com/org/repo/issues/123)}
* {Link to external documentation, standards, or reference material}
* {Link to implementation PR if applicable}

---

## Notes

**For Organization-Level ADRs** (in `.github/docs/decisions/`):
- Focus on cross-cutting architectural patterns affecting multiple repositories
- Include impact on all relevant repos (Kerrigan, UI, Whisper-STT, MCP servers)
- Reference repository-level ADRs where implementation details are documented

**For Repository-Level ADRs** (in `{repo}/docs/decisions/`):
- Focus on implementation specifics for that repository
- Reference organization-level ADRs that constrain or guide the decision
- Include code structure and technology stack details

**Decision Drivers** should prioritize:
1. **Business/Product**: User value, time-to-market, MVP scope
2. **Technical**: Performance, scalability, maintainability
3. **Team**: Expertise, velocity, learning curve
4. **Compliance**: Security, privacy, regulatory requirements
5. **Cost**: Infrastructure, licensing, operational overhead

**Validation** should be:
- **Measurable**: Quantitative metrics preferred over subjective assessments
- **Time-bound**: Specify when to check (e.g., "within 3 months", "after MVP launch")
- **Actionable**: Clear criteria for success/failure leading to specific actions
