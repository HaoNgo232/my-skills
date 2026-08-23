# Framework Profile: NestJS

## Profile identity

```yaml
profile_id: nestjs
profile_version: "1.0.0"
languages:
  - typescript
  - javascript
frameworks:
  - nestjs
priority: 100
```

## Detection criteria

### Required evidence

Select this profile when at least one strong condition is verified:

1. package.json contains @nestjs/core; or
2. source imports symbols from @nestjs/common and has a Nest bootstrap.

### High-confidence evidence

Profile confidence is HIGH when both are present:

- package.json contains @nestjs/core;
- application bootstrap calls NestFactory.create or a Nest microservice
  creation API.

### Medium-confidence evidence

Profile confidence is MEDIUM when one of these is present:

- NestJS dependencies without visible bootstrap;
- multiple imports from @nestjs/common;
- Nest decorators such as @Module, @Controller or @Injectable.

### Rejection criteria

Do not select solely because:

- a directory is named modules;
- decorators exist but do not come from NestJS;
- compiled output contains NestJS strings while source evidence is absent.

## Important files and manifests

Inspect when present:

- package.json
- lock files
- nest-cli.json
- tsconfig*.json
- src/main.ts
- root application module
- logger modules
- configuration modules
- test bootstrap
- Docker and orchestration configuration

Search dependencies for:

- @nestjs/core
- @nestjs/common
- @nestjs/platform-express
- @nestjs/platform-fastify
- @nestjs/graphql
- @nestjs/microservices
- @nestjs/schedule
- @nestjs/bull
- @nestjs/bullmq
- nestjs-pino
- pino
- winston
- nest-winston
- @opentelemetry/api

## Architectural boundaries

Map these NestJS-specific boundaries:

- middleware;
- guards;
- interceptors;
- pipes;
- controllers;
- GraphQL resolvers;
- WebSocket gateways;
- services;
- repositories;
- exception filters;
- event handlers;
- microservice message handlers;
- queue producers and processors;
- scheduled jobs;
- bootstrap and shutdown hooks.

## Logger and instrumentation patterns

Search for:

```text
Logger
LoggerService
console.log
console.info
console.warn
console.error
nestjs-pino
PinoLogger
pino
winston
WinstonModule
APP_INTERCEPTOR
APP_FILTER
APP_GUARD
useGlobalInterceptors
useGlobalFilters
useLogger
bufferLogs
AsyncLocalStorage
requestId
correlationId
traceId
BullModule
Processor
Process
Cron
Interval
Timeout
NestFactory
```

Inspect custom logger wrappers before deciding whether their output is
structured or safely redacted.

## NestJS request lifecycle

A request may pass through:

1. middleware;
2. guard;
3. interceptor before-handler;
4. pipe;
5. controller or resolver;
6. service;
7. repository or external dependency;
8. interceptor after-handler;
9. exception filter.

Trace representative operations through this lifecycle.

Flag equivalent request events emitted at several stages.

## Recommended event ownership

Recommended defaults:

| Event | Preferred owner |
|---|---|
| HTTP request completion | Global interceptor or HTTP logger |
| Unhandled HTTP exception | Global exception filter or logger integration |
| Authorization rejection | Guard or security boundary |
| Business-state transition | Owning service or domain module |
| Dependency failure | Integration/client boundary |
| Database telemetry | ORM instrumentation or tracing layer |
| Queue-job completion | Processor boundary |
| Scheduled-job summary | Scheduled-job boundary |
| Startup/shutdown | Bootstrap or lifecycle hook |

These are defaults, not proof that a codebase follows them.

## Controllers and resolvers

Flag routine logging of:

- complete DTOs;
- complete request objects;
- headers;
- authenticated user objects;
- errors that are rethrown and logged globally;
- success events already owned by a global interceptor.

Controllers or resolvers may log meaningful boundary-specific decisions when
they are not already owned elsewhere.

## Middleware

Check whether middleware:

- logs full request objects;
- logs every request without route exclusion or sampling;
- duplicates interceptor access logs;
- exposes headers, cookies or query parameters;
- creates a correlation ID but does not propagate it.

## Guards and authentication

Audit events may be appropriate for:

- repeated authentication failures;
- access denied to sensitive operations;
- role and permission changes;
- administrative impersonation;
- suspicious authentication behavior.

Never log:

- bearer tokens;
- cookies;
- password or MFA secrets;
- complete decoded JWT payloads;
- complete authenticated-user objects.

Normal successful authorization checks should not create excessive INFO logs.

## Interceptors

Check whether interceptors:

- measure duration consistently;
- use route templates rather than raw URLs;
- add request and trace context;
- log response bodies;
- log streaming responses incorrectly;
- duplicate middleware or controller events;
- turn every successful request into a large INFO event;
- exclude or sample health endpoints.

## Exception filters

Check:

- whether stack traces are emitted once;
- whether expected 4xx responses are logged as ERROR;
- whether exception responses expose internal details;
- whether exception messages contain sensitive payload values;
- whether request and trace identifiers are present;
- whether handled and unhandled exceptions are distinguished.

Validation failures usually do not require ERROR unless they indicate abuse,
systemic contract breakage or an internal invariant failure.

## Services

Services should log meaningful business or operational events, not every method
entry and exit.

Good candidates:

- business-state transitions;
- irreversible operations;
- provider failures;
- consistency failures;
- degraded fallback behavior.

Flag generic messages such as:

```text
Entering method
Operation successful
Something went wrong
```

when they lack stable event names and useful context.

## Prisma and TypeORM

When used, inspect environment-specific query logging.

Flag:

- every SQL query logged in production;
- query parameters containing personal data;
- full entity logging;
- connection strings containing credentials;
- slow-query logs without thresholds;
- duplicated ORM and application query logs.

Recommend metrics or traces for aggregate query latency.

## Bull and BullMQ

For queue processors, check:

- job-start logs on high-volume queues;
- complete job payload logging;
- retries producing duplicate error events;
- missing final-failure events;
- loss of correlation;
- one success event per high-volume job;
- per-item logging inside batch jobs.

Useful bounded fields include:

- queue.name
- job.name
- job.id
- attempt
- outcome
- duration_ms
- bounded processing counts

High-volume success events should be sampled, aggregated or replaced by metrics.
Final failures should retain safe error context.

## Scheduled jobs

Scheduled jobs should normally emit one summary per execution, not one log per
processed row.

Useful fields include:

- job.name
- outcome
- duration_ms
- processed_count
- success_count
- failure_count
- a bounded sample of safe failure identifiers

## Microservices and event handlers

When @nestjs/microservices is present, inspect:

- @MessagePattern;
- @EventPattern;
- transport clients;
- serialization and deserialization errors;
- acknowledgement and retry behavior;
- correlation propagation;
- message payload logging.

Do not log complete messages by default.

Check whether retries and redelivery multiply identical logs.

## External integrations

Log safe metadata:

- provider;
- operation;
- status code;
- timeout;
- retry count;
- duration;
- provider error code;
- outcome.

Do not log:

- authorization headers;
- full URLs containing secrets;
- full request or response payloads;
- provider tokens;
- raw payment details.

## Health endpoints

Routine successful calls should usually be excluded or heavily sampled:

- /health
- /ready
- /readiness
- /live
- /liveness
- /metrics

Failures must remain observable.

## NestJS-specific volume risks

Flag:

- global request logging combined with interceptor logging;
- console.* left in providers;
- ORM query logging enabled globally;
- response-body serialization in an interceptor;
- logging every WebSocket message;
- logging every queue-job start and completion;
- logs inside batch processors;
- repeated exception logging in service and global filter;
- verbose startup route mapping in production where unnecessary;
- unbounded metadata attached through request context.

## Framework-specific report additions

Add a NestJS lifecycle coverage section:

| Boundary | Current logging | Event owner | Duplication | Missing context |
|---|---|---|---|---|
| Middleware | | | | |
| Guards | | | | |
| Interceptors | | | | |
| Controllers/resolvers | | | | |
| Services | | | | |
| Persistence | | | | |
| Exception filters | | | | |
| Queues/jobs | | | | |

Also report:

- HTTP adapter;
- selected logger implementation;
- global logger providers;
- global interceptors;
- global exception filters;
- correlation mechanism;
- OpenTelemetry integration;
- ORM query logging configuration.
