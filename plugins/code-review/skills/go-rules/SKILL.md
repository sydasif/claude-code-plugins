---
name: go-rules
description: Go-specific code review rules to ensure best practices.
user-invocable: false
---

# Go Code Review Rules

These are Go-specific code review rules. Follow these guidelines to maintain high-quality Go code.

---

## Rule 1: Naming Conventions

Follow Go naming conventions as defined in Effective Go.

❌ **Forbidden:**

- Using camelCase for exported functions/types (use PascalCase)
- Using snake_case for any identifiers
- Abbreviations in names that reduce readability
- Starting private functions with capital letter

✅ **Required:**

- `PascalCase` for exported functions, types, and constants: `GetUser`, `UserManager`
- `camelCase` for unexported functions and types: `getUser`, `userManager`
- `UPPER_SNAKE_CASE` for exported constants: `MAX_RETRY_COUNT`, `DEFAULT_TIMEOUT`
- Descriptive names that clearly indicate the purpose
- Package names in lowercase: `users`, `handlers`
- Test functions with `Test` prefix and camel case: `TestGetUserByID`

**Example:**

```go
type UserManager struct {
    db *sql.DB
}

func (um *UserManager) GetUser(id int) (*User, error) {
    // implementation
}

const MAX_RETRY_COUNT = 3
```

**Why:** Consistent naming improves readability and maintainability across Go projects.

---

## Rule 2: Error Handling

Handle errors appropriately following Go best practices.

❌ **Forbidden:**

- Ignoring errors with blank identifier without good reason: `val, _ := function()`
- Returning bare errors without context
- Creating errors with `fmt.Errorf()` when `errors.New()` is sufficient
- Panicking in library code (only use in truly exceptional circumstances)

✅ **Required:**

- Handle all errors explicitly: `if err != nil { return err }`
- Wrap errors with context using `fmt.Errorf("%w")` for error wrapping
- Use `errors.Is()` and `errors.As()` for error comparison
- Return descriptive error messages
- Use error types for complex error handling scenarios
- Use `errors.Join()` (Go 1.20+) for multiple errors

**Example:**

```go
rows, err := db.Query("SELECT * FROM users WHERE id = ?", id)
if err != nil {
    return nil, fmt.Errorf("failed to query user with id %d: %w", id, err)
}
defer rows.Close()
```

**Why:** Proper error handling makes debugging easier and prevents silent failures.

---

## Rule 3: Go Concurrency Patterns

Write safe concurrent code using Go's built-in concurrency features.

❌ **Forbidden:**

- Sharing mutable state between goroutines without synchronization
- Using mutexes when channels would be more appropriate
- Goroutine leaks by not properly closing or signaling goroutines to stop
- Calling non-concurrent-safe operations on maps from multiple goroutines

✅ **Required:**

- Use channels for communication between goroutines
- Use `sync.WaitGroup` to wait for goroutines to complete
- Use `context.Context` for cancellation and timeouts
- Use `sync.Mutex` or `sync.RWMutex` for shared state protection
- Use `sync.Once` for one-time initialization
- Use `atomic` package for simple atomic operations
- Properly close channels when finished

**Example:**

```go
ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
defer cancel()

resultCh := make(chan Result, 1)
go func() {
    resultCh <- fetchResult(ctx)
}()
```

**Why:** Proper concurrency handling prevents race conditions and data corruption.

---

## Rule 4: Security Best Practices

Implement secure coding practices to prevent vulnerabilities.

❌ **Forbidden:**

- Hardcoding sensitive information like passwords or API keys
- Building SQL queries with string concatenation (SQL injection risk)
- Trusting user input without validation
- Using `template.HTML` without proper sanitization
- Executing commands with user input without validation

✅ **Required:**

- Store sensitive data in environment variables or secure vaults
- Use parameterized queries or prepared statements with `database/sql`
- Validate and sanitize all user inputs
- Use `html/template` with automatic escaping
- Use `url.PathEscape()` and `url.QueryEscape()` for URL encoding
- Implement proper authentication and authorization
- Use HTTPS for network communications
- Use `crypto/tls` for secure communication
- Use `golang.org/x/crypto` packages for secure cryptographic operations

**Example:**

```go
// Safe SQL query
stmt, err := db.Prepare("SELECT * FROM users WHERE id = ?")
if err != nil {
    return err
}
defer stmt.Close()

row := stmt.QueryRow(userID)
```

**Why:** Prevents security vulnerabilities and protects sensitive data.

---

## Rule 5: Performance and Memory Management

Write efficient code considering Go's memory model and garbage collector.

❌ **Forbidden:**

- Creating unnecessary allocations in hot paths
- Using `fmt.Sprintf` in performance-critical code
- Premature optimization without profiling
- Holding references to prevent garbage collection unnecessarily

✅ **Required:**

- Pre-allocate slices and maps when size is known: `make([]int, 0, capacity)`
- Use `strings.Builder` for efficient string concatenation
- Use buffers pools for frequently allocated objects: `sync.Pool`
- Profile code with `go tool pprof` to identify bottlenecks
- Use `bytes.Buffer` for byte slice operations
- Prefer `copy()` for slice/array copying
- Consider using structs with value receivers vs pointer receivers appropriately

**Example:**

```go
var buf strings.Builder
buf.Grow(1024) // Pre-allocate if size is known
buf.WriteString("Hello, ")
buf.WriteString("World!")
result := buf.String()
```

**Why:** Efficient code provides better performance and uses system resources wisely.

---

## Rule 6: Testing Best Practices

Write effective tests to ensure code quality.

❌ **Forbidden:**

- Tests with no assertions
- Tests that depend on external services without proper mocking
- Tests that don't cover edge cases
- Using `t.Fatal()` in goroutines (use `t.Error()` and `sync.WaitGroup`)

✅ **Required:**

- Use table-driven tests for multiple scenarios
- Test both success and error conditions
- Use `testing.T` and `testing.B` appropriately
- Write benchmark tests for performance-critical code
- Use `testify` or similar libraries for assertions when helpful
- Mock external dependencies appropriately
- Use `TestMain` for test setup and teardown when needed
- Follow the arrange-act-assert pattern

**Example:**

```go
func TestCalculateTax(t *testing.T) {
    tests := []struct {
        name     string
        income   float64
        expected float64
    }{
        {"Low income", 10000, 1000},
        {"High income", 100000, 25000},
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            result := CalculateTax(tt.income)
            assert.Equal(t, tt.expected, result)
        })
    }
}
```

**Why:** Comprehensive tests ensure code correctness and maintainability.

---

## Rule 7: Code Organization and Comments

Structure code following Go idioms and provide appropriate documentation.

❌ **Forbidden:**

- Missing documentation for exported functions/types
- Comments that merely repeat the code
- Large functions that should be broken down
- Poor package organization

✅ **Required:**

- Document all exported functions, types, and packages with clear comments
- Use complete sentences in comments
- Group related functions together
- Use `gofmt` to format code consistently
- Organize files logically with clear separation of concerns
- Use meaningful variable names that describe their purpose
- Group imports with standard library first, then external, then internal

**Example:**

```go
// GetUser retrieves a user by their unique identifier.
// Returns ErrUserNotFound if no user exists with the given ID.
func (um *UserManager) GetUser(id int) (*User, error) {
    // implementation
}
```

**Why:** Well-organized code with good documentation is easier to understand and maintain.

---

## Rule 8: Dependency Management

Manage dependencies following Go modules best practices.

❌ **Forbidden:**

- Committing `vendor/` directory without good reason
- Using outdated dependencies with known vulnerabilities
- Importing entire packages when only a few functions are needed

✅ **Required:**

- Use Go modules for dependency management
- Keep dependencies updated: `go get -u`
- Pin dependencies to specific versions in `go.mod`
- Remove unused dependencies: `go mod tidy`
- Use `replace` directive only when necessary for forks
- Scan dependencies for security vulnerabilities with tools like `govulncheck`

**Why:** Proper dependency management ensures reproducible builds and security.

---

## Review Procedure

For each Go file:

1. **Read complete file**
2. **Search for violations**
3. **Report findings** with file:line references

---

## Report Format

### If violations found

```text
❌ FAIL

Violations:
1. [ERROR HANDLING] - handlers/user.go:25
   Issue: Ignored error return value
   Fix: Handle the error explicitly or wrap with context

2. [NAMING CONVENTIONS] - models/user.go:15
   Issue: Used snake_case for exported function
   Fix: Change to PascalCase for exported function
```

### If no violations

```text
✅ PASS

File meets all semantic requirements.
