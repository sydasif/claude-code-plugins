# Swift Code Review Rules

These are Swift-specific code review rules. Follow these guidelines to maintain high-quality Swift code.

---

## Rule 1: Naming Conventions

Follow Swift naming conventions as defined in Swift API Design Guidelines.

❌ **Forbidden:**

- Using camelCase for class names (use PascalCase)
- Using PascalCase for method and variable names (use camelCase)
- Using prefixes or abbreviations unnecessarily
- Using ALL_CAPS for non-constant variables

✅ **Required:**

- `PascalCase` for class, enum, struct, protocol, and type names: `UserManager`, `NetworkError`, `ViewController`
- `camelCase` for method names, variable names, and properties: `getUser`, `userName`, `maximumRetryCount`
- `UpperCamelCase` for enum cases: `case success`, `case error`, `case networkError`
- `UPPER_SNAKE_CASE` for global constants: `MAX_RETRY_COUNT`, `DEFAULT_TIMEOUT`
- Descriptive names that clearly indicate the purpose
- Use Swift's natural language naming patterns: `remove(at:)` instead of `removeAtIndex`
- Use `is`, `has`, `can`, `should` prefixes for Boolean properties and methods: `isEnabled`, `hasChildren`

**Example:**

```swift
class UserManager {
    private let maxRetryCount = 3

    func getUser(withId id: Int) -> User? {
        // implementation
    }

    var isEnabled: Bool = true
}

enum NetworkError: Error {
    case invalidURL
    case connectionFailed
    case timeout
}
```

**Why:** Consistent naming improves readability and maintainability across Swift projects.

---

## Rule 2: Error Handling

Handle errors appropriately following Swift error handling best practices.

❌ **Forbidden:**

- Force unwrapping optionals with `!` unnecessarily
- Using `try!` in production code
- Ignoring errors with `_ = try function()`
- Using exceptions for normal control flow

✅ **Required:**

- Use `do-catch` blocks for error handling
- Use optional binding (`if let`, `guard let`) for safe unwrapping
- Use `try?` for operations that might fail and return optional
- Create custom error types conforming to `Error` protocol
- Use `throws` and `rethrows` appropriately in functions
- Handle errors at appropriate levels of abstraction
- Use `defer` for cleanup code that should execute regardless of error

**Example:**

```swift
func fetchUser(from url: URL) throws -> User {
    do {
        let data = try Data(contentsOf: url)
        let user = try JSONDecoder().decode(User.self, from: data)
        return user
    } catch let error as DecodingError {
        throw NetworkError.decodingFailed(error)
    } catch {
        throw NetworkError.unknown(error)
    }
}

// Safe optional handling
guard let user = user else {
    print("User not found")
    return
}
```

**Why:** Proper error handling makes debugging easier and prevents crashes.

---

## Rule 3: Modern Swift Features

Leverage modern Swift features for cleaner, more efficient code.

❌ **Forbidden:**

- Using outdated Swift syntax when modern alternatives are available
- Not taking advantage of newer Swift features (5.0+)
- Using verbose code when Swift syntactic sugar is available

✅ **Required:**

- Use property wrappers: `@Published`, `@State`, `@Environment`
- Use key-path expressions: `users.sorted(\.name)`
- Use function builders (like `ViewBuilder`) for DSLs
- Use opaque return types (`some View`, `some Sequence`)
- Use result builders for declarative syntax
- Use `async/await` for asynchronous operations (iOS 15+)
- Use actor isolation for thread safety (iOS 15+)
- Use existential any for protocol types (Swift 5.7+)
- Use macro systems when appropriate (Swift 5.9+)
- Use package plugins for build-time code generation

**Example:**

```swift
// Modern async/await
func fetchUserData() async throws -> User {
    let (data, _) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode(User.self, from: data)
}

// Property wrappers
@State private var userName: String = ""
@Published var users: [User] = []

// Key-path expressions
let sortedUsers = users.sorted(using: KeyPathComparator(\.name))
```

**Why:** Modern Swift features lead to more readable and maintainable code.

---

## Rule 4: Security Best Practices

Implement secure coding practices to prevent vulnerabilities.

❌ **Forbidden:**

- Hardcoding sensitive information like passwords or API keys
- Storing sensitive data in plain text
- Using HTTP instead of HTTPS for network requests
- Building SQL queries with string concatenation (SQL injection risk)
- Using `eval()` or similar dynamic execution with user data

✅ **Required:**

- Store sensitive data in Keychain using Security framework
- Use HTTPS for all network communications
- Validate and sanitize all user inputs
- Use certificate pinning for sensitive APIs
- Implement proper authentication and authorization
- Use secure random generators: `SecRandomCopyBytes`
- Encrypt sensitive data at rest using proper encryption
- Use secure coding practices for biometric authentication
- Validate SSL certificates properly
- Implement proper session management
- Use secure defaults for configuration settings

**Example:**

```swift
// Secure data storage
func storeApiKey(_ apiKey: String) {
    let data = apiKey.data(using: .utf8)!
    var query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: "API_KEY",
        kSecValueData as String: data
    ]

    SecItemAdd(query as CFDictionary, nil)
}

// Secure network request
URLSession.shared.dataTask(with: secureURL) { data, response, error in
    // Handle response securely
}
```

**Why:** Prevents security vulnerabilities and protects sensitive data.

---

## Rule 5: Performance and Memory Management

Write efficient code considering Swift's ARC and performance characteristics.

❌ **Forbidden:**

- Creating retain cycles with strong reference cycles
- Using `weak` unnecessarily when `strong` is appropriate
- Creating unnecessary copies of large value types
- Using force casts (`as!`) instead of safe casting

✅ **Required:**

- Use `weak` and `unowned` references to break retain cycles
- Implement `deinit` for debugging memory leaks
- Use structs for lightweight, value-type data
- Use classes for reference types and identity-based objects
- Use `lazy` properties for expensive initializations
- Use `@inline(__always)` for performance-critical functions when appropriate
- Profile code with Instruments to identify bottlenecks
- Use `autoreleasepool` for memory-intensive operations
- Use value types appropriately to avoid reference counting overhead
- Use `ContiguousArray` for better performance when reference semantics aren't needed

**Example:**

```swift
class NetworkManager {
    private weak var delegate: NetworkDelegate?

    lazy var jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()

    deinit {
        print("NetworkManager deallocated")
    }
}
```

**Why:** Efficient code provides better performance and uses system resources wisely.

---

## Rule 6: Code Organization and Documentation

Structure code following Swift idioms and provide appropriate documentation.

❌ **Forbidden:**

- Missing documentation for public APIs
- Comments that merely repeat the code
- Large classes that should be broken down
- Poor protocol and extension organization

✅ **Required:**

- Document all public classes, methods, and properties with Swift documentation
- Use complete documentation with parameter and return descriptions
- Group related functionality using extensions
- Use protocols for abstraction and dependency injection
- Follow SOLID principles and common design patterns
- Use proper indentation and formatting (4 spaces)
- Organize files logically with clear separation of concerns
- Use meaningful variable names that describe their purpose
- Use access control appropriately (`private`, `internal`, `public`, `open`)

**Example:**

```swift
/**
 Retrieves a user by their unique identifier.

 - Parameter id: The unique identifier of the user to retrieve
 - Returns: The user with the specified ID, or nil if not found
 - Throws: NetworkError if there's an error communicating with the server
 */
func getUser(withId id: Int) async throws -> User? {
    // implementation
}
```

**Why:** Well-organized code with good documentation is easier to understand and maintain.

---

## Rule 7: Concurrency and Threading

Write safe concurrent code using Swift's concurrency features.

❌ **Forbidden:**

- Accessing UI elements from background threads
- Creating race conditions with shared mutable state
- Using DispatchQueue.main.async unnecessarily

✅ **Required:**

- Use `async/await` for asynchronous operations (iOS 15+)
- Use `Task` and `TaskGroup` for structured concurrency
- Use `@MainActor` for UI updates
- Use `Sendable` protocol for thread-safe types
- Use `actor` for thread-safe shared mutable state
- Use proper queue management for background operations
- Use `DispatchQueue.global(qos:).async` for background work
- Use `OperationQueue` for complex dependency chains

**Example:**

```swift
// Modern concurrency
func fetchMultipleUsers(ids: [Int]) async throws -> [User] {
    return try await withThrowingTaskGroup(of: User.self) { group in
        for id in ids {
            group.addTask {
                try await self.fetchUser(withId: id)
            }
        }

        var users: [User] = []
        for try await user in group {
            users.append(user)
        }
        return users
    }
}

// Main actor for UI updates
@MainActor
func updateUserUI(_ user: User) {
    nameLabel.text = user.name
    emailLabel.text = user.email
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

- Use XCTest or other appropriate testing frameworks
- Follow Given-When-Then or Arrange-Act-Assert pattern
- Test both success and error conditions
- Use meaningful test method names
- Test boundary conditions and edge cases
- Mock external dependencies appropriately
- Use XCTUnwrap for optional values in tests
- Implement proper test fixtures and setup/teardown
- Use test doubles (mocks, stubs) appropriately
- Keep tests fast and independent

**Example:**

```swift
class UserServiceTests: XCTestCase {
    var userService: UserService!
    var mockNetworkClient: MockNetworkClient!

    override func setUp() {
        super.setUp()
        mockNetworkClient = MockNetworkClient()
        userService = UserService(networkClient: mockNetworkClient)
    }

    func testGetUser_WithValidId_ReturnsUser() async throws {
        // Given
        let userId = 123
        let expectedUser = User(id: userId, name: "John Doe")
        mockNetworkClient.stubbedUser = expectedUser

        // When
        let result = try await userService.getUser(withId: userId)

        // Then
        XCTAssertEqual(result?.id, userId)
        XCTAssertEqual(result?.name, "John Doe")
    }
}
```

**Why:** Comprehensive tests ensure code correctness and maintainability.

---

## Review Procedure

For each Swift file:

1. **Read complete file**
2. **Search for violations**
3. **Report findings** with file:line references

---

## Report Format

### If violations found

```text
❌ FAIL

Violations:
1. [ERROR HANDLING] - Sources/UserService.swift:42
   Issue: Used force unwrap operator unnecessarily
   Fix: Use optional binding or try? for safe unwrapping

2. [SECURITY PRACTICES] - Sources/NetworkManager.swift:15
   Issue: Used HTTP instead of HTTPS for sensitive API
   Fix: Change to HTTPS for secure communication
```

### If no violations

```text
✅ PASS

File meets all semantic requirements.
```
