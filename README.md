# Claude Code Review Plugin

Semantic code reviews for modified files using customizable project-specific rules.

## Supported Languages

Python, JavaScript, Go, Rust, C# (top 5 languages of 2025)

## Installation

```bash
/plugin marketplace add sydasif/claude-code-review
/plugin install code-review@sydasif-claude-plugins
```

## Configuration

Edit `.claude/settings.json`:

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

## Usage

```bash
/review    # Review modified files since last review
/codebase-review  # Review entire codebase
```

## Adding New Languages

### For Your Project

1. Create rules file: `plugins/code-review/rules/yourlang-rules.md`
2. Update `.claude/settings.json`:
   - Add extension to `fileExtensions`
   - Add mapping to `languageSpecificRules`

### Contributing

1. Fork: `git clone https://github.com/YOUR_USERNAME/claude-code-review.git`
2. Add language support in:
   - `plugins/code-review/rules/yourlang-rules.md`
   - `plugins/code-review/hooks/tools/code-review-plugin.sh`
   - `plugins/code-review/agents/code-reviewer.md`
3. Submit pull request

## Requirements

- `jq` (macOS: `brew install jq`, Ubuntu: `sudo apt-get install jq`)

## Architecture

- **Hooks**: Detect file changes
- **Agent**: Enforces review rules
- **Commands**: `/review`, `/codebase-review`
