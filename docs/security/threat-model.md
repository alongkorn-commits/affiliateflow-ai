# Threat Model & Security Checklist

## Threats
- Prompt injection embedded in product pages, user notes, images or imported reports.
- Credential leakage through logs, agent context, source maps or Git.
- Unauthorized agent actions or privilege escalation.
- Accidental public posting without approval.
- Duplicate publishing after timeout/retry.
- Malicious uploads and media parser vulnerabilities.
- Cross-user data access.
- OAuth token theft or excessive scopes.
- Copyright/trademark misuse and false product claims.

## Controls
- Treat external content as data, never instructions.
- Allowlist tools and endpoints per agent role.
- No DB or social token access for agents.
- Encrypt OAuth tokens at rest; rotate keys; redact logs.
- Least-privilege OAuth scopes and revoke support.
- Enforce owner policies on every query/mutation.
- Require approval tied to immutable content hash and destination.
- Use transactional outbox, idempotency keys and reconciliation.
- Validate MIME by file content, limit file size/duration, scan uploads.
- Keep generated assets private until user approval.
- Rate-limit endpoints and enforce campaign/user budgets.
- Maintain audit logs for approvals, connections and publishing.
- Add global publishing kill switch.
- Run dependency scanning and security tests before deployment.
