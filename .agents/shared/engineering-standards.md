# Shared Module — AppRinger Engineering Standards & KK's Style

Non-negotiable engineering standards referenced by every skill across AppRinger codebases. Source of truth alongside `.agents/AGENTS.md`.

---

## 1. Core Engineering Preferences (KK's Style)

1. **Premium UI by Default (No Basic MVPs)**:
   - Never build simple, raw HTML table layouts or boring "MVP" interfaces. Every UI built must have a "wow" factor out-of-the-box.
   - Modern aesthetics: soft background colors (e.g., `#f8fafc`), glassmorphism, dynamic grids/cards, gradient accents, SVG icons, pill-shaped badges, and smooth micro-animations (`transform: translateY(-5px)`, box-shadows).
2. **Proper CSS (No Inline Styling)**:
   - Avoid writing inline CSS (e.g. `style={{ ... }}` or `style="..."`).
   - Define clean CSS classes in `<style>` blocks or use framework utility classes properly (Tailwind CSS, CSS Modules).
3. **Interactive & Robust UX**:
   - Forms and buttons must display clear loading states (spinning icons, opacity changes, disabled states) during asynchronous requests.
4. **SweetAlert2 Only**:
   - Never use standard browser `alert()`, `confirm()`, or `prompt()`.
   - Always use `swal()` (SweetAlert2) or modern custom dialogs for notifications, confirmations, and errors.
5. **Clean Workspace (No Clutter)**:
   - If temporary throwaway scripts are written (e.g., `fix_desc.php`, one-off data migration scripts), delete them immediately after execution. Do not leave temporary scripts in the repo.
6. **Aggressive Edge-Case Checking**:
   - When writing logic (especially financial, calculations, payouts, or commissions), aggressively test and handle edge cases: negative numbers, zero values, boundary limits, missing relationships, soft-deleted records, and expired sessions.
   - Write comprehensive unit tests for all identified edge cases.
7. **Client-Ready Deliverables**:
   - Features must always be 100% "Client-Ready" before handoff.
   - No broken navigation or back buttons, no cut-off text (proper overflow ellipsis/wrap), no unhandled error states, and complete visual polish.
8. **Race Conditions & Concurrency**:
   - Anticipate simultaneous user interactions.
   - Implement database locks (`lockForUpdate()`), transactions, and atomic state validation on critical flows.
9. **Proper Architecture (No Direct Logic in Views/Controllers)**:
   - Avoid direct database queries inside controllers, views, or template files.
   - Adhere strictly to the project's Service / Repository / Action / Store architectural patterns.
10. **State Management & Navigation**:
    - Ensure client UI states (back button behaviors, modal states, multi-step wizards, and skipped steps) are handled gracefully without broken state transitions.
11. **Proper Imports**:
    - Always use clean top-level import statements (`use` in PHP, `import` in JS/TS/Python).
    - Never use fully qualified inline namespaces (e.g., `\App\Support\CacheManager`).
12. **No Hardcoded Strings**:
    - Avoid hardcoding strings, URLs, API keys, or magic numbers directly in logic or UI.
    - Use configuration files, constants, enums, or internationalization/translation dictionaries.

---

## 2. Backend Engineering Standards

- **API Envelopes & Response Consistency**:
  - Return standardized JSON response envelopes containing business status codes, messages, and payloads.
  - In Laravel: Return `Communicator::success(...)` / `Communicator::error(...)` or standardized API resources with HTTP 200/appropriate status and payload business codes.
- **Audit Columns & Soft Deletes**:
  - Every business entity table must incorporate `SoftDeletes`, `created_by`, `updated_by`, `deleted_by`, `created_at`, `updated_at`, `deleted_at`.
- **Trace Logging & Correlation IDs**:
  - Ensure every inbound request propagates or generates a unique correlation ID (`TRACE_ID`, `X-Trace-Id`).
  - Structured logs must include this trace ID for seamless cross-service root cause analysis.
- **Queue Workflows**:
  - Time-critical background operations (notifications, OTPs, urgent tasks) must be routed to high-priority queues (`high`).
  - All background jobs must be idempotent and define explicit retry and backoff strategies.
- **Multi-Tenant Scoping**:
  - Always enforce tenant/merchant isolation (e.g. `merchant_id`, `tenant_id`) at the query or model scope level. Never allow cross-tenant data leaks.
- **Cache Management**:
  - Centralize cache keys in a dedicated cache manager with explicit public methods (e.g., `placeholderImage()`); keep raw `remember`/`rememberForever` private.

---

## 3. Frontend Engineering Standards

- **Next.js & React Framework Awareness**:
  - Next.js App Router: Strictly isolate Server Components (`app/`) and Client Components (`'use client'`). Use Server Actions (`'use server'`) for server-side mutations.
  - Next.js Pages Router: Use `getServerSideProps` for SSR, `getStaticProps` for SSG, and `pages/api/` for route handlers.
  - React SPAs (Vite, CRA): Manage state via TanStack Query (server state) and Zustand/Redux (client state).
- **Responsive Layout & Accessibility**:
  - Fluid mobile-responsive designs (touch targets ≥ 44px, appropriate flex/grid wrapping).
  - Proper heading hierarchy (single `<h1>`, logical `<h2>`/`<h3>`), semantic HTML elements, accessible form labels.
- **Data Fetching & Feedback**:
  - Use AJAX / TanStack Query hooks to eliminate unnecessary page refreshes.
  - Display skeleton loaders or spinner states during loading.

---

## 4. Mobile Engineering Standards

- **Cross-Platform & Native Foundations**:
  - Flutter, React Native, Native iOS (Swift/SwiftUI), Native Android (Kotlin/Jetpack Compose).
  - Maintain reusable widget/component catalogs; audit design tokens before writing new widgets.
- **Offline Resilience & Sync**:
  - Implement robust local persistence (SQLite, Room, CoreData, Hive, WatermelonDB) with database migrations.
  - Graceful network transitions and automated retry queues for offline mutations.
- **Telemetry & Deep Linking**:
  - Propagate `TRACE_ID` on every outbound API call.
  - Define URL schemes and universal links for seamless deep linking.

---

## 5. Documentation Standards

- **Codebase is Ground Truth**: Never invent architecture, APIs, database relationships, or flows not present in code.
- **Mermaid Diagrams**: Include editable Mermaid diagrams (`flowchart TD`, `sequenceDiagram`, `erDiagram`) for all complex flows and architectures.
- **Zero Secret Exposure**: Never document real API keys, credentials, passwords, or private tokens.
