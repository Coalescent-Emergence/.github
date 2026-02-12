Security policy

Reporting a vulnerability
- Preferred method: Create a private repository issue labelled `security` and mention `@jay13jay`, or email security@<org-domain> if set up.
- If sensitive, use GitHub Security Advisories to communicate privately.

Response expectations
- Acknowledge within 48 hours.
- Provide a timeline for triage and remediation priority.

Secret handling
- Never commit secrets, credentials, or private keys to the repository.
- Store third-party API keys (e.g., `OPENAI_API_KEY`) in repository secrets or org secrets.
- Workflows must not expose secrets to forked PRs. AI steps run only when the PR originates from the same repository.

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
