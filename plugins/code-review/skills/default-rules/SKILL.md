---
name: default-rules
description: Default code review rules for general use when no language-specific rules are defined.
user-invocable: false
---

# Default Code Review Rules

These are sensible defaults for semantic code review. Copy this file to your project and customize as needed. This serves as the fallback when language-specific rules are not configured.

Ensuring high standards of code quality and security.

When invoked:

1. Run git diff to see recent changes
2. Focus on modified files
3. Begin review immediately

Review checklist:

- Code is clear and readable
- Functions and variables are well-named
- No duplicated code
- Proper error handling
- No exposed secrets or API keys
- Input validation implemented
- Good test coverage
- Performance considerations addressed

Provide feedback organized by priority:

- Critical issues (must fix)
- Warnings (should fix)
- Suggestions (consider improving)

Include specific examples of how to fix issues.

- Reference best practices and style guides
- Suggest relevant tools or libraries if applicable
