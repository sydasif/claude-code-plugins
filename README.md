# Claude Code Review Plugin 🚀

> **Semantic code reviews for Claude Code using customizable project-specific rules.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude-Code-purple.svg)](https://claude.ai)

![Python](https://img.shields.io/badge/Python-3776AB?logo=python&logoColor=ffdd54)
![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?logo=javascript&logoColor=black)
![Go](https://img.shields.io/badge/Go-00ADD8?logo=go&logoColor=white)
![Rust](https://img.shields.io/badge/Rust-000000?logo=rust&logoColor=white)
![C#](https://img.shields.io/badge/C%23-239120?logo=c-sharp&logoColor=white)

Empower your AI assistant to enforce your project's coding standards. This plugin enables manual and automated code reviews against language-specific best practices.

---

## ⚡ Features

- **Semantic Analysis**: Goes beyond linting to check for logic, safety, and design patterns.
- **Multi-Language Support**: First-class support for the top languages of `2025`:
  - **Python** (`.py`)
  - **JavaScript** (`.js`)
  - **Go** (`.go`)
  - **Rust** (`.rs`)
  - **C#** (`.cs`)

- **Incremental Reviews**: Only reviews files modified since the last review cycle.
- **Fully Customizable**: Define your own rules or extend support to any language.

---

## 📦 Installation

Install directly from the Claude Code marketplace:

```bash
/plugin marketplace add sydasif/claude-code-plugins
/plugin install code-review@sydasif-claude-plugins
```

**Requirements:** `git` must be installed, to track file changes.

---

## 🚀 Usage

Run reviews directly from the Claude Code prompt:

| Command | Description |
|---------|-------------|
| `/review` | Review only files modified since the last review. |
| `/codebase-review` | perform a full review of the entire codebase. |

---

## 🏗️ Architecture

- **Agent**: A specialized `code-reviewer` agent applies semantic rules.
- **Commands**: Custom slash commands expose functionality to the user.
- **Skills**: Language-specific skill modules encapsulate review logic.

---

## 📄 License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).
