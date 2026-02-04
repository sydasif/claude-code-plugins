---
name: code-review
description: Review modified files since the last commit
---

Review the following files modified since the last commit:

!bash -c "{ git diff HEAD --name-only --diff-filter=ACMR; git ls-files --others --exclude-standard; } | sort -u"

> You must delegate this task to the `code-reviewer` agent.
