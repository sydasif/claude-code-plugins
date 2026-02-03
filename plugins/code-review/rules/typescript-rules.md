# TypeScript Code Review Rules

These are TypeScript-specific code review rules. Follow these guidelines to maintain high-quality TypeScript code.

---

## Rule 1: Strict Type Definitions

Use precise and explicit type definitions to maximize type safety benefits.

❌ **Forbidden:**

- Using `any` type without proper justification
- Implicit `any` types in function parameters or return values
- Using `Object` instead of specific object types
- Using generic `Array` instead of typed arrays like `Array<string>`

✅ **Required:**

- Explicit types for function parameters: `(name: string): void`
- Explicit return types for exported functions: `(): Promise<User>`
- Use specific object interfaces: `{ name: string; age: number }` or `interface User`
- Use union types: `type Status = 'active' | 'inactive'`
- Use generics appropriately: `<T>(item: T): T`

**Why:** Strict typing catches bugs at compile time and serves as excellent documentation.

---

## Rule 2: Interface and Type Definitions

Organize your types properly using interfaces and types where appropriate.

❌ **Forbidden:**

- Inline type definitions in function signatures when they could be reusable
- Using type aliases for object shapes (prefer interfaces)
- Deeply nested anonymous types without proper naming

✅ **Required:**

- Use `interface` for object shapes and `type` for unions/primitives
- Define reusable types at the module level
- Use `Partial<T>`, `Pick<T, K>`, `Omit<T, K>` for derived types
- Use discriminated unions for complex type relationships

**Example:**

```typescript
interface User {
  id: number;
  name: string;
  email: string;
}

type UserRole = 'admin' | 'user' | 'guest';
```

**Why:** Well-defined types improve code maintainability and reduce duplication.

---

## Rule 3: Strict Null Checks

Enable and respect strict null checking to prevent runtime errors.

❌ **Forbidden:**

- Using non-null assertions (`!`) unnecessarily
- Ignoring nullable types in conditional logic
- Accessing properties without checking for null/undefined

✅ **Required:**

- Use optional chaining: `user?.profile?.email`
- Use nullish coalescing: `value ?? defaultValue`
- Proper type guards: `if (user !== null) { ... }`
- Define optional properties with `?:`

**Why:** Proper null handling prevents common runtime errors like "Cannot read property of undefined".

---

## Rule 4: Module Import/Export Best Practices

Follow consistent and efficient module patterns.

❌ **Forbidden:**

- Importing entire libraries when only a few functions are needed
- Using namespace imports when specific imports are clearer
- Circular dependencies between modules

✅ **Required:**

- Use specific imports: `import { useState } from 'react'`
- Group and order imports: external libraries, internal modules, relative imports
- Use barrel exports in index files: `export { MyComponent } from './MyComponent'`
- Prefer default exports for primary exports, named exports for secondary

**Why:** Proper module handling improves bundle size and maintainability.

---

## Rule 5: Asynchronous Code Patterns

Use consistent and safe patterns for handling asynchronous operations.

❌ **Forbidden:**

- Forgotten `await` keywords causing unhandled promises
- Using `.then()` when async/await is more readable
- Not handling promise rejections properly

✅ **Required:**

- Use async/await consistently: `const data = await fetchData();`
- Proper error handling with try/catch blocks
- Use `Promise.all()` for concurrent operations when appropriate
- Avoid nested async/await when possible

**Example:**

```typescript
try {
  const userData = await fetchUserData(userId);
  return processUser(userData);
} catch (error) {
  console.error('Failed to fetch user data:', error);
  throw error;
}
```

**Why:** Consistent async patterns improve code readability and error handling.

---

## Rule 6: Modern TypeScript Features

Leverage TypeScript-specific features to write better code.

❌ **Forbidden:**

- Using JavaScript patterns when TypeScript alternatives are better
- Not using readonly when immutability is intended
- Ignoring utility types that could simplify code

✅ **Required:**

- Use `readonly` for immutable properties: `readonly items: string[]`
- Use utility types: `Partial<User>`, `Required<User>`, `Readonly<User>`
- Use mapped types for complex transformations
- Leverage conditional types for advanced type logic when appropriate

**Why:** Using TypeScript's advanced features maximizes type safety and code expressiveness.

---

## Review Procedure

For each TypeScript file:

1. **Read complete file**
2. **Search for violations**
3. **Report findings** with file:line references

---

## Report Format

### If violations found

```text
❌ FAIL

Violations:
1. [STRICT TYPE DEFINITIONS] - src/models/user.ts:23
   Issue: Used 'any' type without justification
   Fix: Replace with specific type or provide justification comment

2. [NULL CHECKS] - src/services/api.ts:45
   Issue: Missing optional chaining for possibly undefined property
   Fix: Use user?.profile?.email instead of user.profile.email
```

### If no violations

```text
✅ PASS

File meets all semantic requirements.
```