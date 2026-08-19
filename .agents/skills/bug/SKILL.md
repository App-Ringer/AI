---
name: bug
description: Bug triage, trace and Root Cause Analysis workflow for AKAL. Reproduces the defect, traces it through logs (TRACE_ID, storage/logs/trace) and code to the true root cause, writes an RCA document with a 5-Whys chain and Mermaid trace diagram, runs impact analysis for the fix, grills the user on missing context, back-propagates corrections into the feature's 19-phase docs, requires a failing regression test before the fix, and ends with a caveman summary. Trigger on "bug", "broken", "error", "not working", "RCA", "root cause", "investigate failure", "hotfix".
---

# Bug Trace & RCA — AKAL

Never patch a symptom. Find the root cause, prove it with a failing test, then fix.

Read first: `.agents/shared/akal-standards.md`.

Docs root: `docs/bugs/BUG-<NNN>-<slug>/`.

---

## Step 1 — Capture the Report

Record exactly what the user gave: symptom, environment, timestamp, user/record ID, `TRACE_ID`, exact error string (verbatim, never paraphrased), screenshots.
Missing critical detail? Ask immediately (Step 3 grill), do not guess.

## Step 2 — Reproduce

- Write the minimal reproduction steps. State the expected vs actual result.
- Cannot reproduce? Say so plainly and switch to evidence-only tracing. Never claim a fix for an unreproduced bug without saying it is unverified.
- Pull evidence: `storage/logs/trace/trace*.log` by `TRACE_ID`, `laravel.log`, HTTP audit rows from `LoggerRequest`, queue failure table, DB row state.

## Step 3 — Grill Me

Run `.agents/shared/grill-me.md`, bug flavour:
- When did it start? What shipped around then?
- Every time, or intermittent? What percentage of requests?
- One user/record or many? Which environment?
- Any manual DB edit, config change, or deploy in the window?
- Expected behaviour per spec — or is the spec itself wrong?

## Step 4 — Trace to Root Cause

Walk the execution path top-down with `path:line` at each hop: route → middleware → controller → validation → service → repository → model/DB → job → gateway → response.
At each hop state: expected value vs actual value, and whether the defect is already present.
Mark the exact line where reality diverges from intent.

Classify the root cause:
`logic | validation | data | migration | race condition | cache staleness | queue/retry | config/env | third-party | contract mismatch | spec defect`

Output `docs/bugs/BUG-<NNN>-<slug>/RCA.md`:

```markdown
# BUG-<NNN> — <title>
- Severity: Critical | High | Medium | Low
- Environment / first seen / TRACE_ID:
- Status: Investigating | Root Cause Found | Fixed | Verified

## Symptom
## Reproduction
## Evidence
<shortest decisive log line, exact>

## Trace Path
| Hop | path:line | Expected | Actual | Diverged |

## Root Cause
<one paragraph, one cause, at path:line>

## 5 Whys
1. Why ... → ...
2. ...

## Contributing Factors
## Why Tests Missed It
## Blast Radius
<other call sites with the same defect — search and list them>

## Fix Options
| Option | Effort | Risk | Recommendation |

## Prevention
<test, guard, monitor, or doc change that stops recurrence>
```

Add a **Mermaid `sequenceDiagram`** of the failing flow with the divergence point annotated.

## Step 5 — Impact Analysis for the Fix

Run `.agents/shared/impact-analysis.md` on the proposed fix.
Extra: corrupted data already written by the bug — is a backfill/repair script needed? Are queued jobs or cached values poisoned? Do they need flushing?
Output: `docs/bugs/BUG-<NNN>-<slug>/Impact-Analysis.md`.

## Step 6 — Approval Gate

Present `Fix-Plan.md` with the chosen option, data repair plan, and rollback.
**No code until the user approves** — EXCEPT a declared production-down hotfix, where you state the emergency, apply the minimal fix, and complete all docs immediately after.

## Step 7 — Failing Test First

Write the regression test that FAILS on current code and reproduces the bug. Show the failing output. Only then apply the fix and show it green.
Add tests for every sibling call site found in Blast Radius.

## Step 8 — Fix, Verify, Back-Propagate

- Apply the fix per `akal-standards.md`.
- Run the full suite. Report REAL numbers.
- If the spec was wrong, update the feature's 19-phase docs under `docs/features/<feature-name>/` and note the correction in `RCA.md`.
- Run the data repair script if needed; log rows touched.
- Write `Postmortem.md` for Critical/High: timeline, detection gap, monitoring added.

## Step 9 — Caveman Summary

Run `.agents/shared/caveman-summary.md`. Mandatory. Must state root cause in one line, files fixed, regression test name, real test numbers.
