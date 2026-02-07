# Refactoring Checklist

This comprehensive checklist covers universal refactoring opportunities applicable to any language or framework. Apply items relevant to the code's language, framework, and architectural style.

## 1. Architecture & Design Patterns

### SOLID Principle Violations
- [ ] **Single Responsibility Violation**: Class/module/function doing too many unrelated things
- [ ] **Open/Closed Violation**: Modification required to extend behavior (missing abstractions/plugins)
- [ ] **Liskov Substitution Violation**: Subtypes that don't honor parent contracts
- [ ] **Interface Segregation Violation**: Consumers forced to depend on methods they don't use
- [ ] **Dependency Inversion Violation**: High-level modules depending on low-level details instead of abstractions

### Separation of Concerns
- [ ] **Business logic in presentation layer**: Views/templates/controllers contain domain logic
- [ ] **UI concerns in business layer**: Domain/service code references UI types or frameworks
- [ ] **Data access in business logic**: Business rules mixed with database/API calls
- [ ] **Cross-cutting concerns scattered**: Logging, auth, validation duplicated across layers instead of centralized

### Pattern Violations
- [ ] **Missing pattern application**: Code that would clearly benefit from a known pattern (Strategy, Observer, Factory, etc.)
- [ ] **Pattern misapplication**: Wrong pattern used for the problem (over-engineering or wrong fit)
- [ ] **Inconsistent patterns**: Same problem solved with different patterns across the codebase
- [ ] **God object/class**: Single class with too many responsibilities (> 500 lines is a signal)
- [ ] **Feature envy**: Methods that use more data from other classes than their own

### Dependency Management
- [ ] **Hard-coded dependencies**: Direct instantiation instead of injection/configuration
- [ ] **Circular dependencies**: Modules/classes depending on each other in cycles
- [ ] **Hidden dependencies**: Dependencies not visible in constructor/interface (global state, service locators)
- [ ] **Unnecessary coupling**: Components knowing more about each other than needed
- [ ] **Missing abstractions**: Concrete types where interfaces/protocols would enable flexibility

## 2. Code Organization & Structure

### Module/Package Boundaries
- [ ] **Wrong module placement**: Code in incorrect architectural layer
- [ ] **Circular module dependencies**: Modules importing each other
- [ ] **Feature-to-feature coupling**: Feature modules directly depending on other feature modules
- [ ] **Leaking implementation details**: Internal types exposed through public APIs
- [ ] **Missing module boundaries**: Monolithic code that should be split into modules

### File Organization
- [ ] **Multiple unrelated types per file**: Unrelated classes/types in a single file
- [ ] **Misnamed files**: File name doesn't match primary type/function name
- [ ] **Oversized files**: Files exceeding 400-500 lines (consider splitting)
- [ ] **Missing directory structure**: Related files not grouped logically
- [ ] **Test file misplacement**: Test files not mirroring source structure

### Naming Conventions
- [ ] **Inconsistent naming style**: Mixed naming conventions (camelCase, snake_case, etc.)
- [ ] **Non-descriptive names**: Variables/functions with unclear purpose (`temp`, `data`, `handle`, `x`)
- [ ] **Misleading names**: Names that suggest wrong behavior or type
- [ ] **Abbreviation inconsistency**: Mixed use of abbreviations vs full words
- [ ] **Boolean naming**: Boolean variables/methods not phrased as questions (`is`, `has`, `can`, `should`)
- [ ] **Overly long names**: Names that are excessively verbose when context makes shorter names clear

## 3. Presentation / UI Layer

### View Logic Separation
- [ ] **Business logic in views**: Views computing business rules instead of displaying precomputed state
- [ ] **Complex conditionals in templates**: Nested if/else in view templates that should be precomputed
- [ ] **Data transformation in views**: Views formatting, filtering, or sorting data themselves
- [ ] **Direct service/API calls from views**: Views bypassing the logic layer to fetch data
- [ ] **Navigation logic in views**: Views deciding navigation instead of delegating to a coordinator/router

### Component Design
- [ ] **Oversized components**: Components doing too much (> 200 lines is a signal)
- [ ] **Missing component extraction**: Repeated view structures that should be shared components
- [ ] **Custom implementations of existing components**: Reinventing UI elements the design system or framework provides
- [ ] **Inconsistent styling**: Hard-coded colors/fonts/spacing instead of design tokens or theme values
- [ ] **Missing empty/loading/error states**: UI components that only handle the happy path

### Rendering Efficiency
- [ ] **Unnecessary re-renders**: Components re-rendering when unrelated state changes
- [ ] **Missing memoization**: Expensive computations in render path not memoized
- [ ] **Large render trees**: Deeply nested component hierarchies causing performance issues
- [ ] **Missing virtualization**: Large lists rendered without virtualization/lazy loading

## 4. State Management

### State Design
- [ ] **Multiple sources of truth**: Same data stored in multiple places
- [ ] **Derived state stored**: Computed values stored when they could be derived on demand
- [ ] **Unnecessary state**: Values in state that never change or aren't used for rendering
- [ ] **Wrong state scope**: State lifted too high (global when local suffices) or too low (local when shared needed)
- [ ] **Missing state encapsulation**: Internal state exposed as mutable to consumers

### State Updates
- [ ] **Inconsistent update patterns**: Different approaches to state mutation across the codebase
- [ ] **Side effects in state computation**: State derivation functions with side effects
- [ ] **Race conditions**: Concurrent state updates without synchronization
- [ ] **Missing state validation**: State transitions that can leave invalid combinations
- [ ] **State mutations scattered**: State changed from too many places (hard to trace cause-effect)

## 5. Asynchronous Programming

### Async Patterns
- [ ] **Callback hell / pyramid of doom**: Deeply nested callbacks or promise chains
- [ ] **Missing modern async patterns**: Callbacks/promises where async/await (or equivalent) is available
- [ ] **Unhandled async errors**: Async operations without error handling
- [ ] **Missing cancellation**: Long-running operations that can't be cancelled
- [ ] **Fire-and-forget without justification**: Async operations whose results are silently ignored

### Concurrency Safety
- [ ] **Shared mutable state**: Data accessed from multiple threads/coroutines without protection
- [ ] **Missing thread/actor confinement**: UI updates from background threads
- [ ] **Deadlock potential**: Lock ordering issues or blocking on async results
- [ ] **Resource leaks**: Subscriptions, listeners, or handles not cleaned up on cancellation/disposal

### Reactive/Event Patterns
- [ ] **Uncancelled subscriptions**: Event subscriptions not cleaned up on disposal
- [ ] **Memory leaks in closures**: Closures capturing references that prevent garbage collection
- [ ] **Missing backpressure**: Producers overwhelming consumers without flow control
- [ ] **Complex chains**: Event/stream chains that should be broken into named intermediate steps

## 6. API & External Integration

### Client Patterns
- [ ] **Bypassing centralized client**: Direct HTTP/network calls instead of using a shared client
- [ ] **Duplicate endpoint definitions**: Same endpoints defined in multiple places
- [ ] **Hard-coded URLs**: URLs not using configuration/environment variables
- [ ] **Missing request/response models**: Using raw dictionaries/maps instead of typed models
- [ ] **Inconsistent error handling**: Different error handling approaches across API calls

### Data Access Layer
- [ ] **Business logic in data access**: Repositories/DAOs containing business rules
- [ ] **Missing repository abstraction**: Direct database/API access from business logic
- [ ] **Inconsistent data access patterns**: Different naming/signature patterns across repositories
- [ ] **Missing caching**: Repeatedly fetching the same data without caching
- [ ] **N+1 queries**: Fetching related data in loops instead of batch/join operations

### External Service Integration
- [ ] **Missing circuit breaker**: No fallback when external services fail
- [ ] **Missing timeout**: External calls without timeout configuration
- [ ] **Missing retry logic**: Transient failures not retried
- [ ] **Tight coupling to external API**: Business logic tightly coupled to external API shapes

## 7. Code Duplication

### Logic Duplication
- [ ] **Duplicate business logic**: Same logic in multiple modules/classes
- [ ] **Duplicate validation**: Same validation rules across different features
- [ ] **Duplicate formatting**: Same data formatting in multiple places
- [ ] **Duplicate data access code**: Similar queries/API calls not extracted
- [ ] **Copy-pasted functions**: Nearly identical functions with minor variations

### Structural Duplication
- [ ] **Similar component structures**: Multiple UI components with nearly identical structure
- [ ] **Repeated layout patterns**: Same layout/template code across multiple views
- [ ] **Duplicate configuration**: Same config values defined in multiple locations

### Model Duplication
- [ ] **Duplicate type definitions**: Same data structures defined in multiple modules
- [ ] **Redundant computed properties**: Same computation logic across types
- [ ] **Duplicate utility methods**: Same helper methods on multiple types/modules

## 8. Error Handling & Edge Cases

### Error Handling Patterns
- [ ] **Unsafe type operations**: Forced type casts, force unwrapping, unchecked index access
- [ ] **Missing error propagation**: Errors caught but not reported/re-thrown
- [ ] **Generic catch blocks**: Catch-all without specific error handling
- [ ] **Missing user feedback**: Errors not surfaced to users appropriately
- [ ] **Inconsistent error types**: Different error patterns across modules
- [ ] **Silent failures**: Errors swallowed without logging or notification

### Null/Nil/Undefined Handling
- [ ] **Missing null checks**: Potential null dereference in languages without null safety
- [ ] **Excessive null checks**: Null checks where the value is guaranteed to exist
- [ ] **Null used for semantics**: Null/nil representing meaningful states instead of explicit types (e.g., Result, Optional, sealed class)
- [ ] **Default value misuse**: Using default values when the absence itself is meaningful

### Edge Cases
- [ ] **Missing empty state handling**: No handling for empty collections/data
- [ ] **Missing loading states**: No loading indicators for async operations
- [ ] **Missing offline/degraded handling**: No graceful degradation when services unavailable
- [ ] **Missing input validation**: User/external input not validated
- [ ] **Missing boundary checks**: Array/buffer access without bounds checking
- [ ] **Missing concurrent access handling**: Shared resources accessed without synchronization

## 9. Performance & Efficiency

### Memory Management
- [ ] **Memory leaks**: Objects retained longer than needed (circular references, missed cleanup)
- [ ] **Large data in memory**: Excessive data loaded when pagination/streaming would be better
- [ ] **Missing resource cleanup**: File handles, connections, listeners not closed/disposed
- [ ] **Unnecessary object allocation**: Creating objects in hot paths that could be reused

### Computation Efficiency
- [ ] **Expensive computed properties**: Heavy computation in getters called repeatedly
- [ ] **Missing memoization/caching**: Repeated expensive calculations not cached
- [ ] **Inefficient algorithms**: O(n^2) or worse where better algorithms exist
- [ ] **Blocking main thread**: Heavy work on the UI/main thread
- [ ] **Missing lazy evaluation**: Eagerly computing values that may never be used
- [ ] **Unnecessary work**: Computing values that are immediately discarded or overwritten

### I/O Efficiency
- [ ] **Chatty I/O**: Many small reads/writes where batching would be better
- [ ] **Synchronous I/O in hot paths**: Blocking I/O where async would improve throughput
- [ ] **Missing connection pooling**: Creating new connections per request

## 10. Testing & Testability

### Test Coverage
- [ ] **Missing unit tests**: Core business logic without test coverage
- [ ] **Missing integration tests**: Feature flows without integration tests
- [ ] **Missing edge case tests**: Tests only cover happy path
- [ ] **Missing error path tests**: Error handling logic not tested

### Testability Issues
- [ ] **Hard-to-test code**: Code with dependencies that can't be mocked/stubbed
- [ ] **Missing test doubles**: No mock/stub/fake implementations for testing
- [ ] **Side effects in constructors**: Initialization code with side effects (network calls, file I/O)
- [ ] **Global/static state**: Tests affected by mutable global state
- [ ] **Time-dependent tests**: Tests that depend on current date/time without abstraction
- [ ] **Non-deterministic tests**: Tests with random or order-dependent behavior

### Test Quality
- [ ] **Test duplication**: Same scenario tested in multiple ways
- [ ] **Brittle tests**: Tests coupled to implementation details rather than behavior
- [ ] **Missing assertions**: Tests that run code but don't assert outcomes
- [ ] **Misleading test names**: Test names that don't describe what's being tested
- [ ] **Test setup overhead**: Excessive setup that obscures the test's intent

## 11. Documentation & Code Clarity

### Documentation
- [ ] **Missing public API documentation**: Public types/methods without documentation
- [ ] **Outdated comments**: Comments that don't match current implementation
- [ ] **Commented-out code**: Dead code left in comments
- [ ] **Over-commenting**: Obvious code explained unnecessarily
- [ ] **Missing "why" comments**: Complex decisions without rationale (comment the why, not the what)

### Code Readability
- [ ] **Long functions/methods**: Functions exceeding 40-50 lines
- [ ] **Long parameter lists**: Functions with > 4 parameters (consider objects/builders)
- [ ] **Complex conditionals**: Nested if/else that should be guard clauses or early returns
- [ ] **Magic numbers/strings**: Hard-coded literals without named constants
- [ ] **Missing constants/enums**: Repeated string/number literals that should be named
- [ ] **Unclear variable scope**: Variables declared far from usage
- [ ] **Overly clever code**: Code that prioritizes cleverness over clarity

## 12. Security & Privacy

### Data Security
- [ ] **Hard-coded secrets**: API keys, tokens, passwords in source code
- [ ] **Insecure storage**: Sensitive data stored in plain text (should use secure storage)
- [ ] **Logging sensitive data**: PII, credentials, or tokens in logs
- [ ] **Missing data sanitization**: User input rendered or executed without sanitization

### Communication Security
- [ ] **Insecure connections**: HTTP instead of HTTPS, missing TLS validation
- [ ] **Missing authentication**: API calls without proper auth headers
- [ ] **Token exposure**: Auth tokens in URL parameters or logs
- [ ] **Missing request validation**: Server not validating request integrity

### Common Vulnerabilities
- [ ] **Injection vulnerabilities**: SQL injection, command injection, XSS
- [ ] **Missing CSRF protection**: State-changing operations without CSRF tokens
- [ ] **Insecure deserialization**: Deserializing untrusted data without validation
- [ ] **Missing rate limiting**: Endpoints without protection against abuse

## 13. Language Idioms & Modern Features

### Modern Language Adoption
- [ ] **Missing modern async**: Old async patterns where language provides better alternatives (async/await, coroutines, actors)
- [ ] **Missing modern concurrency**: Manual thread management where structured concurrency exists
- [ ] **Missing modern null safety**: Manual null checks where language has null-safe operators
- [ ] **Missing modern pattern matching**: Complex if/else chains where pattern matching available
- [ ] **Missing modern type features**: Verbose code where generics, type aliases, or union types would simplify

### Type System Usage
- [ ] **Weak typing**: Using `Any`/`Object`/`any` instead of specific types or generics
- [ ] **Missing enums/unions**: String/integer constants instead of enumerated types
- [ ] **Missing value types**: Mutable reference types where immutable value types fit better
- [ ] **Type assertion overuse**: Frequent runtime type checks suggesting missing polymorphism
- [ ] **Stringly typed APIs**: Strings used where structured types would prevent errors

### Functional Patterns
- [ ] **Imperative collection processing**: Manual loops where map/filter/reduce would be clearer
- [ ] **Missing immutability**: Mutable variables/fields where immutable would be safer
- [ ] **Side effects in pure functions**: Functions that should be pure but have hidden side effects
- [ ] **Missing higher-order functions**: Repeated patterns that could be abstracted with function parameters

## 14. Observability & Monitoring

### Telemetry & Metrics
- [ ] **Missing instrumentation**: Key operations without timing/counting metrics
- [ ] **Inconsistent event naming**: Different naming patterns for telemetry events
- [ ] **Missing error tracking**: Errors not reported to monitoring systems
- [ ] **Missing performance tracking**: No metrics for critical user-facing paths
- [ ] **Over-instrumentation**: Excessive telemetry causing performance overhead

### Logging
- [ ] **Missing logging**: Critical operations without log statements
- [ ] **Excessive logging**: Debug-level logs left in production paths
- [ ] **Inconsistent log levels**: Wrong severity levels for log messages
- [ ] **Missing context**: Log messages without sufficient debugging context (request IDs, user context, etc.)
- [ ] **Unstructured logging**: Free-text logs where structured logging would enable better searching

### Health & Diagnostics
- [ ] **Missing health checks**: Services without health/readiness endpoints
- [ ] **Missing error context**: Exceptions without enough context to diagnose
- [ ] **Missing correlation IDs**: Distributed operations without traceability

## 15. Build, Configuration & Dependencies

### Configuration
- [ ] **Hard-coded environment values**: Environment-specific values not using configuration
- [ ] **Missing environment separation**: Same config for dev/staging/production
- [ ] **Incorrect access control**: Public visibility where private/internal appropriate
- [ ] **Missing feature flags**: Changes that should be toggleable aren't

### Dependencies
- [ ] **Unnecessary dependencies**: Importing large libraries for small functionality
- [ ] **Version conflicts**: Dependency version mismatches or incompatibilities
- [ ] **Missing version pinning**: Dependencies without locked/pinned versions
- [ ] **Outdated dependencies**: Old versions with known security issues or bugs
- [ ] **Transitive dependency bloat**: Pulling in large dependency trees unnecessarily

### Build Process
- [ ] **Missing static analysis**: No linter/formatter configured
- [ ] **Missing type checking**: Dynamic language without type checking tools
- [ ] **Long build times**: Build steps that could be parallelized or cached
- [ ] **Missing CI/CD checks**: Key validations not automated in pipeline
