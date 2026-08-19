# AppRinger (AR-Inbox) Workspace Rules & Governance

This file defines the engineering guidelines and user preferences for the **AppRinger (AR-Inbox)** project.

## Engineering & Governance Rules

1. **Strict Design & Impact Analysis First**: Run impact analysis and clarify missing requirements before writing code.
2. **Zero Code Generation Without Approval**: Always obtain user approval on implementation plans before modifying code.
3. **No Unanswered Questions**: If requirement details or business rules are missing, ask clarifying questions. Do not assume business logic.
4. **Multi-Tenant Scoping**: Every merchant-owned entity must use `merchant_id` and respect `MerchantScope`. Never leak cross-merchant data.

---

## User Preferences & Coding Standards (KK's Style)

1. **Premium UI by Default**: Never build raw HTML or boring MVP interfaces. Every UI must have high visual polish: soft background colors (`#f8fafc`), glassmorphism, dynamic card grids, gradient accents, SVG icons, pill-shaped badges, and micro-animations (`transform: translateY(-5px)`).
2. **Proper CSS (No Inline Styling)**: Define clean CSS blocks or use Tailwind utility classes properly. Avoid inline CSS.
3. **SweetAlert2 Only**: Never use browser `alert()`. Always use `swal()` (SweetAlert2) for notifications, alerts, and confirmations.
4. **Proper Imports**: Always use top-level `use` statements in PHP and clean imports in JavaScript/TypeScript. Do not use fully qualified inline class names.
5. **Feature Gating**: All new merchant capabilities must use `MerchantFeatureKey` and default to disabled.
6. **Clean Workspace**: Delete temporary throwaway scripts (e.g. `fix_desc.php`, one-off DB updates) immediately after execution.
7. **Concurrency & Locking**: Always consider concurrent access and race conditions. Use database locks (`lockForUpdate()`) and atomic state checks.
8. **Client-Ready Deliverables**: Ensure complete polish—no broken navigation, no cut-off text, proper overflow handling, and robust loading/error states.
9. **No Hardcoded Strings**: Use configuration files, constants, enums, or translation files.
10. **Blade Pagination**: Always use pagination for table/list datasets in Blade views. Never load un-paginated full datasets.
11. **AJAX Data Fetch & Update**: Prefer AJAX / Livewire data fetching to eliminate unnecessary full-page reloads.
12. **100% Mobile Responsive**: All Blade & Livewire UI pages must be 100% mobile-responsive.
