---
name: analyze-project
description: Automatically inspects and fingerprints any current project/codebase where it runs (Frontend, Backend, Mobile, Monorepo, Fullstack). Discovers tech stack, framework (Next.js App/Pages Router, React/Vite/CRA, Laravel, Node, Python, Flutter), routing, state management, styling, UI components, API layer, test suite, and conventions. Generates a persistent project profile (.agents/project-profile.md), and seamlessly continues into downstream workflows (feature development, bug fixes, code reviews). Trigger on "analyze project", "scan project", "project analysis", "understand codebase", "analyze-project", "onboard project", "project context".
---

# Project Analysis & Context Onboarding (`analyze-project`)

Dynamically analyze the workspace where this skill is invoked, fingerprint the complete technical stack, document architecture and conventions, and immediately transition into the user's active task or downstream skills (`new-feature-fe`, `new-feature-be`, `bug`, `cr`, `review`).

---

## Step 1 — Workspace Discovery & Manifest Audit

Inspect the root directory to identify the project topology and ecosystems present:

```bash
# Check primary manifest and configuration files
ls -la package.json composer.json pubspec.yaml pyproject.toml requirements.txt go.mod pom.xml build.gradle Cargo.toml .env*
```

1. **Topology Detection**:
   - **Single Project**: Dedicated Frontend (`src/`), Backend (`app/` or `src/`), or Mobile (`lib/`).
   - **Monorepo**: Presence of `pnpm-workspace.yaml`, `lerna.json`, `turbo.json`, `nx.json`, or a `packages/` / `apps/` directory.
   - **Polyrepo Workspace**: Sibling directory pairings (e.g., `AppName-FE` and `AppName-BE`). Detect which side is active or analyze both.

---

## Step 2 — Deep Stack & Framework Fingerprinting

Read manifest files and dependencies to pinpoint the exact framework, libraries, and versions:

### 1. Frontend Ecosystem (Inspect `package.json`)
- **Framework**:
  - **Next.js**: Check for `next`. If present, check directory structure:
    - **App Router**: `app/` folder exists → React Server Components, `'use client'`, Server Actions (`'use server'`), route handlers (`route.ts`).
    - **Pages Router**: `pages/` folder exists → SSR (`getServerSideProps`), SSG (`getStaticProps`), `pages/api/`.
  - **React SPA**: Check bundler/scaffolding:
    - **Vite**: `vite.config.*` present.
    - **CRA**: `react-scripts` in dependencies.
    - **Remix**: `@remix-run/react` present.
  - **Vue / Nuxt / Svelte / Angular**: Detect corresponding CLI and config files.
- **Routing**: `react-router-dom` (v5 vs v6 data router), `@tanstack/react-router`, or file-based routing.
- **State Management**: Zustand, `@tanstack/react-query` (TanStack Query), Redux Toolkit (`@reduxjs/toolkit`), Context API, MobX.
- **Styling System**: Tailwind CSS (`tailwind.config.*`), CSS Modules (`*.module.css`), Vanilla CSS (`*.css`), Bootstrap, Styled Components, Emotion.
- **UI Components & Icons**: Shadcn UI (`components.json`), Radix UI, Headless UI, Material UI, Ant Design, Lucide Icons (`lucide-react`), FontAwesome.
- **Notifications & Dialogs**: SweetAlert2 (`sweetalert2`), Sonner, React-Hot-Toast, React-Toastify.
- **API & Networking**: Axios instance location (e.g., `src/Api/`, `src/services/`), Fetch wrappers, base URLs in `.env*`.

### 2. Backend Ecosystem (Inspect `composer.json`, `package.json`, `pyproject.toml`, `go.mod`)
- **Framework**:
  - **Laravel**: `artisan` file, `app/Models/`, `routes/api.php`, `routes/web.php`.
  - **Node.js**: NestJS (`@nestjs/core`), Express (`express`), Fastify (`fastify`).
  - **Python**: FastAPI (`fastapi`), Django (`django`), Flask (`flask`).
  - **Go**: Gin, Echo, Fiber, standard library.
  - **Java / Kotlin**: Spring Boot (`pom.xml` / `build.gradle`).
- **Database & ORM**: Eloquent, Prisma (`prisma/schema.prisma`), TypeORM, Sequelize, SQLAlchemy, Mongoose, GORM.
- **Authentication**: Laravel Sanctum / Passport, JWT, NextAuth / Auth.js, Passport.js, Session cookies.
- **Background Jobs & Cache**: Redis, BullMQ, Celery, Laravel Queues (`jobs`, `queues`).

### 3. Mobile Ecosystem (Inspect `pubspec.yaml`, `package.json`, etc.)
- **Flutter**: Dart SDK, state management (`flutter_bloc`, `flutter_riverpod`, `provider`), routing (`go_router`, `auto_route`), networking (`dio`, `http`).
- **React Native**: Expo (`expo`), React Native CLI, `react-navigation`.
- **Native iOS/Android**: Swift/SwiftUI vs Kotlin/Jetpack Compose.

---

## Step 3 — Architecture & Coding Conventions Audit

Inspect the project directories to uncover established patterns:

1. **Folder Architecture**:
   - Atomic design (`atoms/`, `molecules/`, `organisms/`) vs feature-based modules (`features/<name>/` or `Components/<Feature>/`) vs layered architecture (`controllers/`, `services/`, `repositories/`).
2. **Component Conventions**:
   - File extensions: `.tsx`, `.jsx`, `.vue`, `.svelte`.
   - Prop types: TypeScript interfaces vs PropTypes vs un-typed.
   - Styling pattern: Utility classes (Tailwind) vs CSS modules vs global stylesheets. Confirm that **inline styles (`style={{ ... }}`) are avoided**.
3. **API & Contract Patterns**:
   - Where are API requests initiated? (Custom hooks, Redux thunks, TanStack Query, service classes).
   - Response formatting: Standard envelop (e.g., `{ status, data, message, code }`) vs raw response.
   - Request headers: Check for correlation IDs (`X-Trace-Id`, `TRACE_ID`) and auth tokens.
4. **Testing & Tooling**:
   - Test runners: Vitest, Jest, React Testing Library, Playwright, Cypress, PHPUnit, Pytest.
   - Linting & Formatter: ESLint, Prettier, EditorConfig.

---

## Step 4 — Generate Project Profile Document

Write a structured project profile to `.agents/project-profile.md` (or `docs/project-profile.md` if `.agents` does not exist in the root):

```markdown
# Project Profile — <Project Name>

Generated on: <YYYY-MM-DD>
Workspace Root: <absolute or relative path>

## 1. Stack Overview
| Category | Technology / Library | Version / Details |
|---|---|---|
| **Platform** | Frontend / Backend / Mobile / Fullstack | |
| **Framework** | Next.js / React (Vite/CRA) / Laravel / NestJS | |
| **Language** | TypeScript / JavaScript / PHP / Python / Dart | |
| **Routing** | App Router / Pages Router / React Router / File routes | |
| **State / Cache**| TanStack Query / Zustand / Redux / Context / Eloquent | |
| **Styling** | Tailwind CSS / CSS Modules / Vanilla CSS / Bootstrap | |
| **UI & Icons** | Radix / Shadcn / Lucide / FontAwesome | |
| **Dialogs/Alerts**| SweetAlert2 / Sonner / Toast | |
| **Networking** | Axios / Fetch / Server Actions / GraphQL | |
| **Testing** | Vitest / Jest / RTL / Playwright / PHPUnit | |

## 2. Directory Layout & Architecture
<Brief tree diagram and description of src/, components, services, routes, stores>

## 3. Key Conventions & Rules
- **Styling**: Class-based styling (Tailwind/CSS Modules). NO inline CSS (`style={{}}`).
- **UI & UX Polish**: Premium UI by default, loading skeletons/spinners, SweetAlert2 for dialogs (no browser `alert()`).
- **API Handling**: Base Axios instance at `<path>`, correlation header `<header-name>`.
- **State Pattern**: <e.g. Server state via React Query, client state via Zustand>.

## 4. Run & Test Commands
- Dev Server: `<e.g. npm start / npm run dev / php artisan serve>`
- Build: `<e.g. npm run build>`
- Tests: `<e.g. npm test / vitest run / php artisan test>`
```

---

## Step 5 — Report Fingerprint & Seamless Continuation ("phir continue ho")

1. **Executive Summary**: Output a concise, clean summary of the analyzed stack in the chat response.
2. **Context Carry-Forward**:
   - If the user triggered this skill alongside a task (e.g., *"analyze this project and add feature X"* or *"scan codebase and fix bug Y"*), **IMMEDIATELY CONTINUE** into that task without stopping, applying the newly generated project profile.
   - If the user ran this as a standalone analysis, suggest the next logical skill (`new-feature-fe`, `new-feature-be`, `bug`, `cr`, `review`) tailored to the discovered tech stack.
