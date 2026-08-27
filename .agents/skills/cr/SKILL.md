---
name: cr
description: Change Request (CR) workflow for modifying existing features across any codebase. Runs impact analysis against existing feature documentation, conducts clarification interviews, writes a versioned CR record, back-propagates edits into all affected specifications (DB schema, backend, frontend, API contracts, sequence diagrams, tests, Postman/OpenAPI), enforces plan approval before code, and ends with a caveman summary. Trigger on "change request", "CR", "modify feature", "update spec", "requirement changed".
---

# Change Request (CR) Workflow

For modifications to a feature that ALREADY has documentation under `docs/features/<feature-name>/`.
Brand-new feature? Use `new-feature-be`, `new-feature-fe`, or `new-feature-mobile`. Broken behaviour/defect? Use `bug`.

---

## Step 1 — Locate & Read the Existing Feature

- Find `docs/features/<feature-name>/`. If it does not exist, STOP and inform the user that the feature lacks documentation — offer to run the appropriate new feature workflow (`new-feature-be` / `new-feature-fe` / `new-feature-mobile`) instead.
- Read the current specification set. Quote the exact current rule that is changing (`file:line` or doc reference). No CR proceeds without a clearly defined "before" state.

## Step 2 — Impact Analysis (Delta Mode)

Analyze the blast radius of the requested change:

- **Docs Delta**: Which feature specifications become stale? (e.g., Schema, API, State, UI, Tests).
- **Code Delta**: `path:line` of every controller, handler, service, repository, model, component, or store affected.
- **Data & Migration Delta**: Database schema changes, nullable migrations, data backfills, or transformations needed for existing records.
- **Contract Delta**: Breaking changes for mobile apps, external clients, or frontend consumers. Are new fields additive, or has payload meaning changed?
- **Test Delta**: Which existing tests assert the OLD behaviour and must be updated? (A green test suite after a CR with zero test updates indicates missing coverage).
- **In-Flight State**: Queued background jobs, cached items, active user sessions, or tokens holding the OLD rule. Migration and cache-invalidation strategy for each.

Output: `docs/features/<feature-name>/changes/CR-<NNN>-<slug>/Impact-Analysis.md`.

## Step 3 — Grill Me

Clarify business and technical boundaries:
- Does this change apply to existing records retroactively, or only to newly created ones?
- Effective date / feature flag / phased rollout needed?
- Is the old behaviour supported as a fallback, or completely deprecated?
- Are external client integrations or mobile apps affected by contract deprecation?

STOP after asking to await user response.

## Step 4 — Write the CR Record

Create `docs/features/<feature-name>/changes/CR-<NNN>-<slug>/CR.md`:

```markdown
# CR-<NNN> — <title>
- Feature: <feature-name>
- Raised by / Date:
- Status: Draft | Approved | Implemented

## Before
<exact current behaviour with doc and code references>

## After
<exact new behaviour and expectations>

## Reason
<business justification / technical rationale>

## Clarifications
<grill-me Q&A summary>

## Affected Docs
| Doc | Change Needed |

## Affected Code
| path:line | Change Needed |

## Data Migration & Backfill
## Backward Compatibility
## Risk & Rollback
## Test Delta
| Test | Old Assertion | New Assertion |
```

Add a row to `docs/features/<feature-name>/changes/CHANGELOG.md` (create if missing).

## Step 5 — Back-Propagate Into Feature Docs

Edit every stale specification document IN PLACE so the feature docs remain the single source of truth. Never leave contradictory legacy text.
Each edited document receives a trailing line: `> Updated by CR-<NNN> on <YYYY-MM-DD>.`
Mandatory diagram refresh whenever touched:
- Schema updates → Mermaid `erDiagram`
- Workflow/call updates → Mermaid `sequenceDiagram`
- State transitions → Mermaid `stateDiagram`
- Architecture/flow changes → Mermaid `flowchart`
- API changes → `API.md` and OpenAPI/Postman collection sync.

## Step 6 — Plan Approval Gate (HARD STOP)

Present the ordered implementation plan (documentation already updated, application code not yet modified).
**Write ZERO application code until the user explicitly approves the plan.**

## Step 7 — Implement

Apply the code changes following established project architecture and coding standards:
- Adhere to clean architecture (Controller/Handler → Service → Repository/Model → UI).
- Ensure DB safety (transactions, locking where needed, safe column migrations).
- Avoid magic strings and inline styles; use constants/enums and clean styling.
- Update OLD tests to reflect the new assertions and add tests for new edge cases.
- Maintain 100% test coverage.

## Step 8 — Verify

Run the automated test suite and report REAL pass/fail numbers.
Confirm cache invalidation for changed keys, check backwards compatibility, and ensure in-flight asynchronous jobs will not fail on the updated payload schema.

## Step 9 — Caveman Summary

Mandatory concise completion summary: Specify which docs changed, which files were updated, and which tests flipped/were added.
