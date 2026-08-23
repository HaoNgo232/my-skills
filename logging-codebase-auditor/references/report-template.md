# Logging Audit Report

## 1. Executive summary

- Scope:
- Framework:
- Logging libraries:
- Deployment facts:
- Overall risk:
- Files inspected:
- Limitations:

## 2. Verified architecture

| Area | Verified finding |
|---|---|
| Logger | |
| Request logging | |
| Error boundary | |
| Correlation | |
| Tracing | |
| Redaction | |
| Destination | |
| Rotation/retention | |
| Queue/jobs | |

## 3. Findings

[SEVERITY] Rule ID — Finding title

- Confidence:
- Module:
- Evidence:
  - path/to/file.ts:line
- Current behavior:
- Impact:
- Recommendation:
- Better signal:
- Verification required:

Repeat for each finding.

## 4. Module recommendations

Module: module-name

### Important operations

- operation

### Recommended events

| Event name | Level | When emitted | Required safe fields | Sampling |
|---|---|---|---|---|

### Do not log

- field or event

### Prefer metrics/traces for

- use case

## 5. Duplicate logging map

| Flow | Logging locations | Recommended owner | Logs to remove |
|---|---|---|---|

## 6. Security and privacy

| Risk | Evidence | Data involved | Recommendation |
|---|---|---|---|

## 7. Volume and disk assessment

### Verified controls

- control

### Risks

- risk

### Capacity model

```text
average_event_bytes × events_per_second × 86400
```

### Missing measurements

- measurement

Do not present scenarios as measured production values.

## 8. Prioritized action plan

### Immediate

- critical or high-risk action

### Next sprint

- medium-risk action

### Later

- low-risk improvement

## 9. Verification required

List deployment or runtime questions that static code inspection cannot settle.

## 10. Final assessment

Clearly separate:

- verified problems;
- likely risks;
- unknown items;
- optional improvements.
