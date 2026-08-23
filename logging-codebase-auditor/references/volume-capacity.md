# Logging Volume and Capacity Standard

## 1. Evaluate separate storage layers

Do not treat "logging storage" as one disk.

Check separately:

1. application local files;
2. container stdout/stderr storage;
3. node or host logging;
4. log shipper buffers;
5. message queues used for telemetry;
6. centralized log storage;
7. archive storage.

A safe central destination does not prove the application's local disk is safe.

## 2. Basic volume model

When measured values exist:

```text
daily_uncompressed_bytes =
  average_event_bytes
  × events_per_second
  × 86400
```

Approximate retained storage:

```text
retained_storage =
  daily_uncompressed_bytes
  × retention_days
  × replication_factor
  × indexing_overhead_factor
  × safety_margin
```

Compression and indexing behavior depend on the destination. Do not invent
those factors.

## 3. Required measurements

If capacity cannot be calculated, request or recommend measuring:

- average event size;
- p95 event size;
- events per second;
- peak events per second;
- events generated per request;
- error burst rate;
- retry amplification;
- retention period;
- replication;
- compression ratio;
- indexing overhead;
- collector buffer size;
- local disk quota;
- disk growth rate.

## 4. Volume amplification patterns

Flag:

- one log per loop item;
- nested-loop logging;
- logging full arrays or objects;
- one stack trace per retry;
- duplicated request completion events;
- ORM query logs;
- HTTP client request and response dumps;
- health-check access logs;
- debug logs enabled globally;
- queue job start and success logs at high throughput;
- repeated identical errors without rate limiting.

## 5. Recommended controls

Depending on the event:

- aggregation;
- metrics;
- trace sampling;
- probabilistic log sampling;
- deterministic sampling by request or tenant;
- rate limiting;
- deduplication;
- bounded payloads;
- truncation;
- field allowlists;
- route exclusions;
- time- and size-based rotation;
- retention limits;
- disk quotas;
- bounded retry buffers.

## 6. Sampling constraints

Never blindly sample:

- security audit events;
- permission changes;
- destructive administrative actions;
- final payment failures;
- final job failures;
- data export and deletion events;
- evidence required for compliance.

High-frequency successful events are stronger sampling candidates.

If events are dropped or sampled, recommend a metric counting:

- emitted events;
- sampled events;
- dropped events;
- logger or collector failures.

## 7. Failure behavior

Audit what happens when:

- local disk is full;
- stdout consumer is slow;
- log collector is unavailable;
- transport retries are exhausted;
- in-memory buffer reaches its limit;
- serialization fails.

Logging should not silently consume unbounded memory or disk.

The recommendation must consider business criticality. Do not automatically
make all application requests fail solely because a debug log cannot be sent.

## 8. Report format for volume risks

Include:

- amplification source;
- verified code path;
- frequency driver;
- event-size driver;
- bounded or unbounded status;
- current controls;
- missing controls;
- measurements required;
- recommended mitigation.

Do not label disk exhaustion as certain unless capacity and traffic evidence
support that conclusion.
