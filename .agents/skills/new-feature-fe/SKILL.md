---
name: new-feature-fe
description: Mandatory workflow for designing and implementing a NEW FRONTEND feature across modern web architectures. Automatically detects and adapts to Next.js (App Router with Server Components/Server Actions vs Pages Router with SSR/SSG) or React SPAs (Vite, React Router, TanStack Query, Zustand/Redux). Enforces impact analysis, grill-me clarification, 19-phase frontend specification docs with Mermaid diagrams, component/design token reuse audit, premium UI aesthetics (glassmorphism, micro-animations, responsive layout), proper CSS (no inline styles), SweetAlert2/toast notifications, 100% unit + component + E2E coverage, strict plan-approval gate before code, and a caveman completion summary. Trigger on "new frontend feature", "new UI", "new screen", "new-feature-fe", "add react component", "add nextjs page", "frontend feature".
---

# New Frontend Feature Design & Implementation

Scope: Web frontend applications across Next.js and React ecosystems.
Backend and mobile implementations are out of scope — this skill binds directly to backend API contracts (`docs/features/<feature-name>/API.md`).

Docs root: `docs/features/<feature-name>/frontend/` (or `docs/features/<feature-name>/`)

---

## 🧭 Navigation Standard
Every generated markdown file must start with a compact top navigation bar for 1-hop agent traversal:
`> 🧭 [Master Index](../../INDEX.md) | **Feature**: <feature-name> | **Backend API**: [API.md](../API.md)`

---

## 🛡️ Anti-Patchwork Frontend Standard
1. **Typed DTOs & Validation**: Never use unverified `any` payloads. Validate inputs with Zod/Yup and bind to explicit backend DTO contracts.
2. **Explicit State Machines**: Handle loading, empty, error, and success states explicitly. Never mask missing data with silent fallbacks (`|| ''` or `?.`) when data absence indicates an upstream error.
3. **No Inline Hacks**: Keep styles encapsulated in CSS classes/modules or Tailwind. Keep business transformations in custom hooks/services, not inside render trees.

---

## Step 0 — Stack & Architecture Analysis (Automated Detection)

Before writing any design or code, inspect `package.json`, configuration files, and directory structure to determine the exact frontend stack and apply its architectural patterns:

### 1. Next.js Ecosystem
- **Detection**: `next` in dependencies, `next.config.js` / `next.config.mjs` / `next.config.ts`.
- **App Router (`app/`)**:
  - React Server Components (RSC) by default for data fetching and static markup.
  - Client Components (`'use client'`) strictly for interactivity, hooks, browser APIs, and state.
  - Server Actions (`'use server'`) or Route Handlers (`app/api/.../route.ts`) for mutations.
  - Special file conventions: `page.tsx`, `layout.tsx`, `loading.tsx`, `error.tsx`, `not-found.tsx`, `template.tsx`.
  - Data caching & revalidation: `fetch(..., { next: { revalidate, tags } })`, `revalidatePath()`, `revalidateTag()`.
  - SEO / Metadata: `generateMetadata()`, OpenGraph tags, JSON-LD structured data.
  - Streaming UI: `<Suspense fallback={<Skeleton />}>`.
- **Pages Router (`pages/`)**:
  - `getServerSideProps` (SSR) / `getStaticProps` (SSG) / `getInitialProps`.
  - `pages/_app.tsx`, `pages/_document.tsx`, API routes in `pages/api/`.

### 2. React SPA Ecosystem (Vite / CRA / Remix)
- **Detection**: `react` with `vite`, `@remix-run/react`, or `react-scripts`.
- **Routing**: `react-router-dom` (v6+ data routers / `createBrowserRouter`), `@tanstack/react-router`, or Remix file routes.
- **Data Fetching & Server Cache**: `@tanstack/react-query` (TanStack Query), SWR, RTK Query, or Axios client with custom hooks.
- **Client State Management**: Zustand, Redux Toolkit, Jotai, Context API.

### 3. Styling & Design System
- **Detection**: Tailwind CSS (`tailwind.config.js`), CSS Modules (`*.module.css`), Vanilla CSS (`*.css`), Styled Components, Emotion.
- **UI Components**: Shadcn UI / Radix UI, Headless UI, Mantine, Chakra UI, Lucide Icons, Framer Motion.

---

## Step 1 — Impact Analysis

Run impact analysis across the frontend codebase:
- Identify affected routes, navigation menus, and breadcrumbs.
- Audit component dependency graph: which shared atoms/molecules are reused vs newly created.
- Check state management blast radius: store schema updates, query cache key invalidations.
- Assess bundle size impact and code-splitting boundaries (dynamic imports / lazy loading).
- Verify backend API contract compatibility (endpoints, DTOs, business status codes).

Output: `docs/features/<feature-name>/frontend/Impact-Analysis.md` (with top navigation bar).

## Step 2 — Grill Me

Conduct a focused clarification interview with the user:
- Layout & Breakpoints: Target devices (Mobile-first, Tablet, Desktop, Ultra-wide)?
- Data Fetching Strategy: Real-time (polling/WebSockets), server-rendered, or client-cached with optimistic updates?
- Interaction & State: Exact UX for loading states (skeletons vs spinners), empty data states, and error retries?
- Form Validation: Client-side Zod/Yup validation rules, asynchronous availability checks?
- Internationalization & Theme: Dark/light mode support, localized string keys?

STOP after asking to await user response. Record answers under `## Clarifications` in `Feature-Spec.md`.

## Step 3 — Component & Design Token Reuse Audit

- Inventory existing UI components (Buttons, Modals, Cards, Tables, Dropdowns, Badges, Tooltips).
- Audit design tokens: color palette (primary, secondary, neutral, semantic error/success), typography scales, border radii, shadows.
- Enforce **Kushaal's Premium UI Bar**:
  - Modern aesthetic: Soft backgrounds (e.g., `#f8fafc`), glassmorphism overlays, dynamic card grids, pill-shaped badges, SVG icons.
  - Micro-animations: Hover lifts (`transform: translateY(-2px)`), smooth transitions, ripple effects, framer-motion page transitions.
  - Proper CSS: Clean scoped classes / Tailwind utilities — **NEVER inline CSS styles** (`style={{ ... }}` is prohibited except for dynamic programmatic coordinates/widths).
  - Notifications: SweetAlert2 (`swal()`) or modern toast notifications — **NEVER raw browser `alert()`**.
  - Client-Ready Polish: No cut-off texts (proper ellipsis / line clamps), touch targets ≥ 44px, flawless back-button and modal state handling.
- Record the component reuse map in `UI-Design.md`.

---

## Step 4 — Write All 19 Frontend Docs

Zero implementation code until all 19 specification files exist under `docs/features/<feature-name>/frontend/` (or `docs/features/<feature-name>/`), each featuring the top navigation bar:

1. `Impact-Analysis.md` — Route and component blast radius, bundle size impact, dependency audit, rollback plan.
2. `Feature-Spec.md` — User stories, UI acceptance criteria, interaction rules, `## Clarifications`.
3. `Use-Cases.md` — User journeys, happy/alt/error/offline paths. **Mermaid `stateDiagram`**.
4. `Component-Hierarchy.md` — Atomic component tree (Atoms → Molecules → Organisms → Templates → Pages). **Mermaid `flowchart`**.
5. `UI-Design.md` — Responsive breakpoints, design tokens, color palette, glassmorphism, micro-animations, loading/empty/error states.
6. `State-Management.md` — Global state, server cache, local component state, optimistic updates, cache keys. **Mermaid `stateDiagram`**.
7. `API-Integration.md` — Contract bindings to backend `API.md`, TypeScript DTOs, query hooks / Server Actions, error code to UI mapping.
8. `Routing-Navigation.md` — Route paths, URL search params, layouts, auth guards, redirect rules, back-stack preservation.
9. `Accessibility-SEO.md` — ARIA roles, keyboard navigation, focus trap in modals, color contrast (WCAG AA), Next.js metadata / OpenGraph.
10. `Sequence-Diagram.md` — User Event → Component → Action/Hook → API/Server → State Update → Render. **Mermaid `sequenceDiagram`**.
11. `Architecture.md` — Module topology, directory structure, data flow, boundary contracts. **Mermaid `flowchart`**.
12. `Logging-Telemetry.md` — Client error boundaries, correlation ID (`TRACE_ID`) propagation in headers, analytics events.
13. `Unit-Component-Test.md` — 100% coverage matrix for hooks, utils, and isolated components (Vitest / Jest / React Testing Library).
14. `E2E-Test.md` — Playwright / Cypress full user journey test specifications.
15. `Performance.md` — Core Web Vitals (LCP, INP, CLS), code-splitting, lazy loading, image optimization (`next/image`), memoization (`useMemo`, `useCallback`).
16. `Security.md` — XSS prevention, DOM sanitization (DOMPurify if raw HTML), CSP compliance, auth token storage (httpOnly cookies vs secure memory).
17. `Deployment-Build.md` — Build steps, environment variables (`NEXT_PUBLIC_` / `VITE_`), feature flags, static asset caching.
18. `Review.md` — Peer review checklist, UI design QA, accessibility checklist, quality gates.
19. `Walkthrough.md` — Final deliverables summary, UI screenshots, interactive demo flow, proof of completion.

Mermaid diagrams are mandatory in docs 3, 4, 6, 10, and 11.

---

## Step 5 — Plan Approval Gate (HARD STOP)

Present `docs/features/<feature-name>/frontend/implementation_plan.md` — ordered file list, component breakdown, data hooks, test plan.
**Write ZERO application code until the user explicitly approves the plan.**

---

## Step 6 — Implement (Framework-Specific Sequence)

Execute the implementation in strict dependency order:

1. **Types & Schemas**: TypeScript interfaces, DTOs, Zod validation schemas.
2. **API & Data Layer**:
   - *Next.js App Router*: Server Actions (`'use server'`) or fetch wrappers with revalidation tags.
   - *React SPA*: TanStack Query hooks (`useQuery`, `useMutation`) with typed query keys and optimistic updates.
   - Attach correlation header (`X-Trace-Id` / `TRACE_ID`) to all outgoing requests.
3. **State Management**: Zustand stores / Context providers with selectors and actions.
4. **Reusable UI Atoms & Molecules**: Buttons, inputs, modals, cards, badges adhering to design tokens.
5. **Feature Organisms & Complex Blocks**: Forms with validation, data tables with pagination/sorting, interactive charts.
6. **Page & Layout Assembly**:
   - *Next.js*: Compose `page.tsx`, `layout.tsx`, `loading.tsx` with Suspense boundaries.
   - *React SPA*: Route components, navigation links, error boundary wrappers.
7. **Interactive States & UX Polish**:
   - Loading skeletons and button spinners during async mutations.
   - SweetAlert2 / toast feedback on success and failure.
   - Graceful empty states with call-to-action buttons.
   - AbortController cleanup in useEffect to prevent race conditions on rapid user input.

---

## Step 7 — Test to 100% Coverage

- Run unit and component test suites (Vitest / Jest + React Testing Library).
- Run E2E user journeys (Playwright / Cypress).
- Report REAL pass/fail numbers and coverage percentages.
- Validate critical scenarios: Form validation failures, network timeout/retry, empty API responses, unauthorized redirect, theme switching, responsive resizing.

---

## Step 8 — Design QA & Master Index Registration

- Verify responsive layouts across mobile (375px), tablet (768px), and desktop (1280px+).
- Ensure zero unhandled console warnings/errors.
- **Register into `docs/INDEX.md`**:
  - Add feature UI page routes to Route Index.
  - Link frontend spec root under the Feature Registry.
- Update `Walkthrough.md` with UI screenshots and verification evidence.

---

## Step 9 — Caveman Summary

Mandatory concise completion summary: Specify framework mode (Next.js App/Pages vs React SPA), components created, routes added, `docs/INDEX.md` entries synced, and real test suite metrics.
