---
name: project-documentation-auditor
description: Analyzes any existing software project/codebase to create, audit, update, and maintain its technical documentation. Treats the actual codebase as the absolute source of truth without inventing unverified behavior. Supports Laravel/PHP, Node/NestJS/Express, Python/FastAPI/Django, React/Next.js, Java/Spring, .NET, Mobile (Flutter/RN/iOS/Android), Monorepos, Microservices, REST/GraphQL APIs, and background workers. Audits existing docs for drift (ACCURATE, OUTDATED, INCORRECT, MISSING, DUPLICATED, UNCLEAR), produces right-sized docs with verified Mermaid diagrams, and enforces zero secret exposure. Trigger on "audit docs", "document project", "project documentation", "audit documentation", "generate docs", "reverse engineer docs", "update docs", "document codebase".
---

# Project Documentation Auditor (`project-documentation-auditor`)

An autonomous, multi-stack technical documentation engineering workflow. Analyzes any existing codebase, treats code as the absolute source of truth, reverse-engineers architecture and business workflows, audits existing docs for drift, and creates or updates verified, developer-friendly documentation with Mermaid diagrams.

---

## ⚖️ CORE PRINCIPLE: The Codebase is the Source of Truth

> [!IMPORTANT]
> **The actual codebase is the absolute source of truth.**
> Never invent architecture, request flows, APIs, database relationships, external integrations, configuration, or business behavior that cannot be verified directly from the code.
> If a behavior or intent cannot be verified conclusively, state:
> *"Implementation could not be conclusively determined from the available code."*

### Multi-Stack Compatibility
This skill automatically adapts to any project topology and tech stack:
- **PHP / Laravel / Symfony / WordPress**
- **JavaScript / TypeScript / Node.js / Express / NestJS / Fastify**
- **Python / Django / FastAPI / Flask**
- **React / Next.js (App & Pages Router) / Vue / Nuxt / Svelte**
- **Java / Kotlin / Spring Boot**
- **C# / .NET Core / ASP.NET**
- **Mobile**: Flutter, React Native, Swift/iOS, Kotlin/Android
- **Architectures**: Monorepos, Microservices, REST APIs, GraphQL, CLI tools, Background Queue workers

---

## 1. Project Discovery

Begin by analyzing the complete project topology and structure. Do **not** assume conventional folder structures exist; adapt discovery to the actual files present.

### Discovery Checklist
1. **Languages & Runtimes**: Inspect manifests (`package.json`, `composer.json`, `pubspec.yaml`, `pyproject.toml`, `requirements.txt`, `go.mod`, `pom.xml`, `build.gradle`, `*.csproj`, `Dockerfile`, `.nvmrc`, `.tool-versions`).
2. **Frameworks & Build Systems**: Webpack, Vite, Turbopack, Artisan, Gradle, Maven, Cargo, Poetry, PNPM, NPM, Yarn.
3. **Application Entry Points**: HTTP kernels, server bootstraps (`index.ts`, `main.py`, `public/index.php`, `src/index.js`, `app.module.ts`, `lib/main.dart`).
4. **Boundaries & Monorepo Layout**: Sub-packages (`packages/*`, `apps/*`, `services/*`), frontend/backend demarcations.
5. **Code Layers & Artifacts**:
   - **Routes & Handlers**: `routes/`, `src/routes/`, `controllers/`, API gateways, GraphQL schemas/resolvers.
   - **Business Layer**: `services/`, `actions/`, `use-cases/`, `handlers/`, `managers/`.
   - **Data & Persistence**: `models/`, `entities/`, `repositories/`, migrations (`database/migrations/`, `prisma/migrations/`, `alembic/`).
   - **Middleware & Security**: Authentication guards, permission policies, interceptors, CORS, rate limits.
   - **Async & Scheduling**: Jobs, queues, background workers, event listeners, crons, scheduled commands.
   - **External Interfaces**: Webhooks, HTTP API clients, third-party SDK integrations.
   - **Tests & Quality**: Unit, feature, integration, E2E tests (`tests/`, `__tests__/`, `cypress/`, `playwright/`).
   - **Infrastructure**: `Dockerfile`, `docker-compose.yml`, Kubernetes manifests, GitHub Actions, CI/CD pipelines, Terraform.

---

## 2. Documentation Detection (Mode A vs Mode B)

Inspect the workspace for existing documentation:
- Check for `docs/`, `doc/`, `documentation/`, `wiki/`.
- Check root documents: `docs/INDEX.md`, `README.md`, `CONTRIBUTING.md`, `ARCHITECTURE.md`, `CHANGELOG.md`.
- Check specialized docs: API specs (`openapi.yaml`, `swagger.json`), ADRs (`docs/adr/`), setup guides, deployment guides.

### MODE A — `docs/` Does NOT Exist
Create a clean, right-sized documentation structure appropriate for the project's complexity, always anchored by `docs/INDEX.md`.

### MODE B — `docs/` ALREADY Exists
**Do NOT recreate documentation blindly or overwrite accurate work.**
1. Audit existing documentation against current code.
2. Compare each claim with the actual implementation.
3. Identify outdated, missing, incorrect, duplicated, or unclear sections.
4. Update **only** what has drifted or is missing.
5. Ensure `docs/INDEX.md` is populated and synchronized.
6. Preserve accurate, high-value historical context.

---

## 3. Codebase Reverse Engineering

Before writing any documentation, thoroughly inspect and map the underlying system across 6 critical dimensions:

### A. System Architecture
- Major components, modules, and their single-responsibility boundaries.
- Component dependencies and directional data flow.
- Internal communication (in-process events, service calls, message brokers).
- External communication (REST, gRPC, webhooks, sockets).

### B. Request / API Flow
Trace representative requests from entry to persistence:
```
Client Request
  └──> Reverse Proxy / Gateway
        └──> Routing Layer
              └──> Middleware Pipeline (Auth, Rate Limit, Validation)
                    └──> Controller / Route Handler
                          └──> Domain Service / Action
                                └──> Model / Repository Layer
                                      └──> Database / Cache / External Service
                                ┌──────┘
                          <─────┘ Domain Result
                    <─────┘ Formatted JSON / HTML Response
```

### C. Authentication & Authorization
- Auth mechanism (JWT, Laravel Sanctum/Passport, Session cookies, OAuth2, API Keys).
- Login, refresh, and logout lifecycles.
- Permission enforcement (RBAC, ABAC, Policies, Guards, Middleware).
- Security boundaries, multi-tenant scoping (`merchant_id`, `tenant_id`).

### D. Database & Data Model
- Entities, tables, schemas, and primary/foreign keys.
- Cardinality and relationships (1:1, 1:N, N:M).
- Critical indexes, soft deletes (`deleted_at`), audit trails (`created_by`, `updated_by`).
- Entity lifecycle states and state machine transitions.
- *Strict Rule: Never document real credentials, production connection strings, or sensitive data.*

### E. Background Processing & Asynchronous Jobs
- Queue drivers (Redis, SQS, RabbitMQ, DB queues).
- Job classes, payload structures, serialization, and dispatched events.
- Workers, supervisor configurations, concurrency.
- Retry policies, backoff intervals, dead-letter queues (DLQ), and failure handling.
- Scheduled cron tasks and maintenance commands.

### F. External Integrations & Third-Party Services
Identify every outbound API, SDK, and third-party dependency:
- Payment Gateways (Stripe, Razorpay, Cashfree, PayPal).
- Messaging & Communications (Twilio, WhatsApp Business API, SendGrid, SES, Firebase FCM).
- Storage & CDN (AWS S3, Cloudinary, GCP Storage).
- AI & LLM APIs (OpenAI, Gemini, Anthropic).
- Analytics, Monitoring, and Webhooks.

Document for each:
- **Purpose**: Why the service is used.
- **Direction**: Inbound (webhooks) vs Outbound (HTTP requests).
- **Auth**: Bearer token, signature verification, API secret headers.
- **Error & Retry Behavior**: Circuit breakers, exponential backoff, logging.
- *Strict Rule: NEVER document real API keys, secrets, tokens, or private credentials.*

---

## 4. Business Logic & Workflow Mapping

Documentation must not remain abstract; it must capture real domain business logic discovered in the code:
- Identify key business transactions (e.g., User Registration, Checkout, Order Processing, Invoice Generation, Appointment Booking, Lead Routing, Refund Processing).
- For each workflow, trace and document the end-to-end execution chain:
  ```
  Trigger (HTTP request, webhook, cron, event)
    ──> Validation (Request schemas, rules, permission checks)
    ──> Pre-conditions & Business Rules (Account state, inventory, balances)
    ──> Core Processing & State Transitions (Status mutations, calculations)
    ──> Database Mutations (Transactions, record creation/updates)
    ──> Synchronous External Calls (Payment capture, identity verification)
    ──> Asynchronous Dispatch (Emails, background jobs, webhook notifications)
    ──> Success Result (HTTP response format, status codes)
    ──> Failure & Rollback Handling (DB rollbacks, compensation, error responses)
  ```

---

## 5. Documentation Structure (Right-Sized)

Organize files under `docs/` based on project complexity. Always anchor navigation with `docs/INDEX.md`:

```
docs/
├── INDEX.md                           # Fast-path token-efficient Master Index (Routes, Tables, Jobs, Features)
├── README.md                          # Human developer onboarding hub & architecture map
├── architecture/
│   ├── overview.md                    # High-level architecture, tech stack & layers
│   ├── application-flow.md            # Request lifecycle & data flow
│   └── integrations.md                # Third-party services & APIs
├── api/
│   ├── overview.md                    # Auth, headers, standard envelope, error codes
│   └── endpoints.md                   # Verified endpoint specifications
├── database/
│   └── schema.md                      # Tables, relationships, state transitions & ER diagram
├── workflows/
│   ├── authentication.md              # Auth flows, session lifecycle, token refresh
│   ├── business-workflows.md          # Core business transactions & domain logic
│   └── background-processing.md       # Queues, jobs, cron schedules & retries
├── deployment/
│   ├── setup.md                       # Local environment bootstrap & dependencies
│   ├── environment.md                 # Configuration variables reference
│   └── production.md                  # Docker, workers, web server & release workflow
├── development/
│   ├── testing.md                     # Running tests, fixtures, factories & test suites
│   └── troubleshooting.md             # Common errors, debugging steps & recovery
└── CHANGELOG.md                       # Documentation change tracking
```

---

## 6. Flowcharts and Diagrams (Mermaid)

Use Mermaid diagrams extensively wherever visual representation clarifies complexity.
*Rules for Diagrams:*
- **Must reflect actual code**: Node names and transitions must match real classes, routes, tables, and jobs.
- **No decorative diagrams**: Every diagram must convey structural or sequential information.
- **Readability**: Break massive diagrams into focused sub-diagrams.

### Standard Diagram Types
1. **Architecture & Topology**: `flowchart TD`
2. **Request Lifecycle / Business Flow**: `sequenceDiagram`
3. **Database Relationships**: `erDiagram`
4. **State Transitions**: `stateDiagram`

---

## 7. Existing Documentation Audit Framework

When auditing existing documents (Mode B), evaluate each section against the code and categorize findings:

| Status | Definition | Action Required |
|---|---|---|
| **ACCURATE** | Documentation precisely matches the active codebase. | Preserve content; do not rewrite. |
| **OUTDATED** | Was valid in earlier commits, but code has drifted/evolved. | Update to reflect current implementation. |
| **INCORRECT** | Explicitly contradicts the code or describes non-existent logic. | Correct with code citation. |
| **MISSING** | Critical implementation exists in code without any documentation. | Write new verified documentation. |
| **DUPLICATED** | Same concept documented in multiple conflicting places. | Consolidate into a single canonical source. |
| **UNCLEAR** | Vague, ambiguous, or lacks detail needed for developer execution. | Refine with concrete examples and parameters. |

---

## 8. Documentation Quality Standards & Navigation

- **Compact Navigation Bar**: Every document file under `docs/` MUST start with a 1-line top navigation header:
  `> 🧭 [Master Index](../../INDEX.md) | **Domain**: <Domain> | **Tables**: [schema.md](../database/schema.md) | **API**: [endpoints.md](../api/endpoints.md)`
- **Technically Accurate**: Every claim corresponds to verified code.
- **Concrete & Specific**: Real routes, CLI commands, class names, and query parameters.
- **Cross-Linked**: Internal relative links between `INDEX.md`, `README.md`, `architecture/`, `api/`, and `database/`.
- **Maintainable**: Clear headings, standard Markdown, version-control friendly.

---

## 9. Source-of-Truth Hierarchy

When conflicting information arises, apply this strict priority order:

1. **Actual Implementation / Code** *(Highest authority)*
2. **Database Migrations & Active Schema**
3. **Configuration Files (`config/*`, `.env.example`)**
4. **Automated Test Suites & Assertions**
5. **Existing Documentation (`docs/*`)**
6. **Project `README.md`**
7. **Code Comments & Docblocks** *(Lowest authority; often stale)*

---

## 10. Environment & Configuration Security

Document environment configuration without ever leaking secrets:
- List variable names, descriptions, whether they are required, and where they are consumed.
- **STRICT PROHIBITION**: NEVER document real credentials, production passwords, private keys, API secrets, or internal auth tokens.

---

## 11. API Documentation Standard

For every documented endpoint, provide a verified specification with auth, headers, payload schemas, and response formats.

---

## 12. Database Schema & Data Models

Document verified database architecture: Entity Purpose, Key Columns & Types, Soft deletes & audit columns, Indexes, Relationships, and Mermaid `erDiagram`.

---

## 13. Deployment & Infrastructure Documentation

Document verified build and operational processes: Runtimes, Build commands, Migrations, Process supervisors, Schedulers, and Health checks.

---

## 14. Post-Documentation Validation Pass

Before concluding the documentation task, execute a thorough verification sweep:
1. **Reference Check**: Does every documented route, controller, service, job, and model actually exist in the code?
2. **File Links**: Are all Markdown links between documents valid and resolving?
3. **Diagram Syntax**: Do all Mermaid diagrams compile without syntax errors?
4. **Secret Scrubbing**: Did any real secret, private key, token, or password accidentally slip into documentation?
5. **Index Synchronization**: Is `docs/INDEX.md` fully populated and matching actual routes/tables?

---

## 15. Master Fast-Path Index (`docs/INDEX.md`) Standard

`docs/INDEX.md` is the high-speed, token-efficient lookup map used by AI agents and developers to pinpoint specs in under 300 tokens:

```markdown
# 🧭 Master Documentation Index & Registry

> **Project**: <Project Name> | **Stack**: <Stack> | **Docs Updated**: <YYYY-MM-DD>

## 1. Feature Registry
| Feature | Domain | Specification Root | API Contract | DB Schema |
|---|---|---|---|---|
| User Auth | Auth | [docs/features/auth/Feature-Spec.md](./features/auth/Feature-Spec.md) | [API.md](./features/auth/API.md) | [DB-Changes.md](./features/auth/DB-Changes.md) |

## 2. Route & Endpoint Index
| HTTP Method | Route Path | Controller / Handler | Feature Doc |
|---|---|---|---|
| `POST` | `/api/v1/orders` | `OrderController@store` | [orders/API.md](./features/orders/API.md) |

## 3. Database Table & Model Index
| Table Name | Model / Entity | Domain | Doc Reference |
|---|---|---|---|
| `orders` | `App\Models\Order` | Orders | [database/schema.md](./database/schema.md#orders) |

## 4. Background Jobs & Queues Index
| Job Class | Queue | Trigger / Schedule | Doc Reference |
|---|---|---|---|
| `ProcessPaymentJob` | `high-priority` | Checkout Event | [workflows/background-processing.md](./workflows/background-processing.md) |
```

---

## 16. Change Tracking & Non-Destructive Updates

- Never overwrite or discard accurate existing documentation.
- When updating, make targeted diffs against specific sections.
- Update `docs/INDEX.md` whenever routes, models, or features change.

---

## 17. Final Audit Summary Report

At the conclusion of the audit/documentation process, output a clean, structured summary including `docs/INDEX.md` status, created docs, diagrams added, and validation status.

---

## 18. Strict Behavioral Rules

### ❌ NEVER:
- Generate generic or boilerplate documentation without inspecting code.
- Invent endpoints, database tables, jobs, or third-party integrations.
- Expose production secrets, passwords, tokens, or private credentials.
- Blindly overwrite accurate existing documentation.

### ✅ ALWAYS:
- Inspect before writing.
- Establish active code as the supreme source of truth.
- Maintain `docs/INDEX.md` as the fast-path registry.
- Include the compact top navigation bar on every markdown file.
- Validate documentation against the code before concluding.

---

## 19. 7-Phase Execution Workflow

```mermaid
flowchart LR
  P1["Phase 1: Discover<br/>(Scan manifests & topology)"] --> P2["Phase 2: Audit<br/>(Check existing docs & INDEX.md)"]
  P2 --> P3["Phase 3: Reverse Engineer<br/>(Code, DB, APIs, Flows)"]
  P3 --> P4["Phase 4: Document<br/>(Write/update docs & INDEX.md)"]
  P4 --> P5["Phase 5: Diagram<br/>(Add verified Mermaid charts)"]
  P5 --> P6["Phase 6: Validate<br/>(Cross-check code & scrub secrets)"]
  P6 --> P7["Phase 7: Report<br/>(Output final audit summary)"]
```
