---
name: logging-codebase-auditor
description: Audit logging quality, security, observability coverage, duplication, excessive volume and storage-capacity risks in application codebases. Use when reviewing structured logging, correlation, sensitive-data exposure, log levels, error visibility, audit trails, module-specific event design, sampling, retention and disk-exhaustion risks.
license: MIT
compatibility: Designed for codebase-reading agents. Supports framework-specific behavior through independently discoverable references/framework-*.md profiles.
metadata:
  version: "1.1.0"
  architecture: "core-plus-framework-profiles"
  default-mode: "audit-only"
---

# Logging Codebase Auditor

Audit application logging using deterministic core policies and optional
framework profiles.

The skill must remain framework-independent.

Framework-specific knowledge belongs exclusively in files matching:

```text
references/framework-*.md
```

Adding support for a new framework must not require modifying this file,
the core policy or existing framework profiles.

## Files to load

Always read:

1. assets/policy.yaml
2. references/core-standard.md
3. references/volume-capacity.md
4. references/report-template.md

Then discover available framework profiles by listing:

```text
references/framework-*.md
```

Do not assume a profile exists or applies until its detection criteria match
verified repository evidence.

## Framework profile protocol

Each `references/framework-*.md` profile must provide:

1. Profile identity
2. Detection criteria
3. Important files and manifests
4. Architectural boundaries
5. Logger and instrumentation patterns
6. Framework-specific audit checks
7. Framework-specific volume risks
8. Recommended event ownership
9. Framework-specific report additions

A profile may extend the core rules, but must not weaken:

- credential protection;
- personal-data protection;
- evidence requirements;
- bounded-volume requirements;
- audit-only default behavior.

## Profile selection

### Step 1: Discover profiles

List all files matching:

```text
references/framework-*.md
```

Read the Profile identity and Detection criteria sections.

### Step 2: Inspect repository evidence

Inspect repository manifests, configuration and source structure before choosing
a profile.

Examples of evidence include:

- dependency manifests;
- framework configuration files;
- bootstrap files;
- imports;
- annotations or decorators;
- build files;
- directory conventions.

### Step 3: Select profiles

Select a profile only when its required detection criteria are satisfied.

Profile confidence:

- HIGH: framework dependency and bootstrap evidence are both present.
- MEDIUM: dependency or strong source evidence is present.
- LOW: only weak naming or directory evidence is present.

Do not apply a profile with only LOW confidence without clearly labelling the
assumption.

A repository may use multiple profiles. For example, a backend framework and a
worker framework may coexist.

### Step 4: Generic fallback

If no profile matches:

- continue using the core policy;
- label framework-specific coverage as limited;
- report the evidence needed to add a new profile;
- do not invent framework behavior.

## Core principles

- Do not require every log to contain the same fields.
- Apply fields based on event type and operational purpose.
- Prefer one useful event over many fragmented log lines.
- Never trade security for debugging convenience.
- Do not invent traffic, retention, deployment or storage facts.
- Separate verified findings, inferred risks and unknown information.
- Every code finding must include a file, line, symbol or configuration key.
- Default to audit-only.
- Do not modify files unless explicitly requested.

## Supported modes

### Audit mode — default

Inspect the codebase and produce a report. Do not edit files.

### Suggest mode

Recommend event schemas and implementation approaches. Do not edit files.

### Fix mode

Only activate when the user explicitly requests code changes.

Before editing:

1. Show the files planned for modification.
2. Explain behavior changes.
3. Preserve the existing logging library unless replacement is requested.
4. Apply the smallest safe change.
5. Run available tests, lint and type checking.
6. Report anything that could not be verified.

## Audit workflow

### Step 1: Establish repository facts

Inspect relevant files such as:

- dependency manifests;
- lock files;
- build configuration;
- application bootstrap;
- logging configuration;
- environment configuration;
- container configuration;
- orchestration manifests;
- process manager configuration;
- telemetry configuration;
- CI/CD configuration;
- collector and transport configuration.

Identify when possible:

- languages;
- frameworks;
- application types;
- logger libraries;
- telemetry libraries;
- databases;
- queues and workers;
- scheduled jobs;
- logging destinations;
- production log levels;
- redaction configuration;
- rotation and retention configuration;
- deployment model.

If something cannot be verified, label it UNKNOWN.

### Step 2: Load applicable framework profiles

Follow the profile-selection protocol.

Record:

- selected profiles;
- confidence;
- matching evidence;
- profiles considered but rejected.

### Step 3: Build an architectural boundary map

Use generic boundaries plus boundaries defined by selected profiles.

Generic boundaries include:

- inbound requests;
- authentication and authorization;
- business operations;
- persistence;
- external dependencies;
- asynchronous jobs;
- scheduled operations;
- event consumers;
- startup and shutdown;
- health checks;
- error ownership boundaries.

For each boundary, identify important operations and failure paths.

### Step 4: Inventory current logging

Search for:

- logger imports and wrappers;
- direct stdout or console usage;
- structured and unstructured logs;
- exception logging;
- request and response logging;
- database query logging;
- trace or correlation context;
- audit logging;
- payload serialization;
- redaction;
- sampling;
- rate limiting;
- local file transports;
- buffering and retry behavior.

Do not classify a wrapper as safe without inspecting its implementation.

### Step 5: Apply core and profile rules

Apply:

1. all applicable rules from assets/policy.yaml;
2. all applicable checks from selected framework profiles.

For each finding include:

- rule ID;
- severity;
- confidence;
- evidence;
- impact;
- recommendation.

Do not report an issue as verified when evidence is insufficient. Put uncertain
items under Verification required.

### Step 6: Detect duplication and amplification

Trace representative operations across architectural boundaries.

Flag:

- the same event emitted at several layers;
- logging inside loops;
- per-record batch logs;
- retry amplification;
- repeated stack traces;
- unbounded payload logging;
- high-frequency success logs;
- health-check noise;
- query logging;
- dynamic event names and fields.

Apply additional flow rules from the selected framework profiles.

### Step 7: Evaluate storage and disk risk

Follow references/volume-capacity.md.

When measurements exist:

```text
daily_uncompressed_bytes =
  average_event_bytes
  × events_per_second
  × 86400
```

When measurements do not exist:

- do not invent traffic;
- provide the formula;
- identify amplification factors;
- list required measurements;
- clearly label optional scenarios as examples, not predictions.

Evaluate separately:

- application-local storage;
- container or host logs;
- collector buffers;
- transport queues;
- centralized storage;
- archive retention.

### Step 8: Recommend boundary-specific event design

For each important boundary or module, recommend:

- events worth logging;
- events that should not be logged;
- suitable level;
- required safe fields;
- sensitive fields to omit or redact;
- aggregation or sampling policy;
- metrics or traces that are better suited than logs;
- event ownership.

Apply framework-specific ownership guidance from selected profiles.

### Step 9: Produce the report

Use references/report-template.md.

Order findings by:

1. credentials and secret exposure;
2. personal-data exposure;
3. missing critical failure visibility;
4. unbounded volume or disk-exhaustion risk;
5. duplicate logging;
6. missing correlation;
7. inconsistent schema or level;
8. lower-value improvements.

## Severity model

### CRITICAL

- credentials, tokens or private keys are logged;
- highly sensitive data is exposed at scale;
- a verified unbounded logging path creates immediate operational risk.

### HIGH

- payloads are logged without an allowlist;
- high-frequency unbounded logging exists;
- production debug or query logging lacks controls;
- critical operations have no failure visibility;
- local logging lacks verified capacity controls.

### MEDIUM

- correlation is missing across important boundaries;
- duplicate logs significantly increase cost or noise;
- log levels are misleading;
- error context is insufficient;
- personal identifiers lack a clear handling policy.

### LOW

- naming inconsistency;
- minor metadata gaps;
- low-impact maintainability improvements.

## Confidence model

- HIGH: directly verified in code or configuration.
- MEDIUM: strong static evidence; runtime behavior may differ.
- LOW: potential risk requiring runtime or deployment verification.

## Hard restrictions

Never recommend logging:

- passwords;
- access tokens;
- refresh tokens;
- session identifiers;
- API keys;
- cookies;
- authorization headers;
- private keys;
- raw payment-card data;
- arbitrary request or response bodies;
- connection strings containing credentials.

Do not recommend replacing useful logs with silence. Recommend safe metadata,
aggregation, metrics or traces instead.

## Final verification

Before finishing, confirm:

- framework profiles were discovered dynamically;
- selected profiles have matching evidence;
- every finding has evidence;
- assumptions are labelled;
- sensitive values are not repeated;
- volume conclusions distinguish measurements from estimates;
- recommendations are boundary-specific;
- no code was modified in audit mode;
- all applicable core and profile rules were considered.
