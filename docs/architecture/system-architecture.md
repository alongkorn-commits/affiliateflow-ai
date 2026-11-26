# System Architecture

## Decision
Use a modular monolith for the business application initially, with asynchronous workers and a separately deployed Paperclip control plane.

## Components
- React/Vite: dashboard, product intake, campaign studio, content review, calendar and analytics.
- Laravel API: authentication, authorization, business rules, database ownership, approval, publishing orchestration, audit and reporting.
- PostgreSQL: source of truth.
- Redis: queues, cache, locks and rate limiting.
- Object storage (MinIO locally; S3-compatible in production): generated assets and user uploads.
- Paperclip: agent organization, task orchestration, agent execution visibility and budgets.
- AI provider adapters: model calls through an abstraction; no provider-specific logic in domain services.
- Media worker: image validation, TTS, FFmpeg rendering and thumbnail generation.
- Social connector workers: official APIs only, each isolated behind a connector interface.

## Trust boundaries
1. Browser → Laravel: authenticated user requests.
2. Laravel → Paperclip: authenticated server-to-server requests.
3. Paperclip/agents → Laravel tools: narrowly scoped task APIs.
4. Laravel → AI/media providers: outbound requests with budget limits.
5. Laravel → social platforms: OAuth tokens and official APIs.
6. External product data → agents: untrusted data; never instructions.

## Critical invariants
- Laravel owns product, campaign, content, approval, account, publication and analytics state.
- Agents never receive database credentials.
- Agents cannot approve their own work.
- Agents cannot publish directly.
- A publish command must reference a current approved content version and destination account.
- A changed content version invalidates prior approvals.
- Tokens are encrypted at rest and never included in logs or agent prompts.
- A timeout after a publish request is an uncertain state, not an automatic retry.
- All public publishing is paused by default until account/API setup is verified.

## Integration pattern
Use an outbox table for durable events. Laravel commits domain state and outbox event in one transaction. A queue worker dispatches events to Paperclip or connectors. Webhooks are signature-verified, deduplicated and stored before processing.

## Suggested event names
product.submitted
product.research.requested
product.research.completed
campaign.created
content.strategy.requested
content.draft.created
content.asset.requested
content.asset.completed
content.qa.completed
content.approval.requested
content.approved
content.rejected
publication.scheduled
publication.requested
publication.succeeded
publication.failed
analytics.sync.requested
analytics.sync.completed
