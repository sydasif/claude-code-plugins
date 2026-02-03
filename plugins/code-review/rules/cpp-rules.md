# C++ Code Review Rules

These are C++-specific code review rules. Follow these guidelines to maintain high-quality C++ code.

---

## Rule 1: Naming Conventions

Follow C++ naming conventions as defined in modern C++ best practices.

❌ **Forbidden:**

- Using inconsistent naming schemes across the codebase
- Using Hungarian notation
- Using ALL_CAPS for non-constant variables
- Using names that conflict with standard library names

✅ **Required:**

- `snake_case` for variables and function names: `user_count`, `get_value`
- `PascalCase` for class names, struct names, and type aliases: `UserManager`, `HttpRequest`
- `SCREAMING_SNAKE_CASE` for constants and macros: `MAX_BUFFER_SIZE`, `DEFAULT_PORT`
- `m_` prefix for member variables (optional but consistent): `m_userId`, `m_name`
- Descriptive names that clearly indicate the purpose
- Consistent naming across the entire codebase

**Example:**

```cpp
class UserManager {
private:
    std::vector<User> m_users;
    static constexpr int MAX_RETRIES = 3;

public:
    bool add_user(const User& user);
    User get_user(int id) const;
};
```

**Why:** Consistent naming improves readability and maintainability across C++ projects.

---

## Rule 2: Memory Management

Handle memory allocation and deallocation following RAII and smart pointer best practices.

❌ **Forbidden:**

- Using raw pointers for ownership
- Manual `new`/`delete` without RAII
- Memory leaks from unpaired allocations
- Dangling pointers from deleted objects
- Using `malloc`/`free` instead of `new`/`delete` in C++

✅ **Required:**

- Use smart pointers (`std::unique_ptr`, `std::shared_ptr`) for automatic memory management
- Follow RAII (Resource Acquisition Is Initialization) principle
- Use `std::make_unique` and `std::make_shared` for creating smart pointers
- Use stack allocation when possible instead of heap allocation
- Implement proper copy/move constructors and assignment operators
- Use containers instead of raw arrays when possible
- Use `std::string` instead of C-style strings

**Example:**

```cpp
// Good
auto ptr = std::make_unique<Resource>(args);
std::vector<int> numbers = {1, 2, 3, 4, 5};

// Avoid
Resource* ptr = new Resource(args);
int* arr = new int[size];
```

**Why:** Proper memory management prevents memory leaks, dangling pointers, and undefined behavior.

---

## Rule 3: Modern C++ Features

Leverage modern C++ features for cleaner, safer code.

❌ **Forbidden:**

- Using C-style arrays and functions
- Not using `const` when appropriate
- Using pre-C++11 features when modern alternatives are better

✅ **Required:**

- Use `auto` for type deduction when it improves readability
- Use `constexpr` for compile-time constants
- Use range-based for loops: `for (const auto& item : container)`
- Use `nullptr` instead of `NULL` or `0`
- Use `override` and `final` keywords for virtual functions
- Use move semantics (`std::move`) when appropriate
- Use `noexcept` for functions that shouldn't throw
- Use `[[nodiscard]]` for functions whose return values shouldn't be ignored
- Use structured bindings: `auto [key, value] = *it;`

**Example:**

```cpp
class Resource {
public:
    Resource(Resource&& other) noexcept;  // Move constructor
    Resource& operator=(Resource&& other) noexcept;  // Move assignment

    void process() const noexcept;  // Noexcept if guaranteed not to throw
};

[[nodiscard]] bool initialize();  // Return value should be used
```

**Why:** Modern C++ features lead to safer, more efficient, and more readable code.

---

## Rule 4: Security Best Practices

Implement secure coding practices to prevent vulnerabilities.

❌ **Forbidden:**

- Buffer overflows from unchecked array access
- Using unsafe C library functions (`strcpy`, `sprintf`, etc.)
- Integer overflows without checks
- Improper input validation
- Using uninitialized variables

✅ **Required:**

- Use bounds-checked containers and access methods
- Use safe string functions: `strncpy`, `snprintf`, or better yet, C++ streams
- Validate all input parameters and external data
- Use `std::array` or `std::vector` instead of C-style arrays
- Initialize all variables before use
- Use `static_assert` for compile-time checks
- Perform integer overflow checks when necessary
- Use secure random number generators from `<random>`
- Implement proper access controls and input sanitization

**Example:**

```cpp
// Safe
std::array<char, BUFFER_SIZE> buffer{};
strncpy(buffer.data(), input, buffer.size() - 1);
buffer.back() = '\0';

// Or better
std::string safe_buffer(input, std::min(strlen(input), BUFFER_SIZE - 1));
```

**Why:** Prevents security vulnerabilities like buffer overflows, integer overflows, and injection attacks.

---

## Rule 5: Performance and Efficiency

Write efficient code considering C++'s performance characteristics.

❌ **Forbidden:**

- Unnecessary object copies in loops
- Premature pessimization without profiling
- Using expensive operations in performance-critical code

✅ **Required:**

- Use const references for parameters that shouldn't be modified: `const std::string&`
- Use move semantics for expensive objects when transferring ownership
- Reserve capacity for containers when size is known: `vec.reserve(size)`
- Use emplacement functions: `emplace_back` instead of `push_back` when possible
- Profile code to identify actual bottlenecks
- Use appropriate data structures for the task (e.g., `std::unordered_map` for lookups)
- Minimize dynamic allocations in performance-critical paths
- Use `final` keyword for classes that shouldn't be inherited from

**Example:**

```cpp
// Efficient
std::vector<std::string> items;
items.reserve(expected_size);  // Pre-allocate to avoid reallocations

for (const auto& item : source_items) {
    items.emplace_back(std::move(item));  // Move instead of copy
}
```

**Why:** Efficient code provides better performance and uses system resources wisely.

---

## Rule 6: Error Handling

Handle errors appropriately using modern C++ patterns.

❌ **Forbidden:**

- Ignoring return values that indicate errors
- Using error codes inconsistently
- Throwing exceptions from destructors
- Using exceptions for expected control flow

✅ **Required:**

- Use exceptions for error conditions, not normal control flow
- Derive custom exceptions from standard exception hierarchy
- Use `std::optional<T>` for functions that might not return a value
- Use `std::expected<T, Error>` (C++23) or similar for error-prone operations
- Handle errors at appropriate levels of abstraction
- Implement proper exception safety guarantees (basic, strong, no-throw)
- Use RAII to ensure cleanup even when exceptions occur

**Example:**

```cpp
std::optional<User> find_user(int id) {
    if (id <= 0) {
        return std::nullopt;
    }
    // lookup logic
    if (found) {
        return user;
    }
    return std::nullopt;
}
```

**Why:** Proper error handling makes debugging easier and prevents undefined behavior.

---

## Rule 7: Concurrency and Thread Safety

Write safe concurrent code using C++ threading features.

❌ **Forbidden:**

- Sharing mutable state between threads without synchronization
- Race conditions from unsynchronized access
- Deadlocks from improper lock ordering

✅ **Required:**

- Use `std::mutex` and other synchronization primitives appropriately
- Use RAII lock guards: `std::lock_guard`, `std::unique_lock`
- Use `std::atomic` for atomic operations
- Consider using `std::async` or thread pools for task-based parallelism
- Use `std::condition_variable` for thread coordination
- Follow lock ordering protocols to prevent deadlocks
- Use `thread_local` for thread-specific data when appropriate
- Prefer immutable data sharing between threads

**Example:**

```cpp
class ThreadSafeCounter {
private:
    mutable std::mutex m_mutex;
    int m_count = 0;

public:
    void increment() {
        std::lock_guard<std::mutex> lock(m_mutex);
        ++m_count;
    }

    int get_count() const {
        std::lock_guard<std::mutex> lock(m_mutex);
        return m_count;
    }
};
```

**Why:** Proper concurrency handling prevents race conditions and data corruption.

---

## Rule 8: Testing Best Practices

Write effective tests to ensure code quality.

❌ **Forbidden:**

- Tests with no assertions
- Tests that depend on external factors without proper mocking
- Tests that don't cover edge cases
- Tests that modify shared state without proper isolation

✅ **Required:**

- Use appropriate test frameworks (Google Test, Catch2, etc.)
- Follow AAA pattern: Arrange, Act, Assert
- Test both success and error conditions
- Use meaningful test names that describe the scenario
- Test boundary conditions and edge cases
- Mock external dependencies appropriately
- Use parameterized tests for multiple input scenarios
- Test error handling paths
- Keep tests independent and deterministic

**Example:**

```cpp
TEST(UserManagerTest, GetUser_ValidId_ReturnsUser) {
    // Arrange
    UserManager manager;
    int test_id = 123;

    // Act
    auto result = manager.get_user(test_id);

    // Assert
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->id, test_id);
}
```

**Why:** Comprehensive tests ensure code correctness and maintainability.

---

## Review Procedure

For each C++ file:

1. **Read complete file**
2. **Search for violations**
3. **Report findings** with file:line references

---

## Report Format

### If violations found

```text
❌ FAIL

Violations:
1. [MEMORY MANAGEMENT] - src/UserManager.cpp:42
   Issue: Used raw pointer for object ownership
   Fix: Replace with std::unique_ptr or std::shared_ptr

2. [SECURITY PRACTICES] - src/Buffer.cpp:15
   Issue: Used unsafe strcpy function
   Fix: Replace with strncpy or std::string
```

### If no violations

```text
✅ PASS

File meets all semantic requirements.
```
