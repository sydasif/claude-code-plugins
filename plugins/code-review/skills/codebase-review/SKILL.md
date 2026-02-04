---
name: codebase-review
description: Perform a full review of the entire codebase (WARNING: May produce large file list)
context: fork
agent: code-reviewer
---

Review the entire codebase.

Here is the list of all files:
!git ls-files

⚠️ WARNING: This command may produce a very large list of files. Prioritize architectural analysis and structural issues over line-by-line code review if the list is extensive.