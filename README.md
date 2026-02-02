# Claude Code Review Plugin

A semantic code review plugin for Claude Code that automatically reviews modified files using customizable project-specific rules.

## Features

- **Automatic Reviews**: Triggers after Claude finishes modifying files
- **Semantic Analysis**: Checks for logic, style, and safety issues that linters miss
- **Incremental Reviews**: Only reviews files modified since the last review cycle
- **Customizable Rules**: Define your own semantic rules per project
- **Multi-Language Support**: Configurable for any programming language

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

The plugin uses Claude Code hooks to automatically trigger reviews:

1. **PostToolUse Hook**: Logs file modifications to `/tmp/event-log-{SESSION_ID}.jsonl`
2. **Stop Hook**: Checks for new files since last review and triggers the `code-reviewer` agent
3. **Code Review Agent**: Enforces rules defined in the project's rules file

## Configuration

The plugin auto-initializes with default settings in `.claude/settings.json`:

```json
{
  "codeReview": {
    "enabled": true,
    "fileExtensions": ["py", "ipynb"],
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
    "fileExtensions": ["py", "js", "ts", "java", "cpp"],
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

### Manual Review

Use the `/review` command to trigger a manual code review at any time.

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
2. Use **Mypy** or **TypeScript** for type checking
3. Use this **Code Review Plugin** for semantic rules (e.g., "Docstrings must explain *why*, not just *what*", or "Variable names must be domain-specific")

## Contributing

Feedback and contributions are welcome! Please open an issue or pull request on the GitHub repository.
