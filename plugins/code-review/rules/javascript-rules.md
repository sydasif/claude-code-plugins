# JavaScript Code Review Rules

These are JavaScript-specific code review rules. Follow these guidelines to maintain high-quality JavaScript code.

---

## Rule 1: Consistent Naming Conventions

Use appropriate naming conventions based on the type of entity.

❌ **Forbidden:**

- Using snake_case for functions, variables, or methods
- Using PascalCase for non-constructor functions or non-class entities
- Inconsistent naming within the same codebase

✅ **Required:**

- `camelCase` for functions, variables, and methods: `getUserData`, `isLoading`
- `PascalCase` for constructors, classes, and React components: `UserProfile`, `HttpRequest`
- `UPPER_SNAKE_CASE` for constants: `MAX_RETRY_COUNT`, `DEFAULT_TIMEOUT`

**Why:** Consistent naming improves readability and reduces cognitive load.

---

## Rule 2: Proper Use of Semicolons

Maintain consistency in semicolon usage based on the project's style guide.

❌ **Forbidden:**

- Mixing semicolon styles within the same project
- Missing semicolons if the project uses them
- Unnecessary semicolons after certain statements if the project omits them

✅ **Required:**

- If using semicolons: Add semicolons after statements: `let x = 5;`
- If omitting semicolons: Consistently omit them throughout the project
- Maintain the project's existing style consistently

**Why:** Consistent style prevents potential ASI (Automatic Semicolon Insertion) issues and maintains project uniformity.

---

## Rule 3: Modern ES6+ Features

Leverage modern JavaScript features to write cleaner, more maintainable code.

❌ **Forbidden:**

- Using `var` for variable declarations (unless specifically needed for hoisting)
- Using function declarations when arrow functions are more appropriate
- Using `for` loops when `forEach`, `map`, `filter` are more expressive

✅ **Required:**

- Use `const` for values that don't change, `let` for variables that do
- Use arrow functions for callbacks and simple functions: `items.map(item => item.name)`
- Use template literals: `Hello ${name}`
- Use destructuring: `const {firstName, lastName} = user`
- Use spread operator: `[...array1, ...array2]`

**Why:** Modern features lead to more readable and maintainable code.

---

## Rule 4: Proper Error Handling

Handle errors appropriately to prevent application crashes and improve debugging.

❌ **Forbidden:**

- Empty catch blocks: `catch(e) {}`
- Generic error handling without context
- Ignoring rejected promises

✅ **Required:**

- Always log errors in catch blocks: `console.error('Failed to fetch user:', error)`
- Use specific error types when appropriate
- Handle promise rejections: `promise.catch(error => console.error(error))`
- Consider using try/catch for async operations

**Why:** Proper error handling makes debugging easier and prevents silent failures.

---

## Rule 5: Consistent Module Import/Export Style

Use consistent module syntax throughout the project.

❌ **Forbidden:**

- Mixing CommonJS and ES6 module syntax in the same project
- Destructuring imports when only one export is needed

✅ **Required:**

- Use ES6 imports/exports when possible: `import { Component } from 'react'`
- Use default exports appropriately: `export default function MyComponent()`
- Group and order imports logically: external libraries, internal modules, relative imports
- Use absolute paths when available, relative paths when necessary

**Why:** Consistent module usage improves code organization and maintainability.

---

## Rule 6: Strict Equality Checks

Use strict equality operators to avoid type coercion issues.

❌ **Forbidden:**

- Using `==` and `!=` operators (except in specific edge cases where type coercion is intentional)
- Comparing different types without explicit conversion

✅ **Required:**

- Use `===` and `!==` for comparisons
- Explicitly convert types when necessary before comparison

**Why:** Strict equality prevents unexpected behavior caused by JavaScript's type coercion.

---

## Review Procedure

For each JavaScript file:

1. **Read complete file**
2. **Search for violations**
3. **Report findings** with file:line references

---

## Report Format

### If violations found

```text
❌ FAIL

Violations:
1. [NAMING CONVENTIONS] - src/utils.js:15
   Issue: Used snake_case for function name
   Fix: Change my_function to myFunction

2. [ERROR HANDLING] - src/api.js:32
   Issue: Empty catch block
   Fix: Add error logging in catch block
```

### If no violations

```text
✅ PASS

File meets all semantic requirements.
```