# Architecture Validation Reference

This document provides universal principles and strategies for validating code against sound architectural practices. It is **language-agnostic and architecture-agnostic** — it works by teaching you how to validate any codebase against its own declared architecture, not by assuming a specific pattern.

## How to Use This Guide

1. **Read the project's own architecture first**: Check `CLAUDE.md`, `.claude/rules/`, `.github/instructions/`, and project documentation. These are the source of truth for what the project's architecture is — not this file.
2. **Apply universal principles**: The design principles and smell detection below apply to all code regardless of architecture.
3. **Validate against the project's own rules**: Use the methodology in "Project-Specific Validation" to check whether the code respects the boundaries and conventions the project declares.

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
- Business logic importing infrastructure modules directly
- Constructor creating its own dependencies (hard-coded `new` or direct instantiation)
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
- Each module/component should own one concern
- Concerns that change for different reasons should live in different modules
- Cross-cutting concerns (logging, auth, validation) should be centralized, not scattered

---

## Project-Specific Architecture Validation

Rather than matching code against a catalog of known patterns, validate it against **the project's own declared architecture**. Every project has an architecture, whether it's explicitly documented or implied by its structure.

### Step 1: Discover the Project's Architecture

Check these sources in order:

1. **`CLAUDE.md`** and **`.claude/rules/`** — bootstrap-generated architecture docs
2. **`.github/instructions/`** — GitHub Copilot instructions, often describe architecture
3. **`AGENTS.md`** or similar** — agent configuration with architectural context
4. **README, CONTRIBUTING, or architecture docs** — explicit documentation
5. **If none exist**: infer from the module/package structure and dependency graph

What to look for:
- **Declared boundaries**: What modules/layers/packages exist and what are they responsible for?
- **Dependency rules**: Which modules are allowed to depend on which?
- **Naming conventions**: How are things named and organized?
- **Patterns in use**: What patterns does the code actually follow (observable from imports and structure)?

### Step 2: Identify the Code's Role

Determine what role the code under analysis plays within the project's declared architecture:
- What module/package/layer does it belong to?
- What is its stated responsibility?
- What should it depend on, and what should depend on it?

Do NOT assume a specific set of roles (e.g., "presentation/business/data"). Use whatever roles the project itself defines.

### Step 3: Validate Boundary Compliance

Check the code against its own declared boundaries:

- [ ] **Dependencies flow correctly**: The code only imports from modules it's allowed to depend on
- [ ] **No boundary violations**: The code doesn't reach into modules it shouldn't know about
- [ ] **Responsibilities are honored**: The code does what its module is responsible for — nothing more
- [ ] **Abstractions are respected**: If the project uses interfaces/protocols at boundaries, the code goes through them
- [ ] **Conventions are followed**: Naming, file organization, and patterns match the rest of the module

### Step 4: Document Violations

For each boundary violation found:
- What boundary was crossed (e.g., "module A imports module B directly, but the project routes through an interface")
- Where in the code (file and line)
- What the project's architecture expects instead
- Suggested fix

---

## Dependency Management

These principles apply universally to how components obtain their dependencies.

### Dependency Direction
- Dependencies should flow in one direction (whatever direction the project declares)
- Circular dependencies between modules signal a boundary problem
- If module A depends on module B and B depends on A, at least one direction needs an abstraction

### Dependency Provision
- Components should receive dependencies rather than create them
- Dependencies should be substitutable for testing (via injection, configuration, or convention)
- The mechanism (constructor injection, DI container, service locator, module system) matters less than the principle: **consumers shouldn't know how dependencies are built**

### Dependency Visibility
- A component's dependencies should be visible in its interface (constructor, imports, configuration)
- Hidden dependencies (global state, ambient singletons, implicit service location) make code harder to test and reason about
- If a dependency is hidden, it should be documented or made explicit

---

## Universal Refactoring Strategies

When violations are found, these strategies guide resolution:

### 1. Extract
- **Extract Method**: Long function → smaller, named functions
- **Extract Class/Module**: God class → focused units with single responsibilities
- **Extract Interface**: Concrete dependency → abstraction + implementation

### 2. Move
- **Move to Correct Module**: Code in the wrong module → move to where it belongs per the project's architecture
- **Move Logic to Owner**: Logic that operates on another module's data → move to where the data lives
- **Move Cross-Cutting Concern**: Scattered concern → centralized utility or middleware

### 3. Replace
- **Replace Inheritance with Composition**: Deep hierarchy → composition + delegation
- **Replace Conditional with Polymorphism**: switch/if-else chains → strategy/polymorphism
- **Replace Magic Values with Constants**: Literals → named constants or enums
- **Replace Manual Work with Framework**: Hand-rolled solutions → framework/library features

### 4. Simplify
- **Simplify Conditional Logic**: Nested conditions → guard clauses / early returns
- **Simplify Dependency Graph**: Circular deps → introduce abstractions or mediator
- **Simplify State**: Multiple sources of truth → single source + derivation

### 5. Introduce
- **Introduce Abstraction**: Concrete coupling → interface/protocol between components
- **Introduce Pattern**: Ad-hoc logic → recognized design pattern appropriate for the project
- **Introduce Tests**: Untested critical path → test coverage

---

## Architecture Smell Summary

Quick reference for the most common architectural smells. These are universal — they appear in any codebase regardless of architecture style.

| Smell | Signal | Strategy |
|-------|--------|----------|
| God Class | > 500 lines, multiple responsibilities | Extract classes/modules |
| Feature Envy | Method uses more data from another module than its own | Move method to where data lives |
| Shotgun Surgery | One change requires touching many files | Consolidate related logic |
| Divergent Change | One module changed for many different reasons | Split by responsibility |
| Inappropriate Intimacy | Modules accessing each other's internals | Introduce abstractions at boundary |
| Data Clumps | Same group of fields passed around together | Extract into value object |
| Primitive Obsession | Strings/ints for domain concepts | Introduce domain types |
| Long Parameter List | > 4 parameters | Introduce parameter object |
| Middle Man | Module that only delegates | Remove or inline |
| Speculative Generality | Abstractions for unused scenarios | Remove, apply YAGNI |
