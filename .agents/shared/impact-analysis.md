# Shared Module — Impact Analysis

Every AKAL skill (`new-feature-be`, `new-feature-mobile`, `cr`, `bug`, `review`) MUST run this module before writing any plan or code.

## 1. Blast Radius Sweep

Search the workspace and list EVERY touched artifact with `path:line` references:

| Layer | What to audit |
|---|---|
| Routes | `AKAL-BE/routes/*.php` — new/changed endpoints, middleware groups, rate limiters |
| Controllers | Request validation, `Communicator` usage, response codes |
| Services / Actions | Business rules, transaction boundaries, side effects |
| Repositories / Models | Eloquent scopes, relations, `SoftDeletes`, casts, `$fillable` |
| Database | Existing vs missing tables, indexes, FKs, migration vs create |
| Queues / Jobs | Queue name, retries, backoff, idempotency (`high` queue for time-sensitive work) |
| Cache | `CacheManager` keys, TTL, invalidation points, stampede risk |
| Config / Enums | `config/*.php`, `App\Enums\ResponseMessage`, admin-configurable settings |
| Logging | `trace` channel, `TRACE_ID` propagation, `App\Support\Logger\Logger`, `LoggerRequest` middleware |
| Admin UI | Blade views, settings screens, dashboards |
| Mobile | Screens, state stores, DTOs, local storage schema, force-update gates |
| Tests | Existing tests that will break, fixtures, factories |
| CI/CD | `.github/workflows/tests.yml`, `.github/workflows/devDeploy.yml`, `scripts/deploy.sh` |
| Docs | `docs/features/**`, `docs/api/postman.json`, `docs/architecture/**`, `docs/db/**` |

## 2. Database Table Audit (MANDATORY)

- Verify each target table actually exists in `AKAL-BE/database/migrations/`. Missing table means a full `CREATE TABLE` migration, never `ALTER TABLE`.
- EVERY table MUST have `SoftDeletes` (`$table->softDeletes()` + trait on the model).
- EVERY table MUST have audit columns: `created_by`, `updated_by`, `deleted_by` (nullable unsigned big int) plus `created_at`, `updated_at`, `deleted_at`.
- Note concurrency needs: `lockForUpdate()`, unique constraints, atomic state transitions.

## 3. Backward Compatibility & Risk

- Breaking API change? Old mobile builds in the wild? Force-update needed?
- Data migration required for existing rows? Backfill script? Rollback path?
- Queue payload shape change while old jobs are still queued?
- Cache key shape change while old values are still warm?

## 4. Output

Write the result to the skill's designated `Impact-Analysis.md` path with:

- Affected files table (`path:line`)
- Missing vs existing tables verdict
- Risk register: `Risk | Likelihood | Impact | Mitigation`
- Rollback plan
- Effort estimate (dev + test, in hours)
