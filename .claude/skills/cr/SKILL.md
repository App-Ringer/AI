---
name: cr
description: Change Request workflow for AKAL. Use when an EXISTING documented feature must change — new rule, changed limit, added field, altered flow, scope tweak. Runs impact analysis against the existing 19-phase doc set, grill-me clarification, writes a versioned CR record, back-propagates edits into every affected feature doc (DB-Changes, BE-Changes, API, Sequence-Diagram, tests, Postman), enforces plan approval before code, and ends with a caveman summary. Trigger on "change request", "CR", "modify feature", "update spec", "requirement changed".
---

# Change Request (CR) — AKAL

For changes to a feature that ALREADY has docs under `docs/features/<feature-name>/`.
Brand-new feature? Use `new-feature-be` or `new-feature-mobile`. Broken behaviour? Use `bug`.

Read first: `.agents/shared/akal-standards.md`.

---

## Step 1 — Locate & Read the Existing Feature

- Find `docs/features/<feature-name>/`. If it does not exist, STOP and tell the user the feature is undocumented — offer to run `new-feature-be` / `new-feature-mobile` instead.
- Read the current spec set. Quote the exact current rule that is changing (`file:line`). No CR without a stated "before".

## Step 2 — Impact Analysis (Delta Mode)

Run `.agents/shared/impact-analysis.md`, focused on the delta:

- **Docs delta**: which of the 19 docs go stale? List them explicitly.
- **Code delta**: `path:line` of every controller/service/repository/model/job/widget affected.
- **Data delta**: schema change? backfill for existing rows? nullable-then-fill migration?
- **Contract delta**: is this breaking for shipped mobile builds? Additive field, or changed meaning? Force update needed?
- **Test delta**: which existing tests now assert the OLD behaviour and must change (list them — a green suite after a CR with zero test edits is a red flag).
- **In-flight state**: queued jobs, warm cache entries, open sessions/OTPs holding the OLD rule. Migration strategy for each.

Output: `docs/features/<feature-name>/changes/CR-<NNN>-<slug>/Impact-Analysis.md`.

## Step 3 — Grill Me

Run `.agents/shared/grill-me.md` plus CR-specific questions:
- Applies to existing records retroactively, or only new ones?
- Effective date / feature flag / gradual rollout?
- Is the old behaviour a supported fallback, or fully removed?
- Who signs off — is this client-approved scope?

STOP after asking.

## Step 4 — Write the CR Record

`docs/features/<feature-name>/changes/CR-<NNN>-<slug>/CR.md`:

```markdown
# CR-<NNN> — <title>
- Feature: <feature-name>
- Raised by / date:
- Status: Draft | Approved | Implemented

## Before
<exact current behaviour + doc/code refs>

## After
<exact new behaviour>

## Reason
## Clarifications
<grill-me Q&A>

## Affected Docs
| Doc | Change needed |

## Affected Code
| path:line | Change needed |

## Data Migration & Backfill
## Backward Compatibility
## Risk & Rollback
## Test Delta
| Test | Old assertion | New assertion |
```

Add a row to `docs/features/<feature-name>/changes/CHANGELOG.md` (create if missing).

## Step 5 — Back-Propagate Into Feature Docs

Edit every stale doc IN PLACE so the 19-phase set stays the single source of truth. Never leave contradictory old text.
Each edited doc gets a trailing line: `> Updated by CR-<NNN> on <YYYY-MM-DD>.`
Mandatory refresh when touched: `DB-Changes.md` erDiagram, `Sequence-Diagram.md` sequenceDiagram, `Use-Cases.md` stateDiagram, `Architecture.md` flowchart, `API.md` + `docs/api/postman.json`.

## Step 6 — Plan Approval Gate (HARD STOP)

Present the ordered implementation plan (docs already updated, code not yet touched).
**Write ZERO application code until the user explicitly approves.**

## Step 7 — Implement

Standards from `akal-standards.md` apply unchanged: `Communicator` + `ResponseMessage`, soft deletes + audit columns, `high` queue, trace logging, no hardcoded strings, `swal()`, pagination, AJAX, responsive.
Update the OLD tests to the new assertions and add new edge-case tests. Keep coverage at 100%.

## Step 8 — Verify

Run the suite, report REAL numbers. Confirm cache invalidation for changed keys and that in-flight queued jobs won't break on the new shape.

## Step 9 — Caveman Summary

Run `.agents/shared/caveman-summary.md`. Mandatory. Include what docs changed and what tests flipped.
