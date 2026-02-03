# Python Code Review Rules

These are Python-specific code review rules. Follow these guidelines to maintain high-quality Python code.

---

## Rule 1: Google-Style Docstrings (PEP 257)

All public modules, classes, and functions must have Google-style docstrings.

❌ **Forbidden:**

- Missing docstrings on public entities
- "One-liner" descriptions for complex functions
- Sphinx/reST or NumPy style (unless explicitly re-configured)

✅ **Required:**

- Triple quotes `"""`
- `Args:` section for parameters
- `Returns:` section for return values
- `Raises:` section for known exceptions
- Module-level docstrings for all modules
- Class docstrings explaining the class purpose

**Example:**

```python
def fetch_user(user_id: int) -> dict:
    """Fetches a user profile from the database.

    Args:
        user_id: The unique identifier of the user.

    Returns:
        A dictionary containing the user's profile data.

    Raises:
        ValueError: If user_id is negative.
        ConnectionError: If the database is unreachable.
    """
    ...
```

**Why:** Clear documentation ensures code is maintainable and understandable by others (and LLMs).

---

## Rule 2: Strict Type Hints (PEP 484, PEP 526)

No escape hatches. Use precise type hints for all function arguments and return values.

❌ **Forbidden:**

- Missing type hints
- `Any` (unless absolutely necessary and justified)
- Bare `list` or `dict` without generics (use `list[str]`, `dict[str, int]`)
- Unused imports that cause circular dependency workarounds

✅ **Required:**

- Full signatures: `def func(a: int, b: str) -> bool:`
- `Optional[T]` or `T | None` for nullable values (Python 3.10+)
- `Union` or `|` for multiple types (Python 3.10+)
- Variable annotations: `count: int = 0`
- Generic types: `List[int]`, `Dict[str, Any]`, or `list[int]`, `dict[str, Any]` (Python 3.9+)

**Why:** Type hints catch bugs before runtime and serve as excellent documentation.

---

## Rule 3: No Print Statements in Production

Production code must use the `logging` module, not standard output.

❌ **Forbidden:**

- `print(...)`
- `pprint(...)`
- `sys.stdout.write(...)`
- `sys.stderr.write(...)` for application messages

✅ **Required:**

- `import logging`
- `logger = logging.getLogger(__name__)`
- `logger.info(...)`, `logger.warning(...)`, `logger.error(...)`, `logger.debug(...)`
- Structured logging with relevant context

**Why:** `print` cannot be categorized by severity, lacks timestamps/context, and clutters stdout in production/CI environments.

---

## Rule 4: Explicit Error Handling

Never swallow errors blindly. Handle specific exceptions.

❌ **Forbidden:**

- Bare `except:`
- `except Exception:` (without re-raising or logging extensively)
- `pass` inside an except block without a comment
- Silent failure without proper error propagation

✅ **Required:**

- Catch specific exceptions: `except ValueError:`
- `try/finally` or `with` statements for resource cleanup
- Proper exception chaining: `raise CustomException("msg") from original_exc`
- Log exceptions with context before handling

**Why:** Catch-all exceptions hide bugs and make debugging impossible.

---

## Rule 5: PEP 8 Naming Conventions

Follow standard Python naming conventions to maintain idiomatic code.

❌ **Forbidden:**

- camelCase for functions/variables (`myFunction`, `myVariable`)
- PascalCase for functions/variables
- snake_case for classes (`my_class`)
- Single character variable names (except for loop counters)

✅ **Required:**

- `snake_case` for functions, variables, modules
- `PascalCase` (CapWords) for classes and exceptions
- `UPPER_CASE` for constants
- Descriptive names that clearly indicate purpose
- Private attributes with leading underscore: `_private_attr`

**Why:** Consistency lowers the cognitive load for reading code.

---

## Rule 6: Import Organization and Best Practices

Structure imports according to PEP 8 standards.

❌ **Forbidden:**

- Wildcard imports: `from module import *`
- Relative imports for same package
- Imports inside functions (except for conditional imports)
- Multiple imports per line

✅ **Required:**

- Standard library imports first
- Third-party imports second
- Local application/library imports third
- Blank lines between import groups
- Absolute imports preferred over relative
- Specific imports: `from module import specific_function`

**Example:**

```python
import os
import sys
from pathlib import Path

import requests
import yaml

from myapp.models import User
from myapp.utils import helper_function
```

**Why:** Organized imports improve readability and help identify dependencies.

---

## Rule 7: Security Best Practices

Implement secure coding practices to prevent vulnerabilities.

❌ **Forbidden:**

- Hardcoded secrets, API keys, or passwords
- Direct use of `eval()`, `exec()`, or `compile()` with user input
- Unsanitized input in SQL queries (use parameterized queries)
- Insecure deserialization (pickle) with untrusted data

✅ **Required:**

- Store secrets in environment variables or secure vaults
- Use parameterized queries or ORM to prevent SQL injection
- Validate and sanitize all user inputs
- Use secure random generators for tokens
- Hash passwords with bcrypt or similar

**Why:** Prevents security vulnerabilities and data breaches.

---

## Rule 8: Modern Python Features and Best Practices

Leverage modern Python features for cleaner, more efficient code.

❌ **Forbidden:**

- Outdated Python 2 compatibility code
- Manual file handling without context managers
- Manual string formatting (old % style or .format())

✅ **Required:**

- Context managers: `with open(file) as f:`
- f-strings for string formatting: `f"Hello {name}"`
- Walrus operator (Python 3.8+) where appropriate: `if (n := len(a)) > 10:`
- Type hints and generics
- Dataclasses for simple data containers
- Pathlib for path manipulation

**Why:** Modern features are more readable, efficient, and less error-prone.

---

## Rule 9: Performance and Memory Best Practices

Write efficient code that minimizes resource consumption.

❌ **Forbidden:**

- Loading entire large files into memory unnecessarily
- Repeated expensive operations in loops
- Creating unnecessary intermediate lists

✅ **Required:**

- Use generators for large datasets: `(x for x in items if condition)`
- Use `itertools` for efficient iteration patterns
- Consider `functools.lru_cache` for expensive pure functions
- Use `collections.defaultdict` to avoid repeated key checking

**Why:** Efficient code scales better and uses system resources wisely.

---

## Rule 10: Dependency and Execution Best Practices

Always use modern, reproducible dependency management and execution patterns.

❌ **Forbidden:**

- Using `pip install` directly
- Running Python scripts with `python script.py`
- Using `pip` for project dependencies
- Direct execution without proper environment isolation

✅ **Required:**

- Always use `uv` for dependency management (not pip)
- Always use `uv run` to execute Python scripts and commands
- For ad-hoc Python execution, use `uv run python -c "your code"`
- Use virtual environments for project isolation
- Pin dependencies in `requirements.txt` or `pyproject.toml`

**Why:** Using `uv` ensures consistent, fast, and reproducible environments across all development machines and CI/CD pipelines.

---

## Review Procedure

For each Python file:

1. **Read complete file**
2. **Search for violations**
3. **Report findings** with file:line references

---

## Report Format

### If violations found

```text
❌ FAIL

Violations:
1. [GOOGLE-STYLE DOCSTRINGS] - src/users.py:42
   Issue: Missing 'Args' section in docstring
   Fix: Add Args section describing 'user_id' parameter

2. [NO PRINT STATEMENTS] - src/main.py:15
   Issue: Used print() for debugging
   Fix: Replace with logger.info()
```

### If no violations

```text
✅ PASS

File meets all semantic requirements.
```