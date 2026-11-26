# Operations Runbook

## Pause all publishing
Set global publishing enabled flag to false in application configuration/database. Stop scheduler workers if needed. Confirm no queued jobs remain eligible.

## Failed publication
1. Inspect publication status and redacted attempt metadata.
2. If outcome is UNKNOWN, query the platform for the remote post before retrying.
3. Do not retry if a remote post already exists.
4. If failed definitively, verify token, scopes, media format and platform response.
5. Retry only with same idempotency key when connector semantics support it.

## Expired social token
Mark account `reauthorization_required`, pause its scheduled publications and request user reconnect. Never ask user to paste tokens into chat or issue trackers.

## AI budget exceeded
Stop new generation tasks, allow safe in-flight tasks to finish or cancel according to policy, notify owner and show cost breakdown.

## Storage outage
Stop asset generation and publishing that depends on inaccessible assets. Preserve jobs for retry after health checks pass.

## Data backup
Use managed PostgreSQL backups in production. Test restore regularly. Local Docker volumes are not a backup.
