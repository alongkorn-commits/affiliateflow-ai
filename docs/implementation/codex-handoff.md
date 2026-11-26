# Codex Handoff — Read First

You are implementing AffiliateFlow AI from this repository scaffold. Do not rewrite the architecture without documenting an ADR.

## Current state
This repository contains requirements, architecture, a PostgreSQL schema reference, API outline, event contracts, Paperclip role specifications and local infrastructure. It does NOT yet contain a completed Laravel or React application.

## Non-negotiable rules
1. Laravel is the source of truth for all business data.
2. Paperclip is orchestration only.
3. No agent gets database credentials or social OAuth tokens.
4. Public publishing is disabled by default and requires human approval scoped to immutable content version + social account.
5. Do not scrape Shopee or assume Affiliate Open API access.
6. Do not fake integrations. Use interfaces, mocks and explicit `not_configured` states until credentials and API approval exist.
7. Never commit secrets.
8. Use Thai-first UX, English code identifiers, UTC storage and Asia/Bangkok display.
9. Add tests for all state transitions, authorization, approval invalidation and publishing idempotency.
10. Keep scope focused. Finish one milestone, run tests, report exact files changed and blockers.

## Milestone 0 — Repository audit
- Inspect current repository and preserve useful existing work.
- Identify installed versions and package manager.
- Create `docs/implementation/implementation-status.md`.
- Do not overwrite user code without explaining.

## Milestone 1 — Backend foundation
- Install/configure Laravel 12 in `apps/api`.
- Add Sanctum authentication.
- Add PostgreSQL and Redis configuration.
- Convert `docs/database/schema.sql` into Laravel migrations (improve FK ordering and cyclic content version relation).
- Add models, factories and seeders.
- Add request validation, policies and API resources.
- Add feature tests.
- Implement modules: Identity, Products, Campaigns, Content, Approvals, SocialAccounts, Publishing, Analytics, AI Orchestration, Audit.

Acceptance:
- Authenticated user can create/list/update own products.
- Cross-user access is denied.
- Product URL validation preserves affiliate query parameters.
- Tests pass.

## Milestone 2 — Frontend foundation
- Create React + TypeScript + Vite.
- Use Mantine and Tabler Icons.
- Implement responsive Thai-first layout.
- Screens: Login, Dashboard, Products, Product Detail, Campaigns, Content Studio, Approval Center, Calendar, Social Accounts, Analytics, Settings.
- Use typed API client and loading/empty/error states.
- Do not use mock data in production views; seed demo data only in local environment.

Acceptance:
- User can submit a product and see its status.
- UI works on desktop and mobile widths.

## Milestone 3 — AI task integration
- Define provider-neutral AI interface.
- Add Paperclip adapter behind `AgentOrchestrator` interface.
- Use mock adapter in tests.
- Add task lifecycle, callback/webhook signature validation, idempotency and correlation IDs.
- Implement Product Research and Strategy/Copy tasks with JSON schema validation.
- Add prompt-injection boundary and output validation.

Acceptance:
- Product research can be queued, completed with structured output, and reviewed.
- Provider failures are visible and recoverable.

## Milestone 4 — Content & media
- Implement immutable content versions.
- Add asset storage abstraction (local/MinIO/S3).
- Add image generation provider interface, TTS interface and FFmpeg worker.
- Generate only from approved briefs and authorized assets.
- Add deterministic media validation and QA checklist.

Acceptance:
- One campaign can produce a versioned image/video package.
- Editing creates a new version and invalidates approvals.

## Milestone 5 — Approval & export
- Implement per-version, per-account approval.
- Implement preview, reject-with-feedback, revision and export ZIP.
- Implement kill switch.
- Add tests proving agents cannot approve or publish.

Acceptance:
- No publication can be queued without valid approval.
- Export works even without social API credentials.

## Milestone 6 — Social connector framework
- Define `SocialPublisher` interface and per-platform adapters.
- Start with mock connector and one platform only after developer has valid API credentials.
- Implement OAuth securely, token encryption, scopes, expiry and revoke.
- Implement idempotency and UNKNOWN/reconciliation state.
- Respect platform API review and content policies.

Acceptance:
- Mock connector tests pass.
- Live connector is disabled unless configured and authorized.

## Milestone 7 — Analytics & hardening
- Metric snapshots, affiliate report import, cost records.
- Audit logs, rate limits, monitoring, backups and security tests.
- End-to-end test from product intake to approved export.
- Add deployment guide and threat model.

## Required final report after each milestone
- Summary
- Files created/changed
- Commands run
- Test results
- Known limitations
- Next milestone recommendation

Do not claim the product is production-ready until live security review, platform API approval, backup/restore tests and end-to-end tests are complete.
