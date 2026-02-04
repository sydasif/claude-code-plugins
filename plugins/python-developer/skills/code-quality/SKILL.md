---
name: code-quality
description: Enforce Python code quality with ruff, mypy, and modern best practices
user-invocable: false
---

# Python Code Quality Enforcer

This skill ensures Python code meets the highest quality standards using modern tools and best practices.

## Available Commands

### Linting with Ruff

```bash
# Check code for issues
uv run ruff check src/

# Auto-fix linting issues
uv run ruff check --fix src/

# Check specific files
uv run ruff check file.py

# Check with specific rules
uv run ruff check --select E,W src/
```

### Type Checking with MyPy

```bash
# Run type checking
uv run mypy src/

# Check specific files
uv run mypy file.py

# Show detailed error messages
uv run mypy --show-error-codes src/

# Ignore missing imports (for now)
uv run mypy --ignore-missing-imports src/
```

### Formatting with Black

```bash
# Format code
uv run black src/

# Check formatting without changing
uv run black --check src/

# Format specific file
uv run black file.py
```

### Security Scanning with Safety

```bash
# Scan dependencies for vulnerabilities
uv run safety check

# Check with JSON output
uv run safety check --json
```

## Quality Standards

### Type Hints (PEP 484)

All public functions must have complete type annotations:

```python
def process_data(
    input_data: list[dict[str, Any]],
    threshold: float = 0.5
) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    """Process input data and filter based on threshold.

    Args:
        input_data: List of dictionaries to process.
        threshold: Minimum value to include in results.

    Returns:
        Tuple of filtered data and rejected data.
    """
    # Implementation here
    pass
```

### Google-Style Docstrings

```python
def fetch_user(user_id: int) -> dict[str, Any]:
    """Fetch user profile from database.

    Args:
        user_id: Unique identifier of the user.

    Returns:
        Dictionary containing user profile data.

    Raises:
        ValueError: If user_id is invalid.
        ConnectionError: If database is unreachable.
    """
    # Implementation here
    pass
```

### Naming Conventions (PEP 8)

- **Variables/Functions**: `snake_case`
- **Classes**: `PascalCase`
- **Constants**: `UPPER_SNAKE_CASE`
- **Private**: `_leading_underscore`
- **Dunder**: `__double_underscore__`

## Code Review Checklist

### Must Fix (Critical)

1. **Type Hints**: All public functions have type annotations
2. **Security**: No hardcoded secrets or API keys
3. **Error Handling**: Specific exceptions, no bare except
4. **Imports**: No wildcard imports (`from module import *`)

### Should Fix (Important)

1. **Documentation**: All public APIs have docstrings
2. **Formatting**: Code follows Black formatting
3. **Naming**: Consistent PEP 8 naming
4. **Complexity**: Functions under 20 lines

### Consider (Nice to Have)

1. **Performance**: Avoid unnecessary computations
2. **Testing**: Adequate test coverage
3. **Modern Features**: Use f-strings, pathlib, etc.

## Common Violations and Fixes

### Violation: Missing Type Hints

```python
# ❌ Bad

def process_data(data):
    return [x * 2 for x in data]

# ✅ Fixed
def process_data(data: list[int]) -> list[int]:
    return [x * 2 for x in data]
```

### Violation: Bare Except

```python
# ❌ Bad

try:
    result = risky_operation()
except:
    print("Error occurred")

# ✅ Fixed
try:
    result = risky_operation()
except SpecificError as e:
    logger.error(f"Operation failed: {e}")
    raise
```

### Violation: Wildcard Import

```python
# ❌ Bad

from math import *

# ✅ Fixed
import math

# or
from math import sqrt, pi
```

## Integration with Development Workflow

### Pre-commit Hooks

```bash
# Run quality checks before committing
uv run ruff check src/
uv run mypy src/
uv run black --check src/
```

### CI/CD Pipeline

```yaml
# .github/workflows/python.yml
name: Python Quality Checks

on: [push, pull_request]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-python@v4
        with:
          python-version: '3.12'

      - name: Install dependencies
        run: uv sync

      - name: Run linting
        run: uv run ruff check src/

      - name: Run type checking
        run: uv run mypy src/

      - name: Run formatting check
        run: uv run black --check src/
```

## Performance Optimization

### Avoid Common Pitfalls

```python
# ❌ Bad - Creates unnecessary list

squares = [x * x for x in range(1000000)]

# ✅ Good - Uses generator

squares = (x * x for x in range(1000000))
```

### Use Modern Python Features

```python
# ❌ Old style

file = open('data.txt', 'r')
try:
    content = file.read()
finally:
    file.close()

# ✅ Modern with context manager

with open('data.txt', 'r') as file:
    content = file.read()
```

## Security Best Practices

### Input Validation

```python
import re
from typing import Union

def validate_email(email: str) -> Union[str, None]:
    """Validate email address format.

    Args:
        email: Email address to validate.

    Returns:
        Validated email or None if invalid.
    """
    pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    if re.match(pattern, email):
        return email
    return None
```

### Safe Database Operations

```python
import sqlite3
from typing import List, Dict, Any

def get_users_by_age(min_age: int) -> List[Dict[str, Any]]:
    """Get users older than minimum age.

    Args:
        min_age: Minimum age to filter users.

    Returns:
        List of user dictionaries.
    """
    conn = sqlite3.connect('users.db')
    cursor = conn.cursor()

    # Use parameterized query to prevent SQL injection
    query = "SELECT * FROM users WHERE age > ?"
    cursor.execute(query, (min_age,))

    results = cursor.fetchall()
    conn.close()

    return results
```

---

## Integration with Other Skills

This skill works with:

- `dependency-manager` to ensure quality tools are installed
- `python-expert` for comprehensive code review
- Custom scripts for project-specific quality rules

Use this skill to maintain high code quality standards throughout your Python development workflow.
