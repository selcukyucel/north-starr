---
name: refactoring-analyzer
description: Analyze code modules and files for refactoring opportunities, code smells, and architectural pattern violations in any language or framework. Use this skill when the user asks to "analyze code smells", "find refactoring opportunities", "check for code quality issues", or "review architecture" for a specific module or file.
author: Selcuk Yucel
---

# Refactoring Analyzer

## Overview

Systematically analyze code for refactoring opportunities by checking against comprehensive checklists and architectural principles. This skill identifies code smells, architectural violations, design pattern misuse, and improvement opportunities in **any language or framework**.

## When to Use This Skill

Use this skill when the user requests:
- "Analyze code smells in [module/file]"
- "Find refactoring opportunities in [module/file]"
- "Check [module/file] for architecture violations"
- "Review code quality in [module/file]"
- "What can be improved in [module/file]?"
- "Look for code duplication in [module/file]"

**Important**: This skill analyzes specific modules or files, NOT the entire codebase. The user should specify the scope.

## Analysis Workflow

### Step 1: Determine Scope

Identify what needs to be analyzed from the user's request:

**Module-Level Analysis** (directory with related files):
- A feature module, package, or namespace
- A domain/service layer
- A shared/utility library

**File-Level Analysis**:
- A specific source file
- A specific test file
- A configuration file

If the scope is unclear, ask the user to specify the module or file path.

### Step 2: Detect Language & Context

Before analyzing, identify the project's technology stack:

1. **Language**: Look at file extensions (`.swift`, `.ts`, `.py`, `.go`, `.rs`, `.java`, `.kt`, etc.)
2. **Framework**: Check imports/dependencies (React, SwiftUI, Django, Spring, etc.)
3. **Architecture**: Check for `CLAUDE.md`, `.ai/patterns/`, or other project docs describing the architecture
4. **Conventions**: Check for linter configs (`.eslintrc`, `.swiftlint.yml`, `pyproject.toml`, etc.)

This context shapes which checklist items are most relevant and what patterns to validate against.

### Step 3: Read the Target Code

Use appropriate tools to read the code being analyzed:

**For Module Analysis**:
1. Use `Glob` to find all source files in the module directory
2. Use `Read` to load each file in the module
3. Note the module's purpose and dependencies

**For File Analysis**:
1. Use `Read` to load the specific file
2. Check related files (e.g., if analyzing a view, also read its controller/model/service)

**Context Gathering**:
- Understand the code's purpose and responsibility
- Identify dependencies and relationships
- Note patterns and conventions used
- Check `.ai/patterns/` and `.ai/landmines/` for project-specific knowledge

### Step 4: Apply Refactoring Checklist

Load and apply the comprehensive refactoring checklist from `references/refactoring-checklist.md`.

**How to use the checklist**:

1. **Read the checklist**: Use the Read tool to load `references/refactoring-checklist.md` into context

2. **Scan systematically**: Go through each category relevant to the code type:
   - For UI/View code: Focus on Presentation Layer, State Management, Component Reuse
   - For Business Logic: Focus on Architecture, Code Organization, Error Handling
   - For Data/API code: Focus on API Integration, Error Handling, Async Patterns
   - For Tests: Focus on Testing & Testability, Code Clarity
   - For All code: Always check Architecture, Duplication, Security, Performance

3. **Document findings**: For each issue found, note:
   - Issue category and specific checklist item
   - File and line number (if applicable)
   - Code snippet demonstrating the issue
   - Severity (Critical, High, Medium, Low)

**Severity Guidelines**:
- **Critical**: Security vulnerabilities, data loss risks, crashes, resource leaks
- **High**: Architectural violations, major pattern violations, significant maintainability issues
- **Medium**: Code duplication, missing best practices, moderate complexity
- **Low**: Naming inconsistencies, minor style issues, documentation gaps

### Step 5: Validate Against Architecture

Load and validate against architectural principles from `references/architecture-patterns.md`.

**How to validate**:

1. **Read architecture guide**: Use the Read tool to load `references/architecture-patterns.md` into context

2. **Understand the project's architecture**: Check `CLAUDE.md` and `.ai/patterns/` for project-specific architecture decisions

3. **Identify the code's role**: Determine what architectural component this code represents:
   - Presentation/UI layer
   - Business/domain logic layer
   - Data access/infrastructure layer
   - Shared/utility code

4. **Validate against principles**:
   - Single Responsibility: Does each unit have one clear purpose?
   - Dependency Direction: Do dependencies flow in the correct direction?
   - Abstraction Boundaries: Are layer boundaries respected?
   - Separation of Concerns: Is presentation separate from logic? Logic from data access?

5. **Document violations**: For each architectural violation, note:
   - Expected pattern vs actual implementation
   - File and location
   - Impact on maintainability/testability
   - Suggested refactoring approach

### Step 6: Identify Refactoring Opportunities

Beyond checklist items, look for higher-level refactoring opportunities:

**Extract and Consolidate**:
- Duplicate code that should be extracted to shared utilities
- Custom implementations where framework/library solutions exist
- Repeated logic that should be helper functions or shared modules
- Similar structures that could share a base component or abstraction

**Architectural Improvements**:
- Code in wrong layer that should be moved
- Missing abstractions (interfaces, protocols, base classes)
- Tight coupling that should be loosened
- Missing error handling or edge case handling

**Modern Language Adoption**:
- Old patterns that have modern replacements in the language
- Manual implementations of things the standard library provides
- Imperative code that could be declarative/functional
- Callback/promise chains that could use async/await

**Performance Optimizations**:
- Unnecessary re-computation or re-rendering
- Missing lazy evaluation or caching
- Inefficient algorithms or data structures
- Blocking operations that should be async

### Step 7: Generate Report

Create a comprehensive, actionable report with the following structure:

#### Report Template

```markdown
# Refactoring Analysis: [Module/File Name]

## Summary
- **Language/Framework**: [detected stack]
- **Total Issues Found**: [count]
- **Critical**: [count]
- **High**: [count]
- **Medium**: [count]
- **Low**: [count]

## Critical Issues

### 1. [Issue Title]
**Category**: [Category from checklist]
**Severity**: Critical
**Location**: `[File]:[Line]`

**Description**: [What's wrong and why it's critical]

**Current Code**:
```
[Code snippet showing the issue]
```

**Suggested Fix**:
```
[Code snippet showing the solution]
```

**Impact**: [Why this matters]

---

## High Priority Issues

[Same format as Critical]

---

## Medium Priority Issues

[Same format as Critical]

---

## Low Priority Issues

[Same format as Critical]

---

## Architecture Validation

### Principle Compliance
- [ ] Single Responsibility: each unit has one clear purpose
- [ ] Dependency Direction: dependencies flow correctly
- [ ] Abstraction Boundaries: layer boundaries respected
- [ ] Separation of Concerns: presentation / logic / data separated
- [ ] Naming Conventions: consistent naming throughout

### Violations Found
[List any architectural violations with references]

---

## Refactoring Opportunities

### Extract to Shared Code
[List code that should be extracted with suggestions]

### Existing Solutions to Adopt
[List framework/library features that could replace custom code]

### Modernization Opportunities
[List areas where modern language/framework features could be adopted]

---

## Positive Observations

[List things done well - proper patterns, good practices, etc.]

---

## Recommended Action Plan

1. **Immediate** (Critical/High issues):
   - [Action item]
   - [Action item]

2. **Short-term** (Medium issues):
   - [Action item]
   - [Action item]

3. **Long-term** (Low issues + optimizations):
   - [Action item]
   - [Action item]
```

### Report Guidelines

**Be Specific**:
- Always include file paths and line numbers
- Show actual code snippets, not descriptions
- Provide concrete fix suggestions in the project's language

**Be Actionable**:
- Prioritize issues clearly
- Explain why each issue matters
- Provide working code examples for fixes

**Be Balanced**:
- Include positive observations
- Don't overwhelm with minor issues
- Focus on impactful improvements

**Be Contextual**:
- Consider the code's purpose and constraints
- Acknowledge tradeoffs
- Respect the project's existing conventions and style
- Adapt recommendations to the language/framework idioms

## Tips for Effective Analysis

### Focus on Impact
Prioritize issues that:
- Affect security or stability
- Violate core architectural principles
- Create maintenance burden
- Impact performance noticeably

### Provide Context
For each finding:
- Explain **why** it's an issue
- Show **how** to fix it
- Describe the **impact** of fixing it

### Be Constructive
- Frame issues as opportunities
- Acknowledge good practices when present
- Suggest incremental improvements
- Consider team coding style and constraints

### Use References
- Point to specific checklist items in `refactoring-checklist.md`
- Reference principles in `architecture-patterns.md`
- Check `.ai/patterns/` and `.ai/landmines/` for project-specific knowledge
- Link to relevant language/framework documentation when helpful

## Common Analysis Patterns

### For Presentation/UI Code
1. Check that business logic lives outside the view/template layer
2. Validate component reuse (avoid reinventing existing components)
3. Check state management patterns
4. Review accessibility and edge case handling
5. Check for proper separation of concerns

### For Business Logic / Domain Code
1. Validate single responsibility
2. Check dependency injection / inversion of control
3. Review error handling completeness
4. Verify no UI/presentation dependencies leak in
5. Check for proper abstractions and interfaces

### For Data Access / Infrastructure Code
1. Validate repository/service patterns
2. Check error handling and retry logic
3. Review API integration patterns
4. Verify no business logic leaking into data layer
5. Check for proper resource management (connections, file handles, etc.)

### For Shared / Utility Code
1. Verify no business logic (should be pure utilities)
2. Check reusability and API design
3. Validate proper documentation
4. Review for unnecessary dependencies
5. Check for proper error handling

## Limitations

- This skill analyzes code structure and patterns, not runtime behavior
- Cannot detect all performance issues without profiling
- Cannot validate business logic correctness
- Cannot verify against proprietary external APIs
- Recommendations are based on universal best practices but may need adjustment for specific project contexts
- Language-specific deep analysis may require additional domain knowledge

## References

This skill uses two comprehensive reference documents:

1. **refactoring-checklist.md**: 15 categories covering universal refactoring opportunities
   - Architecture & Design Patterns
   - Code Organization & Structure
   - Presentation / UI Layer
   - State Management
   - Asynchronous Programming
   - API & External Integration
   - Code Duplication
   - Error Handling & Edge Cases
   - Performance & Efficiency
   - Testing & Testability
   - Documentation & Code Clarity
   - Security & Privacy
   - Language Idioms & Modern Features
   - Observability & Monitoring
   - Build, Configuration & Dependencies

2. **architecture-patterns.md**: Universal architectural principles and common patterns
   - Architecture detection guidance
   - Universal design principles (SOLID, DRY, etc.)
   - Common architectural patterns (Layered, Clean, Hexagonal, etc.)
   - Common component patterns (MVC, MVVM, Repository, etc.)
   - Dependency management principles
   - Universal refactoring strategies

These references are loaded into context during analysis to ensure comprehensive and accurate findings.
