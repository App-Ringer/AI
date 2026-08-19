---
name: review
description: Code review workflow for AKAL. Reviews a diff, branch, PR, or file set against AKAL engineering standards — Communicator + ResponseMessage usage, soft deletes and audit columns, high-priority queues, trace logging, cache correctness, race conditions, security, test coverage, premium Blade UI rules, and doc drift versus the 19-phase feature specs. Runs impact analysis on the change, grills the author on unclear intent, reports severity-tagged findings with path:line and concrete fixes, and ends with a caveman summary. Trigger on "review", "code review", "review my PR", "audit this diff", "check my changes".
---

# Code Review — AKAL

Review only. Do NOT fix code unless the user asks. Findings first, fixes on request.

Read first: `.agents/shared/akal-standards.md`, `.agents/AGENTS.md`.

---

## Step 1 — Establish Scope

- Default: uncommitted changes + commits on the current branch vs `master` (`git diff master...HEAD`, `git status`).
- Explicit target (file, folder, PR number) overrides the default.
- State the reviewed scope in one line before findings — file count and line count. Never review a moving target silently.

## Step 2 — Impact Analysis

Run `.agents/shared/impact-analysis.md` on the diff. Reviewer lens:
- What does this change break for existing callers?
- Any DB/contract/cache/queue shape change without a migration path?
- Any behaviour change not reflected in `docs/features/<feature-name>/` (doc drift)?

## Step 3 — Grill Me (when intent is unclear)

Run `.agents/shared/grill-me.md`. Ask only where a wrong guess would produce a wrong finding:
- Intended behaviour of an ambiguous branch?
- Deliberate omission, or forgotten?
- Is this temporary/spike code or production-bound?

Ambiguity left unanswered gets reported as a `❓ QUESTION` finding, not as a false-positive bug.

## Step 4 — Review Checklist

**Correctness**
- Off-by-one, null/empty handling, wrong operator, inverted condition, unreachable branch.
- Error paths return the right business code; no swallowed exceptions.
- Transactions wrap multi-write operations; `lockForUpdate()` where two requests can collide.

**AKAL standards**
- `Communicator::success` / `Communicator::error` used; HTTP status always `200`; no redundant explicit `200` argument.
- `App\Enums\ResponseMessage` cases, never raw strings.
- Every new table/model has `SoftDeletes` + `created_by`, `updated_by`, `deleted_by`, `created_at`, `updated_at`, `deleted_at`.
- Time-sensitive job on `onQueue('high')`; job idempotent; retry/backoff set.
- Trace logging present with `TRACE_ID`; no secrets/PII/OTP in logs.
- Cache access via a named `CacheManager` method; invalidation on every write path.
- Top-level `use` imports; no inline FQCNs; no hardcoded strings.

**Security**
- Authorization checked, not just authentication. IDOR on every ID from the request.
- Mass assignment (`$fillable` / `$guarded`), SQL built from user input, unvalidated file upload.
- Rate limiting on public and auth endpoints. Secrets not committed.

**Performance**
- N+1 queries, missing index on a filtered/joined column, unbounded query without pagination, work inside a loop that belongs outside, cache stampede.

**Blade / Admin UI**
- `swal()` not `alert()`. Pagination present. AJAX with real loading + error states. No inline CSS. Responsive. Reused existing components.

**Tests**
- New logic has tests. Edge cases covered, not just happy path. Assertions are meaningful, not `assertTrue(true)`. No test deleted or skipped to make the suite green.

**Docs**
- Feature docs updated for behaviour change; `API.md` and `docs/api/postman.json` in sync.

## Step 5 — Report

One line per finding, most severe first:

```
path/to/file.php:42: 🔴 CRITICAL: <problem>. Fix: <concrete fix>.
```

Severity: `🔴 CRITICAL` (data loss, security hole, prod breakage) · `🟠 HIGH` (wrong behaviour, missing authz check, no test on risky logic) · `🟡 MEDIUM` (perf, maintainability, standard violation) · `🔵 LOW` (naming, dead code) · `❓ QUESTION` (needs author intent).

Rules: no praise padding, no scope creep, no style nits that do not change meaning. Every finding must name a concrete failure scenario — if you cannot describe how it breaks, drop it. Verify each finding by reading the surrounding code before reporting; guesses are not findings.
Write the report to `docs/reviews/<YYYY-MM-DD>-<scope>.md` when the user asks for a persisted record.

## Step 6 — Verdict

`APPROVE` · `APPROVE WITH COMMENTS` · `REQUEST CHANGES` (any 🔴 or 🟠 forces this) · `BLOCKED` (needs author answers).

## Step 7 — Caveman Summary

Run `.agents/shared/caveman-summary.md`. Mandatory. Counts by severity + verdict.
