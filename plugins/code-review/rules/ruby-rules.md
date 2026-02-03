# Ruby Code Review Rules

These are Ruby-specific code review rules. Follow these guidelines to maintain high-quality Ruby code.

---

## Rule 1: Naming Conventions

Follow Ruby naming conventions as defined in community standards.

❌ **Forbidden:**

- Using CamelCase for method names (reserved for classes and modules)
- Using dashes in file names or gem names (use underscores)
- Using ALL_CAPS for non-constant variables
- Using abbreviations that reduce readability

✅ **Required:**

- `SnakeCase` for class and module names: `UserManager`, `HttpRequest`
- `snake_case` for method and variable names: `get_user`, `user_count`
- `SCREAMING_SNAKE_CASE` for constants: `MAX_RETRY_COUNT`, `DEFAULT_TIMEOUT`
- `?` suffix for predicate methods: `valid?`, `empty?`, `has_permission?`
- `!` suffix for dangerous methods that modify state: `save!`, `delete!`
- `CamelCase` for file names that map to class names: `user_manager.rb` → `UserManager`
- Descriptive names that clearly indicate the purpose

**Example:**

```ruby
class UserManager
  MAX_RETRY_COUNT = 3

  def get_user(id)
    # implementation
  end

  def valid_user?(user)
    # implementation
  end

  def delete_user!(user)
    # implementation that modifies state
  end
end
```

**Why:** Consistent naming improves readability and maintainability across Ruby projects.

---

## Rule 2: Error Handling

Handle errors appropriately following Ruby best practices.

❌ **Forbidden:**

- Using bare `rescue` without specifying exception type
- Rescuing `StandardError` when more specific exceptions are available
- Ignoring rescued exceptions without logging
- Using exceptions for normal control flow

✅ **Required:**

- Rescue specific exceptions rather than generic rescue
- Use `begin/rescue/end` blocks appropriately
- Log exceptions with context when caught
- Raise meaningful exceptions with descriptive messages
- Use `ensure` blocks for cleanup code
- Implement proper exception hierarchies for custom exceptions
- Use `retry` appropriately for recoverable errors
- Consider using `return` instead of exceptions for expected conditions

**Example:**

```ruby
def fetch_user(id)
  begin
    response = http_client.get("/users/#{id}")
    JSON.parse(response.body)
  rescue Net::TimeoutError => e
    Rails.logger.error "Timeout fetching user #{id}: #{e.message}"
    raise UserFetchError, "Failed to fetch user #{id} due to timeout"
  rescue JSON::ParserError => e
    Rails.logger.error "Invalid JSON response for user #{id}: #{e.message}"
    raise UserParseError, "Invalid response format for user #{id}"
  end
end
```

**Why:** Proper error handling makes debugging easier and prevents silent failures.

---

## Rule 3: Modern Ruby Features

Leverage modern Ruby features for cleaner, more efficient code.

❌ **Forbidden:**

- Using outdated Ruby syntax when modern alternatives are available
- Not taking advantage of newer Ruby features (2.0+)
- Using verbose blocks when shorthand methods are available

✅ **Required:**

- Use frozen string literals: `# frozen_string_literal: true`
- Use safe navigation operator (Ruby 2.3+): `user&.profile&.name`
- Use squiggly heredocs for indented strings: `<<~SQL`
- Use endless method definition (Ruby 3.0+): `def square(x) = x * x`
- Use numbered parameters for simple blocks (Ruby 2.7+): `list.map { _1.upcase }`
- Use pattern matching (Ruby 2.7+) for complex destructuring
- Use keyword arguments for method parameters when appropriate
- Use `Hash#transform_keys` and `Hash#transform_values` for hash transformations
- Use `Array#filter_map` for combined filtering and mapping (Ruby 2.7+)

**Example:**

```ruby
# frozen_string_literal: true

class UserService
  def process_users(users)
    users.filter_map { |user| user.name.upcase if user.active? }
  end

  def format_query(table, columns)
    <<~SQL
      SELECT #{columns.join(', ')}
      FROM #{table}
      WHERE active = true
    SQL
  end
end
```

**Why:** Modern Ruby features lead to more readable and maintainable code.

---

## Rule 4: Security Best Practices

Implement secure coding practices to prevent vulnerabilities.

❌ **Forbidden:**

- Hardcoding sensitive information like passwords or API keys
- Building SQL queries with string interpolation (SQL injection risk)
- Trusting user input without validation
- Using `eval()` or similar dynamic execution with user data
- Rendering raw user input without sanitization
- Mass assignment without proper protection

✅ **Required:**

- Store sensitive data in environment variables or secure vaults
- Use parameterized queries or ActiveRecord methods for database access
- Validate and sanitize all user inputs using strong parameters (Rails) or validation libraries
- Use HTTPS for network communications
- Implement proper authentication and authorization (BCrypt, Devise, etc.)
- Use `html_safe` and `sanitize` methods carefully for HTML rendering
- Use `Rails.application.config.filter_parameters` to filter sensitive parameters
- Implement CSRF protection with `protect_from_forgery`
- Use secure random generators: `SecureRandom.urlsafe_base64`
- Validate file uploads and content types
- Use `html_escape` or equivalent for user-generated content

**Example:**

```ruby
class UsersController < ApplicationController
  def create
    # Strong parameters to prevent mass assignment
    user_params = params.require(:user).permit(:name, :email, :password)

    @user = User.new(user_params)

    if @user.save
      redirect_to @user
    else
      render :new
    end
  end
end
```

**Why:** Prevents security vulnerabilities and protects sensitive data.

---

## Rule 5: Performance and Memory Management

Write efficient code considering Ruby's runtime characteristics.

❌ **Forbidden:**

- Creating unnecessary objects in loops
- Using expensive operations in loops unnecessarily
- Loading entire datasets when only partial data is needed
- Using N+1 queries without proper eager loading

✅ **Required:**

- Use eager loading to prevent N+1 queries: `includes(:association)`
- Use `select` to limit database columns when appropriate
- Use `find_each` for processing large datasets: `User.find_each { |user| ... }`
- Use `pluck` for simple data extraction: `User.pluck(:name, :email)`
- Implement proper caching strategies (Redis, Memcached)
- Use database indexes for frequently queried columns
- Profile code with tools like `benchmark-ips` or `memory_profiler`
- Use `freeze` for immutable strings and objects when appropriate
- Use `map` and `select` appropriately instead of `each` with conditionals
- Consider using `find_by_sql` for complex queries instead of multiple DB calls

**Example:**

```ruby
# Efficient processing of large datasets
User.includes(:posts).where(active: true).find_each(batch_size: 100) do |user|
  process_user_data(user)
end

# Efficient data extraction
user_names = User.where(active: true).pluck(:name)
```

**Why:** Efficient code provides better performance and uses system resources wisely.

---

## Rule 6: Code Organization and Documentation

Structure code following Ruby idioms and provide appropriate documentation.

❌ **Forbidden:**

- Missing documentation for public APIs
- Comments that merely repeat the code
- Large classes that should be broken down
- Poor module organization

✅ **Required:**

- Document all public methods with YARD documentation
- Use meaningful variable and method names that describe their purpose
- Group related functionality together in modules and classes
- Follow the Single Responsibility Principle
- Use proper indentation and formatting (2 spaces)
- Organize files logically with clear separation of concerns
- Use meaningful commit messages and git practices
- Follow Rails conventions when using Rails framework
- Use gems and libraries appropriately
- Write self-documenting code with clear method names

**Example:**

```ruby
# @param [Integer] user_id The unique identifier of the user
# @param [Boolean] include_posts Whether to include associated posts
# @return [User, nil] The user object or nil if not found
# @raise [ActiveRecord::RecordNotFound] If user doesn't exist
def find_user_with_options(user_id, include_posts: false)
  includes = include_posts ? [:posts] : []
  User.includes(includes).find(user_id)
end
```

**Why:** Well-organized code with good documentation is easier to understand and maintain.

---

## Rule 7: Testing Best Practices

Write effective tests to ensure code quality.

❌ **Forbidden:**

- Tests with no assertions
- Tests that depend on external services without proper mocking
- Tests that don't cover edge cases
- Tests that modify shared state without proper isolation

✅ **Required:**

- Use appropriate test frameworks (RSpec, Minitest)
- Follow Given-When-Then or Arrange-Act-Assert pattern
- Test both success and error conditions
- Use meaningful test method names
- Test boundary conditions and edge cases
- Mock external dependencies appropriately
- Use factories for test data creation (FactoryBot)
- Implement proper test fixtures and setup/teardown
- Use test doubles (mocks, stubs) appropriately
- Keep tests fast and independent

**Example:**

```ruby
describe UserService, '#find_active_user' do
  let(:user) { create(:user, :active) }

  it 'returns user when valid id is provided' do
    # Given
    # User is created in let block

    # When
    result = described_class.find_active_user(user.id)

    # Then
    expect(result).to eq(user)
  end

  it 'raises error when user is inactive' do
    # Given
    inactive_user = create(:user, :inactive)

    # When & Then
    expect {
      described_class.find_active_user(inactive_user.id)
    }.to raise_error(UserInactiveError)
  end
end
```

**Why:** Comprehensive tests ensure code correctness and maintainability.

---

## Rule 8: Ruby Style and Idioms

Write idiomatic Ruby code following community conventions.

❌ **Forbidden:**

- Using `for` loops instead of iterator methods
- Using `puts` for logging in applications
- Long methods that exceed 10-15 lines for complex logic
- Deeply nested conditionals (more than 2-3 levels)

✅ **Required:**

- Use Ruby iterators: `each`, `map`, `select`, `reject`, `reduce`
- Use `&&` and `||` for boolean logic, `and` and `or` for control flow
- Use `nil?` instead of comparing with `nil`
- Use `presence` and `present?` methods in Rails
- Use `try` or safe navigation operator instead of checking for nil
- Use `tap` for debugging or intermediate transformations
- Use `attr_reader`, `attr_writer`, `attr_accessor` appropriately
- Prefer single quotes for strings unless interpolation is needed
- Use guard clauses to reduce nesting: `return if condition`

**Example:**

```ruby
class OrderProcessor
  def process_order(order)
    return false unless order.valid?
    return false unless order.payable?

    charge_customer(order)
    send_confirmation_email(order)
    update_inventory(order)
  end

  private

  def charge_customer(order)
    # implementation
  end
end
```

**Why:** Idiomatic Ruby code is more readable and maintainable by the Ruby community.

---

## Review Procedure

For each Ruby file:

1. **Read complete file**
2. **Search for violations**
3. **Report findings** with file:line references

---

## Report Format

### If violations found

```text
❌ FAIL

Violations:
1. [SECURITY PRACTICES] - app/controllers/users_controller.rb:15
   Issue: Used string interpolation in SQL query
   Fix: Use parameterized queries or ActiveRecord methods

2. [RUBY STYLE] - app/models/user.rb:23
   Issue: Deeply nested conditionals
   Fix: Use guard clauses to reduce nesting
```

### If no violations

```text
✅ PASS

File meets all semantic requirements.
```