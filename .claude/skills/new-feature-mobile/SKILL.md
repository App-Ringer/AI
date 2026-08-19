---
name: new-feature-mobile
description: Mandatory workflow for designing and implementing a NEW MOBILE APP feature in AKAL (AKAL-Mobile/). Enforces impact analysis, grill-me clarification, a 19-phase mobile specification doc set with Mermaid diagrams under docs/features/<feature-name>/mobile/, widget reuse and design-token audit, state management spec, API contract binding to the backend, offline/local storage, permissions and deeplinks, TRACE_ID propagation and crash reporting, accessibility, force-update and store release plan, 100% unit + widget + E2E coverage, strict plan-approval gate before any code, and a caveman completion summary. Trigger on "new mobile feature", "new screen", "app feature", "new-feature-mobile".
---

# New Mobile Feature — AKAL

Scope: `AKAL-Mobile/` only. Backend/API/DB work is OUT of scope — use `new-feature-be`.
If the feature needs a new or changed endpoint, STOP and require the backend contract (`docs/features/<feature-name>/API.md`) to exist and be approved first. Mobile never invents API shapes.

Read first: `.agents/shared/akal-standards.md`, `.agents/AGENTS.md`.

Docs root for this skill: `docs/features/<feature-name>/mobile/`.

---

## Step 1 — Impact Analysis

Run `.agents/shared/impact-analysis.md`, mobile lens:
- Screens, routes, navigation graph entries affected.
- State stores / blocs / providers touched.
- DTO + model changes, JSON contract drift, nullable fields.
- Local storage / secure storage schema and its migration path.
- Minimum supported OS, app version gate, force-update need for old builds.
- App size and dependency additions (justify every new package).
- Existing widget/theme tokens that already solve this.

Output: `docs/features/<feature-name>/mobile/Impact-Analysis.md`.

## Step 2 — Grill Me

Run `.agents/shared/grill-me.md` plus mobile-specific questions:
- Offline behaviour: cached read, queued write, or hard block?
- Loading/empty/error/retry states per screen — what copy?
- Back-navigation and deeplink entry from push notification?
- Permission denied permanently — what fallback UI?
- Which strings need localisation now vs later?
- Analytics events required?

STOP after asking. Record answers in `Feature-Spec.md` under `## Clarifications`.

## Step 3 — Widget & Design Token Reuse Audit

Inventory existing widgets, themes, spacing/color/typography tokens, shared components. Reuse first; new widget requires justification. Record the reuse map in `UI-Design.md`.
Aesthetic bar matches the AKAL premium standard: soft surfaces, subtle depth, gradient accents, micro-animations, no jank, touch targets ≥ 44dp.

## Step 4 — Write All 19 Mobile Docs

Zero implementation code until all 19 files exist under `docs/features/<feature-name>/mobile/`:

1. `Impact-Analysis.md` — blast radius, version gating, risk register, rollback, estimate.
2. `Feature-Spec.md` — goal, acceptance criteria, remote-config toggles, `## Clarifications`.
3. `Use-Cases.md` — actors, happy/alt/failure/offline paths. **Mermaid `stateDiagram`**.
4. `Screen-Flow.md` — navigation graph, entry points, deeplinks, back-stack rules. **Mermaid `flowchart`**.
5. `UI-Design.md` — screens, widget reuse map, design tokens, typography, dark mode, accessibility (labels, contrast, dynamic text scaling), empty/loading/error states.
6. `State-Management.md` — store/bloc/provider design, events, states, side effects, disposal. **Mermaid `stateDiagram`**.
7. `API-Integration.md` — endpoints consumed (bound to backend `API.md`), DTOs, serialization, business-code → UI message mapping, timeouts, retry/backoff.
8. `Local-Storage.md` — cached entities, secure storage items, schema versioning + migration, eviction, what must never be persisted.
9. `Permissions-Deeplinks.md` — OS permissions with rationale copy, denied/permanently-denied fallbacks, push handling, deeplink routes.
10. `Sequence-Diagram.md` — UI → state store → repository → API → cache. **Mermaid `sequenceDiagram`** for happy, failure, offline, retry.
11. `Architecture.md` — layering, module boundaries, DI graph. **Mermaid `flowchart`**.
12. `Logging.md` — `TRACE_ID` header propagation to backend, crash/error reporting, log redaction rules, debug-only logs.
13. `Unit-Test.md` — 100% coverage matrix for state stores, mappers, validators, repositories (mocked).
14. `Widget-Test.md` — per-screen widget tests: every state, tap targets, form validation, accessibility semantics.
15. `E2E-Test.md` — full journeys on device/emulator: cold start, deeplink entry, offline mode, permission denial, back navigation.
16. `Performance.md` — frame budget/jank, list virtualization, image caching, cold start time, app size delta, battery/network cost.
17. `Security.md` — secure storage of tokens, certificate pinning, obfuscation, root/jailbreak posture, screenshot/clipboard rules for sensitive screens, no secrets in the bundle.
18. `Release-Deployment.md` — build flavors, version bump, force-update gate via `/api/v1/masterData`, staged store rollout, rollback/kill-switch.
19. `Review.md` — peer review checklist, quality gates, final walkthrough with screenshots and proof of completion.

Mermaid mandatory in docs 3, 4, 6, 10, 11.

## Step 5 — Plan Approval Gate (HARD STOP)

Present `docs/features/<feature-name>/mobile/implementation_plan.md` — ordered task list, files to touch, package additions, test plan.
**Write ZERO app code until the user explicitly approves.**

## Step 6 — Implement

Order: models/DTOs → repository + API client → state store → widgets → screens → navigation/deeplinks → local storage → localisation → analytics.

Rules:
- No hardcoded strings — localisation files or constants.
- No hardcoded colors/spacing — design tokens only.
- Every async path renders loading, empty, error, and retry states.
- Every network call carries `TRACE_ID` and maps business codes to user-facing copy.
- No secrets, tokens, or keys in source or bundle.
- Dispose controllers/streams/listeners. No leaks.

## Step 7 — Test to 100%

Run unit + widget + E2E suites. Report REAL numbers. Cover offline, expired token refresh, permission denied, empty list, slow network, back navigation, deeplink cold start.

## Step 8 — Release Prep

Version bump, force-update matrix, screenshots for `Review.md`, changelog entry in `docs/release-notes/`.

## Step 9 — Caveman Summary

Run `.agents/shared/caveman-summary.md`. Mandatory.
