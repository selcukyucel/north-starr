---
name: bootstrap
description: Generate native Claude Code configuration for an existing project. Explores the codebase and produces CLAUDE.md files, .claude/rules/, and .claude/agents/ so Claude Code works effectively from the first task. Run once per project.
---

# Project Bootstrap — Claude Code Configuration Generator

## Purpose

Explore an existing project and generate native Claude Code configuration so it works effectively from the first task. Runs once, produces artifacts that Claude Code auto-loads and auto-enforces.

**Outputs:**
- `CLAUDE.md` files — project and module-level context (auto-loaded by Claude Code)
- `.claude/rules/*.md` — conventions and constraints scoped by file path (auto-enforced)
- `.claude/agents/*.md` — project-tuned specialized agents (reusable on-demand)

## When to Use

- First time working on an existing project with Claude Code
- When `.claude/` directory is empty or missing project-specific configuration
- When onboarding to a new codebase

## Prerequisites

- The project root must be accessible
- Git history is helpful but not required (used for churn analysis)

## Workflow

### Step 1: Explore & Detect

**Goal:** Understand the shape and stack of the project before reading code.

**Actions:**
1. Identify the technology stack from config files at the root (package managers, build tools, language configs, CI/CD)
2. Map the top-level directory structure — modules, packages, feature areas
3. Identify entry points (main files, app delegates, index files, server entry points)
4. Check for existing documentation (README, docs/, inline doc comments)
5. Note the build system, test runner, and deployment mechanism

**Output:** Mental model of project structure. No files written yet.

### Step 2: Identify Architecture & Grain

**Goal:** Understand the architectural pattern and which direction changes flow easily.

**Actions:**
1. Determine the high-level architecture:
   - Pattern: MVC, MVVM, Clean Architecture, Hexagonal, etc.
   - Topology: monolith, microservices, modular monolith, serverless, etc.
   - Communication: client-server, event-driven, message-based, etc.
2. Map layers and their responsibilities (presentation, domain, data, infrastructure)
3. Identify the **grain** — which changes are easy vs. hard:
   - Adding a new feature: what files must change?
   - Adding a new data model: what layers are affected?
   - Changes that go against the grain are friction sources
4. Note framework conventions that shape the architecture:
   - Dependency injection approach
   - State management strategy
   - Navigation / routing pattern
   - Error handling conventions

### Step 3: Discover Patterns

**Goal:** Understand "how things are done here" so new code follows conventions.

**Actions:**
1. Pick 3-5 representative modules (by: most imported, most recently active, or central to the architecture)
2. Identify recurring patterns:
   - Feature file layout and structure
   - Data fetching and transformation
   - Error handling and user-facing error surfacing
   - State management and propagation
   - Dependency provision
   - Test organization and style
3. Look for shared utilities, base classes, or helpers reused across modules
4. Note naming conventions — file names, types, functions, variables

### Step 4: Detect Danger Zones

**Goal:** Identify high-friction areas before anyone gets burned.

**Actions:**
1. **Complexity hotspots:** Large files (500+ lines), deeply nested logic, functions with many parameters (5+), classes with many responsibilities
2. **Developer warnings:** Search for `TODO`, `FIXME`, `HACK`, `XXX`, `WORKAROUND`, `TEMPORARY` comments
3. **Git churn** (if git history available):
   ```bash
   git log --since="6 months ago" --pretty=format: --name-only | sort | uniq -c | sort -rn | head -20
   ```
4. **Test gaps:** Modules or features with no test coverage
5. **Documentation gaps:** Complex logic with no comments or README

### Step 5: Generate Configuration

**Goal:** Produce configuration files for the AI tools in use. Generate all sections below. The content is the same — only the file locations differ per tool.

---

#### A. Project Context (root-level)

Write the project context to all applicable locations:

- `CLAUDE.md` — Claude Code (auto-loaded)
- `AGENTS.md` — Universal (works with any AI tool)
- `.github/copilot-instructions.md` — VS Code Copilot (auto-loaded)

All three get the same content:

```markdown
# [Project Name]

[One-sentence project description]

## Tech Stack

[Languages, frameworks, key dependencies, build tools, test runner]

## Architecture

[Pattern, topology, layers and their responsibilities]

## Grain

[What changes easily, what is hard, what to avoid going against]

## Module Map

[Top-level modules/packages with one-line descriptions, key dependencies between them, shared infrastructure]

## Vocabulary

[Only terms that are ambiguous or have project-specific meanings]

## How to Approach Tasks

**Before starting any task, assess its complexity:**

| Complexity | Signals | Action |
|------------|---------|--------|
| **Low** | Single file, straightforward change, well-understood area | Implement directly |
| **Medium** | 3+ files, unfamiliar area, non-trivial logic, or integration points | Run `/invert` then `/plan` automatically |
| **High** | Wide blast radius, irreversible changes, unfamiliar domain, or critical system | Run `/invert` then `/plan` automatically |

**For Medium and High complexity tasks — do this automatically, don't wait for the user to ask:**
1. Run `/invert` — identify risks, edge cases, and failure modes
2. Run `/plan` — break the work into tracked tasks, using invert's risks as constraints
3. Execute the plan with progress tracking and session notes

**Resuming work:** Always check `.plans/` for active implementation plans before starting new work. If an active plan exists, resume it instead of starting fresh.
```

If any of these files already exist with project-specific content, merge rather than overwrite.

---

#### B. Module-Level Context Files

For each danger zone or complex module found in Step 4, write context in that directory:

- `CLAUDE.md` — Claude Code (auto-loaded when working in that directory)

```markdown
# [Module Name]

[What this module does, how it fits in the architecture]

## Caution

[Specific warnings: race conditions, fragile logic, missing tests, known bugs]

## Patterns

[How this module does things, if different from the project defaults]
```

---

#### C. Path-Scoped Rules

Generate rules scoped by file path. Create in all applicable formats:

**Claude Code** — `.claude/rules/*.md`:
```markdown
---
paths: ["glob/pattern/**"]
---

[Clear, concise instruction or warning]
```

**VS Code Copilot** — `.github/instructions/*.instructions.md`:
```markdown
---
applyTo: "glob/pattern/**"
---

[Same instruction content]
```

**Cursor** — `.cursor/rules/*.mdc`:
```markdown
---
globs: glob/pattern/**
---

[Same instruction content]
```

**What to generate rules for:**
- Naming conventions — scoped to the project's file extensions
- Architecture constraints — what the grain allows and disallows
- Error handling — the project's established pattern
- Danger zone alerts — scoped to specific risky directories

**Guidelines:**
- Generate only rules that reflect real patterns found in the codebase
- Do not invent rules for patterns that don't exist
- Use specific path globs — broad rules waste context on irrelevant files
- Keep each rule file focused on one concern
- The content is the same across tools — only the frontmatter format differs

---

#### D. Agents

**Claude Code** — `.claude/agents/*.md`:

```yaml
---
name: [project]-explorer
description: Deep exploration and analysis of the [project] codebase
model: sonnet
tools: Read, Glob, Grep
memory: project
---
```

**VS Code Copilot** — `.github/agents/*.agent.md`:

```yaml
---
name: [project]-explorer
description: Deep exploration and analysis of the [project] codebase
tools: codebase
---
```

The agent prompt should include:
- The discovered architecture and grain
- Key modules and their relationships
- Known danger zones to watch for

Generate additional agents only if the project clearly warrants them. Default to one.

## Post-Bootstrap Checklist

- [ ] Project context at root — `CLAUDE.md`, `AGENTS.md`, `.github/copilot-instructions.md`
- [ ] Module-level `CLAUDE.md` for each identified danger zone
- [ ] Path-scoped rules — `.claude/rules/`, `.github/instructions/`, `.cursor/rules/`
- [ ] At least one project-tuned agent

## Output Summary

After completing all steps, present:

```
## Bootstrap Complete

**Project:** [name]
**Tech Stack:** [languages, frameworks, tools]
**Architecture:** [pattern, layers]
**Grain:** [easy changes vs. hard changes]

**Files Generated:**

Universal:
- AGENTS.md — [sections included]

Claude Code:
- CLAUDE.md — [sections included]
- [N] .claude/rules/ files — [list names]
- [N] .claude/agents/ files — [list names]

VS Code Copilot:
- .github/copilot-instructions.md
- [N] .github/instructions/ files — [list names]
- [N] .github/agents/ files — [list names]

Cursor:
- [N] .cursor/rules/ files — [list names]

Module-level:
- [N] CLAUDE.md files — [list directories]

**Recommended First Read:** [2-3 files a newcomer should read first]
**Key Danger Zones:** [areas to approach with caution]
```

## Notes

- This skill is language-agnostic — it detects the project's stack and generates appropriate configuration
- This skill is tool-agnostic — it generates config for Claude Code, VS Code Copilot, and Cursor simultaneously
- Can be run incrementally — bootstrap just the area you're working in, expand later
- Do not try to document everything — focus on what reduces friction for the next task
- Prefer breadth over depth: shallow understanding of the whole project beats deep knowledge of one module
- Generate only rules for patterns that actually exist — never invent conventions
- If the project already has configuration, build on what exists rather than overwriting
- The generated configuration is a starting point — it improves through subsequent `/learn` invocations
