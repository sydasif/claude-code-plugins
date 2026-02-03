---
name: review
Description: Trigger a semantic code review on modified files against project-specific rules.
---

# Code Review of Modified Files

Trigger a semantic code review on modified files against project-specific rules defined in `${CLAUDE_PLUGIN_ROOT}/rules/`.

1. **Identify Modified Files**: Use `git diff` to find changed files since the last commit or a specific reference point:

   > If no changes found, exit with: "No files have been modified since the last review."

2. **Filter Files**: Use the configured file extensions from `.claude/settings.json`.

3. **Initiate Review**: Use the `Task` tool with `subagent: "code-reviewer"` and pass the list of modified files as the prompt.
