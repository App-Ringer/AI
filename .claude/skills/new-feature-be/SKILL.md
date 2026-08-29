---
name: new-feature-be
description: Mandatory workflow for designing and implementing a NEW BACKEND feature across any backend stack (Laravel, Node.js/NestJS/Express, Python/FastAPI/Django, Go, Java/Spring, etc.). Enforces clean architecture, impact analysis, grill-me clarification, 19-phase specification docs with Mermaid diagrams, DB soft deletes + audit columns (created_by, updated_by, deleted_by, created_at, updated_at, deleted_at), consistent API response wrappers with business status codes/enums, trace logging/correlation IDs, idempotent high-priority queues, configurable settings, OpenAPI/Postman documentation, 100% unit + integration + E2E coverage, strict plan-approval gate before code, and a caveman completion summary. Trigger on "new backend feature", "new API", "add endpoint", "new-feature-be".
---

# New Backend Feature Design & Implementation

Scope: Backend services, API endpoints, database schema & migrations, background queues, caching, and CI/CD.
Frontend and mobile implementations are out of scope — this skill produces client contracts (`Client-Contracts.md` or `API.md`) for frontend/mobile consumers.

Docs root: `docs/features/<feature-name>/`

---

## 🧭 Navigation Standard
Every generated markdown file must start with a compact top navigation bar for 1-hop agent traversal:
`> 🧭 [Master Index](../../INDEX.md) | **Feature**: <feature-name> | **Domain**: <Domain> | **Tables**: [DB-Changes.md](./DB-Changes.md) | **API**: [API.md](./API.md)`

---

## 🛡️ Anti-Patchwork Architecture Standard
1. **Enforce Invariants at the Root**: Design database schemas with proper constraints (foreign keys, check constraints, non-null guards, unique indexes) and use DTOs/Form Requests to make illegal states unrepresentable.
2. **Encapsulate in Domain Actions/Services**: Never place business logic directly in controllers or route closures. Encapsulate core operations in dedicated Domain Action/Service classes.
3. **Traceability**: Link every route, model, and queue job directly to its specification via `docs/INDEX.md`.

---

## Step 0 — Stack & Architecture Discovery

Before designing, inspect the workspace to identify the backend ecosystem:
- **Framework & Runtime**: Laravel, Node.js (NestJS / Express / Fastify), Python (FastAPI / Django), Go, Java/Spring, etc.
- **Database & ORM**: PostgreSQL, MySQL, SQLite, MongoDB via Eloquent, Prisma, TypeORM, SQLAlchemy, GORM, etc.
- **Queue & Cache Drivers**: Redis, RabbitMQ, SQS, database queues, Memcached.
- **Authentication**: JWT, Sanctum, Passport, OAuth2, Session-based auth.

Follow the architectural patterns and service/repository boundaries already established in the codebase.

## Step 1 — Impact Analysis

Run impact analysis across the existing backend:
- Audit existing database tables and models (missing table requires `CREATE TABLE` migration, not `ALTER TABLE`).
- Check route conflicts, middleware chains, and authorization policies.
- Assess queue worker load, cache invalidation blast radius, and external API dependencies.

Output: `docs/features/<feature-name>/Impact-Analysis.md` (with top navigation bar).

## Step 2 — Grill Me

Conduct a focused clarification interview with the user:
- Present a single numbered batch of questions with sensible defaults provided.
- Clarify domain logic, rate limits, error states, and permissions.
- STOP and wait for responses before writing detailed specifications.
- Record answers under `## Clarifications` in `Feature-Spec.md`.

## Step 3 — UI / Admin View Reuse Audit (if admin views are touched)

If the feature includes server-rendered admin views (e.g., Blade, EJS, Jinja, Thymeleaf):
- Inventory existing components, partials, CSS design tokens, and utility classes. Reuse before creating.
- Enforce premium aesthetics: modern spacing, subtle shadows, SweetAlert2 (`swal()`), AJAX with loading spinners, pagination, and responsiveness.
- Record component reuse in `Design-Review.md`.

## Step 4 — Write All 19 Backend Docs

Zero implementation code until all 19 specification files exist under `docs/features/<feature-name>/` (all featuring the top navigation bar):

1. `Impact-Analysis.md` — Codebase scope, schema audit, risk register, rollback plan, estimate.
2. `Feature-Spec.md` — Business goals, current vs future flows, acceptance criteria, configurable settings, `## Clarifications`.
3. `Use-Cases.md` — Actors, happy/alt/failure paths, abuse cases. **Mermaid `stateDiagram`**.
4. `DB-Changes.md` — Schema, indexes, constraints, locking strategies, migration SQL, soft deletes + audit columns (`created_by`, `updated_by`, `deleted_by`, `created_at`, `updated_at`, `deleted_at`). **Mermaid `erDiagram`**.
5. `BE-Changes.md` — Controllers/handlers, services, repositories, actions, middleware, request validation, routes, queue jobs, cache keys.
6. `Client-Contracts.md` — Contract for Web and Mobile consumers: endpoints, request/response schemas, business status codes, headers.
7. `Design-Review.md` — Admin/server-rendered UI screens, component reuse map, design tokens (if applicable).
8. `API.md` — Endpoints, headers, payload schemas, business codes, rate limits, cURL + Postman/OpenAPI payloads.
9. `Logging.md` — Correlation / `TRACE_ID` propagation, structured logging format, log levels, sensitive data redaction.
10. `Sequence-Diagram.md` — Client → API → Middleware → Service → DB → Queue → External Gateway. **Mermaid `sequenceDiagram`** for happy, failure, and retry flows.
11. `Architecture.md` — Topology, module boundaries, queue workers, cache layer. **Mermaid `flowchart`**.
12. `Unit-Test.md` — 100% coverage matrix for business logic, services, validators, and mappers.
13. `Integration-Test.md` — API endpoints, DB queries, transactions, queue dispatch, cache hit/miss integration matrix.
14. `E2E-Test.md` — Full journey integration test specifications.
15. `Performance.md` — Query execution plans, N+1 query prevention, indexing strategy, caching policy, rate limiting, load test plan.
16. `Security.md` — Authentication, authorization (IDOR checks on all route params), input sanitization, SQLi/XSS protection, rate limiting, secrets management.
17. `Deployment.md` — Migration execution order, environment variables, feature flags, zero-downtime rollout, rollback steps.
18. `Review.md` — Peer review checklist and quality gate criteria.
19. `Walkthrough.md` — Final deliverable summary, Postman/OpenAPI links, verification evidence.

## Step 5 — Plan Approval Gate (HARD STOP)

Present `docs/features/<feature-name>/implementation_plan.md` — ordered task list, files to touch, migration sequence, test matrix.
**Write ZERO application code until the user explicitly approves the plan.** No starter code, no scaffolding, no migration execution.

## Step 6 — Implement

Implementation sequence:
1. Database migrations & entity models (with soft deletes and audit fields).
2. Data access layer / Repositories / Query builders.
3. Business logic services / Domain actions.
4. Request validators & input sanitizers.
5. Controllers / Route handlers & middleware.
6. Asynchronous jobs / Background queue workers (idempotent, prioritized, with retry/backoff).
7. Centralized cache management & automatic invalidation on mutation.
8. Admin views / Server templates (if applicable).
9. Documentation and API contract synchronization.

Core implementation rules:
- Consistent API response formatting with structured status and business message enums/constants.
- SoftDeletes and audit author/timestamp fields on all persistent entity tables.
- Time-sensitive background tasks routed to high-priority queues with exponential backoff.
- Trace logging carrying request correlation IDs (`TRACE_ID`).
- Admin/system settings configurable via environment or database settings rather than hardcoded magic values.
- Clean top-level imports, no inline fully qualified class names.

## Step 7 — Test to 100% Coverage

Run the automated test suites (unit, integration, feature). Report REAL pass/fail numbers and coverage percentages.
Verify edge cases: expired tokens, lock contention, soft-deleted rows, negative numbers, missing relationships, race conditions, cache invalidation.

## Step 8 — Docs & Master Index Registration

1. Update `API.md`, Postman/OpenAPI collection files, and `Walkthrough.md`.
2. **Register into `docs/INDEX.md`**:
   - Add feature row to Feature Registry.
   - Add all new endpoints to the Route Index.
   - Add all new DB tables to the Database Table Index.
   - Add all new background jobs to the Async Jobs Index.
3. Ensure CI/CD workflows run all new tests.

## Step 9 — Caveman Summary

Mandatory concise completion summary: Specify endpoints created, migrations run, queue jobs added, `docs/INDEX.md` entries registered, and real test suite coverage numbers.
