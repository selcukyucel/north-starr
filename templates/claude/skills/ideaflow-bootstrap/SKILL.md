---
name: ideaflow-bootstrap
description: Generate minimum viable project context for AI-assisted development. Produces architecture overview, vocabulary, initial patterns, initial landmines, and module map so the AI can work effectively from the first task. Run once per project. Trigger phrases: "bootstrap this project", "generate project context", "initialize idea flow".
---

# Idea Flow Bootstrap - Project Context Generation

## Purpose

Generate the minimum viable context so the AI can work effectively from the first task on an existing project. This is Phase 0 of the Idea Flow Agentic Workflow v2.0 -- it runs once per project to seed the knowledge base that grows through subsequent work.

**Outputs:**
- Architecture overview (layers, modules, connections, the "grain" of the codebase)
- Vocabulary (codebase-specific terms, naming conventions, resolved ambiguities)
- Initial patterns (how things are typically done here)
- Initial landmines (known trouble spots, complexity hotspots, areas with no tests)
- Module map (what exists, what it does, how it relates)

## When to Use

- First time using the Idea Flow workflow on an existing project
- When onboarding to a new codebase
- When the `.ai/` directory and `.ai/memory/` files are empty or missing project-specific content

**Trigger phrases:**
- "bootstrap this project"
- "generate project context"
- "initialize idea flow"

## Prerequisites

- The project root must be accessible
- Git history is helpful but not required (used for churn analysis in Step 5)

## Workflow

### Step 1: Explore Project Structure

**Goal:** Understand the shape of the project before reading code.

**Actions:**
1. Read project root files to identify the technology stack:
   - `package.json`, `Cargo.toml`, `go.mod`, `Makefile`, `build.gradle`, `*.xcodeproj`, `*.sln`, `pyproject.toml`, `Gemfile`, or equivalent
   - `.editorconfig`, `tsconfig.json`, `swiftlint.yml`, or other tool configs
   - `Dockerfile`, `docker-compose.yml`, CI/CD configs
2. Map the top-level directory structure -- what modules, packages, or feature areas exist
3. Identify entry points (main files, app delegates, index files, server entry points)
4. Check for existing documentation (`README.md`, `docs/`, inline doc comments, wikis)
5. Note the build system, test runner, and deployment mechanism

**Record:** A summary of project structure, tech stack, and entry points.

### Step 2: Identify Architecture

**Goal:** Understand the architectural pattern and the "grain" of the codebase.

**Actions:**
1. Determine the high-level architectural pattern:
   - MVC, MVVM, MVP, VIPER, Clean Architecture, Hexagonal, etc.
   - Monolith, microservices, modular monolith, serverless, etc.
   - Client-server, peer-to-peer, event-driven, etc.
2. Map the layers and their responsibilities:
   - Presentation / UI layer
   - Business logic / domain layer
   - Data / persistence / network layer
   - Infrastructure / platform layer
3. Identify the "grain" -- which direction do changes flow easily?
   - Adding a new feature: what files need to change?
   - Adding a new data model: what layers are affected?
   - Changes that go "against the grain" are friction sources
4. Note framework-specific conventions that shape the architecture:
   - Dependency injection approach
   - State management strategy
   - Navigation / routing pattern
   - Error handling conventions

**Record:** Architecture overview with layer diagram and grain description.

### Step 3: Build Vocabulary

**Goal:** Prevent semantic friction by documenting what terms mean in this codebase.

**Actions:**
1. Identify domain-specific terms used in code, comments, and documentation:
   - Business domain terms (e.g., "subscription", "roster", "campaign")
   - Technical terms with project-specific meanings (e.g., "coordinator" might mean different things in different codebases)
2. Note naming conventions:
   - Case style (camelCase, snake_case, PascalCase, kebab-case)
   - Prefixes or suffixes with meaning (e.g., `I` prefix for interfaces, `DTO` suffix for data transfer objects)
   - File naming conventions (e.g., `*.viewmodel.ts`, `*Repository.swift`)
3. Resolve ambiguous terms -- same word meaning different things in different parts of the codebase
4. Note any abbreviations or acronyms used without explanation

**Save to:** `.ai/memory/vocabulary.md`

### Step 4: Discover Patterns

**Goal:** Understand "how things are done here" so new code follows existing conventions.

**Actions:**
1. Read 3-5 representative modules that appear well-structured and recently maintained
2. Identify recurring code patterns:
   - How are new features structured? (file layout, class hierarchy)
   - How is data fetched and transformed?
   - How are errors handled and surfaced to users?
   - How is state managed and propagated?
   - How are dependencies provided to components?
   - How are tests organized and written?
3. Look for shared utilities, base classes, or helper functions that are reused across modules
4. Note any code generation, macros, or metaprogramming in use

**Save to:** `.ai/patterns/` -- create one pattern file per significant pattern, using the template at `.ai/patterns/_TEMPLATE.md`. Focus on the 2-4 most important patterns that a newcomer would need to follow.

### Step 5: Detect Landmines

**Goal:** Identify areas where friction is likely to be high, before anyone steps on a mine.

**Actions:**
1. **Complexity hotspots:** Scan for large files (500+ lines), deeply nested logic, functions with many parameters (5+), or classes with many responsibilities
2. **Developer warnings:** Search for `TODO`, `FIXME`, `HACK`, `XXX`, `WORKAROUND`, `TEMPORARY`, `BUG` comments -- these are signals from past developers about known issues
3. **Git churn (if git history available):** Check which files change most frequently. High churn often indicates friction:
   ```bash
   git log --since="6 months ago" --pretty=format: --name-only | sort | uniq -c | sort -rn | head -20
   ```
4. **Test gaps:** Identify modules or features with no test coverage
5. **Documentation gaps:** Note areas with no comments, no README, and complex logic -- these are modeling pain zones

**Save to:** `.ai/landmines/` -- create one landmine file per significant danger zone, using the template at `.ai/landmines/_TEMPLATE.md`. Focus on the areas most likely to cause trouble in the near term.

### Step 6: Generate Module Map

**Goal:** Provide a quick-reference map of the entire codebase.

**Actions:**
1. List all top-level modules, packages, or feature areas with a one-line description of each
2. Map key dependencies between modules:
   - Which modules depend on which?
   - What are the shared/core modules that everything uses?
   - Are there circular dependencies?
3. Identify shared infrastructure:
   - Common utilities, extensions, helpers
   - Design system or component library
   - Networking, persistence, and other service layers
4. Note the module boundaries -- where are the seams that allow independent changes?

**Save to:** `.ai/memory/` as a project overview, and reference from `.ai/memory/patterns.md` if relevant.

## Post-Bootstrap Checklist

After running all steps, verify these files exist and contain useful content:

- [ ] `.ai/memory/vocabulary.md` -- updated with project-specific terms
- [ ] `.ai/memory/patterns.md` -- index of discovered patterns
- [ ] `.ai/patterns/` -- 2-4 pattern files for the most important conventions
- [ ] `.ai/landmines/` -- landmine files for the most dangerous areas
- [ ] Module map saved to `.ai/memory/`

## Output

After completing all steps, present a summary:

```
## Bootstrap Summary

**Project:** [name]
**Tech Stack:** [languages, frameworks, tools]
**Architecture:** [pattern, layers]
**Grain:** [which changes are easy, which are hard]

**Modules Discovered:** [count]
**Patterns Documented:** [count] (list with links)
**Landmines Identified:** [count] (list with links)
**Vocabulary Terms Added:** [count]

**Recommended First Read:** [2-3 files a newcomer should read first]
**Known Friction Zones:** [areas to approach with extra caution]

**Files Created/Updated:**
- [list of all files created or modified]
```

## Notes

- This skill is language-agnostic -- it works for any project type (iOS, web, backend, CLI, etc.)
- Can be run incrementally: bootstrap just the module you are about to work in rather than the entire project
- Do not try to document everything -- focus on what reduces friction for the next task
- Check if the `.ai/` directory structure exists before starting; create it if needed:
  ```
  .ai/
  ├── patterns/
  ├── landmines/
  ├── checklists/
  └── tasks/
  ```
- Check if `.ai/memory/` directory exists; create it if needed
- If the project already has partial context (e.g., some patterns documented), build on what exists rather than starting over
- The bootstrap is a starting point, not the final word -- every subsequent LEARN phase (Phase 5) adds more context naturally
- Prefer breadth over depth: a shallow understanding of the whole project is more useful than deep knowledge of one module

## Integration

**Workflow Phase:** Phase 0 (Bootstrap)
**Next Phase:** Phase 1 (SENSE) -- use `/ideaflow-sense` when starting the first real task
**Reference:** See `IDEAFLOW_AGENTIC_WORKFLOW.md` for the full workflow specification

**Version:** 1.0
