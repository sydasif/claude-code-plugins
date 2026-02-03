# Dart Code Review Rules

These are Dart-specific code review rules. Follow these guidelines to maintain high-quality Dart code.

---

## Rule 1: Naming Conventions

Follow Dart naming conventions as defined in Effective Dart.

❌ **Forbidden:**

- Using camelCase for class and enum names (use UpperCamelCase)
- Using UpperCamelCase for function and variable names (use lowerCamelCase)
- Using underscores in library names (use hyphens)
- Using ALL_CAPS for non-constant variables

✅ **Required:**

- `UpperCamelCase` for classes, typedefs, extensions, mixins, and enum names: `UserManager`, `HttpRequest`, `MyMixin`
- `lowerCamelCase` for functions, methods, variables, and parameters: `getUser`, `userName`, `maxRetryCount`
- `lowercase_with_underscores` for library and file names: `http_client.dart`, `utils.dart`
- `upper_snake_case` for static constants and variables: `MAX_RETRY_COUNT`, `DEFAULT_TIMEOUT`
- Descriptive names that clearly indicate the purpose
- Use `is`, `has`, `can`, `should` prefixes for Boolean properties: `isEnabled`, `hasChildren`
- Use `to` prefix for conversion methods that consume self: `toString`, `toInt`
- Use `as` prefix for methods that return borrowed data: `asList`, `asMap`

**Example:**

```dart
class UserManager {
  static const maxRetryCount = 3;

  User? getUser(int id) {
    // implementation
  }

  bool get isEnabled => true;
}

enum NetworkError {
  invalidUrl,
  connectionFailed,
  timeout,
}
```

**Why:** Consistent naming improves readability and maintainability across Dart projects.

---

## Rule 2: Error Handling

Handle errors appropriately following Dart best practices.

❌ **Forbidden:**

- Using `try-catch` for control flow when exceptions aren't appropriate
- Ignoring errors with `catch (_, __) {}`
- Using `rethrow` outside of catch blocks
- Throwing errors from getters

✅ **Required:**

- Use `try-catch-finally` blocks for error handling
- Use `Future.catchError()` for asynchronous error handling
- Use `Stream.handleError()` for stream error handling
- Create custom exception types extending `Exception`
- Use `Error.throwWithStackTrace()` when preserving stack trace is important
- Use `rethrow` to preserve original stack trace in catch blocks
- Handle errors at appropriate levels of abstraction
- Use `Future.wait()` with `eagerError` for multiple future error handling

**Example:**

```dart
Future<User?> fetchUser(int id) async {
  try {
    final response = await httpClient.get('/users/$id');
    return User.fromJson(response.body);
  } on SocketException {
    log('Network error occurred while fetching user $id');
    rethrow;
  } on FormatException catch (e, stackTrace) {
    log('Invalid response format for user $id: $e');
    Error.throwWithStackTrace(
      NetworkError('Invalid response format'),
      stackTrace
    );
  }
}

// Stream error handling
Stream<int> processDataStream(Stream<String> input) {
  return input
    .map((str) => int.tryParse(str))
    .where((num) => num != null)
    .cast<int>()
    .handleError((error) => log('Error processing data: $error'));
}
```

**Why:** Proper error handling makes debugging easier and prevents crashes.

---

## Rule 3: Modern Dart Features

Leverage modern Dart features for cleaner, more efficient code.

❌ **Forbidden:**

- Using outdated Dart syntax when modern alternatives are available
- Not taking advantage of newer Dart features (2.12+ null safety, 2.17+ records, etc.)
- Using verbose code when Dart syntactic sugar is available

✅ **Required:**

- Use null safety features: `String?`, `late`, `required` keyword
- Use records (Dart 3.0+) for simple data grouping: `(int, String)`, `(name: String, age: int)`
- Use patterns (Dart 3.0+) for destructuring and matching: `if (value case (int x, int y))`
- Use collection-if and collection-for: `[..., if (condition) element]`
- Use cascade notation: `..method1()..method2()`
- Use spread operator: `list = [...otherList, newItem]`
- Use arrow syntax for single-expression functions: `int get length => items.length;`
- Use factory constructors for creating instances
- Use mixins for sharing code across class hierarchies
- Use extension methods for adding functionality to existing types
- Use sealed classes with enhanced enums (Dart 2.17+)

**Example:**

```dart
// Records and patterns
(String, int) getNameAndAge(User user) => (user.name, user.age);

void processUser(User user) {
  final (name, age) = getNameAndAge(user);
  print('$name is $age years old');

  // Pattern matching
  if (user case User(:name, :email when email.contains('@'))) {
    sendWelcomeEmail(name, email);
  }
}

// Collection literals with control flow
List<int> getEvenNumbers(List<int> numbers) {
  return [
    for (final number in numbers)
      if (number.isEven) number,
  ];
}

// Extension methods
extension EmailValidation on String {
  bool get isValidEmail => RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(this);
}
```

**Why:** Modern Dart features lead to more readable and maintainable code.

---

## Rule 4: Security Best Practices

Implement secure coding practices to prevent vulnerabilities.

❌ **Forbidden:**

- Hardcoding sensitive information like passwords or API keys
- Storing sensitive data in plain text using SharedPreferences or similar
- Using HTTP instead of HTTPS for network requests
- Building SQL queries with string concatenation (SQL injection risk)
- Using `eval()` or similar dynamic execution with user data

✅ **Required:**

- Store sensitive data using flutter_secure_storage or similar secure storage
- Use HTTPS for all network communications
- Validate and sanitize all user inputs using validation libraries
- Implement proper authentication and authorization (OAuth2, JWT)
- Use certificate pinning for sensitive APIs
- Encrypt sensitive data at rest using proper encryption
- Implement proper session management
- Use secure defaults for configuration settings
- Validate SSL certificates properly
- Use secure random generators: `Random.secure()`
- Implement proper input sanitization and output encoding
- Use Content Security Policy (CSP) headers when appropriate

**Example:**

```dart
// Secure data storage
class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static Future<void> storeApiKey(String apiKey) async {
    await _storage.write(key: 'api_key', value: apiKey);
  }

  static Future<String?> getApiKey() async {
    return await _storage.read(key: 'api_key');
  }
}

// Secure network request
class SecureHttpClient extends BaseClient {
  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    // Add security headers
    request.headers.addAll({
      'X-Content-Type-Options': 'nosniff',
      'X-Frame-Options': 'DENY',
    });

    return super.send(request);
  }
}
```

**Why:** Prevents security vulnerabilities and protects sensitive data.

---

## Rule 5: Performance and Memory Management

Write efficient code considering Dart's performance characteristics.

❌ **Forbidden:**

- Creating unnecessary object allocations in hot paths
- Using `forEach` when traditional loops might be more efficient for large collections
- Not using const constructors when possible
- Creating lambda instances inside loops

✅ **Required:**

- Use `const` constructors for immutable objects when possible
- Use `late` and `lazy` initialization for expensive operations
- Use `compute()` for CPU-intensive operations to avoid blocking UI
- Use `Isolate` for heavy computational work
- Use `Stream.periodic()` for time-based operations
- Profile code with DevTools to identify bottlenecks
- Use `Widget` keys appropriately in Flutter
- Use `ListView.builder()` instead of `ListView()` for large lists
- Use `KeepAlive` for widgets that should maintain state
- Implement proper state management to avoid unnecessary rebuilds

**Example:**

```dart
// Const constructors
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Use const widgets when possible
      decoration: const BoxDecoration(
        color: Colors.blue,
      ),
    );
  }
}

// Efficient list building
class EfficientList extends StatelessWidget {
  final List<Item> items;

  const EfficientList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ItemWidget(item: items[index]);
      },
    );
  }
}
```

**Why:** Efficient code provides better performance and uses system resources wisely.

---

## Rule 6: Code Organization and Documentation

Structure code following Dart idioms and provide appropriate documentation.

❌ **Forbidden:**

- Missing documentation for public APIs
- Comments that merely repeat the code
- Large classes that should be broken down
- Poor file and package organization

✅ **Required:**

- Document all public classes, functions, and methods with Dart documentation
- Use complete documentation with parameter and return descriptions
- Use triple-slash comments (`///`) for documentation
- Include examples in documentation with code blocks
- Group related functionality using libraries and packages
- Follow SOLID principles and common design patterns
- Use proper indentation and formatting (2 spaces, `dart format`)
- Organize files logically with clear separation of concerns
- Use meaningful variable names that describe their purpose
- Use `part` and `part of` for splitting large libraries appropriately
- Use `import` prefixes and combinators appropriately

**Example:**

```dart
/// Retrieves a user by their unique identifier.
///
/// The [id] parameter must be a positive integer representing the user's unique identifier.
///
/// Returns a [User] object if found, or `null` if no user exists with the given [id].
///
/// Example:
/// ```dart
/// final userService = UserService();
/// final user = await userService.getUser(123);
/// if (user != null) {
///   print('Found user: ${user.name}');
/// }
/// ```
Future<User?> getUser(int id) async {
  // implementation
}
```

**Why:** Well-organized code with good documentation is easier to understand and maintain.

---

## Rule 7: Asynchronous Programming

Write safe asynchronous code using Dart's async features.

❌ **Forbidden:**

- Using `await` in loops unnecessarily (blocking each iteration)
- Not handling Future completion when the result is needed
- Using `Completer` when async/await is more appropriate
- Forgetting to handle unawaited Futures

✅ **Required:**

- Use `async`/`await` for asynchronous operations
- Use `Future.wait()` for running multiple Futures concurrently
- Use `Stream` for handling sequences of asynchronous events
- Use `Isolate` for CPU-intensive work
- Use `Timer` for delayed execution
- Handle all Futures appropriately (await or explicitly ignore)
- Use `unawaited()` from `flutter/foundation` to explicitly ignore Futures
- Use `CancelableOperation` for cancellable async operations
- Implement proper error handling for async operations

**Example:**

```dart
// Concurrent Futures
Future<List<User>> fetchMultipleUsers(List<int> ids) async {
  final futures = ids.map((id) => fetchUser(id));
  final users = await Future.wait(futures);
  return users.where((user) => user != null).cast<User>().toList();
}

// Stream usage
Stream<int> processDataStream(Stream<String> input) async* {
  await for (final item in input) {
    if (int.tryParse(item) is int parsed) {
      yield parsed;
    }
  }
}

// Proper Future handling
void handleAsyncOperation() {
  final future = performAsyncTask();

  // If we don't need to await, explicitly ignore
  unawaited(future.then((result) => log('Task completed: $result')));
}
```

**Why:** Proper async handling prevents blocking and improves performance for I/O-bound operations.

---

## Rule 8: Testing Best Practices

Write effective tests to ensure code quality.

❌ **Forbidden:**

- Tests with no assertions
- Tests that depend on external services without proper mocking
- Tests that don't cover edge cases
- Tests that modify shared state without proper isolation

✅ **Required:**

- Use appropriate test frameworks (test, flutter_test)
- Follow Given-When-Then or Arrange-Act-Assert pattern
- Test both success and error conditions
- Use meaningful test function names
- Test boundary conditions and edge cases
- Mock external dependencies appropriately using `mockito` or similar
- Use `setUp()` and `tearDown()` for test fixtures
- Implement proper test isolation
- Use `golden tests` for UI widget testing
- Keep tests fast and independent
- Use `group()` to organize related tests

**Example:**

```dart
import 'package:test/test.dart';

void main() {
  late UserService userService;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    userService = UserService(mockRepository);
  });

  group('UserService', () {
    test('get user with valid id returns user', () async {
      // Given
      const userId = 123;
      const expectedUser = User(id: userId, name: 'John Doe');
      when(() => mockRepository.findById(userId))
          .thenAnswer((_) async => expectedUser);

      // When
      final result = await userService.getUser(userId);

      // Then
      expect(result, equals(expectedUser));
      verify(() => mockRepository.findById(userId)).called(1);
    });

    test('get user with invalid id returns null', () async {
      // Given
      const userId = -1;
      when(() => mockRepository.findById(userId))
          .thenAnswer((_) async => null);

      // When
      final result = await userService.getUser(userId);

      // Then
      expect(result, isNull);
    });
  });
}
```

**Why:** Comprehensive tests ensure code correctness and maintainability.

---

## Review Procedure

For each Dart file:

1. **Read complete file**
2. **Search for violations**
3. **Report findings** with file:line references

---

## Report Format

### If violations found

```text
❌ FAIL

Violations:
1. [ERROR HANDLING] - lib/services/user_service.dart:42
   Issue: Used try-catch for control flow instead of proper validation
   Fix: Use validation before processing or appropriate error handling

2. [SECURITY PRACTICES] - lib/network/api_client.dart:15
   Issue: Used HTTP instead of HTTPS for sensitive API
   Fix: Change to HTTPS for secure communication
```

### If no violations

```text
✅ PASS

File meets all semantic requirements.
```