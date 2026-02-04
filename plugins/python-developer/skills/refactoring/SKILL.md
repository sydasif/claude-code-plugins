---
name: refactoring-specialist
description: Modernize legacy Python code with best practices
user-invocable: false
---

# Python Refactoring Specialist

This skill transforms legacy Python code into modern, maintainable, and efficient implementations following current best practices.

## Refactoring Patterns

### 1. String Formatting Modernization

#### Convert .format() to f-strings

```python
# ❌ Legacy
name = "Alice"
age = 30
message = "{} is {} years old".format(name, age)
result = "{name} is {age} years old".format(name=name, age=age)

# ✅ Modern
name = "Alice"
age = 30
message = f"{name} is {age} years old"
result = f"{name} is {age} years old"
```

#### Convert % formatting to f-strings

```python
# ❌ Legacy
name = "Bob"
score = 95.5
result = "Player %s scored %.1f%%" % (name, score)

# ✅ Modern
name = "Bob"
score = 95.5
result = f"Player {name} scored {score:.1f}%"
```

### 2. Path Manipulation Modernization

#### Convert os.path to pathlib

```python
# ❌ Legacy
import os
file_path = os.path.join("data", "users", "profile.json")
parent_dir = os.path.dirname(file_path)
file_exists = os.path.exists(file_path)

# ✅ Modern
from pathlib import Path
file_path = Path("data") / "users" / "profile.json"
parent_dir = file_path.parent
file_exists = file_path.exists()
```

#### Path operations with pathlib

```python
# ❌ Legacy
import os
file_path = "src/utils/helpers.py"
if os.path.splitext(file_path)[1] == ".py":
    print(f"Processing Python file: {file_path}")

# ✅ Modern
from pathlib import Path
file_path = Path("src/utils/helpers.py")
if file_path.suffix == ".py":
    print(f"Processing Python file: {file_path.name}")
```

### 3. Dictionary and Data Structure Modernization

#### Convert dict to TypedDict for structure

```python
# ❌ Legacy
def process_user(user_data):
    name = user_data["name"]
    age = user_data["age"]
    active = user_data.get("active", False)
    return f"{name} ({age}) - Active: {active}"

# ✅ Modern
from typing import TypedDict

class User(TypedDict):
    name: str
    age: int
    active: bool

def process_user(user_data: User) -> str:
    name = user_data["name"]
    age = user_data["age"]
    active = user_data.get("active", False)
    return f"{name} ({age}) - Active: {active}"
```

#### Convert manual classes to dataclasses

```python
# ❌ Legacy
class Person:
    def __init__(self, name, age, email):
        self.name = name
        self.age = age
        self.email = email

    def __repr__(self):
        return f"Person(name='{self.name}', age={self.age}, email='{self.email}')"

    def __eq__(self, other):
        if not isinstance(other, Person):
            return False
        return self.name == other.name and self.age == other.age and self.email == other.email

# ✅ Modern
from dataclasses import dataclass

@dataclass
class Person:
    name: str
    age: int
    email: str
```

### 4. Function Modernization

#### Convert positional args to keyword-only

```python
# ❌ Legacy
def create_user(name, age, active=True, admin=False):
    return {"name": name, "age": age, "active": active, "admin": admin}

# ✅ Modern
def create_user(name: str, age: int, *, active: bool = True, admin: bool = False):
    """Create a new user.

    Args:
        name: User's full name
        age: User's age
        active: Whether the user is active
        admin: Whether the user has admin privileges
    """
    return {"name": name, "age": age, "active": active, "admin": admin}
```

#### Convert lambda functions to proper functions

```python
# ❌ Legacy
numbers = [1, 2, 3, 4, 5]
is_even = lambda x: x % 2 == 0
even_numbers = list(filter(is_even, numbers))

# ✅ Modern
def is_even(number: int) -> bool:
    """Check if a number is even."""
    return number % 2 == 0

numbers = [1, 2, 3, 4, 5]
even_numbers = list(filter(is_even, numbers))
```

### 5. Loop Modernization

#### Convert index-based loops to enumerate

```python
# ❌ Legacy
items = ["apple", "banana", "cherry"]
for i in range(len(items)):
    print(f"{i}: {items[i]}")

# ✅ Modern
items = ["apple", "banana", "cherry"]
for i, item in enumerate(items):
    print(f"{i}: {item}")
```

#### Convert manual accumulator to sum/list comprehension

```python
# ❌ Legacy
total = 0
for num in numbers:
    total += num

items = []
for num in numbers:
    if num > 0:
        items.append(num * 2)

# ✅ Modern
from typing import Iterable

def sum_numbers(numbers: Iterable[float]) -> float:
    """Calculate the sum of numbers."""
    return sum(numbers)

positive_doubled = [num * 2 for num in numbers if num > 0]
```

### 6. Exception Handling Modernization

#### Use specific exceptions and exception chaining

```python
# ❌ Legacy
def divide(a, b):
    try:
        result = a / b
    except:
        return None

# ✅ Modern
def divide(a: float, b: float) -> float:
    """Divide a by b.

    Args:
        a: Dividend
        b: Divisor

    Returns:
        The result of a / b

    Raises:
        ZeroDivisionError: If b is zero
        TypeError: If a or b are not numeric
    """
    try:
        return a / b
    except ZeroDivisionError as e:
        raise ZeroDivisionError(f"Cannot divide {a} by zero") from e
    except TypeError as e:
        raise TypeError(f"Invalid operand types for division: {type(a).__name__}, {type(b).__name__}") from e
```

### 7. Context Management Modernization

#### Use context managers for resource management

```python
# ❌ Legacy
def read_file(filename):
    file = open(filename, 'r')
    content = file.read()
    file.close()
    return content

def write_file(filename, content):
    file = open(filename, 'w')
    file.write(content)
    file.flush()
    file.close()

# ✅ Modern
def read_file(filename: str) -> str:
    """Read content from a file."""
    with open(filename, 'r') as f:
        return f.read()

def write_file(filename: str, content: str) -> None:
    """Write content to a file."""
    with open(filename, 'w') as f:
        f.write(content)
```

### 8. Import Modernization

#### Group and organize imports properly

```python
# ❌ Legacy
import os
from pathlib import Path
import sys
import requests
from mymodule import helper_function
import numpy as np

# ✅ Modern
import os
import sys
from pathlib import Path

import numpy as np
import requests

from mymodule import helper_function
```

## Refactoring Process

### 1. Assessment

1. Identify legacy patterns in the code
2. Prioritize refactoring based on impact and risk
3. Check for existing tests (ensure they exist before refactoring)

### 2. Safe Refactoring Steps

1. Run existing tests to establish baseline
2. Apply one refactoring pattern at a time
3. Run tests after each change
4. Verify functionality remains the same

### 3. Modernization Checklist

- [ ] All string formatting uses f-strings
- [ ] Path operations use `pathlib`
- [ ] Function signatures use type hints
- [ ] Keyword-only arguments are used where appropriate
- [ ] Data classes replace simple classes
- [ ] Context managers handle resources
- [ ] Exception handling is specific
- [ ] Iterations use appropriate patterns (enumerate, comprehension)
- [ ] Lambda functions are moved to named functions if complex
- [ ] Imports are organized in standard groups

## Quality Assurance

### Before Refactoring

```bash
# Ensure code quality tools are available
uv run mypy src/
uv run ruff check src/
uv run pytest tests/
```

### After Refactoring

```bash
# Verify refactored code passes all checks
uv run mypy src/
uv run ruff check src/
uv run pytest tests/
uv run pytest --cov=src --cov-report=term-missing
```

## Common Refactoring Scenarios

### Scenario 1: Migrate to f-strings

```python
# Find all % formatting and .format() calls
# Replace with equivalent f-string expressions
# Preserve alignment and formatting options
```

### Scenario 2: Migrate to dataclasses

```python
# Identify simple classes with only attributes
# Add @dataclass decorator
# Add type hints to attributes
# Remove boilerplate methods (__init__, __repr__, __eq__)
```

### Scenario 3: Migrate to pathlib

```python
# Identify all os.path.* usage
# Replace with pathlib.Path equivalents
# Update path concatenation to use /
# Ensure cross-platform compatibility
```

---

## Integration with Other Skills

This skill works with:

- `code-quality` to ensure refactored code meets modern standards
- `dependency-manager` to add any new dependencies if needed
- `test-engineer` to ensure refactored code has proper test coverage

Use this skill to modernize legacy Python code into clean, maintainable, and efficient implementations using contemporary Python features and best practices.
