# UI Requirements

Thai-first, clean, modern SaaS dashboard. Desktop-first but responsive. Avoid cluttered sidebars and excessive nested navigation.

## Navigation
- Overview
- Products
- Campaigns
- Content Studio
- Approval Center
- Publishing Calendar
- Social Accounts
- Analytics
- AI Team & Activity
- Settings

## Screens
### Overview
KPI cards: products, campaigns active, content awaiting approval, scheduled posts, published posts, AI spend. Include recent activity and blocked jobs.

### Products
Table/grid with product name, category, research status, source verification, campaigns count and actions. Primary CTA: Add affiliate link.

### Add Product
Affiliate URL, optional product name/category/notes, optional authorized reference image. Explain that URL submission does not guarantee automatic Shopee data extraction.

### Product Detail
Verified facts vs unknown facts, source provenance, affiliate link, research history and campaign creation CTA.

### Campaign Studio
Objective, audience, target platforms, content formats, campaign budget, content angle selection.

### Content Studio
Version list, script, caption, disclosure, media preview, provenance, QA results and revision history.

### Approval Center
Queue with preview, target account, exact version, fact sources, disclosure, QA failures/warnings. Approve or reject with feedback.

### Calendar
Scheduled/published/failed posts by platform, local timezone Asia/Bangkok.

### Social Accounts
Connection state, permissions/scopes, expiry warning, reconnect and revoke. Never display raw tokens.

### Analytics
Separate platform metrics from affiliate clicks/orders/commission. Always show source and reporting period.

### AI Team & Activity
Agent status, task timeline, budget usage, failed tasks and retry controls.

## UX rules
- Every async action shows queued/running/succeeded/failed states.
- Empty states explain the next action.
- Destructive actions require confirmation.
- Approval displays the exact content version and account.
- Disabled integrations explain missing credentials or API approval.
- No fake performance figures outside clearly labeled demo mode.
