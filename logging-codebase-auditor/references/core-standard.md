# Core Logging Standard

## 1. A log records an event, not an object dump

Prefer:

```json
{
  "event.name": "payment.authorization.failed",
  "severity": "ERROR",
  "payment.id": "pay_123",
  "provider": "example-provider",
  "error.code": "PROVIDER_TIMEOUT",
  "outcome": "failure",
  "duration_ms": 2500
}
```

Avoid:

```ts
logger.error({ request, response, user, payment, error });
```

## 2. Fields depend on event type

Do not force every event to contain a fixed list of fields.

### Base context

Use when available:

- timestamp
- severity
- event.name
- service.name
- service.version
- deployment.environment
- module

### Request-scoped event

Add:

- request.id
- trace.id
- span.id
- http.request.method
- http.route
- http.response.status_code

Use route templates such as `/orders/:id`, not raw URLs containing identifiers.

### Completed operation

Add:

- operation.name
- outcome
- duration_ms

### Error event

Add safe versions of:

- error.type
- error.code
- error.message
- error.stack

Do not repeatedly log the same stack trace across layers.

### Audit event

Use:

- audit.action
- actor.type
- actor.id
- target.type
- target.id
- outcome
- reason, when safe and necessary

## 3. Level matrix

### ERROR

Use when:

- an invariant is broken;
- an operation fails and cannot recover;
- user-facing or business impact exists;
- operator investigation may be needed.

### WARN

Use when:

- degraded behavior is handled;
- a retry or fallback succeeds;
- suspicious but non-fatal behavior occurs;
- a capacity threshold is approaching.

### INFO

Use for:

- meaningful business-state transitions;
- job completion summaries;
- service lifecycle events;
- low-frequency operational milestones.

Do not use INFO for every internal function call.

### DEBUG

Use for temporary diagnostic detail.

DEBUG should be disabled by default in production and must still follow
redaction rules.

## 4. Event ownership

Each event should have one primary owner.

Examples:

- request completion: global interceptor or HTTP logger;
- unhandled exception: global exception boundary;
- payment result: payment module;
- database query timing: instrumentation layer;
- queue-job completion: processor boundary.

Lower layers may log only when they add unique information.

## 5. Security rules

Never log credentials or authentication material.

Prefer field allowlists over blocklists.

Do not assume masking strings such as `***` is sufficient. Prevent the
sensitive value from reaching the logger.

Treat error messages, URLs and query strings as potentially sensitive.

Do not repeat real secrets found during the audit.

## 6. Logs versus metrics and traces

Use logs for individual events requiring context.

Use metrics for:

- counts;
- rates;
- error ratios;
- queue depth;
- latency distributions;
- disk and buffer utilization.

Use traces for:

- request flow across services;
- nested operation timing;
- dependency bottlenecks.

Do not generate high-volume logs solely to calculate aggregate statistics.
