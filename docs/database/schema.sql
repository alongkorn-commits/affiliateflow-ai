-- PostgreSQL reference schema. Codex should convert this into Laravel migrations,
-- add policies/constraints/indexes, and test all relationships before production.

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(160) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id UUID NOT NULL REFERENCES users(id),
  name VARCHAR(255),
  category VARCHAR(120),
  description TEXT,
  attributes JSONB NOT NULL DEFAULT '{}',
  research_status VARCHAR(30) NOT NULL DEFAULT 'pending',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE product_sources (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  source_type VARCHAR(40) NOT NULL,
  source_reference TEXT,
  fact_key VARCHAR(120),
  fact_value JSONB,
  confidence NUMERIC(5,4),
  verification_status VARCHAR(30) NOT NULL DEFAULT 'unverified',
  captured_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE affiliate_links (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  original_url TEXT NOT NULL,
  normalized_fingerprint CHAR(64) NOT NULL,
  tracking_url TEXT,
  network VARCHAR(40) NOT NULL DEFAULT 'shopee',
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(product_id, normalized_fingerprint)
);

CREATE TABLE campaigns (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id UUID NOT NULL REFERENCES products(id),
  owner_id UUID NOT NULL REFERENCES users(id),
  name VARCHAR(255) NOT NULL,
  objective TEXT,
  target_audience JSONB NOT NULL DEFAULT '{}',
  platforms JSONB NOT NULL DEFAULT '[]',
  budget_limit NUMERIC(12,2),
  currency CHAR(3) NOT NULL DEFAULT 'THB',
  status VARCHAR(30) NOT NULL DEFAULT 'draft',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE content_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  campaign_id UUID NOT NULL REFERENCES campaigns(id) ON DELETE CASCADE,
  content_type VARCHAR(30) NOT NULL,
  title VARCHAR(255),
  current_version_id UUID,
  status VARCHAR(40) NOT NULL DEFAULT 'draft',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE content_versions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  content_item_id UUID NOT NULL REFERENCES content_items(id) ON DELETE CASCADE,
  version_number INT NOT NULL,
  script JSONB NOT NULL DEFAULT '{}',
  caption TEXT,
  hashtags JSONB NOT NULL DEFAULT '[]',
  disclosure TEXT NOT NULL,
  creative_brief JSONB NOT NULL DEFAULT '{}',
  qa_result JSONB NOT NULL DEFAULT '{}',
  content_hash CHAR(64) NOT NULL,
  created_by_type VARCHAR(20) NOT NULL,
  created_by_id VARCHAR(120),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(content_item_id, version_number)
);

ALTER TABLE content_items
  ADD CONSTRAINT content_items_current_version_fk
  FOREIGN KEY (current_version_id) REFERENCES content_versions(id);

CREATE TABLE media_assets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  content_version_id UUID NOT NULL REFERENCES content_versions(id) ON DELETE CASCADE,
  asset_type VARCHAR(20) NOT NULL,
  storage_disk VARCHAR(40) NOT NULL,
  storage_key TEXT NOT NULL,
  mime_type VARCHAR(120) NOT NULL,
  file_size_bytes BIGINT NOT NULL,
  width INT,
  height INT,
  duration_ms BIGINT,
  provenance JSONB NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE social_accounts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id UUID NOT NULL REFERENCES users(id),
  platform VARCHAR(30) NOT NULL,
  external_account_id VARCHAR(255) NOT NULL,
  display_name VARCHAR(255),
  token_ciphertext TEXT,
  token_expires_at TIMESTAMPTZ,
  scopes JSONB NOT NULL DEFAULT '[]',
  connection_status VARCHAR(30) NOT NULL DEFAULT 'disconnected',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(owner_id, platform, external_account_id)
);

CREATE TABLE approvals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  content_version_id UUID NOT NULL REFERENCES content_versions(id),
  social_account_id UUID NOT NULL REFERENCES social_accounts(id),
  reviewer_id UUID NOT NULL REFERENCES users(id),
  decision VARCHAR(20) NOT NULL CHECK (decision IN ('approved','rejected')),
  comment TEXT,
  approved_content_hash CHAR(64) NOT NULL,
  reviewed_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(content_version_id, social_account_id)
);

CREATE TABLE publications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  content_version_id UUID NOT NULL REFERENCES content_versions(id),
  social_account_id UUID NOT NULL REFERENCES social_accounts(id),
  approval_id UUID NOT NULL REFERENCES approvals(id),
  status VARCHAR(30) NOT NULL DEFAULT 'pending',
  scheduled_at TIMESTAMPTZ,
  submitted_at TIMESTAMPTZ,
  published_at TIMESTAMPTZ,
  external_post_id VARCHAR(255),
  external_post_url TEXT,
  idempotency_key VARCHAR(255) NOT NULL UNIQUE,
  error_code VARCHAR(120),
  error_message_redacted TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE publication_attempts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  publication_id UUID NOT NULL REFERENCES publications(id) ON DELETE CASCADE,
  attempt_number INT NOT NULL,
  request_metadata JSONB NOT NULL DEFAULT '{}',
  response_metadata JSONB NOT NULL DEFAULT '{}',
  outcome VARCHAR(30) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(publication_id, attempt_number)
);

CREATE TABLE metric_snapshots (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  publication_id UUID NOT NULL REFERENCES publications(id) ON DELETE CASCADE,
  source VARCHAR(40) NOT NULL,
  metrics JSONB NOT NULL,
  captured_at TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE affiliate_reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id UUID NOT NULL REFERENCES users(id),
  network VARCHAR(40) NOT NULL,
  report_period_start DATE,
  report_period_end DATE,
  clicks BIGINT,
  orders BIGINT,
  commission_amount NUMERIC(12,2),
  currency CHAR(3) NOT NULL DEFAULT 'THB',
  source_reference TEXT,
  imported_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE ai_tasks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  campaign_id UUID REFERENCES campaigns(id),
  product_id UUID REFERENCES products(id),
  agent_role VARCHAR(60) NOT NULL,
  paperclip_task_id VARCHAR(255),
  task_type VARCHAR(60) NOT NULL,
  status VARCHAR(30) NOT NULL DEFAULT 'queued',
  input_payload JSONB NOT NULL DEFAULT '{}',
  output_payload JSONB NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE ai_runs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ai_task_id UUID NOT NULL REFERENCES ai_tasks(id) ON DELETE CASCADE,
  provider VARCHAR(80),
  model VARCHAR(120),
  input_tokens BIGINT,
  output_tokens BIGINT,
  duration_ms BIGINT,
  status VARCHAR(30) NOT NULL,
  error_redacted TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE cost_records (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id UUID NOT NULL REFERENCES users(id),
  campaign_id UUID REFERENCES campaigns(id),
  ai_task_id UUID REFERENCES ai_tasks(id),
  provider VARCHAR(80) NOT NULL,
  cost_type VARCHAR(40) NOT NULL,
  amount NUMERIC(14,6) NOT NULL,
  currency CHAR(3) NOT NULL DEFAULT 'USD',
  usage_metadata JSONB NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id UUID REFERENCES users(id),
  actor_type VARCHAR(30) NOT NULL,
  actor_id VARCHAR(120),
  action VARCHAR(120) NOT NULL,
  resource_type VARCHAR(80),
  resource_id VARCHAR(120),
  metadata_redacted JSONB NOT NULL DEFAULT '{}',
  ip_hash CHAR(64),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE outbox_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  event_type VARCHAR(120) NOT NULL,
  aggregate_type VARCHAR(80) NOT NULL,
  aggregate_id UUID NOT NULL,
  payload JSONB NOT NULL,
  occurred_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  processed_at TIMESTAMPTZ,
  attempts INT NOT NULL DEFAULT 0
);

CREATE INDEX idx_products_owner ON products(owner_id);
CREATE INDEX idx_campaigns_owner_status ON campaigns(owner_id, status);
CREATE INDEX idx_content_campaign_status ON content_items(campaign_id, status);
CREATE INDEX idx_publications_schedule ON publications(status, scheduled_at);
CREATE INDEX idx_metrics_publication_time ON metric_snapshots(publication_id, captured_at DESC);
CREATE INDEX idx_outbox_unprocessed ON outbox_events(occurred_at) WHERE processed_at IS NULL;
