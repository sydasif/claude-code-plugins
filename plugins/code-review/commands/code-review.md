---
name: code-review
Description: Trigger a semantic code review on modified files.
---

# Code Review of Modified Files

Trigger a semantic code review on modified files against project-specific skills. You must `delegate` this task to the **code-reviewer** subagent.

1. **Identify Modified Files**: Use `git diff` to find changed files since the last commit.
2. **Initiate Review**: Use the `Task` tool with `subagent: "code-reviewer"` and pass the list of modified files as the prompt.
