---
name: new-feature-be
description: Mandatory workflow for designing and implementing a NEW BACKEND feature in AKAL (Laravel, AKAL-BE/). Enforces Pony Tail governance, impact analysis, grill-me clarification, 19-phase specification docs with Mermaid diagrams, DB soft deletes + audit columns (created_by, updated_by, deleted_by, created_at, updated_at, deleted_at), Communicator::success / Communicator::error with ResponseMessage enums, trace Logger + LoggerRequest middleware, high-priority queues, admin-configurable settings, Postman docs, GitHub Actions CI/CD, 100% unit + integration + E2E coverage, strict plan-approval gate before any code, and a caveman completion summary. Trigger on "new backend feature", "new API", "add endpoint", "new-feature-be".
---

# New Backend Feature — AKAL

Scope: `AKAL-BE/` (Laravel), admin Blade UI, DB, queues, cache, API, CI/CD.
Mobile app work is OUT of scope — use `new-feature-mobile` for that. This skill may only write `Mobile-Changes.md` as a **contract document** for the mobile team.

Read first: `.agents/shared/akal-standards.md`, `.agents/AGENTS.md`.

---

## Step 1 — Impact Analysis

Run `.agents/shared/impact-analysis.md` in full.
Output: `docs/features/<feature-name>/Impact-Analysis.md`.
Database table audit is mandatory — missing table means `CREATE TABLE` migration, not `ALTER TABLE`.

## Step 2 — Grill Me

Run `.agents/shared/grill-me.md`. One numbered batch, defaults included, then STOP.
Record answers under `## Clarifications` in `Feature-Spec.md`.

## Step 3 — UI Reuse Audit (if admin UI touched)

Inventory existing Blade components, partials, CSS classes, design tokens. Reuse before creating. Record the reuse map in `Design-Review.md`. Premium aesthetics + `swal()` + pagination + AJAX + full responsiveness per `akal-standards.md`.

## Step 4 — Write All 19 Docs

Zero implementation code until all 19 files exist under `docs/features/<feature-name>/`:

1. `Impact-Analysis.md` — codebase/scope/table-existence audit, risk register, rollback, estimate.
2. `Feature-Spec.md` — business goal, current vs future flow, acceptance criteria, admin-configurable settings, `## Clarifications`.
3. `Use-Cases.md` — actors, happy/alt/failure paths, abuse cases. **Mermaid `stateDiagram`**.
4. `DB-Changes.md` — schema, indexes, constraints, locking, migration + rollback SQL, soft deletes and `created_by`/`updated_by`/`deleted_by`/`created_at`/`updated_at`/`deleted_at` on every table. **Mermaid `erDiagram`**.
5. `BE-Changes.md` — controllers, services, repositories, actions, middleware, validation, routes, jobs on `onQueue('high')`, cache keys via `CacheManager`.
6. `Mobile-Changes.md` — contract for mobile: endpoints consumed, payloads, error codes, force-update impact. Doc-only in this skill.
7. `Design-Review.md` — admin UI screens, component reuse map, tokens, responsive rules.
8. `API.md` — endpoints, headers, request/response schemas, business codes, rate limits, cURL + Postman payloads.
9. `Logging.md` — `TRACE_ID` flow, `App\Support\Logger\Logger` calls, `LoggerRequest` middleware, `storage/logs/trace/trace.log`, what is redacted.
10. `Sequence-Diagram.md` — client → API → service → DB → queue → gateway → Sanctum. **Mermaid `sequenceDiagram`** for happy, failure, retry.
11. `Architecture.md` — topology, dependencies, queue workers. **Mermaid `flowchart`**.
12. `Unit-Test.md` — 100% coverage matrix, mocks, edge cases.
13. `Integration-Test.md` — API, DB, queue, cache, auth integration matrix, 100% coverage.
14. `E2E-Test.md` — full journeys incl. admin UI, swal confirm, AJAX, cache invalidation.
15. `Performance.md` — RPS, query plans, N+1 prevention, caching strategy, load test plan.
16. `Security.md` — authz checks, input sanitization, encryption at rest, rate limits, race conditions, OWASP pass.
17. `Deployment.md` — migration order, env vars, feature flag, rollout + rollback, smoke tests.
18. `Review.md` — peer review checklist and quality gates.
19. `Walkthrough.md` — final summary, Postman link, proof of completion.

## Step 5 — Plan Approval Gate (HARD STOP)

Present `docs/features/<feature-name>/implementation_plan.md` — ordered task list, files to touch, migration order, test plan.
**Write ZERO application code until the user explicitly approves.** No "starter" code, no scaffolding, no migrations.

## Step 6 — Implement

Order: migration + model → repository → service/action → controller → routes → jobs → cache → admin UI → docs sync.

Every commit must satisfy:
- `Communicator::success(...)` / `Communicator::error(...)`, HTTP always `200`, business code inside payload.
- `App\Enums\ResponseMessage` enum cases only.
- `SoftDeletes` + audit columns on every table and model.
- Time-sensitive jobs on `onQueue('high')`, idempotent, with retry/backoff.
- Trace logging with `TRACE_ID`.
- Admin-configurable values in settings, not hardcoded.
- Top-level `use` imports, no inline FQCNs.

## Step 7 — Test to 100%

Run the suite. Report REAL pass/fail/coverage numbers. Cover expired states, lockouts, soft-deleted rows, negative input, missing relations, race conditions, cache hit vs miss. Fix failures before claiming done.

## Step 8 — Docs & Postman Sync

Update `docs/api/postman.json`, `API.md`, and `Walkthrough.md`. Verify `.github/workflows/tests.yml` and `devDeploy.yml` still cover the new paths.

## Step 9 — Caveman Summary

Run `.agents/shared/caveman-summary.md`. Mandatory.
