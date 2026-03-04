Security policy

Reporting a vulnerability
- Preferred method: Create a private repository issue labelled `security` and mention `@jay13jay`, or email security@<org-domain> if set up.
- If sensitive, use GitHub Security Advisories to communicate privately.

Response expectations
- Acknowledge within 48 hours.
- Provide a timeline for triage and remediation priority.

Secret handling
- Never commit secrets, credentials, or private keys to the repository.
- Workflows must not expose secrets to forked PRs. AI steps run only when the PR originates from the same repository.
- **No external AI API keys** (`OPENAI_API_KEY`, `ANTHROPIC_API_KEY`, or equivalents) are stored in repository or org secrets. CI/CD automation agents use **GitHub Models API** via the built-in `GITHUB_TOKEN`. Production services use cluster-internal inference endpoints only. See [ADR-0005](../mvp-control-plane/docs/decisions/ADR-0005-local-only-inference-policy.md).

Dependency management
- Dependabot is enabled to open PRs for dependency updates.
- Review and test dependency updates before merging.
- For critical vulnerabilities, prefer patch or minor fixes that minimize risk.

Disclosure policy
- Coordinate public disclosure with stakeholders and include remediation steps.
- Use Security Advisories to track fixes when needed.

Contact
- Primary contact: @jay13jay
- If private contact required, provide an off-GitHub secure channel.
