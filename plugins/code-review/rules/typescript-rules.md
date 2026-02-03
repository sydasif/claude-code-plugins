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
- Loose typing that defeats the purpose of TypeScript

✅ **Required:**

- Explicit types for function parameters: `(name: string): void`
- Explicit return types for exported functions: `(): Promise<User>`
- Use specific object interfaces: `{ name: string; age: number }` or `interface User`
- Use union types: `type Status = 'active' | 'inactive'`
- Use generics appropriately: `<T>(item: T): T`
- Enable strict mode in tsconfig.json: `"strict": true`

**Why:** Strict typing catches bugs at compile time and serves as excellent documentation.

---

## Rule 2: Interface and Type Definitions

Organize your types properly using interfaces and types where appropriate.

❌ **Forbidden:**

- Inline type definitions in function signatures when they could be reusable
- Using type aliases for object shapes (prefer interfaces)
- Deeply nested anonymous types without proper naming
- Duplicate type definitions across files

✅ **Required:**

- Use `interface` for object shapes and `type` for unions/primitives
- Define reusable types at the module level
- Use `Partial<T>`, `Pick<T, K>`, `Omit<T, K>`, `Record<K,V>` for derived types
- Use discriminated unions for complex type relationships
- Create shared types in dedicated files for cross-module usage
- Use declaration merging appropriately for extending existing types

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
- Disabling strictNullChecks

✅ **Required:**

- Enable strictNullChecks in tsconfig.json
- Use optional chaining: `user?.profile?.email`
- Use nullish coalescing: `value ?? defaultValue`
- Proper type guards: `if (user !== null) { ... }`
- Define optional properties with `?:`
- Use type predicates for custom type guards: `function isValid(value: string | null): value is string`

**Why:** Proper null handling prevents common runtime errors like "Cannot read property of undefined".

---

## Rule 4: Module Import/Export Best Practices

Follow consistent and efficient module patterns.

❌ **Forbidden:**

- Importing entire libraries when only a few functions are needed
- Using namespace imports when specific imports are clearer
- Circular dependencies between modules
- Default exports for objects with multiple properties

✅ **Required:**

- Use specific imports: `import { useState } from 'react'`
- Group and order imports: external libraries, internal modules, relative imports
- Use barrel exports in index files: `export { MyComponent } from './MyComponent'`
- Prefer named exports for utility functions and objects with multiple properties
- Use default exports for single class/function components
- Avoid import cycles by introducing abstraction layers when needed

**Why:** Proper module handling improves bundle size and maintainability.

---

## Rule 5: Asynchronous Code Patterns

Use consistent and safe patterns for handling asynchronous operations.

❌ **Forbidden:**

- Forgotten `await` keywords causing unhandled promises
- Using `.then()` when async/await is more readable
- Not handling promise rejections properly
- Returning promises in void functions without proper handling

✅ **Required:**

- Use async/await consistently: `const data = await fetchData();`
- Proper error handling with try/catch blocks
- Use `Promise.all()` for concurrent operations when appropriate
- Use `Promise.allSettled()` when you need to handle all results regardless of success/failure
- Return proper typed promises from async functions
- Use AbortController for cancellable fetch operations

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
- Misusing conditional types causing poor performance

✅ **Required:**

- Use `readonly` for immutable properties: `readonly items: string[]`
- Use utility types: `Partial<User>`, `Required<User>`, `Readonly<User>`, `Pick<User, 'id' | 'name'>`, `Omit<User, 'password'>`
- Use mapped types for complex transformations
- Leverage conditional types for advanced type logic when appropriate
- Use template literal types for string manipulation: `type EventName = `on${Capitalize<string>}`
- Use const assertions for literal types: `const options = ['red', 'blue'] as const`

**Why:** Using TypeScript's advanced features maximizes type safety and code expressiveness.

---

## Rule 7: Type Safety in Function Design

Design functions with strong type safety in mind.

❌ **Forbidden:**

- Functions with too many parameters without parameter objects
- Optional parameters that should be required
- Functions returning multiple types without proper typing

✅ **Required:**

- Use parameter objects for functions with many parameters
- Use overloads for functions with complex conditional return types
- Use discriminated unions for complex data structures
- Return proper error types or use Result/Either patterns when appropriate
- Narrow types appropriately within function bodies

**Why:** Strongly typed functions are easier to use correctly and harder to misuse.

---

## Rule 8: Generic Types and Constraints

Use generics appropriately to create flexible, reusable code.

❌ **Forbidden:**

- Overusing generics when concrete types would be clearer
- Creating overly complex generic constraints
- Using `any` as generic type parameters

✅ **Required:**

- Add constraints to generic parameters when needed: `<T extends SomeBaseType>`
- Use default generic types when appropriate: `<T = string>`
- Create reusable generic functions and classes
- Use generic constraints for object property access: `<T, K extends keyof T>`

**Why:** Proper generic usage creates flexible, type-safe code without sacrificing performance.

---

## Rule 9: Security Best Practices

Implement secure coding practices specific to TypeScript.

❌ **Forbidden:**

- Trusting user input without proper type validation
- Using `eval()` or similar dynamic execution with user data
- Storing sensitive data in client-side TypeScript code

✅ **Required:**

- Validate types at runtime boundaries using libraries like Zod or Joi
- Use branded types to prevent mixing similar types: `type UserId = string & { __brand: 'UserId' }`
- Sanitize data before using in templates or DOM manipulation
- Type-check external API responses properly
- Use secure typing for authentication states

**Why:** Type safety is an additional layer of security but not a replacement for proper validation.

---

## Rule 10: Performance and Bundle Size

Consider performance implications of TypeScript features.

❌ **Forbidden:**

- Complex conditional types that slow compilation significantly
- Massive generic type definitions that impact build times
- Type-only imports used incorrectly causing runtime dependencies

✅ **Required:**

- Use type-only imports when appropriate: `import type { MyType } from './types'`
- Simplify complex types when they impact compilation speed
- Be mindful of recursive conditional types
- Use declaration files for external library types when needed

**Why:** Balancing type safety with compilation performance ensures efficient development workflow.

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