# Claude Code Review Plugin 🚀

> **Semantic code reviews for Claude Code using customizable project-specific rules.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude-Code-purple.svg)](https://claude.ai)

![Python](https://img.shields.io/badge/Python-3776AB?logo=python&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?logo=javascript&logoColor=black)
![Go](https://img.shields.io/badge/Go-00ADD8?logo=go&logoColor=white)
![Rust](https://img.shields.io/badge/Rust-000000?logo=rust&logoColor=white)
![C#](https://img.shields.io/badge/C%23-239120?logo=c-sharp&logoColor=white)

Empower your AI assistant to enforce your project's coding standards. This plugin enables manual and automated code reviews against language-specific best practices.

---

## ⚡ Features

- **Semantic Analysis**: Goes beyond linting to check for logic, safety, and design patterns.
- **Multi-Language Support**: First-class support for the top languages of 2025:
  - 🐍 **Python** (`.py`)
  - 🌐 **JavaScript** (`.js`)
  - 🐹 **Go** (`.go`)
  - 🦀 **Rust** (`.rs`)
  - #️⃣ **C#** (`.cs`)
- **Incremental Reviews**: Only reviews files modified since the last review cycle.
- **Fully Customizable**: Define your own rules or extend support to any language.

---

## 📦 Installation

Install directly from the Claude Code marketplace:

```bash
/plugin marketplace add sydasif/claude-code-plugins
/plugin install code-review@sydasif-claude-plugins
```

**Requirements:** `jq` must be installed.

- **macOS**: `brew install jq`
- **Linux**: `sudo apt-get install jq`

---

## ⚙️ Configuration

The plugin auto-configures itself in `.claude/settings.json`. Customize enabled languages and rules paths here:

```json
{
  "codeReview": {
    "enabled": true,
    "fileExtensions": ["py", "js", "go", "rs", "cs"],
    "rulesFile": "${CLAUDE_PLUGIN_ROOT}/rules.md",
    "languageSpecificRules": {
      "python": "${CLAUDE_PLUGIN_ROOT}/rules/python-rules.md",
      "javascript": "${CLAUDE_PLUGIN_ROOT}/rules/javascript-rules.md",
      "go": "${CLAUDE_PLUGIN_ROOT}/rules/go-rules.md",
      "rust": "${CLAUDE_PLUGIN_ROOT}/rules/rust-rules.md",
      "csharp": "${CLAUDE_PLUGIN_ROOT}/rules/csharp-rules.md"
    }
  }
}
```

---

## 🚀 Usage

Run reviews directly from the Claude Code prompt:

| Command | Description |
|---------|-------------|
| `/review` | Review only files modified since the last review. |
| `/codebase-review` | perform a full review of the entire codebase. |

---

## 🛠️ Extending Language Support

### For Your Project Only

1. Create a rules file: `plugins/code-review/rules/yourlang-rules.md`
2. Add the extension to `fileExtensions` in `.claude/settings.json`
3. Add the mapping to `languageSpecificRules`

### Contributing to the Plugin

We welcome contributions! To add official support for a new language:

1. **Fork** the repository: `git clone https://github.com/YOUR_USERNAME/claude-code-review.git`
2. **Implement** support in:
   - `plugins/code-review/rules/yourlang-rules.md`
   - `plugins/code-review/hooks/tools/code-review-plugin.sh`
   - `plugins/code-review/agents/code-reviewer.md`
3. **Submit** a Pull Request.

---

## 🏗️ Architecture

- **Hooks**: Event-triggered scripts track file modifications.
- **Agent**: A specialized `code-reviewer` agent applies semantic rules.
- **Commands**: Custom slash commands expose functionality to the user.

---

## 📄 License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).
