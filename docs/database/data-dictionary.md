# Data Dictionary

## Core entities
- users: authenticated platform users.
- products: normalized product records; no assumption that Shopee data is available.
- product_sources: evidence and provenance for each product fact/source.
- affiliate_links: original and validated tracking URL; preserve query parameters.
- campaigns: marketing objective, audience, budget and status.
- content_items: logical content grouping.
- content_versions: immutable creative/copy snapshot.
- media_assets: image/video/audio files and provenance.
- social_accounts: connected platform identities; tokens encrypted.
- approvals: user decision scoped to exact content version and destination.
- publications: one delivery attempt/lifecycle per platform destination.
- publication_attempts: request/response metadata with secrets redacted.
- metric_snapshots: timestamped platform metric observations.
- affiliate_reports: imported affiliate performance/commission data.
- ai_tasks: business task mapped to Paperclip task ID.
- ai_runs: provider/model/token/time/status details.
- cost_records: model/media/storage costs.
- audit_logs: security-sensitive actions.
- outbox_events: durable integration events.

## Modeling rules
- Use UUID primary keys.
- Add created_at/updated_at to mutable entities.
- Keep content_versions immutable after creation.
- Store raw external payload only when allowed, minimize personal data and redact secrets.
- Add `source_type`, `source_reference`, `captured_at`, `confidence` and `verification_status` to sourced facts.
- Use decimal for currency, never float.
- Use JSONB only for provider/platform-specific metadata, not core relational invariants.
