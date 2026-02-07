# Stack Conventions Reference

Curated defaults for common tech stacks. Used by `/architect` to generate smart configuration when the user doesn't specify every detail.

Each stack section covers:
- **Common architecture patterns** — what to suggest when the user picks this stack
- **Default directory structure** — the conventional layout
- **Conventions** — naming, error handling, testing, state management
- **Grain** — what's easy, medium, and hard for each pattern
- **Default tooling** — build, test, lint, format

When the user specifies a stack, look up the closest match here and use it to fill in defaults for anything they didn't explicitly specify.

---

## Frontend

### React / TypeScript

**Common patterns:**
- **Feature-based (recommended default)** — group by feature, each feature owns its components, hooks, types, tests
- **Atomic Design** — atoms, molecules, organisms, templates, pages
- **Domain-driven** — group by business domain, shared UI library

**Default structure (feature-based):**
```
src/
  features/
    [feature]/
      components/
      hooks/
      types.ts
      index.ts
  shared/
    components/
    hooks/
    utils/
  app/
    routes/
    layout/
  types/
```

**Conventions:**
- Naming: PascalCase components, camelCase hooks (useXxx), camelCase utils, kebab-case files
- Components: functional only, prefer composition over inheritance
- State: local state first, lift only when needed; context for cross-cutting concerns
- Error handling: Error boundaries for UI, try/catch for async, typed error states
- Testing: colocated tests (`Component.test.tsx`), React Testing Library, test behavior not implementation
- Imports: absolute paths via tsconfig paths (`@/features/...`)

**Grain:**
- Easy: new component within a feature, new utility
- Medium: new feature (create feature directory + route + state), cross-feature data flow
- Hard: changing state management strategy, restructuring routing, replacing core dependencies

**Default tooling:** Vite or Next.js, Vitest or Jest, ESLint, Prettier, TypeScript strict mode

---

### Vue / TypeScript

**Common patterns:**
- **Feature-based (recommended default)** — group by feature with composables
- **Module-based** — Vuex/Pinia modules aligned with features
- **Page-based** — Nuxt conventions (pages/, components/, composables/)

**Default structure (feature-based):**
```
src/
  features/
    [feature]/
      components/
      composables/
      types.ts
      index.ts
  shared/
    components/
    composables/
    utils/
  app/
    router/
    stores/
```

**Conventions:**
- Naming: PascalCase components, camelCase composables (useXxx), kebab-case files
- Components: Composition API (`<script setup>`), single-file components
- State: Pinia stores, composables for shared logic
- Error handling: error refs in composables, global error handler
- Testing: colocated tests, Vue Test Utils + Vitest, test component behavior
- Imports: auto-imports for Vue APIs (if using Nuxt/unplugin-auto-import)

**Grain:**
- Easy: new component, new composable, new store
- Medium: new feature with routing, cross-feature communication
- Hard: migration between Options/Composition API, SSR adoption, changing state library

**Default tooling:** Vite (or Nuxt), Vitest, ESLint with vue plugin, Prettier

---

### Angular

**Common patterns:**
- **Module-based (recommended default)** — NgModules grouping related components, services, routes
- **Standalone** — standalone components (Angular 14+), lazy-loaded feature routes
- **Domain-driven** — group by business domain with shared libraries

**Default structure (module-based):**
```
src/app/
  core/
    services/
    guards/
    interceptors/
  shared/
    components/
    directives/
    pipes/
  features/
    [feature]/
      components/
      services/
      models/
      [feature].module.ts
      [feature]-routing.module.ts
```

**Conventions:**
- Naming: PascalCase classes, camelCase methods/properties, kebab-case files with type suffix (`.component.ts`, `.service.ts`)
- Components: smart/dumb separation, OnPush change detection for dumb components
- State: services + RxJS for simple apps, NgRx/NGXS for complex state
- Error handling: HTTP interceptors for API errors, ErrorHandler for global errors
- Testing: colocated `.spec.ts` files, TestBed for integration, jasmine/jest for unit
- DI: constructor injection, providedIn: 'root' for singletons

**Grain:**
- Easy: new component in existing module, new service
- Medium: new feature module with routing, cross-module communication
- Hard: module boundary restructuring, migration to standalone, state management changes

**Default tooling:** Angular CLI, Karma/Jest, ESLint, Prettier

---

## Mobile

### iOS / SwiftUI

**Common patterns:**
- **MVVM (recommended default)** — View, ViewModel, Model with SwiftUI's @Observable
- **TCA (The Composable Architecture)** — reducer-based, highly testable
- **Clean Architecture** — domain/data/presentation layers with protocols

**Default structure (MVVM):**
```
[App]/
  App/
    [App]App.swift
    ContentView.swift
  Features/
    [Feature]/
      Views/
      ViewModels/
      Models/
  Core/
    Services/
    Networking/
    Persistence/
  Shared/
    Components/
    Extensions/
    Utilities/
  Resources/
    Assets.xcassets
    Localizable.xcstrings
```

**Conventions:**
- Naming: PascalCase types, camelCase properties/methods, no prefixes (Swift convention)
- Views: small, composable, extract subviews at ~50 lines
- State: @Observable (iOS 17+) or @ObservableObject, avoid @EnvironmentObject for non-global state
- Error handling: typed errors with Swift's Error protocol, Result type for async, no force-unwraps
- Testing: XCTest or Swift Testing, ViewModels are the primary test surface, mock protocols not classes
- Dependencies: Swift Package Manager, protocol-based DI

**Grain:**
- Easy: new view, new view model, UI tweaks
- Medium: new feature (view + view model + model + service), new API integration
- Hard: navigation restructuring, persistence layer changes, cross-feature state coordination

**Default tooling:** Xcode, SPM, XCTest/Swift Testing, SwiftLint, SwiftFormat

---

### Kotlin / Jetpack Compose

**Common patterns:**
- **MVVM with Clean Architecture (recommended default)** — presentation/domain/data layers
- **MVI** — Model-View-Intent, unidirectional data flow
- **Multi-module** — feature modules with shared core

**Default structure (MVVM + Clean):**
```
app/src/main/
  di/
  ui/
    theme/
    navigation/
  feature/
    [feature]/
      presentation/
        [Feature]Screen.kt
        [Feature]ViewModel.kt
      domain/
        model/
        usecase/
        repository/  (interfaces)
      data/
        repository/  (implementations)
        remote/
        local/
```

**Conventions:**
- Naming: PascalCase classes, camelCase functions/properties, PascalCase composables
- Composables: stateless by default, hoist state to caller, extract at ~40 lines
- State: StateFlow in ViewModels, collectAsState in composables
- Error handling: sealed classes for Result types, no unchecked exceptions in domain
- Testing: JUnit 5, composable testing with ComposeTestRule, Mockk for mocking
- DI: Hilt/Dagger or Koin

**Grain:**
- Easy: new composable, new use case, UI changes
- Medium: new feature (screen + VM + use case + repo), new API endpoint
- Hard: navigation graph restructuring, module boundary changes, DI framework migration

**Default tooling:** Gradle (Kotlin DSL), JUnit 5, Detekt, Ktlint

---

## Backend

### Go API

**Common patterns:**
- **Standard layout (recommended default)** — flat structure with cmd/, internal/, pkg/
- **Clean/Hexagonal** — ports and adapters, domain at the center
- **Domain-driven** — packages by business domain

**Default structure (standard layout):**
```
cmd/
  server/
    main.go
internal/
  handler/
  service/
  repository/
  model/
  middleware/
  config/
pkg/
  (exported libraries)
migrations/
```

**Conventions:**
- Naming: PascalCase exported, camelCase unexported, short variable names in small scopes, no getters (Name() not GetName())
- Interfaces: small (1-3 methods), defined by consumer not implementer, accept interfaces return structs
- Error handling: explicit error returns, wrap errors with context (`fmt.Errorf("doing X: %w", err)`), no panic in library code
- Testing: table-driven tests, `_test.go` suffix, testify for assertions (optional), httptest for handlers
- Concurrency: goroutines with context, channels for communication, sync primitives for shared state

**Grain:**
- Easy: new handler + route, new repository method
- Medium: new domain entity (handler + service + repo + model + migration)
- Hard: middleware changes, database migration patterns, changing the HTTP framework

**Default tooling:** Go modules, go test, golangci-lint, gofmt

---

### Python / FastAPI

**Common patterns:**
- **Layered (recommended default)** — routers, services, repositories, models
- **Domain-driven** — packages by domain with shared infrastructure
- **Flat** — simple apps with routes and models

**Default structure (layered):**
```
app/
  main.py
  config.py
  routers/
    [resource].py
  services/
    [resource].py
  repositories/
    [resource].py
  models/
    [resource].py
  schemas/
    [resource].py
  core/
    dependencies.py
    exceptions.py
    middleware.py
tests/
  test_[resource].py
migrations/
  versions/
```

**Conventions:**
- Naming: snake_case functions/variables/modules, PascalCase classes, UPPER_SNAKE_CASE constants
- Typing: full type hints on all function signatures, Pydantic models for validation
- Error handling: custom exception classes, exception handlers in FastAPI, HTTPException for API errors
- Testing: pytest, fixtures for DI override, httpx AsyncClient for API tests, factories for test data
- Async: async def for I/O-bound routes, sync for CPU-bound (run in thread pool)

**Grain:**
- Easy: new endpoint in existing router, new Pydantic schema
- Medium: new resource (router + service + repo + model + schema + migration)
- Hard: auth system changes, middleware restructuring, database strategy changes

**Default tooling:** uv or poetry, pytest, Ruff, mypy, Alembic

---

### Rails

**Common patterns:**
- **Standard MVC (recommended default)** — Rails conventions
- **Service objects** — extract business logic from models and controllers
- **Domain-driven** — engines or packwerk packages for bounded contexts

**Default structure (MVC + service objects):**
```
app/
  controllers/
  models/
  views/
  services/
  jobs/
  mailers/
  serializers/
config/
  routes.rb
db/
  migrate/
spec/ (or test/)
```

**Conventions:**
- Naming: snake_case methods/variables/files, PascalCase classes, plural controllers, singular models
- Models: thin controllers fat models → thin controllers service objects, validations in models
- Error handling: rescue_from in ApplicationController, custom error classes
- Testing: RSpec (preferred) or Minitest, FactoryBot for test data, request specs for API
- Rails way: follow conventions unless there's a strong reason not to

**Grain:**
- Easy: new action in existing controller, add model attribute + migration
- Medium: new resource (model + migration + controller + routes + views/serializer)
- Hard: schema redesign, authentication system changes, Rails version upgrades

**Default tooling:** Bundler, RSpec/Minitest, RuboCop, Brakeman

---

### Java / Spring Boot

**Common patterns:**
- **Layered (recommended default)** — controller, service, repository layers
- **Hexagonal** — ports and adapters, domain core independent of framework
- **Modular monolith** — feature modules with defined boundaries

**Default structure (layered):**
```
src/main/java/com/[org]/[project]/
  config/
  controller/
  service/
  repository/
  model/
    entity/
    dto/
  exception/
  security/
src/main/resources/
  application.yml
src/test/java/
```

**Conventions:**
- Naming: PascalCase classes, camelCase methods/fields, suffix by role (Controller, Service, Repository)
- DI: constructor injection (not field injection), @RequiredArgsConstructor with Lombok
- Error handling: @ControllerAdvice + @ExceptionHandler, custom exception hierarchy, ResponseEntity for API errors
- Testing: JUnit 5, Mockito, @SpringBootTest for integration, @WebMvcTest for controller, @DataJpaTest for repository
- DTOs: separate request/response DTOs from entities, MapStruct or manual mapping

**Grain:**
- Easy: new endpoint in existing controller, new DTO
- Medium: new entity (entity + repo + service + controller + DTOs + migration)
- Hard: security configuration, database migration strategy, module boundary restructuring

**Default tooling:** Maven or Gradle, JUnit 5, Checkstyle/SpotBugs, Spring Boot DevTools

---

### .NET / ASP.NET Core

**Common patterns:**
- **Clean Architecture (recommended default)** — domain, application, infrastructure, presentation layers
- **Vertical slice** — organize by feature, each slice contains its own handler/model/validator
- **Standard MVC** — controllers, services, data access

**Default structure (Clean Architecture):**
```
src/
  [Project].Domain/
    Entities/
    ValueObjects/
    Interfaces/
  [Project].Application/
    Services/
    DTOs/
    Validators/
  [Project].Infrastructure/
    Data/
    Repositories/
    ExternalServices/
  [Project].Api/
    Controllers/
    Middleware/
    Program.cs
tests/
  [Project].UnitTests/
  [Project].IntegrationTests/
```

**Conventions:**
- Naming: PascalCase everything public, _camelCase private fields, I-prefix for interfaces (IRepository)
- DI: built-in DI container, register in Program.cs or extension methods
- Error handling: middleware exception handler, ProblemDetails for API errors, Result pattern for domain
- Testing: xUnit, Moq or NSubstitute, FluentAssertions, WebApplicationFactory for integration tests
- Async: async/await for all I/O, CancellationToken propagation

**Grain:**
- Easy: new endpoint, new DTO, new validator
- Medium: new entity across layers (domain + application + infrastructure + API)
- Hard: cross-cutting concerns (auth, caching, logging), infrastructure provider changes

**Default tooling:** dotnet CLI, xUnit, dotnet-format, analyzers (Roslyn)

---

## Systems

### Rust

**Common patterns:**
- **Library + binary (recommended default)** — lib.rs for logic, main.rs for CLI/server entry
- **Workspace** — multiple crates in a workspace for larger projects
- **Domain-driven** — modules by business domain

**Default structure (library + binary):**
```
src/
  main.rs
  lib.rs
  config.rs
  error.rs
  [module]/
    mod.rs
    types.rs
    handlers.rs (or logic files)
tests/
  integration/
benches/
```

**Conventions:**
- Naming: snake_case functions/variables/modules, PascalCase types/traits, UPPER_SNAKE_CASE constants
- Error handling: thiserror for library errors, anyhow for application errors, `?` propagation, no unwrap() in production code
- Ownership: prefer borrowing, clone only when necessary and documented, use lifetimes explicitly
- Testing: #[test] in same file for unit tests, tests/ directory for integration, #[cfg(test)] mod tests
- Traits: small focused traits, implement std traits (Display, Debug, From) where appropriate

**Grain:**
- Easy: new function in existing module, new type
- Medium: new module (types + logic + tests), new API endpoint
- Hard: error type restructuring, changing async runtime, refactoring ownership boundaries

**Default tooling:** Cargo, cargo test, clippy, rustfmt
