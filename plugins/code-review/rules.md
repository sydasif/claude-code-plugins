# Default Python Code Review Rules

These are sensible defaults for semantic Python code review. Copy this file to your project and customize as needed.

---

## Rule 1: Google-Style Docstrings

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

## Rule 2: Strict Type Hints (PEP 484)

No escape hatches. Use precise type hints for all function arguments and return values.

❌ **Forbidden:**

- Missing type hints
- `Any` (unless absolutely necessary and justified)
- Bare `list` or `dict` without generics (use `list[str]`, `dict[str, int]`)

✅ **Required:**

- Full signatures: `def func(a: int, b: str) -> bool:`
- `Optional[T]` or `T | None` for nullable values
- `Union` or `|` for multiple types

**Why:** Type hints catch bugs before runtime and serve as excellent documentation.

---

## Rule 3: No Print Statements

Production code must use the `logging` module, not standard output.

❌ **Forbidden:**

- `print(...)`
- `pprint(...)`

✅ **Required:**

- `import logging`
- `logger.info(...)`, `logger.warning(...)`, `logger.error(...)`

**Why:** `print` cannot be categorized by severity, lacks timestamps/context, and clutters stdout in production/CI environments.

---

## Rule 4: Explicit Error Handling

Never swallow errors blindly. Handle specific exceptions.

❌ **Forbidden:**

- Bare `except:`
- `except Exception:` (without re-raising or logging extensively)
- `pass` inside an except block without a comment

✅ **Required:**

- Catch specific exceptions: `except ValueError:`
- `try/finally` for resource cleanup

**Why:** Catch-all exceptions hide bugs and make debugging impossible.

---

## Rule 5: PEP 8 Naming Conventions

Follow standard Python naming conventions to maintain idiomatic code.

❌ **Forbidden:**

- camelCase for functions/variables (`myFunction`, `myVariable`)
- PascalCase for functions/variables
- snake_case for classes (`my_class`)

✅ **Required:**

- `snake_case` for functions, variables, modules
- `PascalCase` (CapWords) for classes and exceptions
- `UPPER_CASE` for constants

**Why:** Consistency lowers the cognitive load for reading code.

---

## Rule 6: Dependency and Execution Best Practices

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
- Never use `pip install` or `python script.py` directly

**Why:** Using `uv` ensures consistent, fast, and reproducible environments across all development machines and CI/CD pipelines.

---

## Review Procedure

For each file:

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
