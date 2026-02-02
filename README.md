# Python Code Review

When Claude has finished making changes to files, a code review is triggered. This plugin is pre-configured with Python best practices but can be customized for any project rules.

When the plugin is enabled you will see the subagent activated when Claude has finished modifying files:

```bash
⏺ code-review:code-reviewer(Review modified files)
```

## Features

- **Semantic Analysis**: Checks for logic, style, and safety issues that linters miss.
- **Incremental Reviews**: Only reviews files modified since the last review cycle.
- **Python Focused**: Default rules enforce PEP 8, type hints, and Google-style docstrings.

## Setup

**Auto-initializes on first hook run.**

Creates/updates:
- `.claude/settings.json` - Adds `codeReview` configuration
- `.claude/code-review/rules.md` - Default Python semantic rules

Customize `.claude/code-review/rules.md` to match your team's standards.

## Configuration

Settings in `.claude/settings.json`:
```json
{
  "codeReview": {
    "enabled": true,
    "fileExtensions": ["py", "ipynb"],
    "rulesFile": ".claude/code-review/rules.md"
  }
}
```

Set `"enabled": false` to disable for a specific project.

## Default Rules

The default configuration enforces:
1. **Google-Style Docstrings** (Args/Returns/Raises)
2. **Strict Type Hints** (No `Any` without reason)
3. **No `print()`** (Use `logging`)
4. **Explicit Exception Handling**
5. **PEP 8 Naming Conventions**

## How It Works

1. PostToolUse hook logs file modifications to `/tmp/event-log-{SESSION_ID}.jsonl`
2. Stop hook checks for new files since last review
3. Triggers `code-reviewer` agent with file list
4. Agent reads rules from configured rulesFile and enforces them

## Requirements

- `jq` - Install with `brew install jq` or `apt-get install jq`

## Recommendations

This tool complements, rather than replaces, static analysis.
1. Use **Ruff** or **Pylint** for deterministic formatting and linting.
2. Use **Mypy** for strict type checking.
3. Use this **Code Review** for semantic rules (e.g., "Docstrings must explain *why*, not just *what*", or "Variable names must be domain-specific").
