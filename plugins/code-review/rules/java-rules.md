# Java Code Review Rules

These are Java-specific code review rules. Follow these guidelines to maintain high-quality Java code.

---

## Rule 1: Naming Conventions

Follow Java naming conventions strictly as defined in the Java Language Specification.

❌ **Forbidden:**

- Using camelCase for classes, interfaces, or enums
- Using PascalCase for methods, variables, or constants
- Using underscore in names (except for constants and special cases like JUnit test methods)
- Abbreviations in names that reduce readability

✅ **Required:**

- `PascalCase` for classes, interfaces, enums, and records: `UserService`, `HttpRequest`
- `camelCase` for methods, variables, parameters, and fields: `getUserById`, `firstName`
- `UPPER_SNAKE_CASE` for constants: `MAX_RETRY_COUNT`, `DEFAULT_TIMEOUT`
- Descriptive names that clearly indicate the purpose

**Example:**

```java
public class UserService {
    private static final int MAX_RETRY_ATTEMPTS = 3;

    public User findById(Long userId) {
        // implementation
    }
}
```

**Why:** Consistent naming improves readability and maintainability across Java projects.

---

## Rule 2: Proper Exception Handling

Handle exceptions appropriately following Java best practices.

❌ **Forbidden:**

- Catching generic `Exception` when more specific exceptions are available
- Empty catch blocks without logging or proper handling
- Returning `null` from methods that might cause NullPointerException
- Ignoring checked exceptions

✅ **Required:**

- Catch specific exceptions: `catch (IOException e)` instead of `catch (Exception e)`
- Log exceptions appropriately: `logger.error("Failed to connect", e);`
- Use try-with-resources for resource management: `try (FileInputStream fis = ...)`
- Throw appropriate custom exceptions when needed
- Document exceptions with `@throws` in javadoc

**Example:**

```java
try {
    InputStream inputStream = new FileInputStream(filePath);
    // process file
} catch (FileNotFoundException e) {
    logger.error("Configuration file not found: " + filePath, e);
    throw new ConfigurationException("Missing configuration file", e);
}
```

**Why:** Proper exception handling makes debugging easier and prevents application crashes.

---

## Rule 3: Effective Java Practices

Follow effective Java principles to write robust code.

❌ **Forbidden:**

- Exposing mutable fields in classes meant to be immutable
- Using raw types instead of parameterized types
- Returning null collections instead of empty collections
- Implementing `finalize()` method

✅ **Required:**

- Make defensive copies when necessary
- Use generics: `List<String> names` instead of `List names`
- Return empty collections: `Collections.emptyList()` instead of `null`
- Always override `equals()` and `hashCode()` together
- Prefer composition over inheritance when appropriate

**Why:** Following effective Java practices leads to safer, more maintainable code.

---

## Rule 4: Javadoc Documentation

Provide comprehensive documentation for public APIs.

❌ **Forbidden:**

- Missing Javadoc for public classes, methods, and fields
- Vague or incomplete Javadoc descriptions
- Javadoc that doesn't describe parameters, return values, or exceptions

✅ **Required:**

- Complete Javadoc for all public APIs
- Describe all `@param` values with meaningful explanations
- Document `@return` values, especially for complex types
- Document all `@throws` exceptions with conditions
- Use descriptive, grammatically correct English

**Example:**

```java
/**
 * Retrieves a user by their unique identifier.
 *
 * @param userId the unique identifier of the user to retrieve; must not be null
 * @return the user with the specified ID; never null
 * @throws IllegalArgumentException if userId is null
 * @throws UserNotFoundException if no user exists with the specified ID
 */
public User getUserById(UUID userId) {
    // implementation
}
```

**Why:** Comprehensive documentation enables better code reuse and understanding.

---

## Rule 5: Resource Management

Properly manage resources to prevent leaks and ensure efficient usage.

❌ **Forbidden:**

- Opening streams, connections, or other resources without closing them
- Using try-catch blocks without finally for resource cleanup
- Holding resources longer than necessary

✅ **Required:**

- Use try-with-resources for AutoCloseable resources
- Close resources in finally blocks if try-with-resources is not applicable
- Release resources promptly after use
- Use appropriate connection pooling for database connections

**Example:**

```java
try (Connection conn = dataSource.getConnection();
     PreparedStatement stmt = conn.prepareStatement(SQL_QUERY)) {
    // use resources
    stmt.executeUpdate();
} // resources automatically closed
```

**Why:** Proper resource management prevents memory leaks and optimizes performance.

---

## Rule 6: Concurrency Best Practices

Write thread-safe code when dealing with concurrent access.

❌ **Forbidden:**

- Sharing mutable objects between threads without proper synchronization
- Using non-thread-safe collections in concurrent contexts
- Modifying static state without synchronization

✅ **Required:**

- Use thread-safe collections: `ConcurrentHashMap`, `CopyOnWriteArrayList`
- Use `synchronized` blocks/methods when necessary
- Prefer immutable objects for shared data
- Use `java.util.concurrent` utilities for concurrent programming
- Annotate thread-safety with `@ThreadSafe` when appropriate

**Why:** Proper concurrency handling prevents race conditions and data corruption.

---

## Review Procedure

For each Java file:

1. **Read complete file**
2. **Search for violations**
3. **Report findings** with file:line references

---

## Report Format

### If violations found

```text
❌ FAIL

Violations:
1. [EXCEPTION HANDLING] - src/service/UserService.java:34
   Issue: Caught generic Exception instead of specific IOException
   Fix: Catch specific IOException and handle appropriately

2. [JAVADOC DOCUMENTATION] - src/model/User.java:15
   Issue: Missing Javadoc for public method
   Fix: Add complete Javadoc with param and return documentation
```

### If no violations

```text>
✅ PASS

File meets all semantic requirements.
```