# 🧠 AppRinger AI — Central Agent Standards, Skills & Tooling

[![AppRinger](https://img.shields.io/badge/AppRinger-AI%20Standards-0284c7.svg)](https://appringer.co.in)
[![Antigravity](https://img.shields.io/badge/Antigravity-Skills-orange.svg)](https://deepmind.google)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Skills-black.svg)](https://anthropic.com)
[![Cursor](https://img.shields.io/badge/Cursor-Commands-purple.svg)](https://cursor.com)

Central repository for **AppRinger's multi-stack AI coding standards, agent governance, skills, and IDE configurations** across Antigravity, Gemini CLI, Claude Code, and Cursor.

---

## 📂 Repository Contents

### 1. `.agents/skills/` (Core Agent Workflows)
Multi-stack, self-contained workflows that adapt to any project topology:

| Skill | Description | Triggers / Commands |
|---|---|---|
| **`analyze-project`** | Automatically fingerprints and inspects any project (Frontend, Backend, Mobile, Monorepo). Detects framework, routing, state, styling, APIs, and conventions; writes `.agents/project-profile.md` and seamlessly continues workflow. | `analyze project`, `scan project`, `/analyze-project` |
| **`new-feature-be`** | Designs and implements new backend features across any stack (Laravel, Node/NestJS, Python/FastAPI, Go). Enforces impact analysis, grill-me clarification, 19-phase specification docs with Mermaid diagrams, soft deletes + audit columns, structured envelopes, trace logging, and 100% test coverage. | `new backend feature`, `new API`, `/new-feature-be` |
| **`new-feature-fe`** | Designs and implements new frontend features across modern web architectures (Next.js App/Pages Router, React/Vite/CRA, Vue). Enforces premium aesthetics, proper CSS (no inline styles), SweetAlert2 dialogs, 19-phase frontend specs, and 100% test coverage. | `new frontend feature`, `new UI`, `/new-feature-fe` |
| **`new-feature-mobile`** | Designs and implements new mobile app features across any mobile stack (Flutter, React Native, iOS/Swift, Android/Kotlin). Enforces 19-phase mobile specs, design token audit, offline storage, deep linking, trace ID propagation, and 100% test coverage. | `new mobile feature`, `new screen`, `/new-feature-mobile` |
| **`project-documentation-auditor`** | Analyzes any codebase to audit existing documentation for drift (ACCURATE, OUTDATED, INCORRECT, MISSING, DUPLICATED, UNCLEAR) or generate right-sized technical docs with verified Mermaid diagrams, establishing active code as supreme source of truth with zero secret exposure. | `audit docs`, `document project`, `/project-documentation-auditor` |
| **`cr`** | Change Request workflow for modifying existing features across any codebase. Runs impact analysis against existing feature documentation, conducts clarification interviews, writes a versioned CR record, back-propagates edits into all affected specs, and enforces plan approval before code. | `change request`, `CR`, `modify feature`, `/cr` |
| **`bug`** | Bug triage, trace, and Root Cause Analysis (RCA) workflow. Reproduces defects, traces execution across stack layers and log streams, writes RCA with 5-Whys chain and Mermaid trace diagram, requires a failing regression test before fixing, and updates feature documentation. | `bug`, `broken`, `RCA`, `root cause`, `/bug` |
| **`review`** | Comprehensive code review workflow for any codebase. Audits diffs, branches, or PRs against correctness, race conditions, architecture, security (OWASP), performance (N+1 queries), UI polish, test quality, and reports severity-tagged findings. | `review`, `code review`, `review my PR`, `/review` |

### 2. `.agents/shared/` (Governance Modules)
- `engineering-standards.md`: Full multi-stack guidelines (Backend, Frontend, Mobile) and Kushaal's core styling preferences.
- `grill-me.md`: Interactive question protocol to resolve ambiguous business logic before coding.
- `impact-analysis.md`: Systematic impact assessment before making code changes.
- `ponytail-lifecycle.md`: 19-phase feature development governance reference.
- `caveman-summary.md`: Standardized ultra-concise completion summaries.

### 3. `.cursor/` (Cursor IDE Tooling)
- `commands/`: Slash commands (`/analyze-project`, `/new-feature-be`, `/new-feature-fe`, `/new-feature-mobile`, `/project-documentation-auditor`, `/cr`, `/bug`, `/review`).
- `rules/`: Governance rules (`ar-inbox-skills.mdc`, `prod-contracts.mdc`).

### 4. `.claude/` (Claude Code CLI Tooling)
- Mirror of all skills formatted for Claude Code global/project execution.

---

## ⚡ Global Installation on macOS

Run the install script to make all AppRinger AI skills globally available across **all projects on your Mac**:

```bash
# 1. Clone this repository
git clone https://github.com/App-Ringer/AI.git ~/.dotfiles/appringer-ai

# 2. Run the global installer
cd ~/.dotfiles/appringer-ai
chmod +x install.sh
./install.sh
```

---

## 🚀 1-Command Project Setup

To initialize these agent standards inside any specific project repository:

```bash
# Add this alias to your ~/.zshrc or ~/.bashrc (done automatically by install.sh):
alias init-agents="cp -r ~/.dotfiles/appringer-ai/.agents ./ && cp -r ~/.dotfiles/appringer-ai/.cursor ./ && cp -r ~/.dotfiles/appringer-ai/.claude ./"

# Inside any project:
init-agents
```

---

## 📜 Coding Guidelines & Standards (KK's Style)

1. **Premium UI by Default (No Basic MVPs)**: Modern aesthetics, soft backgrounds (`#f8fafc`), glassmorphism, dynamic grids, hover micro-animations (`transform: translateY(-5px)`).
2. **Proper CSS (No Inline Styling)**: Never write inline CSS. Use clean classes in `<style>` or framework utility classes.
3. **SweetAlert2 Only**: Never use standard browser `alert()`. Always use `swal()` (SweetAlert2) for notifications, alerts, and confirmations.
4. **Clean Workspace (No Clutter)**: Always delete temporary throwaway scripts immediately after execution.
5. **Aggressive Edge-Case Checking**: Always think of edge cases (negative values, boundary limits, missing relations, soft-deleted rows) and write unit tests without prompting.
6. **Client-Ready Deliverables**: Zero broken back buttons, no cut-off text, complete responsive polish.
7. **Concurrency & Locking**: Guard critical transactional logic with database locks (`lockForUpdate()`) and atomic checks.
8. **Proper Architecture**: No direct database calls in controllers, blade files, or views. Adhere to Service/Repository/Action patterns.
9. **Proper Imports**: Always use clean top-level import statements (`use` in PHP, `import` in JS/TS). Never use fully qualified inline names.
10. **No Hardcoded Strings**: Use config files, constants, enums, or translation dictionaries.

---

© App-Ringer. All rights reserved.
