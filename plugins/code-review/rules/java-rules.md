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
- Acronyms treated as words instead of uppercase (XMLHTTPRequest instead of XmlHttpRequst)

✅ **Required:**

- `PascalCase` for classes, interfaces, enums, and records: `UserService`, `HttpRequest`
- `camelCase` for methods, variables, parameters, and fields: `getUserById`, `firstName`
- `UPPER_SNAKE_CASE` for constants: `MAX_RETRY_COUNT`, `DEFAULT_TIMEOUT`
- Descriptive names that clearly indicate the purpose
- Package names in lowercase with dots separating segments: `com.example.project.module`

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
- Swallowing exceptions without proper propagation

✅ **Required:**

- Catch specific exceptions: `catch (IOException e)` instead of `catch (Exception e)`
- Log exceptions appropriately: `logger.error("Failed to connect", e);`
- Use try-with-resources for resource management: `try (FileInputStream fis = ...)`
- Throw appropriate custom exceptions when needed
- Document exceptions with `@throws` in javadoc
- Use `try-finally` or `try-with-resources` for cleanup
- Propagate exceptions up the call stack when appropriate

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
- Using inheritance just to get code reuse

✅ **Required:**

- Make defensive copies when necessary
- Use generics: `List<String> names` instead of `List names`
- Return empty collections: `Collections.emptyList()` instead of `null`
- Always override `equals()` and `hashCode()` together
- Prefer composition over inheritance when appropriate
- Implement `Comparable` interface only when there's a natural ordering
- Use builder pattern for complex object construction

**Why:** Following effective Java practices leads to safer, more maintainable code.

---

## Rule 4: Javadoc Documentation

Provide comprehensive documentation for public APIs.

❌ **Forbidden:**

- Missing Javadoc for public classes, methods, and fields
- Vague or incomplete Javadoc descriptions
- Javadoc that doesn't describe parameters, return values, or exceptions
- Copy-paste documentation without proper updates

✅ **Required:**

- Complete Javadoc for all public APIs
- Describe all `@param` values with meaningful explanations
- Document `@return` values, especially for complex types
- Document all `@throws` exceptions with conditions
- Use descriptive, grammatically correct English
- Include examples when beneficial for understanding

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
- Manual resource management when try-with-resources is available

✅ **Required:**

- Use try-with-resources for AutoCloseable resources
- Close resources in finally blocks if try-with-resources is not applicable
- Release resources promptly after use
- Use appropriate connection pooling for database connections
- Implement `AutoCloseable` interface for custom resource classes
- Use `ScheduledExecutorService.shutdown()` and `awaitTermination()`

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
- Using `Thread.stop()` or `suspend()` methods

✅ **Required:**

- Use thread-safe collections: `ConcurrentHashMap`, `CopyOnWriteArrayList`
- Use `synchronized` blocks/methods when necessary
- Prefer immutable objects for shared data
- Use `java.util.concurrent` utilities for concurrent programming
- Annotate thread-safety with `@ThreadSafe` when appropriate
- Use `java.util.concurrent.atomic` classes for atomic operations
- Use `ExecutorService` instead of creating threads directly

**Why:** Proper concurrency handling prevents race conditions and data corruption.

---

## Rule 7: Modern Java Features (Java 8+)

Leverage modern Java features for cleaner, more efficient code.

❌ **Forbidden:**

- Using old iteration patterns when streams are more appropriate
- Verbose anonymous classes when lambda expressions are cleaner
- Manual null checks when Optional is more expressive

✅ **Required:**

- Use streams for functional-style operations: `list.stream().filter(...).collect(...)`
- Use lambda expressions for SAM (Single Abstract Method) interfaces
- Use `Optional` for values that might be absent
- Use method references: `list.forEach(System.out::println)`
- Use `var` for local variable type inference when it improves readability
- Use records for simple data carriers
- Use sealed classes for restricted hierarchies

**Why:** Modern features lead to more readable and maintainable code.

---

## Rule 8: Security Best Practices

Implement secure coding practices to prevent vulnerabilities.

❌ **Forbidden:**

- Hardcoding sensitive information like passwords or API keys
- Using insecure deserialization (ObjectInputStream)
- Building SQL queries with string concatenation (SQL injection risk)
- Trusting user input without validation

✅ **Required:**

- Store sensitive data in environment variables or secure vaults
- Use parameterized queries or prepared statements
- Validate and sanitize all user inputs
- Use HTTPS for network communications
- Implement proper authentication and authorization
- Use secure random number generators
- Encode output to prevent XSS attacks

**Why:** Prevents security vulnerabilities and protects sensitive data.

---

## Rule 9: Performance and Memory Management

Write efficient code considering JVM characteristics.

❌ **Forbidden:**

- Creating unnecessary objects in loops
- Using `String` concatenation in loops (use `StringBuilder`)
- Holding references to objects preventing garbage collection
- Synchronization bottlenecks

✅ **Required:**

- Use StringBuilder for string concatenation in loops
- Consider object pooling for expensive objects
- Use primitive collections when appropriate to avoid boxing overhead
- Choose appropriate collection types based on usage patterns
- Profile memory usage to identify bottlenecks
- Use weak references when appropriate to prevent memory leaks

**Why:** Efficient code provides better performance and uses system resources wisely.

---

## Rule 10: Testing Best Practices

Write effective tests to ensure code quality.

❌ **Forbidden:**

- Tests with no assertions
- Mocking everything including value objects
- Tests that depend on external services without proper mocking
- Tests that don't cover edge cases

✅ **Required:**

- Use appropriate test frameworks (JUnit 5, TestNG)
- Follow AAA pattern: Arrange, Act, Assert
- Test both happy path and error conditions
- Use meaningful test method names
- Test boundary conditions and edge cases
- Mock external dependencies appropriately
- Use parameterized tests for multiple input scenarios

**Why:** Comprehensive tests ensure code correctness and maintainability.

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

```text
✅ PASS

File meets all semantic requirements.
```