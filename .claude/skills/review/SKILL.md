---
name: review
description: Comprehensive code review workflow for any codebase (Backend, Frontend, Mobile, Fullstack). Reviews diffs, branches, PRs, or file sets against core engineering standards — correctness, race conditions, architecture, security (OWASP, IDOR, input sanitization), performance (N+1 queries, memory leaks, re-renders), UI/UX polish, test quality, and documentation consistency. Runs impact analysis, grills on unclear intent, reports severity-tagged findings (CRITICAL, HIGH, MEDIUM, LOW, QUESTION) with exact path:line and concrete fixes, and ends with a caveman summary. Trigger on "review", "code review", "review my PR", "audit this diff", "check my changes".
---

# Code Review Workflow

Review only. Do NOT modify code unless explicitly requested by the user. Findings first, concrete fixes on request.

---

## Step 1 — Establish Scope

- Default scope: uncommitted changes and branch commits vs the primary branch (`git diff main...HEAD` or `git diff master...HEAD`, `git status`).
- Explicit target (file, directory, PR number) overrides the default.
- State the reviewed scope in one line before findings — include file count and lines changed (+/-). Never review a moving target silently.

## Step 2 — Impact Analysis

Run impact analysis on the diff through a reviewer lens:
- What does this change break for existing callers, consumers, or clients?
- Are there database schema, API contract, or cache shape changes without safe migration paths?
- Is there any behavioral divergence not reflected in `docs/features/<feature-name>/` (doc drift)?

## Step 3 — Grill Me (when intent is unclear)

Clarify only where guessing would result in a false-positive finding:
- What was the intended behavior of this ambiguous branch or omitted edge case?
- Is this temporary/experimental code or production-ready implementation?

Any ambiguity left unanswered must be reported as a `❓ QUESTION` finding rather than an assumed bug.

## Step 4 — Review Checklist

### 1. Correctness & Edge Cases
- Null/undefined safety, off-by-one errors, inverted conditional logic, unreachable branches.
- Proper error propagation; no swallowed errors or empty catch blocks.
- Concurrency & race conditions: Database transactions wrap multi-step writes; row locking (`lockForUpdate` or optimistic locking) where concurrent updates can collide.

### 2. Architecture & Code Cleanliness
- Clear separation of concerns (Presentation / Controller → Business Logic / Service → Data Access / Repository).
- Clean top-level imports; no inline fully qualified names or messy barrel imports.
- No magic numbers or hardcoded strings — use constants, enums, config, or translation files.

### 3. Security (OWASP)
- Authorization verified at every boundary, not just authentication (check for IDOR on all request IDs).
- Mass assignment vulnerabilities, unvalidated file uploads, SQL injection, XSS in rendered output.
- Rate limiting on public and sensitive endpoints; zero secrets or tokens committed in code.

### 4. Performance
- Backend: N+1 queries, missing database indexes on filter/join columns, unbounded queries without pagination, heavy work inside loops.
- Frontend: Unnecessary component re-renders, missing memoization on expensive calculations, unvirtualized long lists.
- Memory: Uncleaned intervals, event listeners, streams, or un-disposed subscriptions.

### 5. UI & UX Polish
- Asynchronous actions display visible loading indicators, disabled button states, and friendly error notifications.
- Modern UX: SweetAlert2 / toast notifications (never raw browser `alert()`).
- Proper CSS: Clean scoped classes / utility classes (no unstyled inline styles).
- Fully responsive across desktop, tablet, and mobile; accessible touch targets and proper text overflow handling.

### 6. Test Quality & Coverage
- New domain logic and bug fixes have dedicated tests.
- Edge cases covered (zero/negative numbers, boundary limits, concurrency, network drops, permission errors).
- Assertions are specific and meaningful; no tests deleted or skipped to make CI green.

### 7. Documentation Integrity
- Feature specifications and API schema collections (Postman / OpenAPI) updated in sync with code changes.

## Step 5 — Report Findings

Format each finding on one line, ordered from highest to lowest severity:

```
path/to/file.ext:42: 🔴 CRITICAL: <concise problem description>. Fix: <concrete fix>.
```

Severity definitions:
- `🔴 CRITICAL`: Data loss, security vulnerability, crashing defect, or production-breaking issue.
- `🟠 HIGH`: Broken business logic, missing authorization check, unhandled edge case, or untested risky logic.
- `🟡 MEDIUM`: Performance bottleneck, architectural violation, memory leak risk, or standard deviation.
- `🔵 LOW`: Minor cleanup, dead code, naming inconsistency.
- `❓ QUESTION`: Ambiguity requiring author clarification.

Rules:
- No praise padding or fluff.
- No subjective style nits that do not impact readability or execution.
- Every finding must name a concrete failure scenario — if you cannot describe how it fails, omit it.
- Verify each finding against surrounding code context before reporting.
- Write the full report to `docs/reviews/<YYYY-MM-DD>-<scope>.md` when a persisted review record is requested.

## Step 6 — Verdict

Conclude the review with one of four verdicts:
- `APPROVE` — Ready to merge/ship.
- `APPROVE WITH COMMENTS` — Non-blocking minor fixes recommended.
- `REQUEST CHANGES` — One or more `🔴 CRITICAL` or `🟠 HIGH` findings must be resolved.
- `BLOCKED` — Key design clarifications needed before completing review.

## Step 7 — Caveman Summary

Mandatory concise completion summary: Total findings count by severity tag, and final verdict.
