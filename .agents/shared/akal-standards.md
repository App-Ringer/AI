# Shared Module — AKAL Engineering Standards

Non-negotiable rules referenced by every skill. Source of truth alongside `.agents/AGENTS.md`.

## Backend (Laravel — `AKAL-BE/`)

- **Communicator**: API controllers ALWAYS return `Communicator::success(...)` / `Communicator::error(...)`. HTTP status is ALWAYS `200`. Business status (`200`, `422`, `429`, `500`) rides inside the JSON payload. Never pass a redundant explicit `200` to `Communicator::success`.
- **ResponseMessage enum**: use `App\Enums\ResponseMessage` cases, never raw strings — e.g. `Communicator::success($data, ResponseMessage::OTP_SENT)`.
- **Logger**: use `App\Support\Logger\Logger`. HTTP audit via the `LoggerRequest` middleware. `trace` channel configured in `config/logging.php`, daily files at `storage/logs/trace/trace.log`, unique `TRACE_ID` per request.
- **Queues**: time-sensitive work (SMS OTP, urgent alerts) goes on the `high` queue via `onQueue('high')`. Jobs must be idempotent and have explicit retry/backoff.
- **Soft deletes + audit columns**: every table and model — `SoftDeletes`, `created_by`, `updated_by`, `deleted_by`, `created_at`, `updated_at`, `deleted_at`.
- **Concurrency**: `lockForUpdate()` + atomic state checks on transactional logic.
- **No hardcoded strings**: config files, enums, constants, or lang files only.
- **Imports**: top-level `use` statements. No fully-qualified inline class names.
- **CacheManager**: one explicit public method per cache key (e.g. `placeholderImage()`); `remember` / `rememberForever` stay private.
- **API separation**:
  - `GET /api/v1/masterData` — public client config (app version, force update, support info, banners).
  - `GET /api/v1/system/config` — authenticated **client-safe** config only. NEVER return server secrets (SMS gateway key, FCM server key, third-party server tokens): every mobile user holds a Sanctum token, so anything on this endpoint is effectively public. Secrets are administered through the session-authenticated admin panel and stored in the `settings` table.
  - `POST /api/v1/admin/system/config` — admin update endpoint.

## Admin / Blade UI

- Premium aesthetics: soft background (`#f8fafc`), glassmorphism, card grids, gradient accents, SVG icons, pill badges, micro-animations (`transform: translateY(-5px)`).
- No inline CSS. Clean CSS classes or established utility classes.
- `swal()` (custom theme dialog) for every notification/confirm. NEVER browser `alert()`.
- Pagination always. Never render an un-paginated list.
- AJAX fetch/update to avoid page reloads; real loading + error states.
- 100% mobile responsive: fluid wrap, overflow handling, touch-sized targets.
- Reuse existing Blade components before creating new ones.

## Testing

- 100% coverage target on services, controllers, actions, gateway integrations.
- Aggressive edge cases: expired OTP, lockout, soft-deleted rows, negative input, missing relations, race conditions, cache hit vs miss.
- Run the suite and report REAL numbers.

## CI/CD (`.github/workflows/`)

- `tests.yml` — PHPUnit on push/PR, PHP 8.3, PCOV coverage, SQLite in-memory.
- `devDeploy.yml` — SSH deploy to test server with passkey validation, runs `scripts/deploy.sh`.

## Docs

- Mermaid mandatory: `sequenceDiagram` (Sequence-Diagram.md), `flowchart` (Architecture.md), `stateDiagram` (Use-Cases.md), `erDiagram` (DB-Changes.md).
- Postman payloads, cURL examples, headers, env vars in `API.md` and `docs/api/postman.json`.
