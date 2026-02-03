# Kotlin Code Review Rules

These are Kotlin-specific code review rules. Follow these guidelines to maintain high-quality Kotlin code.

---

## Rule 1: Naming Conventions

Follow Kotlin naming conventions as defined in Kotlin Coding Conventions.

❌ **Forbidden:**

- Using PascalCase for function and variable names (use camelCase)
- Using camelCase for class and interface names (use PascalCase)
- Using ALL_CAPS for non-constant variables
- Using underscores in class and function names

✅ **Required:**

- `PascalCase` for class, interface, object, and annotation names: `UserManager`, `HttpRequest`
- `camelCase` for function names, variable names, and properties: `getUser`, `userName`
- `UPPER_SNAKE_CASE` for constants: `MAX_RETRY_COUNT`, `DEFAULT_TIMEOUT`
- `backticks` for names that match Kotlin keywords: `val`class`= "value"`
- Descriptive names that clearly indicate the purpose
- Use `is` prefix for Boolean properties: `isEnabled`, `hasChildren`

**Example:**

```kotlin
class UserManager {
    private val maxRetryCount = 3

    fun getUser(id: Int): User? {
        // implementation
    }

    var isEnabled: Boolean = true
}

const val MAX_RETRY_COUNT = 3

enum class NetworkError {
    INVALID_URL,
    CONNECTION_FAILED,
    TIMEOUT
}
```

**Why:** Consistent naming improves readability and maintainability across Kotlin projects.

---

## Rule 2: Error Handling

Handle errors appropriately following Kotlin best practices.

❌ **Forbidden:**

- Using `!!` (non-null assertion operator) unnecessarily
- Using `try-catch` for control flow when exceptions aren't appropriate
- Ignoring nullable return values without proper handling

✅ **Required:**

- Use `try-catch` blocks for error handling
- Use safe calls (`?.`) for nullable properties and methods
- Use `let` for safe operations on nullable values: `value?.let { process(it) }`
- Use `runCatching` and `getOrElse` for functional error handling
- Create custom exception types extending `Exception`
- Use `when` expressions for comprehensive error handling
- Use `also` for error logging with safe calls
- Use `require()` and `check()` for input validation

**Example:**

```kotlin
fun fetchUser(id: Int): User? {
    return try {
        val response = httpClient.get("/users/$id")
        response.fromJson<User>()
    } catch (e: HttpException) {
        Log.e("UserManager", "Error fetching user", e)
        null
    }
}

// Safe nullable handling
user?.let { validUser ->
    processUser(validUser)
}

// Functional error handling
val result = runCatching { riskyOperation() }
    .getOrElse { exception ->
        Log.e("Tag", "Operation failed", exception)
        defaultValue
    }
```

**Why:** Proper error handling makes debugging easier and prevents crashes.

---

## Rule 3: Modern Kotlin Features

Leverage modern Kotlin features for cleaner, more efficient code.

❌ **Forbidden:**

- Using Java-style patterns when Kotlin idioms are available
- Not taking advantage of newer Kotlin features (1.5+)
- Using verbose code when Kotlin syntactic sugar is available

✅ **Required:**

- Use data classes for simple data holders
- Use sealed classes for restricted class hierarchies
- Use `when` expressions instead of `if-else` chains
- Use extension functions for adding functionality to existing classes
- Use `apply`, `also`, `let`, `run`, `with` for fluent programming
- Use destructuring declarations for unpacking data
- Use infix functions for readable DSLs
- Use inline functions for performance when appropriate
- Use coroutines for asynchronous programming
- Use delegated properties (`by lazy`, `by observable`)
- Use value classes (inline classes) for type safety without overhead

**Example:**

```kotlin
// Data class
data class User(val id: Int, val name: String, val email: String)

// Sealed class hierarchy
sealed class NetworkResult<T> {
    data class Success<T>(val data: T) : NetworkResult<T>()
    data class Error<T>(val message: String) : NetworkResult<T>()
    class Loading<T> : NetworkResult<T>()
}

// Extension function
fun String.isValidEmail(): Boolean = this.matches(Regex(".+@.+\\..+"))

// Coroutines
suspend fun fetchUserData(): User? = withContext(Dispatchers.IO) {
    apiService.fetchUser()
}
```

**Why:** Modern Kotlin features lead to more readable and maintainable code.

---

## Rule 4: Security Best Practices

Implement secure coding practices to prevent vulnerabilities.

❌ **Forbidden:**

- Hardcoding sensitive information like passwords or API keys
- Storing sensitive data in SharedPreferences without encryption
- Using HTTP instead of HTTPS for network requests
- Building SQL queries with string concatenation (SQL injection risk)
- Using `eval()` or similar dynamic execution with user data

✅ **Required:**

- Store sensitive data using EncryptedSharedPreferences or Tink
- Use HTTPS for all network communications
- Validate and sanitize all user inputs
- Implement proper authentication and authorization
- Use certificate pinning for sensitive APIs
- Use Android Keystore System for storing cryptographic keys
- Encrypt sensitive data at rest using proper encryption
- Implement proper session management
- Use secure defaults for configuration settings
- Validate SSL certificates properly
- Use Content Provider for secure data sharing between apps
- Implement proper permission handling

**Example:**

```kotlin
// Secure data storage
val encryptedPrefs = EncryptedSharedPreferences.create(
    context,
    "secret_shared_prefs",
    masterKey,
    EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
    EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
)

// Secure network request
val okHttpClient = OkHttpClient.Builder()
    .certificatePinner(certificatePinner)
    .build()
```

**Why:** Prevents security vulnerabilities and protects sensitive data.

---

## Rule 5: Performance and Memory Management

Write efficient code considering Kotlin and JVM performance characteristics.

❌ **Forbidden:**

- Creating unnecessary object allocations in loops
- Using `forEach` when traditional loops might be more efficient
- Not using `const` for compile-time constants
- Creating lambda instances inside loops

✅ **Required:**

- Use `const val` for compile-time constants
- Use `Sequence` for large collections to enable lazy evaluation
- Use `inline` functions to avoid lambda allocation overhead
- Use `lateinit` for properties that can't be initialized in constructor
- Use `@JvmField` to avoid getter/setter overhead for public properties
- Use `takeIf` and `takeUnless` for conditional returns
- Profile code with tools like Android Profiler or JProfiler
- Use `fastForEach` and other optimized iteration methods when appropriate
- Use `distinct()` and other collection operations efficiently
- Consider using `MutableList` vs `List` appropriately

**Example:**

```kotlin
// Compile-time constant
const val MAX_RETRY_COUNT = 3

// Efficient collection processing
val processed = largeList.asSequence()
    .filter { it.isValid }
    .map { it.processedValue }
    .toList()

// Inline function to avoid allocation
inline fun <T> executeIf(condition: Boolean, block: () -> T): T? {
    return if (condition) block() else null
}
```

**Why:** Efficient code provides better performance and uses system resources wisely.

---

## Rule 6: Code Organization and Documentation

Structure code following Kotlin idioms and provide appropriate documentation.

❌ **Forbidden:**

- Missing documentation for public APIs
- Comments that merely repeat the code
- Large classes that should be broken down
- Poor file and package organization

✅ **Required:**

- Document all public classes, functions, and properties with KDoc
- Use complete documentation with parameter and return descriptions
- Group related functionality using companion objects and extensions
- Use sealed classes for exhaustive `when` expressions
- Follow SOLID principles and common design patterns
- Use proper indentation and formatting (4 spaces)
- Organize files logically with clear separation of concerns
- Use meaningful variable names that describe their purpose
- Use visibility modifiers appropriately (`private`, `internal`, `public`)
- Use type aliases for complex generic types when appropriate

**Example:**

```kotlin
/**
 * Retrieves a user by their unique identifier.
 *
 * @param id The unique identifier of the user to retrieve
 * @return The user with the specified ID, or null if not found
 * @throws NetworkException if there's an error communicating with the server
 */
suspend fun getUser(id: Int): User? {
    // implementation
}
```

**Why:** Well-organized code with good documentation is easier to understand and maintain.

---

## Rule 7: Coroutines and Concurrency

Write safe concurrent code using Kotlin's coroutine features.

❌ **Forbidden:**

- Accessing UI elements from background threads without proper context switching
- Creating race conditions with shared mutable state
- Using `runBlocking` in production code unnecessarily
- Cancelling coroutines without proper cleanup

✅ **Required:**

- Use `viewModelScope` or `lifecycleScope` for Android lifecycle-aware coroutines
- Use `Dispatchers.Main`, `Dispatchers.IO`, `Dispatchers.Default` appropriately
- Use `async`/`await` for concurrent operations
- Use `Mutex` for thread-safe access to shared mutable state
- Use `SupervisorJob` for independent child jobs
- Handle coroutine cancellation properly
- Use `withTimeout` for operations that should not hang
- Use `Flow` for reactive programming patterns
- Use `StateFlow` and `SharedFlow` for state management

**Example:**

```kotlin
// Coroutine scope usage
class UserRepository {
    suspend fun fetchUser(id: Int): User = withContext(Dispatchers.IO) {
        apiService.fetchUser(id)
    }
}

// Flow usage
fun observeUserChanges(userId: Int): Flow<User> = flow {
    while (true) {
        delay(REFRESH_INTERVAL)
        emit(fetchUser(userId))
    }
}.flowOn(Dispatchers.IO)

// ViewModel scope
class UserViewModel : ViewModel() {
    fun loadUser(userId: Int) {
        viewModelScope.launch {
            val user = userRepository.fetchUser(userId)
            _user.value = user
        }
    }
}
```

**Why:** Proper concurrency handling prevents race conditions and UI updates on wrong threads.

---

## Rule 8: Testing Best Practices

Write effective tests to ensure code quality.

❌ **Forbidden:**

- Tests with no assertions
- Tests that depend on external services without proper mocking
- Tests that don't cover edge cases
- Tests that modify shared state without proper isolation

✅ **Required:**

- Use appropriate test frameworks (JUnit, Spek, Kotest)
- Follow Given-When-Then or Arrange-Act-Assert pattern
- Test both success and error conditions
- Use meaningful test method names
- Test boundary conditions and edge cases
- Mock external dependencies appropriately
- Use test coroutines for asynchronous testing
- Implement proper test fixtures and setup/teardown
- Use test doubles (mocks, stubs) appropriately
- Keep tests fast and independent

**Example:**

```kotlin
class UserServiceTest {
    @Test
    fun `given valid user id when fetch user then returns user`() = runTest {
        // Given
        val userId = 123
        val expectedUser = User(userId, "John Doe")
        coEvery { userRepository.findById(userId) } returns expectedUser

        // When
        val result = userService.fetchUser(userId)

        // Then
        assertEquals(expectedUser, result)
    }

    @Test
    fun `given invalid user id when fetch user then throws exception`() = runTest {
        // Given
        val userId = -1
        coEvery { userRepository.findById(userId) } throws UserNotFoundException()

        // When & Then
        assertThrows<UserNotFoundException> {
            userService.fetchUser(userId)
        }
    }
}
```

**Why:** Comprehensive tests ensure code correctness and maintainability.

---

## Review Procedure

For each Kotlin file:

1. **Read complete file**
2. **Search for violations**
3. **Report findings** with file:line references

---

## Report Format

### If violations found

```text
❌ FAIL

Violations:
1. [ERROR HANDLING] - src/main/java/com/example/UserService.kt:42
   Issue: Used non-null assertion operator unnecessarily
   Fix: Use safe call operator or let function for nullable handling

2. [SECURITY PRACTICES] - src/main/java/com/example/NetworkManager.kt:15
   Issue: Used HTTP instead of HTTPS for sensitive API
   Fix: Change to HTTPS for secure communication
```

### If no violations

```text
✅ PASS

File meets all semantic requirements.
```
