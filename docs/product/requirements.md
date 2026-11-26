# Product Requirements

## Product
AffiliateFlow AI is a semi-automated, faceless affiliate content operations platform. The first supported product input is a user-submitted Shopee affiliate URL. The platform must not assume access to Shopee APIs or scrape pages.

## Primary user
A solo affiliate publisher who wants AI-assisted research, content creation, approval and multi-channel publishing.

## Core user journey
1. User signs in.
2. User submits an affiliate link and optional product details/images.
3. System validates and stores the link without modifying its tracking parameters.
4. Research agent prepares a sourced product brief. Unknown facts remain explicitly unknown.
5. User reviews the product brief.
6. User creates a campaign and selects target platforms/content formats.
7. Strategy and copy agents create concepts, scripts and captions.
8. Creative pipeline generates permitted media assets.
9. QA checks factual accuracy, disclosure, copyright/provenance, format and link integrity.
10. User reviews an immutable content version and approves specific platform destinations.
11. Scheduler publishes only destinations with valid approval and active authorized connections.
12. Analytics workers ingest metrics from permitted APIs and affiliate reports.

## MVP scope
- Product link submission and manual product details.
- Product profile with source and verification timestamps.
- Campaign creation.
- AI-generated content ideas, scripts and captions.
- Image/video asset metadata and upload.
- QA checklist and hard-block rules.
- Versioned approval workflow.
- Export/download package for manual publishing.
- Social account connection model and connector interface.
- Publishing scheduler abstraction; live connectors only after API access/review.
- Basic performance dashboard and cost ledger.

## Explicitly out of scope for MVP
- Unapproved scraping or automated browsing of Shopee.
- Fake reviews, fabricated product experiences, fabricated discounts or performance claims.
- Fully autonomous public publishing without human approval.
- Automated paid ads, customer DMs, order placement or customer service.
- Guaranteeing commissions, conversions or revenue.

## Functional requirements
- FR-001: Users can submit, edit and archive products.
- FR-002: Duplicate affiliate URLs are detected using normalized URL fingerprints while preserving the original URL.
- FR-003: Product facts must include provenance: source, captured_at, confidence and verification status.
- FR-004: Agents return schema-validated structured outputs.
- FR-005: Campaigns can target multiple channels and content formats.
- FR-006: Content has immutable numbered versions.
- FR-007: Any content mutation creates a new version and invalidates prior approvals.
- FR-008: QA hard failures block approval.
- FR-009: Approval is scoped to content version + platform + social account.
- FR-010: Publishing requires valid approval, active account authorization and policy checks.
- FR-011: Publishing operations are idempotent and reconcile uncertain outcomes.
- FR-012: External API failures are recorded with safe, redacted diagnostics.
- FR-013: Analytics distinguish platform metrics from affiliate conversions/commissions.
- FR-014: AI usage and media costs are recorded by provider, model, task and campaign.
- FR-015: Users can pause all scheduled publishing with a kill switch.

## Non-functional requirements
- Security: encrypted secrets, least privilege, CSRF/auth protection, audit logging.
- Reliability: queue-based processing, retries with backoff, dead-letter handling.
- Privacy: user-owned assets and tokens are private by default.
- Observability: structured logs, correlation IDs and task traceability.
- Localization: Thai-first UI; UTC storage, Asia/Bangkok display.
- Accessibility: keyboard navigation, clear status labels and readable contrast.
