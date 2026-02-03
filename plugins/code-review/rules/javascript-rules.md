# JavaScript Code Review Rules

These are JavaScript-specific code review rules. Follow these guidelines to maintain high-quality JavaScript code.

---

## Rule 1: Consistent Naming Conventions

Use appropriate naming conventions based on the type of entity.

❌ **Forbidden:**

- Using snake_case for functions, variables, or methods
- Using PascalCase for non-constructor functions or non-class entities
- Inconsistent naming within the same codebase
- Abbreviated or unclear variable names

✅ **Required:**

- `camelCase` for functions, variables, and methods: `getUserData`, `isLoading`
- `PascalCase` for constructors, classes, and React components: `UserProfile`, `HttpRequest`
- `UPPER_SNAKE_CASE` for constants: `MAX_RETRY_COUNT`, `DEFAULT_TIMEOUT`
- Descriptive names that clearly indicate purpose
- Boolean variables prefixed with `is`, `has`, `can`, etc.: `isVisible`, `hasPermission`

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
- Using function declarations when arrow functions are more appropriate for concise expressions
- Using `for` loops when `forEach`, `map`, `filter`, `reduce` are more expressive
- Using `for...in` for arrays (use `for...of` instead)

✅ **Required:**

- Use `const` for values that don't change, `let` for variables that do
- Use arrow functions for callbacks and simple functions: `items.map(item => item.name)`
- Use template literals: `Hello ${name}`
- Use destructuring: `const {firstName, lastName} = user`
- Use spread operator: `[...array1, ...array2]`
- Use default parameters: `function greet(name = 'World')`
- Use rest parameters: `function sum(...numbers)`
- Use object shorthand: `{name}` instead of `{name: name}`

**Why:** Modern features lead to more readable and maintainable code.

---

## Rule 4: Proper Error Handling

Handle errors appropriately to prevent application crashes and improve debugging.

❌ **Forbidden:**

- Empty catch blocks: `catch(e) {}`
- Generic error handling without context
- Ignoring rejected promises
- Using `throw` with primitive values instead of Error objects

✅ **Required:**

- Always log errors in catch blocks: `console.error('Failed to fetch user:', error)`
- Use specific error types when appropriate
- Handle promise rejections: `promise.catch(error => console.error(error))`
- Throw Error objects: `throw new Error('message')`
- Use try/catch for async operations
- Implement proper error boundaries in React applications

**Why:** Proper error handling makes debugging easier and prevents silent failures.

---

## Rule 5: Consistent Module Import/Export Style

Use consistent module syntax throughout the project.

❌ **Forbidden:**

- Mixing CommonJS and ES6 module syntax in the same project
- Destructuring imports when only one export is needed
- Importing the entire library when only a few functions are needed

✅ **Required:**

- Use ES6 imports/exports when possible: `import { Component } from 'react'`
- Use default exports appropriately: `export default function MyComponent()`
- Group and order imports logically: external libraries, internal modules, relative imports
- Use absolute paths when available, relative paths when necessary
- Prefer named imports over namespace imports when only a few exports are needed

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
- Use `Object.is()` for comparing NaN or when identity is important

**Why:** Strict equality prevents unexpected behavior caused by JavaScript's type coercion.

---

## Rule 7: Security Best Practices

Implement secure coding practices to prevent vulnerabilities.

❌ **Forbidden:**

- Executing dynamic code with `eval()`, `Function()`, or `setTimeout`/`setInterval` strings
- Including untrusted data directly in DOM (XSS risk)
- Using insecure HTTP instead of HTTPS for sensitive operations
- Storing sensitive data in localStorage/sessionStorage

✅ **Required:**

- Sanitize user input before using in DOM or executing
- Use template literals safely: validate interpolated values
- Escape HTML content when inserting into DOM
- Use Content Security Policy (CSP) headers
- Store sensitive data securely (HTTP-only cookies, encrypted storage)
- Validate and sanitize all inputs on the server side

**Why:** Prevents security vulnerabilities and protects user data.

---

## Rule 8: Asynchronous Programming Patterns

Use appropriate patterns for handling asynchronous operations.

❌ **Forbidden:**

- Nested promises/callbacks (callback hell)
- Forgetting to return promises in chains
- Not handling errors in async/await properly

✅ **Required:**

- Use async/await for cleaner async code: `const data = await fetchData();`
- Proper error handling with try/catch in async functions
- Use Promise.all() for concurrent operations when appropriate
- Cancel promises when components unmount (React useEffect cleanup)
- Avoid creating unnecessary promise chains

**Why:** Proper async handling prevents race conditions and improves performance.

---

## Rule 9: Performance Optimization

Write efficient code that minimizes resource consumption.

❌ **Forbidden:**

- Heavy computations in render methods or loops
- Creating functions in render (in React)
- Memory leaks from unsubscribed event listeners or intervals
- Blocking the main thread with synchronous operations

✅ **Required:**

- Use memoization: `useMemo`, `useCallback` in React
- Debounce/throttle expensive operations
- Use virtualization for large lists
- Implement lazy loading for non-critical resources
- Optimize bundle size by tree-shaking unused code
- Use efficient algorithms and data structures

**Why:** Efficient code provides better user experience and scales better.

---

## Rule 10: Code Quality and Maintainability

Write code that is easy to understand, test, and maintain.

❌ **Forbidden:**

- Magic numbers and strings scattered throughout code
- Functions that are too long or do too many things
- Deep nesting levels (>3-4)
- Duplicate code blocks

✅ **Required:**

- Extract constants for magic numbers/strings
- Keep functions focused on a single responsibility
- Use early returns to reduce nesting
- Extract reusable code into functions or modules
- Write meaningful comments for complex logic
- Use JSDoc for complex functions

**Why:** Clean, maintainable code reduces long-term development costs.

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