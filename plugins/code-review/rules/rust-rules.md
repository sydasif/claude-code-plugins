# Rust Code Review Rules

These are Rust-specific code review rules. Follow these guidelines to maintain high-quality Rust code.

---

## Rule 1: Naming Conventions

Follow Rust naming conventions as defined in Rust API Guidelines.

❌ **Forbidden:**

- Using camelCase for function and variable names (use snake_case)
- Using snake_case for type names (use PascalCase)
- Using PascalCase for module names (use snake_case)
- Using ALL_CAPS for non-constant variables

✅ **Required:**

- `PascalCase` for types, traits, and enum variants: `UserManager`, `HttpRequest`, `SomeVariant`
- `snake_case` for functions, methods, variables, and modules: `get_user`, `user_name`, `network_utils`
- `SCREAMING_SNAKE_CASE` for constants and statics: `MAX_RETRY_COUNT`, `DEFAULT_TIMEOUT`
- Descriptive names that clearly indicate the purpose
- Use `is_`, `has_`, `can_`, `should_` prefixes for Boolean methods: `is_empty`, `has_children`
- Use `to_` prefix for conversion methods that consume self: `to_string`, `to_vec`
- Use `as_` prefix for methods that return borrowed data: `as_str`, `as_slice`

**Example:**

```rust
struct UserManager {
    max_retry_count: u32,
}

impl UserManager {
    fn get_user(&self, id: u32) -> Option<User> {
        // implementation
    }

    fn is_enabled(&self) -> bool {
        // implementation
    }
}

const MAX_RETRY_COUNT: u32 = 3;

enum NetworkError {
    InvalidUrl,
    ConnectionFailed,
    Timeout,
}
```

**Why:** Consistent naming improves readability and maintainability across Rust projects.

---

## Rule 2: Ownership and Borrowing

Handle ownership and borrowing appropriately following Rust's ownership model.

❌ **Forbidden:**

- Moving values when borrowing would be sufficient
- Creating unnecessary clones of owned values
- Creating reference cycles that cause memory leaks
- Using `Rc<T>` or `Arc<T>` when single ownership is sufficient

✅ **Required:**

- Use references (`&T`) when you only need to read data
- Use mutable references (`&mut T`) when you need to modify data
- Return owned values only when necessary
- Use `Clone` sparingly and prefer borrowing
- Use `Rc<T>` for single-threaded shared ownership
- Use `Arc<T>` for multi-threaded shared ownership
- Use `Cell<T>` and `RefCell<T>` for interior mutability in single-threaded contexts
- Use `Mutex<T>` and `RwLock<T>` for interior mutability in multi-threaded contexts
- Follow the borrow checker's rules to ensure memory safety

**Example:**

```rust
// Good: using references
fn process_user(user: &User) -> String {
    format!("Processing user: {}", user.name)
}

// Good: accepting generic types
fn validate_input<T: AsRef<str>>(input: T) -> bool {
    !input.as_ref().trim().is_empty()
}

// Good: returning owned values only when necessary
fn get_default_name<'a>(name: Option<&'a str>) -> &'a str {
    name.unwrap_or("Anonymous")
}
```

**Why:** Proper ownership and borrowing ensure memory safety without garbage collection.

---

## Rule 3: Modern Rust Features

Leverage modern Rust features for cleaner, more efficient code.

❌ **Forbidden:**

- Using outdated Rust syntax when modern alternatives are available
- Not taking advantage of newer Rust features (2018+ edition)
- Using verbose code when Rust syntactic sugar is available

✅ **Required:**

- Use async/await for asynchronous operations
- Use pattern matching extensively with `match` and `if let`
- Use iterator chains for data processing: `iter().filter().map().collect()`
- Use `?` operator for error propagation
- Use derive macros for common trait implementations: `#[derive(Debug, Clone)]`
- Use `impl Trait` for return type elision
- Use `async fn` in traits (when stable)
- Use `const fn` for compile-time computation
- Use `Pin<Box<dyn Future>>` for self-referential futures
- Use `tokio` or other async runtimes appropriately
- Use `#![deny(warnings)]` to catch potential issues

**Example:**

```rust
// Async/await
async fn fetch_user(id: u32) -> Result<User, NetworkError> {
    let response = reqwest::get(&format!("/users/{}", id)).await?;
    response.json().await.map_err(|_| NetworkError::Deserialization)
}

// Iterator chains
fn process_active_users(users: Vec<User>) -> Vec<String> {
    users.into_iter()
        .filter(|user| user.is_active())
        .map(|user| user.name.clone())
        .collect()
}

// Error propagation with ?
fn read_config(path: &str) -> Result<Config, ConfigError> {
    let content = std::fs::read_to_string(path)?;
    let config: Config = serde_json::from_str(&content)?;
    Ok(config)
}
```

**Why:** Modern Rust features lead to more readable and maintainable code.

---

## Rule 4: Safety and Security Best Practices

Implement safe coding practices to prevent vulnerabilities and ensure memory safety.

❌ **Forbidden:**

- Using `unsafe` blocks without proper justification
- Using `unwrap()` on `Option` or `Result` from external sources
- Creating buffer overflows (difficult in safe Rust but possible with unsafe)
- Using raw pointers without proper bounds checking

✅ **Required:**

- Use safe Rust unless performance/memory requirements justify unsafe
- Use `expect()` instead of `unwrap()` with descriptive messages
- Validate and sanitize all user inputs before processing
- Use `std::env::var()` with proper error handling for environment variables
- Implement proper authentication and authorization checks
- Use `zeroize` crate to securely wipe sensitive data
- Use `secrecy` or similar crates to prevent accidental logging of secrets
- Validate file paths to prevent directory traversal
- Use `clap` or similar crates for safe command-line argument parsing
- Apply the principle of least privilege for system interactions
- Use `cargo deny` to check for security vulnerabilities in dependencies

**Example:**

```rust
// Safe input validation
fn validate_username(username: &str) -> Result<String, ValidationError> {
    if username.len() < 3 || username.len() > 32 {
        return Err(ValidationError::InvalidLength);
    }
    if !username.chars().all(|c| c.is_alphanumeric() || c == '_') {
        return Err(ValidationError::InvalidCharacters);
    }
    Ok(username.to_string())
}

// Safe error handling
fn get_env_var(key: &str) -> Result<String, EnvError> {
    std::env::var(key).map_err(|_| EnvError::MissingVariable(key.to_string()))
}
```

**Why:** Rust's safety features prevent entire classes of vulnerabilities while maintaining performance.

---

## Rule 5: Performance and Memory Management

Write efficient code considering Rust's zero-cost abstractions and performance characteristics.

❌ **Forbidden:**

- Creating unnecessary allocations in hot paths
- Using `Vec` when `SmallVec` or stack allocation would be more efficient
- Using `Box` when stack allocation is sufficient

✅ **Required:**

- Use `String::with_capacity()` and `Vec::with_capacity()` when size is known
- Use `SmallVec` or `ArrayVec` for small collections that occasionally grow
- Use `Cow<str>` for functions that sometimes need to own and sometimes borrow
- Use `BTreeMap` vs `HashMap` appropriately (BTreeMap for ordered data)
- Use `DashMap` or similar for concurrent access patterns
- Profile code with tools like `perf`, `cargo-flamegraph`, or `samply`
- Use `no_std` for embedded systems when appropriate
- Use `#[inline]` and `#[cold]` attributes when performance profiling indicates benefit
- Use `rayon` for parallel iteration when appropriate
- Use `Arc<str>` for shared string data

**Example:**

```rust
// Pre-allocating for known size
fn process_lines(lines: &[String]) -> Vec<String> {
    let mut results = Vec::with_capacity(lines.len());
    for line in lines {
        results.push(line.trim().to_uppercase());
    }
    results
}

// Using Cow for efficient string handling
use std::borrow::Cow;

fn normalize_text(text: &str) -> Cow<str> {
    if text.contains(char::is_uppercase) {
        Cow::Owned(text.to_lowercase())
    } else {
        Cow::Borrowed(text)
    }
}
```

**Why:** Efficient code provides better performance and uses system resources wisely.

---

## Rule 6: Code Organization and Documentation

Structure code following Rust idioms and provide appropriate documentation.

❌ **Forbidden:**

- Missing documentation for public APIs
- Comments that merely repeat the code
- Large modules that should be broken down
- Poor crate and module organization

✅ **Required:**

- Document all public functions, structs, and enums with Rust documentation
- Use complete documentation with parameter and return descriptions
- Use `//!` for crate-level documentation
- Use `///` for item-level documentation
- Include examples in documentation with `# Examples`
- Group related functionality using modules
- Follow SOLID principles and common design patterns adapted for Rust
- Use proper indentation and formatting (2 spaces, `cargo fmt`)
- Organize files logically with clear separation of concerns
- Use meaningful variable names that describe their purpose
- Use `pub`, `pub(crate)`, `pub(super)` appropriately for visibility

**Example:**

```rust
/// Retrieves a user by their unique identifier.
///
/// # Arguments
///
/// * `id` - The unique identifier of the user to retrieve
///
/// # Returns
///
/// Returns `Some(User)` if the user exists, or `None` if not found.
///
/// # Examples
///
/// ```
/// let user_service = UserService::new();
/// match user_service.get_user(123) {
///     Some(user) => println!("Found user: {}", user.name),
///     None => println!("User not found"),
/// }
/// ```
pub fn get_user(&self, id: u32) -> Option<User> {
    // implementation
}
```

**Why:** Well-organized code with good documentation is easier to understand and maintain.

---

## Rule 7: Error Handling

Handle errors appropriately following Rust's error handling patterns.

❌ **Forbidden:**

- Using `unwrap()` or `expect()` on external input or error-prone operations
- Creating custom error types without proper error chain support
- Ignoring errors returned by functions

✅ **Required:**

- Use `Result<T, E>` for functions that can fail
- Use `Option<T>` for functions that might not return a value
- Use `?` operator for error propagation
- Create custom error types implementing `std::error::Error`
- Use `thiserror` crate for ergonomic error definitions
- Use `anyhow` crate for application-level error handling
- Implement `From` trait for automatic error conversion
- Use `map_err` for transforming errors
- Use `context` from `anyhow` for adding context to errors

**Example:**

```rust
use thiserror::Error;

#[derive(Error, Debug)]
pub enum UserServiceError {
    #[error("User with ID {user_id} not found")]
    UserNotFound { user_id: u32 },
    #[error("Database error: {source}")]
    DatabaseError {
        #[from]
        source: sqlx::Error,
    },
    #[error("Serialization error: {0}")]
    SerializationError(#[from] serde_json::Error),
}

// Error handling with proper propagation
pub async fn get_user(&self, id: u32) -> Result<User, UserServiceError> {
    let user = sqlx::query_as::<_, User>("SELECT * FROM users WHERE id = $1")
        .bind(id)
        .fetch_optional(&self.db_pool)
        .await?;

    user.ok_or(UserServiceError::UserNotFound { user_id: id })
}
```

**Why:** Proper error handling makes debugging easier and prevents crashes.

---

## Rule 8: Testing Best Practices

Write effective tests to ensure code quality.

❌ **Forbidden:**

- Tests with no assertions
- Tests that depend on external services without proper mocking
- Tests that don't cover edge cases
- Tests that modify shared state without proper isolation

✅ **Required:**

- Use `#[cfg(test)]` and `#[test]` attributes for unit tests
- Use `#[tokio::test]` or `#[async_std::test]` for async tests
- Follow Given-When-Then or Arrange-Act-Assert pattern
- Test both success and error conditions
- Use meaningful test function names
- Test boundary conditions and edge cases
- Use `serial_test` crate to run tests serially when needed
- Implement proper test fixtures and setup/teardown
- Use property-based testing with `proptest` or `quickcheck` when appropriate
- Keep tests fast and independent
- Use `cargo test` and `cargo-nextest` for running tests

**Example:**

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[tokio::test]
    async fn test_get_user_with_valid_id_returns_user() {
        // Given
        let service = UserService::new_test_instance();
        let user_id = 123;

        // When
        let result = service.get_user(user_id).await;

        // Then
        assert!(result.is_ok());
        assert_eq!(result.unwrap().id, user_id);
    }

    #[tokio::test]
    async fn test_get_user_with_invalid_id_returns_not_found() {
        // Given
        let service = UserService::new_test_instance();
        let invalid_id = 999999;

        // When
        let result = service.get_user(invalid_id).await;

        // Then
        assert!(matches!(result, Err(UserServiceError::UserNotFound { .. })));
    }
}
```

**Why:** Comprehensive tests ensure code correctness and maintainability.

---

## Review Procedure

For each Rust file:

1. **Read complete file**
2. **Search for violations**
3. **Report findings** with file:line references

---

## Report Format

### If violations found

```text
❌ FAIL

Violations:
1. [SAFETY PRACTICES] - src/user_service.rs:42
   Issue: Used unwrap() on external input without error handling
   Fix: Use ? operator or match statement for proper error handling

2. [OWNERSHIP] - src/network_handler.rs:15
   Issue: Unnecessary clone operation in performance-critical code
   Fix: Use borrowing instead of cloning when possible
```

### If no violations

```text
✅ PASS

File meets all semantic requirements.
```