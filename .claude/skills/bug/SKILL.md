---
name: bug
description: Bug triage, trace, and Root Cause Analysis (RCA) workflow for any software system. Reproduces defects, traces execution across stack layers and log streams (correlation/trace IDs, application & runtime logs), writes an RCA document with a 5-Whys chain and Mermaid trace diagram, runs impact analysis, grills for missing context, requires a failing regression test before fixing, updates feature documentation, and ends with a caveman summary. Trigger on "bug", "broken", "error", "not working", "RCA", "root cause", "investigate failure", "hotfix".
---

# Bug Trace & Root Cause Analysis (RCA)

Never patch a symptom. Find the root cause, prove it with a failing test, then fix.

Docs root: `docs/bugs/BUG-<NNN>-<slug>/`

---

## Step 1 — Capture the Report

Record exactly what the user gave: symptom, environment, timestamp, user/record ID, request/correlation ID (`TRACE_ID`), exact error string (verbatim, never paraphrased), screenshots, and console logs.
Missing critical detail? Ask immediately (Step 3 grill), do not guess.

## Step 2 — Reproduce & Gather Evidence

- Write the minimal reproduction steps. State the expected vs actual result.
- Cannot reproduce? Say so plainly and switch to evidence-only tracing. Never claim a fix for an unreproduced bug without stating it is unverified.
- Pull evidence from relevant system logs:
  - Backend: application logs, error/exception traces, HTTP request audit logs, queue/worker failure tables, DB slow/error logs.
  - Frontend / Mobile: browser console logs, network tab payloads/status codes, client-side crash/telemetry reports.
  - Database: actual row state, missing foreign keys, stale locks, corrupted timestamps.

## Step 3 — Grill Me

Clarify the context before jumping to conclusions:
- When did it start? What changes/deployments shipped around then?
- Is it deterministic (every time) or intermittent/concurrency-related?
- Does it affect all users/records or a specific subset/tenant/environment?
- Any manual database edits, configuration/environment changes, or third-party service degradations?
- Is this an implementation divergence from the spec, or is the original spec flawed?

## Step 4 — Trace to Root Cause

Walk the execution path top-down with `path:line` at each hop:
Entry/Route → Middleware/Auth → Handler/Controller/View → Validation → Business Service/Action → Data Repository/Model → Database/External Gateway → Response/UI.

At each hop state: expected value vs actual value, and whether the defect is already present.
Mark the exact line where reality diverges from intent.

Classify the root cause:
`logic | validation | data/schema | migration | race condition | concurrency | cache staleness | queue/retry | config/env | third-party | contract mismatch | spec defect`

Output `docs/bugs/BUG-<NNN>-<slug>/RCA.md`:

```markdown
# BUG-<NNN> — <title>
- Severity: Critical | High | Medium | Low
- Environment / First Seen / Trace ID:
- Status: Investigating | Root Cause Found | Fixed | Verified

## Symptom
## Reproduction
## Evidence
<decisive error log snippet, stack trace, or payload mismatch>

## Trace Path
| Hop | path:line | Expected | Actual | Diverged |

## Root Cause
<one concise paragraph, one cause, pinned to path:line>

## 5 Whys
1. Why ... → ...
2. Why ... → ...
3. Why ... → ...
4. Why ... → ...
5. Why ... → ...

## Contributing Factors
## Why Tests Missed It
## Blast Radius
<other call sites, queries, or components with the same pattern — search and list them>

## Fix Options
| Option | Effort | Risk | Recommendation |

## Prevention
<test, schema guard, monitoring alert, or doc update to prevent recurrence>
```

Add a **Mermaid `sequenceDiagram`** of the failing flow with the divergence point annotated.

## Step 5 — Impact Analysis for the Fix

Analyze the side effects of fixing the issue:
- Data integrity: Did the bug write corrupted data? Is a backfill or repair script needed?
- State & In-Flight: Are queued jobs, active sessions, or cached keys poisoned? Do they require purging/invalidation?
- Consumers: Will the fix alter response schemas for existing mobile or API consumers?

Output: `docs/bugs/BUG-<NNN>-<slug>/Impact-Analysis.md`.

## Step 6 — Approval Gate

Present `Fix-Plan.md` with the chosen option, data repair plan, and rollback strategy.
**No code until the user approves** — EXCEPT for a declared production-down emergency, where you state the emergency, apply the minimal fix, and complete all documentation immediately after.

## Step 7 — Failing Test First

Write the regression test that FAILS on current code and reproduces the bug. Show the failing test output.
Only then apply the fix and demonstrate that the test passes green.
Add test coverage for all sibling call sites identified in Blast Radius.

## Step 8 — Fix, Verify & Back-Propagate

- Apply the fix following project architecture and code standards (clean imports, no hardcoded magic values, proper error handling).
- Run the full test suite. Report REAL pass/fail numbers.
- If the specification was incorrect, update the feature docs under `docs/features/<feature-name>/` and note the correction in `RCA.md`.
- Execute data repair scripts if necessary; log rows/records touched.
- Write `Postmortem.md` for Critical/High severity bugs: timeline, detection gap, monitoring/alerts added.

## Step 9 — Caveman Summary

Mandatory concise summary: State root cause in one line, files fixed, regression test name, and real test suite numbers.
