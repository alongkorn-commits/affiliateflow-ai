# Internal Event Contracts

All events include:
- `event_id`: UUID
- `event_type`: string
- `occurred_at`: ISO-8601 UTC
- `correlation_id`: UUID
- `actor`: `{ type, id }`
- `data`: event-specific object
- `schema_version`: integer

## product.research.requested
`{ product_id, owner_id, affiliate_link_id, user_notes? }`

## product.research.completed
`{ product_id, research_task_id, facts: [{ key, value, source, captured_at, confidence, verification_status }] }`

## content.strategy.requested
`{ campaign_id, product_id, target_platforms, requested_formats, constraints }`

## content.draft.created
`{ content_item_id, content_version_id, campaign_id }`

## content.qa.completed
`{ content_version_id, passed, hard_failures: [], warnings: [], checks: [] }`

## content.approved
`{ content_version_id, social_account_id, approval_id, content_hash }`

## publication.requested
`{ publication_id, content_version_id, social_account_id, approval_id, idempotency_key }`

Never include credentials, access tokens, raw secrets or unnecessary personal data in event payloads.
