# Worker Service

Reserved for asynchronous media and platform workers.

Initial implementation may use Laravel queue workers. Keep worker code in Laravel until there is a clear reason to split it into a separate service.

Responsibilities:
- media validation and FFmpeg rendering
- thumbnail and subtitle generation
- storage upload
- social connector jobs
- analytics synchronization

Workers must consume durable jobs, be idempotent, emit structured logs and never bypass approval.
