# /review

Description: Trigger a semantic code review on modified files against project-specific rules.

---

When this command is run, you should:

1. **Identify Modified Files**: Use git to find changed files since the last commit or a specific reference point:

   ```bash
   CHANGED_FILES=$(git diff --name-only HEAD~1 2>/dev/null || git diff --name-only origin/main 2>/dev/null || git status --porcelain | grep '^[MADRC]' | awk '{print $2}')
   ```

   If no changes found, exit with: "No files have been modified since the last review."

2. **Filter Files**: Use the configured file extensions from `.claude/settings.json` (defaults: `["py", "js", "ts"]`)

3. **Initiate Review**: Use the `Task` tool with `subagent_type: "code-reviewer"` and pass the list of modified files as the prompt.
