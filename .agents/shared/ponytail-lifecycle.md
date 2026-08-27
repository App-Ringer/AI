# Shared Module — Pony Tail Feature Lifecycle (Reference)

Governance reference for the 19-phase feature engineering lifecycle. Not a runnable workflow — executable versions live in:
- Backend: `.agents/skills/new-feature-be/SKILL.md`
- Frontend: `.agents/skills/new-feature-fe/SKILL.md`
- Mobile: `.agents/skills/new-feature-mobile/SKILL.md`

Read this document for the intent behind each phase; follow the respective skill for active execution.

## Core Mandates

1. **Design First Execution**: Every feature MUST pass through the Design Phase before any implementation code is written.
2. **Zero Code Generation Without Complete Specifications**: Never generate code until Phase 1–18 documentation is completed and explicitly approved by the user.
3. **No Unanswered Questions**: If any business logic, validation rule, or requirement is ambiguous, STOP immediately and ask all clarifying questions via "Grill Me". Do not assume business logic.
4. **Mandatory 19-Phase Artifacts**: Every feature must produce its full documentation set under `docs/features/<feature-name>/`.

---

## 19-Phase Feature Development Lifecycle

For every feature `<feature-name>`, create `docs/features/<feature-name>/` with the following 19 required documents:

1. **Phase 1 — Requirement Discovery**: Clarify all functional, security, performance, edge-case, and operational questions.
2. **Phase 2 — Impact Analysis**: `Impact-Analysis.md` (Affected modules, DB tables, screens/pages, migration & rollback plan, dev/testing estimate).
3. **Phase 3 — Detailed Feature Specification**: `Feature-Spec.md` (Business goals, current vs future flow, acceptance criteria, permissions, validation rules).
4. **Phase 4 — Use Cases**: `Use-Cases.md` (Happy path, alternative paths, failure paths, concurrency, offline mode, security abuse cases).
5. **Phase 5 — Database Design**: `DB-Changes.md` (ER diagram, table schema, indexes, constraints, migration & rollback scripts).
6. **Phase 6 — Backend Design**: `BE-Changes.md` (Architecture, controllers, services, repositories, validation, routes, middleware, background jobs).
7. **Phase 7 — Frontend / Mobile Design**: `FE-Changes.md` or `Mobile-Changes.md` (Navigation, component hierarchy, wireframes, UI states, offline caching, retry logic).
8. **Phase 8 — UI/UX Review**: `Design-Review.md` (Screens, reusable components, design tokens, typography, colors, responsive behavior, accessibility).
9. **Phase 9 — API Documentation**: `API.md` (Endpoints, headers, payload, response schemas, status codes, rate limits).
10. **Phase 10 — Logging Strategy**: `Logging.md` (Structured logs & Trace ID logging enabled via Admin Settings with dedicated trace log files).
11. **Phase 11 — Sequence Diagrams**: `Sequence-Diagram.md` (Mermaid diagrams for happy path, failure path, retry flow, validation, auth).
12. **Phase 12 — Architecture Diagrams**: `Architecture.md` (Flowchart, Component, Sequence, Deployment, Database Mermaid diagrams).
13. **Phase 13 — Unit Testing**: `Unit-Test.md` (100% test coverage target, mock strategy, edge cases, permission cases).
14. **Phase 14 — Integration Testing**: `Integration-Test.md` (API, database, queue, notification, and auth integrations).
15. **Phase 15 — E2E Testing**: `E2E-Test.md` (User journeys, admin journeys, offline/concurrency journeys, Playwright/Cypress test plan).
16. **Phase 16 — Performance Review**: `Performance.md` (Expected RPS, slow query prevention, caching, memory/CPU usage, load/stress test plan).
17. **Phase 17 — Security Review**: `Security.md` (OWASP audit, auth, injection risks, rate limiting, encryption, audit logs).
18. **Phase 18 — Deployment Plan**: `Deployment.md` (Migration order, deployment sequence, rollback plan, feature flag management, smoke tests).
19. **Phase 19 — Final Engineering Review**: `Review.md` (Final sign-off checklist across all engineering dimensions).

---

## Coding & Architectural Principles

- **SOLID, DRY, KISS**: Prefer composition over inheritance. Decouple services, repositories, and UI components.
- **Proper Imports**: Always use top-level import statements (`use` in PHP, `import` in JS/TS). Never use fully qualified inline class names.
- **SweetAlert2 Dialogs Only**: Never use browser `alert()`. Always use `swal()` (SweetAlert2) for all UI notifications, alerts, and confirmations.
- **Centralized CacheManager**: Define explicit public methods for cache keys (e.g. `placeholderImage()`). Keep `remember` / `rememberForever` private.
- **Clean Workspace**: Delete temporary throwaway scripts immediately after execution.
- **Concurrency & Locking**: Always handle race conditions using database locks (`lockForUpdate()`) on critical transactional logic.
