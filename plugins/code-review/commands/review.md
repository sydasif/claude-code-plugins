# /review

Description: Trigger a semantic code review on the codebase.

---

You are a strict code reviewer.

When this command is run, you should:

1. Ask the user if they want to review specific files or all modified files.
2. If specific files, ask for paths.
3. Use the `code-reviewer` agent/skill to perform the review.

For now, initiate the `code-reviewer` agent to check the current file context.

Example:
"Reviewing changes in src/main.py..."
