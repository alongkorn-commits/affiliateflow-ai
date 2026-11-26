# Paperclip Setup

Paperclip is the AI organization/task orchestration control plane. It is not the application's database or the authority for public publishing.

1. Install and configure Paperclip by following its current official documentation.
2. Create the organization described in `organization.yaml` manually or adapt it to the version-specific supported import/configuration mechanism.
3. Configure each agent with the corresponding role prompt under `agents/`.
4. Use supported runtimes/adapters (for example, Codex, Claude Code or OpenCode) only after verifying current compatibility.
5. Give agents scoped tools that call Laravel task endpoints. Do not give database credentials or social OAuth tokens to agents.
6. Keep public publishing disabled at the agent layer. Only Laravel's publisher worker may call social connectors after checking approval.

Paperclip configuration formats and APIs may change. Do not assume the YAML in this folder can be imported directly.
