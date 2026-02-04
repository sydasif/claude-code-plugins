---
name: csharp-rules
description: C# Code Review Rules
user-invocable: false
---

# C# Code Review Rules

These are C#-specific code review rules. Follow these guidelines to maintain high-quality C# code.

---

## Rule 1: Naming Conventions

Follow C# naming conventions as defined in Microsoft's guidelines.

❌ **Forbidden:**

- Using camelCase for public members (methods, properties, classes, etc.)
- Using PascalCase for private fields
- Using Hungarian notation
- Abbreviations in names that reduce readability

✅ **Required:**

- `PascalCase` for public members: `GetUser`, `UserManager`, `IDisposable`
- `camelCase` for private fields: `userName`, `maxRetries`
- `PascalCase` for private methods and properties: `ValidateInput`, `ConnectionString`
- `PASCAL_CASE` for public constants: `MAX_RETRY_COUNT`, `DEFAULT_TIMEOUT`
- Descriptive names that clearly indicate the purpose
- Prefix interface names with `I`: `IUserService`, `IRepository`

**Example:**

```csharp
public class UserManager
{
    private readonly IUserRepository _userRepository;
    private const int MaxRetryCount = 3;

    public User GetUser(int id)
    {
        // implementation
    }
}
```

**Why:** Consistent naming improves readability and maintainability across C# projects.

---

## Rule 2: Exception Handling

Handle exceptions appropriately following .NET best practices.

❌ **Forbidden:**

- Catching generic `Exception` when more specific exceptions are available
- Empty catch blocks without logging or proper handling
- Throwing exceptions without meaningful messages
- Swallowing exceptions with `catch` that only has `throw;`

✅ **Required:**

- Catch specific exceptions: `catch (ArgumentException ex)` instead of `catch (Exception ex)`
- Log exceptions appropriately with context: `logger.LogError(ex, "Failed to connect to user service")`
- Throw meaningful exceptions with descriptive messages
- Use exception filters for complex conditions: `catch (Exception ex) when (ex.Message.Contains("timeout"))`
- Use `try-finally` or `using` statements for resource cleanup
- Preserve stack trace when re-throwing: use `throw;` not `throw ex;`

**Example:**

```csharp
try
{
    var user = await userService.GetUserAsync(userId);
}
catch (HttpRequestException ex)
{
    logger.LogError(ex, "Failed to retrieve user {UserId}", userId);
    throw new UserServiceException($"Could not retrieve user with ID {userId}", ex);
}
```

**Why:** Proper exception handling makes debugging easier and prevents application crashes.

---

## Rule 3: Modern C# Features

Leverage modern C# features for cleaner, more efficient code.

❌ **Forbidden:**

- Using old patterns when newer, more concise ones are available
- Not using nullable reference types when appropriate
- Verbose property declarations when expression-bodied members are cleaner

✅ **Required:**

- Use nullable reference types: `string?` instead of just `string`
- Use expression-bodied members: `public string Name => firstName + " " + lastName;`
- Use pattern matching: `if (obj is string name) { ... }`
- Use `using` declarations for automatic disposal
- Use `record` types for immutable data carriers
- Use `switch` expressions instead of statement switches when appropriate
- Use `init` only properties for immutable objects
- Use top-level programs for simple applications
- Use `async`/`await` for asynchronous operations

**Example:**

```csharp
public record Person(string FirstName, string LastName, int Age);

public string FormatName(Person person) => person switch
{
    { FirstName: "", LastName: "" } => "Unknown",
    { FirstName: "", LastName: var last } => last,
    { FirstName: var first, LastName: var last } => $"{first} {last}"
};
```

**Why:** Modern features lead to more readable and maintainable code.

---

## Rule 4: Security Best Practices

Implement secure coding practices to prevent vulnerabilities.

❌ **Forbidden:**

- Hardcoding sensitive information like passwords or API keys
- Building SQL queries with string concatenation (SQL injection risk)
- Trusting user input without validation
- Using insecure deserialization methods
- Using weak cryptographic algorithms (MD5, SHA-1)

✅ **Required:**

- Store sensitive data in configuration providers or secure vaults
- Use parameterized queries or Entity Framework for database access
- Validate and sanitize all user inputs using data annotations or validation libraries
- Use HTTPS for network communications
- Implement proper authentication and authorization (Identity, JWT)
- Use secure random number generators: `RandomNumberGenerator`
- Encode output to prevent XSS attacks
- Use modern cryptographic algorithms (AES, SHA-256, bcrypt for passwords)
- Apply principle of least privilege for permissions
- Use Anti-Forgery tokens for forms to prevent CSRF
- Validate file uploads and content types

**Example:**

```csharp
[HttpPost]
[ValidateAntiForgeryToken]
public async Task<IActionResult> CreateUser([FromBody] CreateUserDto model)
{
    if (!ModelState.IsValid)
    {
        return BadRequest(ModelState);
    }

    // Process user creation
}
```

**Why:** Prevents security vulnerabilities and protects sensitive data.

---

## Rule 5: Performance and Memory Management

Write efficient code considering .NET runtime characteristics.

❌ **Forbidden:**

- Creating unnecessary allocations in hot paths
- Using string concatenation in loops
- Holding references to prevent garbage collection unnecessarily
- Synchronous operations in async contexts

✅ **Required:**

- Use `StringBuilder` for string concatenation in loops
- Use `Span<T>` and `Memory<T>` for efficient memory operations
- Use `async`/`await` for I/O-bound operations
- Use `IEnumerable<T>` for lazy evaluation when appropriate
- Use `IAsyncEnumerable<T>` for streaming data asynchronously
- Profile code with performance measurement tools
- Use object pooling for frequently allocated objects when appropriate
- Implement `IDisposable` properly for resources that need cleanup
- Use `Span<T>` and `ReadOnlySpan<T>` for efficient string manipulation

**Example:**

```csharp
public async IAsyncEnumerable<string> ProcessLargeFileAsync(string filePath)
{
    using var reader = new StreamReader(filePath);
    string line;
    while ((line = await reader.ReadLineAsync()) != null)
    {
        yield return line.ToUpperInvariant();
    }
}
```

**Why:** Efficient code provides better performance and uses system resources wisely.

---

## Rule 6: Testing Best Practices

Write effective tests to ensure code quality.

❌ **Forbidden:**

- Tests with no assertions
- Tests that depend on external services without proper mocking
- Tests that don't cover edge cases
- Tests that modify shared state without proper isolation

✅ **Required:**

- Use appropriate test frameworks (xUnit, NUnit, MSTest)
- Follow AAA pattern: Arrange, Act, Assert
- Test both happy path and error conditions
- Use meaningful test method names following convention
- Test boundary conditions and edge cases
- Mock external dependencies appropriately
- Use parameterized tests for multiple input scenarios
- Apply the Arrange-Act-Assert (AAA) pattern
- Use test fixtures for common test setup

**Example:**

```csharp
[Fact]
public async Task GetUser_ValidId_ReturnsUser()
{
    // Arrange
    var userId = 1;
    var mockUserService = new Mock<IUserService>();
    mockUserService.Setup(x => x.GetUserAsync(userId))
                   .ReturnsAsync(new User { Id = userId, Name = "John Doe" });

    // Act
    var result = await mockUserService.Object.GetUserAsync(userId);

    // Assert
    Assert.NotNull(result);
    Assert.Equal("John Doe", result.Name);
}
```

**Why:** Comprehensive tests ensure code correctness and maintainability.

---

## Rule 7: Code Organization and Documentation

Structure code following C# idioms and provide appropriate documentation.

❌ **Forbidden:**

- Missing documentation for public APIs
- Comments that merely repeat the code
- Large classes that should be broken down
- Poor namespace organization

✅ **Required:**

- Document all public classes, methods, and properties with XML documentation
- Use complete XML documentation with `<param>`, `<returns>`, and `<exception>` tags
- Group related functionality together
- Use `dotnet format` to format code consistently
- Organize files logically with clear separation of concerns
- Use meaningful variable names that describe their purpose
- Follow SOLID principles and common design patterns
- Use regions sparingly and only when they improve readability

**Example:**

```csharp
/// <summary>
/// Retrieves a user by their unique identifier.
/// </summary>
/// <param name="userId">The unique identifier of the user to retrieve.</param>
/// <returns>The user with the specified ID.</returns>
/// <exception cref="UserNotFoundException">Thrown when no user exists with the specified ID.</exception>
public async Task<User> GetUserAsync(int userId)
{
    // implementation
}
```

**Why:** Well-organized code with good documentation is easier to understand and maintain.

---

## Rule 8: Dependency Management and Architecture

Manage dependencies and architecture following .NET best practices.

❌ **Forbidden:**

- Tight coupling between classes without proper abstractions
- Not using dependency injection appropriately
- Circular dependencies between modules

✅ **Required:**

- Use dependency injection for loose coupling
- Register services in Program.cs/Startup.cs appropriately
- Use interfaces for abstractions and dependency inversion
- Separate concerns using appropriate architectural patterns (MVC, Clean Architecture, etc.)
- Use MediatR or similar for CQRS patterns when appropriate
- Apply configuration patterns for external settings
- Use NuGet package management with proper versioning
- Keep dependencies updated and scan for vulnerabilities

**Why:** Proper architecture and dependency management ensures maintainable and testable code.

---

## Review Procedure

For each C# file:

1. **Read complete file**
2. **Search for violations**
3. **Report findings** with file:line references

---

## Report Format

### If violations found

```text
❌ FAIL

Violations:
1. [EXCEPTION HANDLING] - Services/UserService.cs:42
   Issue: Caught generic Exception instead of specific HttpRequestException
   Fix: Catch specific HttpRequestException and handle appropriately

2. [SECURITY PRACTICES] - Controllers/UserController.cs:15
   Issue: Missing AntiForgeryToken attribute for POST method
   Fix: Add [ValidateAntiForgeryToken] attribute to prevent CSRF
```

### If no violations

```text
✅ PASS

File meets all semantic requirements.
```
