# Claude Code Plugins Collection 🚀

> **Comprehensive collection of Claude Code plugins for enhanced development workflows.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude-Code-purple.svg)](https://claude.ai)

 ![Python](https://img.shields.io/badge/Python-3776AB?logo=python&logoColor=ffdd54)
 ![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?logo=javascript&logoColor=black)
 ![Go](https://img.shields.io/badge/Go-00ADD8?logo=go&logoColor=white)

Collection of Claude Code plugins that empower your AI assistant to enforce coding standards, streamline Python development, and enhance overall productivity.

---

## ⚡ Features

### 📋 Code Review Plugin
- **Semantic Analysis**: Goes beyond linting to check for logic, safety, and design patterns.
 - **Multi-Language Support**: First-class support for the top languages of `2025`:
   - **Python** (`.py`)
   - **JavaScript** (`.js`)
   - **Go** (`.go`)

- **Incremental Reviews**: Only reviews files modified since the last review cycle.
- **Fully Customizable**: Define your own rules or extend support to any language.

### 🐍 Python Developer Plugin
- **Modern Python Development**: Comprehensive toolkit for Python development using `uv`, `ruff`, and `mypy`.
- **Automated Quality Assurance**: Hooks that automatically format and lint code after changes.
- **Testing Excellence**: Dedicated test engineer agent with modern testing practices.
- **Legacy Code Modernization**: Refactoring specialist skill for transforming legacy code to modern patterns.
- **Project Scaffolding**: Quick setup of new Python projects with best practices.

---

## 📦 Installation

Install directly from the Claude Code marketplace:

```bash
/plugin marketplace add sydasif/claude-code-plugins
/plugin install code-review@sydasif-claude-plugins
/plugin install python-developer@sydasif-claude-plugins
```

**Requirements:** `git` and `uv` must be installed to take full advantage of the Python developer features.

---

## 🚀 Usage

Run commands directly from the Claude Code prompt:

 | Command | Description |
 | --------- | ------------- |
 | `/review` | Review only files modified since the last review. |
 | `/python-expert` | Specialized Python development guidance with modern best practices. |
 | `/test-engineer` | Focused testing expertise with coverage and best practices. |
 | `/py-init` | Scaffold a new Python project with modern tooling and best practices. |

---

## 🏗️ Architecture

- **Agents**: Specialized agents (`code-reviewer`, `python-expert`, `test-engineer`) for focused expertise.
- **Skills**: Language-specific and task-specific skill modules encapsulate domain knowledge.
- **Hooks**: Automated quality assurance that enforces standards on file changes.
- **Commands**: Custom slash commands expose functionality to the user.

---

## 📄 License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).
