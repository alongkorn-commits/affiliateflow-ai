# Workflow Specifications

## A. Product intake
User submits URL and optional details → validate allowed URL scheme/domain → preserve exact affiliate URL → calculate duplicate fingerprint → create product/source records → enqueue research task.

Research output must be structured and cite evidence. Missing facts are `unknown`, not inferred. User confirmation is required for uncertain product identity or price.

## B. Strategy
Research completed → strategist produces audience hypotheses, value proposition, 3 content angles, platform adaptations and risk notes → persist strategy revision → user may edit or accept.

## C. Content production
Accepted strategy → copywriter generates hook, script, shot list, voiceover, captions, CTA and disclosure → creative brief → media worker generates assets → persist immutable content version and assets.

## D. QA
Run deterministic checks first (required fields, disclosure, link, dimensions, duration, file integrity, prohibited claims). Then AI review for clarity and consistency. Hard failures block approval. AI score cannot override hard failures.

## E. Approval
Show preview, source facts, disclosure, target platform and final caption. Approval is scoped to exact version + destination. Any edit creates a new version and resets approval.

## F. Publishing
Scheduler acquires lock → verify kill switch, approval, account status, token validity, platform constraints and idempotency key → submit via connector → record remote ID and status. For timeout/unknown result, reconcile before retrying.

## G. Analytics
Fetch metrics only through permitted APIs or user-provided affiliate reports. Store snapshots with source and captured_at. Never conflate views/clicks with affiliate orders or commissions.

## State machine
Content:
DRAFT → GENERATING → QA_PENDING → QA_FAILED | QA_PASSED → PENDING_APPROVAL → APPROVED | REJECTED → SCHEDULED → PUBLISHING → PUBLISHED | FAILED | BLOCKED

Any content edit creates a new version in DRAFT and requires QA and approval again.

Publication:
PENDING → SCHEDULED → QUEUED → SUBMITTING → PUBLISHED
Alternative states: FAILED, BLOCKED, UNKNOWN (remote result uncertain), CANCELLED.

A publication in UNKNOWN must be reconciled before retry.
