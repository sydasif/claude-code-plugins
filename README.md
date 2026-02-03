# Claude Code Review Plugin

A semantic code review plugin for Claude Code that manually reviews modified files using customizable project-specific rules.

## Features

- **Manual Reviews**: Triggers via the `/review` command after Claude finishes modifying files
- **Semantic Analysis**: Checks for logic, style, and safety issues that linters miss
- **Incremental Reviews**: Only reviews files modified since the last review cycle
- **Customizable Rules**: Define your own semantic rules per project
- **Multi-Language Support**: Focused on top 5 programming languages of 2025
- **Language-Specific Rules**: Different programming languages can have their own specific review rules

## Installation

### Via Marketplace (Recommended)

1. Add the plugin marketplace:

   ```bash
   /plugin marketplace add sydasif/claude-code-review
   ```

2. Install the plugin:

   ```bash
   /plugin install code-review@sydasif-claude-plugins
   ```

### Manual Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/sydasif/claude-code-review ~/.claude/plugins/claude-code-review
   ```

2. Restart Claude Code to load the plugin.

## How It Works

The plugin uses Claude Code hooks to log file changes and provides a command for manual review:

1. **PostToolUse Hook**: Logs file modifications to `.claude/code-review/event-log.jsonl`
2. **Review Command**: Run `/review` to check for new files since last review and trigger the `code-reviewer` agent
3. **Code Review Agent**: Enforces rules defined in the project's rules file

## Configuration

The plugin auto-initializes with default settings in `.claude/settings.json`:

```json
{
  "codeReview": {
    "enabled": true,
    "fileExtensions": ["py", "js", "go", "rs", "cs"],
    "rulesFile": "${CLAUDE_PLUGIN_ROOT}/rules.md"
  }
}
```

### Settings

- `enabled`: Enable/disable the plugin for the current project
- `fileExtensions`: File types to review (add more extensions as needed)
- `rulesFile`: Path to project-specific review rules (default: `${CLAUDE_PLUGIN_ROOT}/rules.md`)

## Customization

### Changing File Extensions

To review other file types, modify the `fileExtensions` array in `.claude/settings.json`:

```json
{
  "codeReview": {
    "enabled": true,
    "fileExtensions": ["py", "js", "go", "rs", "cs"],
    "rulesFile": "${CLAUDE_PLUGIN_ROOT}/rules.md"
  }
}
```

### Custom Rules

The default rules (applied to Python files) are defined in `${CLAUDE_PLUGIN_ROOT}/rules.md`.
Copy and customize them for your project needs.

The default rules enforce:

- Google-Style Docstrings (Args/Returns/Raises sections)
- Strict Type Hints (No `Any` without reason)
- No `print()` statements (Use `logging` instead)
- Explicit Exception Handling
- PEP 8 Naming Conventions

### Language-Specific Rules

The plugin supports language-specific rules, allowing different programming languages to have their own specific review rules. This enables more targeted and relevant code reviews based on the programming language being used.

The plugin currently supports language-specific rules for:

- Python (`.py`)
- JavaScript (`.js`)
- Go (`.go`)
- Rust (`.rs`)
- C# (`.cs`)

#### Configuration

Language-specific rules are configured in `.claude/settings.json`:

```json
{
  "codeReview": {
    "enabled": true,
    "fileExtensions": [
      "py",
      "js",
      "go",
      "rs",
      "cs"
    ],
    "rulesFile": "./plugins/code-review/rules.md",
    "languageSpecificRules": {
      "python": "./plugins/code-review/rules/python-rules.md",
      "javascript": "./plugins/code-review/rules/javascript-rules.md",
      "go": "./plugins/code-review/rules/go-rules.md",
      "rust": "./plugins/code-review/rules/rust-rules.md",
      "csharp": "./plugins/code-review/rules/csharp-rules.md"
    }
  }
}
```

When files are modified and a review is triggered, the plugin detects the programming language based on the file extension and applies the appropriate language-specific rules. If no language-specific rules are configured for a particular language, the plugin falls back to the default `rulesFile`.

#### Creating Custom Language Rules

To create custom rules for a language:

1. Create a new rules file in `plugins/code-review/rules/` with a descriptive name
2. Follow the same format as existing rules files
3. Add an entry to the `languageSpecificRules` section in `.claude/settings.json`
4. Add the appropriate file extension to the `fileExtensions` array

### Manual Review (Primary)

Use the `/review` command to trigger a code review. The plugin will identify which files have been modified since your last review and focus only on those.

## Requirements

- `jq` command-line tool must be installed:
  - macOS: `brew install jq`
  - Ubuntu/Debian: `sudo apt-get install jq`
  - Other systems: Install from your package manager or <https://stedolan.github.io/jq/>

## Architecture

The plugin consists of:

- **Hooks**: Event-triggered scripts that detect file changes
- **Agent**: The `code-reviewer` agent that performs reviews using project rules
- **Commands**: The `/review` command for manual reviews
- **Rules**: Default semantic rules in `rules.md`

## Best Practices

This tool complements, rather than replaces, traditional static analysis:

1. Use **Ruff**, **ESLint**, or **Pylint** for formatting and basic linting
2. Use **Mypy** or **Rust** type checker for type checking
3. Use this **Code Review Plugin** for semantic rules (e.g., "Docstrings must explain *why*, not just *what*", or "Variable names must be domain-specific")

## Contributing

Feedback and contributions are welcome! Please open an issue or pull request on the GitHub repository.
