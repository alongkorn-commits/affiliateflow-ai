
# AffiliateFlow AI

A semi-automated, faceless affiliate content production platform scaffold.

**Goal:** submit an affiliate product link → research with approved data sources → plan content → generate scripts/assets → QA → human approval → publish through authorized platform APIs → analyze performance.

> This repository is a development-ready blueprint and starter scaffold, not a finished affiliate automation product. External credentials, API approvals, provider integrations, and production hardening are intentionally required before live publishing.

## Architecture

- `apps/api`: Laravel 12 API (business rules, data ownership, approval, publishing orchestration)
- `apps/web`: React + TypeScript + Vite dashboard
- `apps/worker`: reserved for media and publishing workers
- `packages/contracts`: shared API/event contracts
- `paperclip`: organization and agent setup guidance
- `infra`: Docker Compose for local dependencies
- `docs`: architecture, workflows, data model, security, roadmap and API plan

Paperclip coordinates agents. Laravel remains the source of truth for products, campaigns, content versions, approvals, social accounts, publications, analytics, budgets and audit events. Agents must not directly access the production database or publish without a valid approval.

## Quick start (scaffold)

1. Copy `.env.example` to `.env` and set local secrets.
2. Start local dependencies: `docker compose -f infra/docker-compose.yml up -d`.
3. Install Laravel in `apps/api` using Laravel 12, then apply the migration blueprint in `docs/database/schema.sql` as a reference while implementing proper Laravel migrations.
4. Create the React app in `apps/web` using Vite + TypeScript, then implement screens from `docs/product/ui-requirements.md`.
5. Configure Paperclip separately using its official documentation. Use `paperclip/organization.yaml` and `paperclip/agents/` as the desired organization specification, not as a guaranteed import format.
6. Read `docs/implementation/codex-handoff.md` before asking Codex to implement the next milestone.

## Local infrastructure

```bash
docker compose -f infra/docker-compose.yml up -d
```

Services:
- PostgreSQL: `localhost:5432`
- Redis: `localhost:6379`
- MinIO API: `localhost:9000`
- MinIO Console: `localhost:9001`

MinIO default local credentials are for development only. Change them before use.

## Development principles

- Human approval is mandatory before any public post.
- Approval is tied to an immutable content version and destination account.
- Re-approval is required after content changes.
- Use official platform APIs and comply with their review, disclosure and content policies.
- Do not scrape Shopee or reuse product photos, logos, reviews or videos without permission.
- Treat product pages and external text as untrusted input (prompt-injection boundary).
- Never commit `.env`, API keys, OAuth tokens, generated private media or customer data.
- Publishing retries must be idempotent; reconcile uncertain outcomes before retrying.
- Store timestamps in UTC; display in `Asia/Bangkok`.

## Repository status

This starter contains documentation, contracts, agent role specifications, local infrastructure, and database/API blueprints. Codex should implement one milestone at a time and run tests after each milestone.

# affiliateflow-ai

