# PHP Code Review Rules

These are PHP-specific code review rules. Follow these guidelines to maintain high-quality PHP code.

---

## Rule 1: Naming Conventions

Follow PHP naming conventions as defined in PSR standards.

❌ **Forbidden:**

- Using camelCase for method names (unless legacy)
- Using underscores in class names
- Using ALL_CAPS for non-constant variables
- Using abbreviated names that reduce readability

✅ **Required:**

- `PascalCase` for class names: `UserManager`, `HttpRequest`
- `camelCase` for method names: `getUser`, `validateInput`
- `snake_case` for function names (in procedural code): `get_user`, `validate_input`
- `UPPER_SNAKE_CASE` for constants: `MAX_RETRY_COUNT`, `DEFAULT_TIMEOUT`
- `lowercase` for namespaces: `App\Services\User`
- Descriptive names that clearly indicate the purpose
- Prefix interfaces with `I` or suffix with `Interface`: `UserInterface`, `IUser`

**Example:**

```php
<?php

namespace App\Services;

class UserManager
{
    private const MAX_RETRY_COUNT = 3;

    public function getUser(int $id): ?User
    {
        // implementation
    }
}
```

**Why:** Consistent naming improves readability and maintainability across PHP projects.

---

## Rule 2: Error Handling

Handle errors appropriately following PHP best practices.

❌ **Forbidden:**

- Suppressing errors with `@` operator unnecessarily
- Using old error handling without exceptions
- Ignoring return values that indicate errors
- Throwing generic exceptions without context

✅ **Required:**

- Use exceptions for error conditions: `throw new InvalidArgumentException()`
- Catch specific exceptions rather than generic `Exception`
- Use try-catch blocks appropriately
- Implement proper error logging with context
- Use `finally` blocks for cleanup when needed
- Validate inputs and throw appropriate exceptions
- Use error reporting levels appropriately in development vs production

**Example:**

```php
try {
    $user = $this->userRepository->findById($id);
    if (!$user) {
        throw new UserNotFoundException("User with ID {$id} not found");
    }
    return $user;
} catch (DatabaseException $e) {
    $this->logger->error('Database error retrieving user', [
        'error' => $e->getMessage(),
        'user_id' => $id
    ]);
    throw $e;
}
```

**Why:** Proper error handling makes debugging easier and prevents silent failures.

---

## Rule 3: Modern PHP Features

Leverage modern PHP features for cleaner, more efficient code.

❌ **Forbidden:**

- Using outdated PHP syntax when modern alternatives are available
- Not using type declarations when possible
- Using procedural code when object-oriented approach is better

✅ **Required:**

- Use type declarations for parameters and return values: `function process(int $id): string`
- Use scalar type hints and return types
- Use union types (PHP 8+): `function process(int|string $value): void`
- Use named arguments (PHP 8+): `createUser(name: 'John', email: 'john@example.com')`
- Use match expressions (PHP 8+): `return match($status) { 'active' => 1, default => 0 };`
- Use constructor property promotion (PHP 8+): `public function __construct(public string $name) {}`
- Use nullsafe operator (PHP 8+): `$user?->getAddress()?->getCity()`
- Use attributes (PHP 8+) instead of annotations
- Use arrow functions for simple operations: `fn($user) => $user->getName()`
- Use `mixed` type when appropriate (PHP 8+)

**Example:**

```php
class UserService
{
    public function __construct(
        private UserRepository $repository,
        private LoggerInterface $logger
    ) {}

    public function findUser(int $id): ?User
    {
        return match(true) {
            $id <= 0 => throw new InvalidArgumentException('ID must be positive'),
            default => $this->repository->find($id)
        };
    }
}
```

**Why:** Modern PHP features lead to more readable and maintainable code.

---

## Rule 4: Security Best Practices

Implement secure coding practices to prevent vulnerabilities.

❌ **Forbidden:**

- Hardcoding sensitive information like passwords or API keys
- Building SQL queries with string concatenation (SQL injection risk)
- Trusting user input without validation
- Using `eval()` or similar dynamic execution
- Displaying sensitive error information to users
- Using weak cryptographic algorithms

✅ **Required:**

- Store sensitive data in environment variables or secure vaults
- Use prepared statements or query builders for database access
- Validate and sanitize all user inputs using validation libraries
- Use HTTPS for network communications
- Implement proper authentication and authorization (sessions, JWT)
- Use password hashing functions: `password_hash()` and `password_verify()`
- Encode output to prevent XSS attacks: `htmlspecialchars()`
- Use Content Security Policy (CSP) headers
- Apply input length limits to prevent buffer overflow attacks
- Use secure random generators: `random_int()`, `random_bytes()`
- Implement CSRF protection for forms
- Use PHP's built-in functions for secure operations

**Example:**

```php
// Secure database query
$stmt = $pdo->prepare("SELECT * FROM users WHERE email = ?");
$stmt->execute([$email]);
$user = $stmt->fetch();

// Secure password handling
$hashedPassword = password_hash($password, PASSWORD_DEFAULT);
$isCorrect = password_verify($password, $hashedPassword);
```

**Why:** Prevents security vulnerabilities and protects sensitive data.

---

## Rule 5: Performance and Memory Management

Write efficient code considering PHP's runtime characteristics.

❌ **Forbidden:**

- Creating unnecessary objects in loops
- Using `include`/`require` inside loops
- Loading large amounts of data unnecessarily
- Using inefficient algorithms for large datasets

✅ **Required:**

- Use autoloading instead of manual includes
- Use generators for processing large datasets: `yield` keyword
- Implement proper caching strategies (Redis, Memcached)
- Use opcode caching (OPcache)
- Optimize database queries with proper indexing and joins
- Use appropriate data structures for the task
- Profile code with tools like Blackfire or Xdebug
- Minimize the use of global variables
- Use `unset()` for large variables when no longer needed
- Consider lazy loading for expensive operations

**Example:**

```php
// Efficient processing of large datasets
public function processLargeCsv(string $filename): Generator
{
    $handle = fopen($filename, 'r');
    while (($row = fgetcsv($handle)) !== false) {
        yield $this->transformRow($row);
    }
    fclose($handle);
}
```

**Why:** Efficient code provides better performance and uses system resources wisely.

---

## Rule 6: Code Organization and Documentation

Structure code following PHP idioms and provide appropriate documentation.

❌ **Forbidden:**

- Missing documentation for public APIs
- Comments that merely repeat the code
- Large classes that should be broken down
- Poor namespace organization

✅ **Required:**

- Document all public classes, methods, and functions with PHPDoc
- Use complete PHPDoc with `@param`, `@return`, and `@throws` tags
- Group related functionality together
- Use PSR-12 coding standards for formatting
- Organize files logically with clear separation of concerns
- Use meaningful variable names that describe their purpose
- Follow SOLID principles and common design patterns
- Use Composer for dependency management
- Follow PSR standards (PSR-1, PSR-4, PSR-12, etc.)

**Example:**

```php
/**
 * Retrieves a user by their unique identifier.
 *
 * @param int $id The unique identifier of the user to retrieve
 * @return User|null The user with the specified ID, or null if not found
 * @throws DatabaseException If there's an error querying the database
 */
public function getUser(int $id): ?User
{
    // implementation
}
```

**Why:** Well-organized code with good documentation is easier to understand and maintain.

---

## Rule 7: Testing Best Practices

Write effective tests to ensure code quality.

❌ **Forbidden:**

- Tests with no assertions
- Tests that depend on external databases without proper mocking
- Tests that don't cover edge cases
- Tests that modify shared state without proper isolation

✅ **Required:**

- Use appropriate test frameworks (PHPUnit, Pest)
- Follow AAA pattern: Arrange, Act, Assert
- Test both success and error conditions
- Use meaningful test method names
- Test boundary conditions and edge cases
- Mock external dependencies appropriately
- Use data providers for testing multiple scenarios
- Implement proper test fixtures and setup/teardown
- Use dependency injection for better testability

**Example:**

```php
/**
 * @test
 */
public function it_returns_user_when_valid_id_is_provided(): void
{
    // Arrange
    $userId = 123;
    $userRepository = $this->createMock(UserRepository::class);
    $userRepository->method('find')
                  ->with($userId)
                  ->willReturn(new User($userId));

    $userService = new UserService($userRepository);

    // Act
    $result = $userService->getUser($userId);

    // Assert
    $this->assertInstanceOf(User::class, $result);
    $this->assertEquals($userId, $result->getId());
}
```

**Why:** Comprehensive tests ensure code correctness and maintainability.

---

## Rule 8: Dependency Management

Manage dependencies following Composer best practices.

❌ **Forbidden:**

- Committing vendor directory to version control
- Using wildcard versions that could introduce breaking changes
- Installing packages globally when project-specific is needed

✅ **Required:**

- Use Composer for dependency management
- Pin dependencies to specific versions or use version ranges appropriately
- Use `composer.lock` to ensure reproducible builds
- Keep dependencies updated: `composer update`
- Remove unused dependencies: `composer remove package-name`
- Use `require-dev` for development dependencies
- Scan dependencies for security vulnerabilities with `composer audit`
- Use autoload optimization in production

**Why:** Proper dependency management ensures reproducible builds and security.

---

## Review Procedure

For each PHP file:

1. **Read complete file**
2. **Search for violations**
3. **Report findings** with file:line references

---

## Report Format

### If violations found

```text
❌ FAIL

Violations:
1. [SECURITY PRACTICES] - src/UserController.php:25
   Issue: Used direct string concatenation in SQL query
   Fix: Use prepared statements instead

2. [TYPE DECLARATIONS] - src/UserService.php:15
   Issue: Missing parameter type declaration
   Fix: Add type declaration to function signature
```

### If no violations

```text
✅ PASS

File meets all semantic requirements.
```