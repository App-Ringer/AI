# Shared Module — "Grill Me" Clarification Mode

Never assume business logic. Never silently pick a default for a rule the user owns.

## Rules

1. Ask questions in ONE batch, numbered, grouped by theme. No drip-feeding.
2. Every question gets a **recommended default** so the user can answer `ok to all defaults`.
3. STOP after asking. Do not write docs, plan, or code until answers land.
4. Re-grill whenever an answer opens a new ambiguity.
5. Log every question + answer into the feature/bug/CR doc under a `## Clarifications` section, so decisions are traceable.

## Question Bank (pick what applies)

**Business rules**
- Exact validation limits, thresholds, expiry windows, retry counts?
- Who is allowed to do this — roles, permissions, ownership checks?
- What happens on duplicate/repeat requests within the window?

**Data**
- New table or extend existing? Which columns are nullable?
- Retention policy? Hard purge ever, or soft delete forever?
- Does an existing row need backfill?

**Failure & edge cases**
- Third-party/gateway down: fail closed or fail open? Retry policy? User-facing message?
- Partial success: what state does the record land in?
- Concurrent requests on the same record: lock, reject, or last-write-wins?
- Soft-deleted parent record: block, cascade, or ignore?

**Config & control**
- Which values must be admin-configurable vs `.env` vs hardcoded enum?
- Feature flag needed for rollout?

**API & clients**
- Breaking change for existing mobile builds? Versioned endpoint or additive?
- Which `ResponseMessage` enum case per failure branch?

**Ops**
- Alerting thresholds? What must land in the `trace` log?
- Expected traffic (RPS, peak) and acceptable latency?

## Format

```
GRILL ME — <scope>

A. Business rules
1. <question>  (default: <recommended answer>)
2. ...

B. Edge cases
3. ...

Reply with numbers, or say "defaults" to accept all recommendations.
```
