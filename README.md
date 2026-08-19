# 🧠 AppRinger AI — Central Agent Standards, Skills & Tooling

[![AppRinger](https://img.shields.io/badge/AppRinger-AI%20Standards-0284c7.svg)](https://appringer.co.in)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Skills-black.svg)](https://anthropic.com)
[![Cursor](https://img.shields.io/badge/Cursor-Rules-purple.svg)](https://cursor.com)

Central repository for **AppRinger's AI coding standards, agent governance, skills, and IDE configurations** (Claude Code, Cursor, Antigravity, Gemini CLI).

---

## 📂 Repository Contents

* **`.agents/`**: Core skill workflows and engineering governance:
  * `skills/new-feature-be/`: Backend feature & API implementation workflow.
  * `skills/new-feature-mobile/`: Mobile screen & client implementation workflow.
  * `skills/cr/`: Change request implementation for documented specs.
  * `skills/bug/`: Bug trace, root cause analysis (RCA) & fix protocol.
  * `skills/review/`: Diff and pull request code review skill.
  * `shared/`: Impact analysis, grill-me question protocol, KK coding standards, caveman summaries.
* **`.cursor/`**: Cursor slash commands (`/bug`, `/cr`, `/new-feature-be`, `/review`) and `.cursor/rules/` (`prod-contracts.mdc`, `ar-inbox-skills.mdc`).
* **`.claude/`**: Claude Code CLI skills symlink and configuration settings.

---

## ⚡ Global Installation on macOS

Run the install script to make all AppRinger AI skills and rules globally available across **all projects on your Mac**:

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
# Add this alias to your ~/.zshrc or ~/.bashrc:
alias init-agents="cp -r ~/.dotfiles/appringer-ai/.agents ./ && cp -r ~/.dotfiles/appringer-ai/.cursor ./ && cp -r ~/.dotfiles/appringer-ai/.claude ./"

# Inside any project:
init-agents
```

---

## 📜 Coding Guidelines & Standards (KK's Style)

1. **Premium UI by Default:** Clean modern aesthetics, soft backgrounds (`#f8fafc`), glassmorphism, dynamic grids, hover micro-animations.
2. **SweetAlert2 Only:** Never use standard browser `alert()`.
3. **Multi-Tenant Scoping:** Always isolate data with `merchant_id` and strict scoping.
4. **Proper Imports:** Always use clean top-level `use` statements in PHP and clean ES6 module imports in JS/TS.
5. **100% Test Coverage:** Always write and run unit and feature tests before concluding tasks.

---

© App-Ringer. All rights reserved.
