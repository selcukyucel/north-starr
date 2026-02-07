# Architecture Patterns Reference

This document provides universal architectural principles and common patterns for validating code quality. Use it to assess whether code follows sound architectural practices, regardless of language or framework.

## How to Use This Guide

1. **Detect the project's architecture first**: Check `CLAUDE.md`, `.ai/patterns/`, and project documentation before applying generic patterns. Project-specific patterns always take precedence.
2. **Identify the code's role**: Determine which architectural layer the code belongs to.
3. **Validate against universal principles**: These always apply, regardless of specific architecture.
4. **Validate against the relevant pattern**: Match the code to the closest common pattern and check compliance.

---

## Universal Design Principles

These principles apply to **all** code in **any** language or framework.

### Single Responsibility (SRP)
Every module, class, or function should have one clear reason to change.

**Signals of violation**:
- Class/file > 400-500 lines
- Function > 40-50 lines
- "And" in the class/function name ("UserManagerAndValidator")
- Multiple unrelated imports
- Changing one behavior requires touching unrelated code

### Open/Closed (OCP)
Software entities should be open for extension but closed for modification.

**Signals of violation**:
- Adding a new type requires modifying a switch/if-else chain in multiple places
- New features require changes to existing, stable code
- Missing plugin/strategy/hook points for known extension scenarios

### Liskov Substitution (LSP)
Subtypes must be usable wherever their base type is expected.

**Signals of violation**:
- Subclass overrides that throw "not supported" exceptions
- Type checks before calling methods on a base type
- Subclass that ignores or breaks parent behavior

### Interface Segregation (ISP)
No client should be forced to depend on methods it doesn't use.

**Signals of violation**:
- Interfaces/protocols with 10+ methods
- Implementations that leave methods empty or throw "not implemented"
- Consumers that only use 1-2 methods of a large interface

### Dependency Inversion (DIP)
High-level modules should not depend on low-level modules. Both should depend on abstractions.

**Signals of violation**:
- Business logic importing database/API/framework modules directly
- Constructor creating its own dependencies (hard-coded `new`)
- Changing infrastructure requires changing business logic

### Additional Principles

**DRY (Don't Repeat Yourself)**:
- Same logic in 3+ places should be extracted
- But don't over-DRY: if two pieces of code look similar but change for different reasons, they should stay separate

**YAGNI (You Aren't Gonna Need It)**:
- Abstractions, extension points, or generics for hypothetical future requirements
- Premature optimization without profiling data
- Configuration for scenarios that may never happen

**Least Surprise**:
- Functions should do what their name suggests, nothing more
- Side effects should be visible in the function signature or name
- Consistent naming and behavior across the codebase

**Separation of Concerns**:
- Presentation code should not contain business logic
- Business logic should not contain data access details
- Infrastructure should not contain business rules

---

## Common Architectural Patterns

### Layered Architecture

The most common architecture. Code is organized into horizontal layers with strict dependency direction.

```
Presentation Layer (UI, Views, Controllers)
        ↓ (depends on)
Business/Domain Layer (Services, Use Cases, Business Rules)
        ↓ (depends on)
Data/Infrastructure Layer (Repositories, API Clients, Database)
        ↓ (depends on)
Shared/Foundation Layer (Utilities, Models, Constants)
```

**Validation checklist**:
- [ ] Dependencies only flow downward (upper layers depend on lower layers)
- [ ] No upward dependencies (data layer doesn't import presentation)
- [ ] No lateral dependencies between features at the same layer
- [ ] Each layer has a clear, documented responsibility
- [ ] Abstractions (interfaces/protocols) live in the layer that uses them, not implements them

**Common variations**:
- **3-tier**: Presentation → Business → Data
- **4-tier**: Presentation → Business → Data → Foundation
- **N-tier**: Further splitting (e.g., separate API and database layers)

### Clean Architecture

Concentric layers with the dependency rule: dependencies point inward.

```
Outer: Frameworks & Drivers (UI, DB, Web, External)
  ↓
Middle: Interface Adapters (Controllers, Presenters, Gateways)
  ↓
Inner: Use Cases (Application Business Rules)
  ↓
Core: Entities (Enterprise Business Rules)
```

**Validation checklist**:
- [ ] Inner layers have zero knowledge of outer layers
- [ ] Use case layer defines interfaces that outer layers implement
- [ ] Entities are pure domain objects with no framework dependencies
- [ ] Data crosses boundaries via simple data transfer objects
- [ ] Framework-specific code is confined to the outermost layer

### Hexagonal Architecture (Ports & Adapters)

Domain core is surrounded by ports (interfaces) and adapters (implementations).

```
         [Adapter: REST API]
              ↓
[Adapter: CLI] → [Port] → [Domain Core] ← [Port] ← [Adapter: Database]
              ↑
         [Adapter: Message Queue]
```

**Validation checklist**:
- [ ] Domain core has no external dependencies
- [ ] Ports are defined as interfaces/protocols in the domain
- [ ] Adapters implement ports and handle external communication
- [ ] Adapters can be swapped without changing the domain
- [ ] Tests use test adapters (fakes/stubs) for ports

### Modular / Feature-Based Architecture

Code organized by feature/domain rather than by technical role.

```
features/
├── authentication/
│   ├── ui/
│   ├── domain/
│   └── data/
├── user-profile/
│   ├── ui/
│   ├── domain/
│   └── data/
└── shared/
    ├── components/
    ├── utilities/
    └── models/
```

**Validation checklist**:
- [ ] Each feature module is self-contained
- [ ] Features don't import other features directly
- [ ] Shared code is in a dedicated shared/common module
- [ ] Cross-feature communication uses events, protocols, or a mediator
- [ ] Each feature module has its own tests

---

## Common Component Patterns

### MVC (Model-View-Controller)

```
User → Controller → Model
         ↓            ↓
       View  ←  ←  ←  ↓ (data updates)
```

**Validation checklist**:
- [ ] Controllers handle user input and coordinate between Model and View
- [ ] Models contain business logic and data
- [ ] Views only handle display, no business logic
- [ ] Controllers don't contain business logic (delegate to models/services)
- [ ] Views don't directly access models (go through controller)

**Common violations**: "Massive Controller" — controller accumulates business logic, data access, and view logic.

### MVVM (Model-View-ViewModel)

```
View ←→ ViewModel → Model/Service
(data binding)    (business logic)
```

**Validation checklist**:
- [ ] Views bind to ViewModel properties (reactive or observable)
- [ ] ViewModels expose display-ready data (formatted, filtered, sorted)
- [ ] ViewModels don't reference view/UI types
- [ ] ViewModels receive dependencies via injection, not creation
- [ ] Business logic lives in ViewModel or dedicated services, not Views
- [ ] Navigation is handled outside ViewModel (coordinator, router, etc.)

**Common violations**: ViewModel importing UI framework, Views doing data transformation, ViewModel creating its own dependencies.

### MVP (Model-View-Presenter)

```
View ←→ Presenter → Model/Service
(via interface)   (business logic)
```

**Validation checklist**:
- [ ] View implements a view interface/protocol
- [ ] Presenter communicates with View only through the interface
- [ ] Presenter contains presentation logic
- [ ] View is passive (no logic, just displays what Presenter says)
- [ ] Presenter is testable without View (via mock view interface)

### Repository Pattern

Abstracts data access behind a clean interface.

```
Business Logic → Repository Interface → Repository Implementation → Data Source
                                                                     (DB, API, Cache)
```

**Validation checklist**:
- [ ] Repository exposes domain-oriented methods (`getActiveUsers()` not `query("SELECT...")`)
- [ ] Repository interface lives in the business/domain layer
- [ ] Repository implementation lives in the data/infrastructure layer
- [ ] Repository handles data source details (caching, pagination, error mapping)
- [ ] Business logic doesn't know about data source internals

**Common violations**: Repository containing business rules, business logic using raw queries, repository leaking data source types.

### Service Pattern

Encapsulates business operations that span multiple entities.

**Validation checklist**:
- [ ] Services contain business logic that doesn't belong to a single entity
- [ ] Services are stateless (receive everything they need as parameters)
- [ ] Services use dependency injection for their dependencies
- [ ] Services have clear, focused interfaces
- [ ] Services don't contain presentation or data access logic

---

## Dependency Management Patterns

### Dependency Injection (DI)

Dependencies are provided to a component rather than created by it.

**Validation checklist**:
- [ ] Dependencies injected via constructor, method parameters, or DI container
- [ ] No `new` / direct instantiation of dependencies inside business logic
- [ ] Dependencies defined as interfaces/protocols (not concrete types)
- [ ] DI container/configuration is centralized
- [ ] Test doubles can be substituted for all dependencies

### Service Locator

A registry that provides dependencies on request. Less preferred than DI but common.

**Validation checklist**:
- [ ] Service locator is centralized, not duplicated
- [ ] Registrations happen at startup/configuration time
- [ ] Dependencies are still accessed via interfaces/protocols
- [ ] Test setup can override registrations

### Factory Pattern

Creates objects without exposing creation logic.

**Validation checklist**:
- [ ] Factories encapsulate complex object creation
- [ ] Consumers depend on the factory interface, not the concrete factory
- [ ] Factory methods return interfaces/protocols, not concrete types
- [ ] Factory is used when creation requires decisions or configuration

---

## Universal Refactoring Strategies

When violations are found, these strategies guide resolution:

### 1. Extract
- **Extract Method**: Long function → smaller, named functions
- **Extract Class**: God class → focused classes with single responsibilities
- **Extract Module**: Monolith → modules with clear boundaries
- **Extract Interface**: Concrete dependency → interface + implementation

### 2. Move
- **Move to Correct Layer**: Data access in presentation → move to data layer
- **Move to Correct Module**: Cross-cutting concern → shared module
- **Move Business Logic**: Logic in view/controller → service or domain layer

### 3. Replace
- **Replace Inheritance with Composition**: Deep hierarchy → composition + delegation
- **Replace Conditional with Polymorphism**: switch/if-else chains → strategy/polymorphism
- **Replace Magic Values with Constants**: Literals → named constants or enums
- **Replace Manual Work with Framework**: Hand-rolled solutions → framework/library features

### 4. Simplify
- **Simplify Conditional Logic**: Nested conditions → guard clauses / early returns
- **Simplify Dependency Graph**: Circular deps → introduce abstractions or mediator
- **Simplify State Management**: Multiple sources of truth → single source + derivation

### 5. Introduce
- **Introduce Abstraction**: Concrete coupling → interface/protocol between components
- **Introduce Pattern**: Ad-hoc logic → recognized design pattern
- **Introduce Tests**: Untested critical path → test coverage

---

## Architecture Smell Summary

Quick reference for the most common architectural smells:

| Smell | Signal | Strategy |
|-------|--------|----------|
| God Class | > 500 lines, multiple responsibilities | Extract classes |
| Feature Envy | Method uses more data from another class | Move method to where data lives |
| Shotgun Surgery | One change requires touching many files | Consolidate related logic |
| Divergent Change | One class changed for many different reasons | Split by responsibility |
| Inappropriate Intimacy | Classes accessing each other's internals | Introduce interfaces |
| Data Clumps | Same group of fields passed around together | Extract into value object |
| Primitive Obsession | Strings/ints for domain concepts | Introduce domain types |
| Long Parameter List | > 4 parameters | Introduce parameter object |
| Middle Man | Class that only delegates | Remove or inline |
| Speculative Generality | Abstractions for unused scenarios | Remove, apply YAGNI |
