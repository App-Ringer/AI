---
name: new-feature-mobile
description: Mandatory workflow for designing and implementing a NEW MOBILE APP feature across any mobile stack (Flutter, React Native, iOS/Swift/SwiftUI, Android/Kotlin/Jetpack Compose). Enforces impact analysis, grill-me clarification, 19-phase mobile specification docs with Mermaid diagrams under docs/features/<feature-name>/mobile/, widget/component reuse and design-token audit, state management design, API contract binding, offline/local storage with migrations, permissions and deeplink routing, correlation ID propagation and crash telemetry, accessibility, store release planning, 100% unit + widget + E2E coverage, strict plan-approval gate before code, and a caveman completion summary. Trigger on "new mobile feature", "new mobile screen", "mobile app feature", "new-feature-mobile".
---

# New Mobile Feature Design & Implementation

Scope: Mobile application codebase (Flutter, React Native, iOS native, Android native).
Backend / API / Database implementations are out of scope — if the feature requires a new or modified backend endpoint, require the backend contract (`docs/features/<feature-name>/API.md`) to exist and be approved first. Mobile never invents unsupported API shapes.

Docs root: `docs/features/<feature-name>/mobile/`

---

## Step 0 — Stack & Mobile Ecosystem Discovery

Inspect the mobile workspace to identify the framework and architectural patterns:
- **Framework**: Flutter (Dart), React Native (TypeScript), iOS (Swift / SwiftUI / UIKit), Android (Kotlin / Jetpack Compose).
- **State Management**: Bloc, Riverpod, Provider, Zustand, Redux Toolkit, MobX, ViewModel / StateFlow.
- **Networking & Cache**: Dio, Axios, Retrofit, Apollo GraphQL, TanStack Query.
- **Local & Secure Storage**: SQLite, Drift, Realm, MMKV, Room, CoreData, FlutterSecureStorage, Keychain/Keystore.
- **Navigation & Routing**: GoRouter, AutoRoute, React Navigation, Navigation Component, SwiftUI Navigation.

## Step 1 — Impact Analysis

Run impact analysis across the mobile app:
- Identify screens, routes, and navigation back-stack entries affected.
- Audit state stores, view models, and domain providers touched.
- Check DTO / model changes, JSON contract drift, and nullable fields.
- Analyze local database / secure storage schema migrations and version increments.
- Verify minimum supported OS version and whether a forced app update gate is required.
- Assess app binary size impact and justify any new third-party package dependencies.

Output: `docs/features/<feature-name>/mobile/Impact-Analysis.md`.

## Step 2 — Grill Me

Conduct a focused clarification interview with the user:
- Offline behaviour: Cached read, queued write with background sync, or immediate blocking alert?
- Screen states: Exact copy and visual design for loading, empty, error, and retry states?
- Navigation: Back-stack behavior and deeplink entry from push notifications?
- Permissions: What fallback UI appears when permissions are permanently denied?
- Localization & Internationalization (i18n): What strings need localization keys?
- Analytics & Telemetry: What custom event tracking is required?

STOP after asking to await user response. Record answers under `## Clarifications` in `Feature-Spec.md`.

## Step 3 — Widget / Component & Design Token Reuse Audit

- Inventory existing widgets/components, design tokens (color palette, spacing, typography scales), and custom themes. Reuse before creating new primitives.
- Enforce premium mobile aesthetics: soft surfaces, subtle depth, gradient accents, fluid micro-animations (hero transitions, swipe gestures), no UI jank (60fps), and accessible touch targets (≥ 44x44 dp / pt).
- Record the component reuse map in `UI-Design.md`.

## Step 4 — Write All 19 Mobile Docs

Zero implementation code until all 19 specification files exist under `docs/features/<feature-name>/mobile/`:

1. `Impact-Analysis.md` — Blast radius, dependency audit, OS version gating, risk register, rollback plan.
2. `Feature-Spec.md` — User stories, business goals, acceptance criteria, remote-config toggles, `## Clarifications`.
3. `Use-Cases.md` — Actors, happy/alt/failure/offline paths. **Mermaid `stateDiagram`**.
4. `Screen-Flow.md` — Navigation graph, entry points, modal stacks, deeplinks, back-stack rules. **Mermaid `flowchart`**.
5. `UI-Design.md` — Screen layouts, component reuse map, design tokens, typography, dark mode, accessibility (contrast, dynamic font scaling), empty/loading/error states.
6. `State-Management.md` — State store / Bloc / ViewModel architecture, event dispatchers, state transitions, side effects, disposal lifecycle. **Mermaid `stateDiagram`**.
7. `API-Integration.md` — Endpoints consumed (bound to backend `API.md`), DTO serialization/deserialization, business status code to UI copy mapping, timeouts, retry/backoff.
8. `Local-Storage.md` — Cached entities, secure storage items, schema versioning, migration scripts, eviction policies, sensitive data protection rules.
9. `Permissions-Deeplinks.md` — OS permissions with rationale copy, denied/blocked fallbacks, push notification handling, URL schemes & universal/app links.
10. `Sequence-Diagram.md` — UI → State Store → Repository → API Client → Local Cache. **Mermaid `sequenceDiagram`** for happy, failure, offline, and retry flows.
11. `Architecture.md` — Layering (UI / Presentation → Domain → Data), module boundaries, Dependency Injection (DI) graph. **Mermaid `flowchart`**.
12. `Logging.md` — Correlation ID (`TRACE_ID`) header propagation to backend, crash reporting, breadcrumbs, debug vs release log redaction.
13. `Unit-Test.md` — 100% coverage matrix for state stores, view models, mappers, validators, and repositories (with mocks).
14. `Widget-Test.md` — Per-screen widget/component tests: every state (loading, error, empty, success), tap targets, form validation, accessibility semantics.
15. `E2E-Test.md` — Full journeys on device/simulator: cold start, deeplink deep entry, offline mode, permission denial, back-navigation.
16. `Performance.md` — Frame rendering budget (60/120fps), list virtualization, image caching/downsampling, cold start latency, memory leak audit, battery/network efficiency.
17. `Security.md` — Secure storage of auth tokens, TLS/certificate pinning, code obfuscation, root/jailbreak posture, clipboard/screenshot privacy on sensitive screens, zero secrets in the app bundle.
18. `Release-Deployment.md` — Build flavors (dev/staging/prod), version code/name bump, minimum supported version check, phased store rollout, rollback/kill-switch strategy.
19. `Review.md` — Peer review checklist, quality gates, and final walkthrough with UI screenshots and verification evidence.

## Step 5 — Plan Approval Gate (HARD STOP)

Present `docs/features/<feature-name>/mobile/implementation_plan.md` — ordered task list, files to touch, package additions, test plan.
**Write ZERO application code until the user explicitly approves the plan.**

## Step 6 — Implement

Implementation sequence:
1. Models, DTOs, and JSON serialization logic.
2. Repository and API client layer (bound to API contracts).
3. State stores / ViewModels / Blocs with event/state handlers.
4. Shared reusable UI widgets and design token integration.
5. Feature screen assemblies with loading, error, empty, and retry states.
6. Navigation routing and deeplink integration.
7. Local database / secure storage cache and schema migrations.
8. Localization keys and strings.
9. Analytics event tracking and telemetry.

Core implementation rules:
- No hardcoded strings — use localization files or centralized constants.
- No hardcoded colors or spacing — use design system tokens and themes.
- Every asynchronous operation must handle and render loading, empty, error, and retry states.
- Every HTTP request must propagate correlation/trace ID headers.
- Never store secrets or sensitive credentials in client bundles.
- Properly dispose controllers, streams, listeners, and subscriptions to eliminate memory leaks.

## Step 7 — Test to 100% Coverage

Run unit, widget/component, and E2E integration test suites. Report REAL pass/fail numbers and coverage metrics.
Validate edge cases: network disconnection, token expiration & refresh, permission denial, empty data lists, slow network latency, system font scaling, and deeplink cold starts.

## Step 8 — Release Prep & Documentation Sync

Bump version identifiers, update changelogs, capture UI screenshots for `Review.md`, and verify CI/CD build scripts pass.

## Step 9 — Caveman Summary

Mandatory concise completion summary: State screens created, state stores added, package additions, and real test suite numbers.
