# AppRinger Workspace Rules & Governance

This file defines the engineering guidelines, agent governance, and user preferences for AppRinger projects across all stacks (Backend, Frontend, Mobile, Monorepos).

---

## 🏛️ Engineering & Governance Rules

1. **Strict Design & Impact Analysis First**: Run impact analysis and clarify missing requirements before writing code.
2. **Zero Code Generation Without Approval**: Always obtain explicit user approval on implementation plans and feature specifications before modifying code.
3. **No Unanswered Questions**: If requirement details or business rules are missing, ask clarifying questions ("Grill Me"). Never assume business logic.
4. **Codebase is Ground Truth**: When auditing, documenting, or debugging, the active code is the ultimate source of truth. Never invent unverified behavior.
5. **Multi-Tenant Scoping**: Every tenant/merchant-owned entity must use strict scoping (e.g. `merchant_id`). Never leak cross-tenant data.

---

## 💎 User Preferences & Coding Standards (KK's Style)

1. **Premium UI by Default (No Basic MVPs)**:
   - Never build simple, raw HTML table layouts or boring "MVP" interfaces. Every UI must have a "wow" factor out-of-the-box.
   - Modern aesthetics: soft background colors (`#f8fafc`), glassmorphism, dynamic grids/cards, gradient accents, SVG icons, pill-shaped badges, and smooth micro-animations (`transform: translateY(-5px)`).
2. **Proper CSS (No Inline Styling)**:
   - Avoid writing inline CSS (e.g. `style={{ ... }}` or `style="..."`).
   - Define clean CSS classes in `<style>` blocks or use framework utility classes properly (Tailwind CSS, CSS Modules).
3. **Interactive & Robust UX**:
   - Forms and buttons must display clear loading states (spinning icons, opacity changes, disabled states) during asynchronous requests.
4. **SweetAlert2 Only**:
   - Never use standard browser `alert()`, `confirm()`, or `prompt()`.
   - Always use `swal()` (SweetAlert2) for notifications, confirmations, and errors.
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

## 🛠️ Multi-Stack Guidelines

- **Backend (Laravel, Node.js, Python, Go)**:
  - Consistent JSON API response envelopes with business status codes.
  - Soft deletes and audit columns (`created_by`, `updated_by`, `deleted_by`, `created_at`, `updated_at`, `deleted_at`).
  - Request trace logging (`TRACE_ID`, `X-Trace-Id`).
  - High-priority queues for time-sensitive jobs (`onQueue('high')`).
  - Centralized cache managers with explicit public methods per key.
- **Frontend (React, Next.js App & Pages Router, Vue)**:
  - Next.js App Router: Strict separation of Server Components and Client Components (`'use client'`). Server Actions for mutations.
  - Next.js Pages Router: SSR / SSG best practices.
  - Skeletons and loading indicators on all async transitions.
- **Mobile (Flutter, React Native, iOS, Android)**:
  - Minimum 44px touch targets, fluid layouts, design-token reuse.
  - Offline-first resilience with local storage migrations and background sync.
- **Testing**:
  - Target 100% test coverage for critical paths, services, and calculations.
