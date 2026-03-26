---
name: bootstrap
description: Generate AI tool configuration for an existing project. Explores the codebase and produces context files, path-scoped pattern rules, landmine rules, and agents for Claude Code and VS Code Copilot. Run once per project.
---

# Project Bootstrap — AI Tool Configuration Generator

## Purpose

Explore an existing project and generate native configuration for the AI tools in use so they work effectively from the first task. Runs once, produces artifacts that each tool auto-loads and auto-enforces.

**Outputs per tool:**

| Artifact | Claude Code | VS Code Copilot |
|----------|-------------|-----------------|
| Project context | `CLAUDE.md` | `AGENTS.md` |
| Pattern rules | `.claude/rules/*.md` | `.github/instructions/*.instructions.md` |
| Landmine rules | `.claude/rules/*.md` | `.github/instructions/*.instructions.md` |
| Agents | `.claude/agents/*.md` | `.github/agents/*.agent.md` |
| Module context | `CLAUDE.md` (in module dir) | — |
| Universal | `AGENTS.md` | `AGENTS.md` |

Pattern and landmine rules use the same content — only the frontmatter format differs per tool.

**Generate artifacts for the tool currently in use.** If running inside Claude Code, generate Claude Code artifacts. If running via VS Code Copilot, generate Copilot artifacts. `AGENTS.md` is always generated (universal).

## Pre-flight: Auto-sync Check

Before starting, read the root `CLAUDE.md` (if it exists and is not a starter template). If `## How to Approach Tasks` appears AFTER `## Tech Stack` or `## Architecture`, the file has an outdated section order. Silently run `/sync` to fix it before continuing with this skill.

## When to Use

- First time working on an existing project with any AI coding tool
- When project-specific AI configuration is empty or missing
- When onboarding to a new codebase

## Prerequisites

- The project root must be accessible
- Git history is helpful but not required (used for churn analysis)

## Content Depth

Generated rules must carry enough depth to be genuinely useful. Use two content structures from the project's knowledge base:

- **Pattern structure** (`skills/_references/patterns/_TEMPLATE.md`) — for conventions and reusable approaches. Each pattern rule follows the full template: Virtues, When to Use, Problem It Solves, Core Approach with step-by-step code examples, Complete Example, Best Practices, Common Mistakes with wrong/fix code, Variations, Testing This Pattern, Performance Considerations, Related patterns and landmines.
- **Landmine structure** (`skills/_references/landmines/_TEMPLATE.md`) — for danger zones and known traps. Each landmine rule follows the full template: Severity with evidence, Threatens (virtues endangered), Symptoms, Root Cause, The Trap (why devs fall in), Safe Approach (Don't/Do with code), Validation, Real-World Impact, Prevention, Related patterns and landmines, Origin.
- **Code Virtues** (`skills/_references/virtues/code-virtues.md`) — the 7 code virtues (Working, Unique, Simple, Clear, Easy, Developed, Brief) used to tag patterns and landmines. Higher virtues take precedence.

**Line limits:**
- **Context files** (CLAUDE.md, AGENTS.md): MUST stay under **100 lines** (max 125 if critical context would be lost). Split into multiple scoped files rather than exceeding.
- **Pattern and landmine rules**: Should be as detailed as needed to follow the full template — typically **50-150 lines**. Depth and working code examples matter more than brevity. These are the project's knowledge base.

## Workflow

### Step 1: Explore & Detect

**Goal:** Understand the shape and stack of the project before reading code.

**Actions:**

1. **Detect the technology stack** — Read config files at the root to identify:
   - **Language & version**: look for `Package.swift`, `pyproject.toml`, `setup.py`, `requirements.txt`, `Cargo.toml`, `go.mod`, `package.json`, `tsconfig.json`, `Gemfile`, `build.gradle`, `pom.xml`, `*.csproj`, `Makefile`, `CMakeLists.txt`, etc.
   - **Package manager**: SPM, pip/poetry/uv, cargo, go modules, npm/yarn/pnpm, bundler, gradle/maven, NuGet, etc.
   - **Build system**: Xcode, webpack/vite/esbuild, cargo, go build, make, gradle, etc.
   - **Test runner**: XCTest, pytest, cargo test, go test, jest/vitest, RSpec, JUnit, etc.
   - **CI/CD**: `.github/workflows/`, `.gitlab-ci.yml`, `Jenkinsfile`, `.circleci/`, etc.
   - **Containerization**: `Dockerfile`, `docker-compose.yml`, `k8s/` manifests
   - **Linting/formatting**: `.eslintrc`, `ruff.toml`, `.swiftlint.yml`, `.rubocop.yml`, `rustfmt.toml`, etc.

2. **Map the top-level directory structure** — modules, packages, feature areas. Run `ls` at root and one level deep to understand layout.

3. **Identify entry points** — main files, app delegates, index files, server entry points, CLI entry points.

4. **Check for existing documentation** — README, docs/, architecture decision records, inline doc comments, OpenAPI specs.

5. **Note the build system, test runner, and deployment mechanism.**

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

**Goal:** Build a comprehensive catalogue of "how things are done here" so new code follows conventions and the knowledge survives across sessions.

**Scope: Analyze ALL modules, not a sample.** Walk the entire codebase systematically. A 3-5 module sample misses cross-cutting patterns, infrastructure conventions, and operational practices that only surface when looking broadly.

**Actions:**

1. **Map every module** — list all top-level directories/packages. Group them by role (feature modules, shared libraries, infrastructure, configuration, tests, scripts, deployment).

2. **Scan each group for recurring patterns.** Look for conventions in these areas — not all will apply to every project, focus on what the codebase actually uses:
   - **Structure** — how features, modules, or components are organized and laid out
   - **Data flow** — how data enters, moves through, and exits the system
   - **Dependencies** — how components get what they need (injection, imports, configuration)
   - **Error handling** — how errors are caught, surfaced, and recovered from
   - **State** — how state is managed, shared, and synchronized
   - **External boundaries** — how the system communicates with anything outside itself
   - **Testing** — how tests are organized, what's mocked, what's tested end-to-end
   - **Build & deploy** — how the project is built, packaged, and shipped
   - **Naming** — file names, types, functions, variables, constants

3. **Look for shared utilities, base classes, protocols, or helpers** reused across modules — these often encode implicit patterns worth documenting explicitly.

4. **Cross-reference patterns** — build a relationship map before writing any rule files:
   - Which patterns **compose** (used together in the same flow)?
   - Which patterns are **alternatives** (different approaches to the same problem)?
   - Which landmines does each pattern **prevent**?
   - Which landmines result from **misapplying** a pattern?
   Every rule's "Related" section must reference at least one other rule. If a pattern has no relationships, it's either too generic or you missed a connection.

5. **For each discovered pattern**, capture using the **full pattern structure** from `skills/_references/patterns/_TEMPLATE.md`:
   - **Virtues** — tag with the primary virtue(s) the pattern serves (from `skills/_references/virtues/code-virtues.md`: Working, Unique, Simple, Clear, Easy, Developed, Brief)
   - **When to Use / Not Good For** — specific situations
   - **Problem It Solves** — what goes wrong without it, what improves with it
   - **Core Approach** — step-by-step with code examples from the actual codebase
   - **Complete Example** — a full working example demonstrating the pattern end-to-end
   - **Best Practices** — do this, why
   - **Common Mistakes** — wrong approach with code, fix with code
   - **Variations** — alternative forms of the pattern found in the codebase
   - **Testing This Pattern** — how to verify correct application, with test code example
   - **Performance Considerations** — any performance implications and mitigations
   - **Related** — links to other patterns and landmines

**Aim for completeness.** A thorough bootstrap should discover 15-40 patterns depending on project complexity. If you find fewer than 10, you likely stopped too early — revisit areas beyond the core feature code (build, deploy, testing, configuration, shared infrastructure).

### Step 4: Detect Danger Zones

**Goal:** Build a comprehensive map of every area where developers can get burned — from code-level traps to operational pitfalls.

**Scope: Look everywhere, not just code hotspots.** Danger zones exist in configuration, deployment, infrastructure, third-party integrations, and operational procedures — not only in source code.

**Actions:**

1. **Complexity hotspots** — large files, deeply nested logic, functions with many parameters, types with many responsibilities. These areas break easily and are hard to modify safely.

2. **Misleading abstractions** — code that doesn't do what its name suggests, dead code paths, unused parameters that look required. These trap developers into wrong assumptions.

3. **Silent failures** — swallowed errors, empty catch blocks, default fallbacks that hide problems. These make debugging nearly impossible.

4. **Developer warnings** — search for `TODO`, `FIXME`, `HACK`, `XXX`, `WORKAROUND`, `TEMPORARY` comments. Each one is a documented landmine left by a previous developer.

5. **Git churn** (if git history available):
   ```bash
   git log --since="6 months ago" --pretty=format: --name-only | sort | uniq -c | sort -rn | head -20
   ```
   Files changed most frequently often contain instability or poorly understood behavior.

6. **External boundaries** — anywhere the system communicates with something outside itself (APIs, services, SDKs, hardware, file systems). These are where assumptions break and failures cascade.

7. **Configuration sensitivity** — settings, credentials, feature flags, or environment-specific behavior where a wrong value causes silent or catastrophic failure.

8. **Resource management** — anything the system allocates, opens, or acquires that must be released, closed, or returned. Leaks here cause gradual degradation.

9. **Test gaps** — modules or features with no test coverage. Untested code is a landmine waiting to detonate.

10. **For each danger zone**, capture using the **full landmine structure** from `skills/_references/landmines/_TEMPLATE.md`:
    - **Severity** — CRITICAL / HIGH / MEDIUM / LOW based on real-world impact. Justify with evidence (file counts, specific instances found, blast radius).
    - **Threatens** — tag with the virtue(s) this landmine endangers (from `skills/_references/virtues/code-virtues.md`: Working, Unique, Simple, Clear, Easy, Developed, Brief)
    - **Symptoms** — observable signs you've hit this
    - **Root Cause** — technical explanation of why this happens
    - **The Trap** — why it seems correct, what makes it non-obvious
    - **Safe Approach** — Don't (dangerous code with explanation) / Do (safe code with explanation)
    - **Validation** — how to verify you're safe, detection in existing code
    - **Real-World Impact** — what actually happens when this goes wrong (cite specific instances found in the codebase)
    - **Prevention** — habits, code review checks, and validation steps
    - **Related** — safe patterns that avoid this, other related landmines
    - **Origin** — how/when this was discovered during bootstrap analysis

**Aim for completeness.** A thorough bootstrap should discover 5-15 landmines depending on project maturity. If you find fewer than 3, you likely stopped too early — revisit areas beyond the core feature code.

### Step 4b: Quality Gate — Self-Review Before Writing

**Goal:** Catch gaps and inconsistencies before generating files. This step is mental — no files written.

**Checks:**

1. **Coverage check** — Does every major module have at least one pattern or landmine? If a module has neither, revisit it — you may have missed something.
2. **Template completeness** — Does every pattern have ALL required sections from the reference template (Virtues, When to Use, Problem, Pattern with code, Complete Example, Best Practices, Common Mistakes, Variations, Testing, Performance, Related)? Does every landmine have ALL required sections (Severity with evidence, Threatens, Symptoms, Root Cause, Trap, Safe Approach, Validation, Real-World Impact, Prevention, Related, Origin)?
3. **Path glob review** — For each rule, verify the glob matches only the files where the pattern actually applies. If you used a broad glob like `**/*.ext` or `**/src/**`, narrow it.
4. **Cross-reference integrity** — Every pattern's "Related" section should link to at least one other pattern or landmine. Every landmine's "Related" should link to the safe pattern that avoids it.
5. **Code example audit** — Every code example must use the project's actual types, imports, and conventions. No placeholder names like `MyService` or `doSomething()` unless the project itself uses those names.
6. **Deduplication** — No two rules should cover the same concern. If two rules overlap, merge them or clarify their distinct scopes.

If any check fails, fix it before proceeding to Step 5.

### Step 5: Generate Configuration

**Goal:** Produce configuration files for the current AI tool. Generate all sections below. The content is the same — only the file locations differ per tool.

---

#### A. Project Context (root-level)

Write the project context to these locations:

- `CLAUDE.md` — Claude Code (auto-loaded). Uses plain text prompts for user approval gates.
- `AGENTS.md` — Universal / VS Code Copilot (auto-loaded). Uses `vscode_askQuestions` for user approval gates.

All context files share the same project content (Tech Stack, Architecture, Grain, Module Map). The only difference is the **managed sections** — `CLAUDE.md` uses plain text prompts while `AGENTS.md` uses `vscode_askQuestions` for interactive approval gates.

**Section order matters** — instructional sections (How to Approach Tasks, When to Learn) come FIRST so the AI tool sees them before project context.

**Managed sections must be copied verbatim.** Read the template file first, then copy the managed sections (everything between `<!-- [NORTH-STARR:*] -->` and `<!-- [/NORTH-STARR:*] -->` markers, including the markers themselves) character-for-character into the generated file. Do NOT paraphrase, simplify, summarize, or rewrite these sections — they contain precise instructions (assessment tables, decision rules, workflow steps) that must be preserved exactly.

- For `CLAUDE.md`: read `templates/CLAUDE.md` and copy the `how-to-approach-tasks` and `auto-learn` managed sections verbatim
- For `AGENTS.md`: read `templates/AGENTS.md` and copy the managed sections verbatim

Project context sections are identical across all files:

```markdown
## Tech Stack

[List languages with versions, frameworks, key dependencies, build tools, package manager, test runner, CI/CD — be specific, not generic]

## Architecture

[Name the pattern (MVVM, Clean, etc.), topology (monolith, modular, etc.). List each layer with its responsibility and dependency direction. Include DI approach and state management strategy.]

## Grain

[What changes easily (e.g. adding a new feature screen) vs. what is hard (e.g. changing navigation pattern). State what to avoid going against and why.]

## Module Map

[List each top-level module with one-line purpose. Show key dependencies between modules. Note shared infrastructure.]
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

#### C. Pattern Rules & Landmine Rules

Generate pattern and landmine rules for the current tool. The content is the same — only the file location and frontmatter format differ per tool.

**File formats per tool:**

**Claude Code** — `.claude/rules/*.md`:
```markdown
---
paths: ["glob/pattern/**"]
---

[Rule content]
```

**VS Code Copilot** — `.github/instructions/*.instructions.md`:
```markdown
---
applyTo: "glob/pattern/**"
---

[Same rule content]
```

**Pattern Rules** — one rule file per pattern discovered in Step 3.

Follow the **full pattern template** from `skills/_references/patterns/_TEMPLATE.md`. Each pattern rule file must include:

- **Category**, **Language/Framework**, and **Virtues** (which code virtues this pattern serves — see `skills/_references/virtues/code-virtues.md`)
- `## When to Use` — Good For / Not Good For
- `## Problem It Solves` — what goes wrong without it, what improves with it
- `## The Pattern` — core idea, step-by-step with code examples from the actual codebase, complete working example
- `## Best Practices` — do this, why
- `## Common Mistakes` — wrong code with explanation, fix code with explanation
- `## Variations` — alternative forms found in the codebase
- `## Testing This Pattern` — how to verify correct application with test code example
- `## Performance Considerations`
- `## Related` — links to related pattern and landmine rule files

**File naming:** `[descriptive-name]-pattern.md` (e.g. `caching-pattern.md`, `repository-pattern.md`)

---

**Landmine Rules** — one rule file per danger zone discovered in Step 4.

Follow the **full landmine template** from `skills/_references/landmines/_TEMPLATE.md`. Each landmine rule file must include:

- **Severity** (CRITICAL / HIGH / MEDIUM / LOW) with evidence justification, **Category**, and **Threatens** (which code virtues this landmine endangers — see `skills/_references/virtues/code-virtues.md`)
- `## Quick Summary` — one-line description
- `## Symptoms` — observable signs you've hit this
- `## Root Cause` — technical explanation of why this happens
- `## The Trap` — why developers fall in, what makes it non-obvious
- `## Safe Approach` — Don't (dangerous code with explanation) / Do (safe code with explanation). Code examples must use the project's actual types and conventions.
- `## Validation` — how to verify you're safe, detection patterns in existing code (include grep/search commands)
- `## Real-World Impact` — what actually happens when this goes wrong. Cite specific instances found in the codebase (file names, line counts, blast radius).
- `## Prevention` — habits, code review checks, validation steps
- `## Related` — safe pattern rules that avoid this, other related landmine rules
- `## Origin` — how/when this was discovered during bootstrap analysis

**File naming:** `[descriptive-name].md` (e.g. `broken-exists-method.md`, `silent-auth-failure.md`)

---

**What to generate rules for:**

Create one rule file per pattern or landmine discovered in Steps 3 and 4. Patterns become pattern rules, danger zones become landmine rules. The specific concerns depend on the project — generate rules only for what was actually found in the codebase.

**Guidelines:**
- Generate only rules that reflect real patterns or dangers found in the codebase — never invent conventions
- Use specific path globs — broad rules waste context on irrelevant files. Path globs must be as narrow as possible to match only files where the pattern applies. **Anti-patterns:** `**/*`, `**/Sources/**`, or `**/*.py` (matches everything). **Good examples:** `**/Sources/Feature/**/*ViewModel*`, `**/tests/integration/**`, `**/src/api/routes/**/*.ts`, `**/models/**/*repository*`. When a pattern applies to a specific file naming convention (e.g., files ending in `ViewModel`, `Service`, `_test.py`), include that in the glob. When it applies to a specific directory subtree, scope the glob to that subtree.
- Keep each rule file focused on one concern
- Include code examples in every rule — abstract descriptions without code are not actionable
- Pattern and landmine rules should be as detailed as the templates require — typically 50-150 lines. Depth matters.
- The content is the same across tools — only the frontmatter format differs
- Include a `_TEMPLATE.md` in the rules directory for future contributions via `/learn`. The generated `_TEMPLATE.md` MUST be derived from the reference templates (`skills/_references/patterns/_TEMPLATE.md` and `skills/_references/landmines/_TEMPLATE.md`). It must include ALL sections from both templates — Virtues/Threatens tags, Testing This Pattern, Performance Considerations, Complete Example, Changelog, and Origin fields. Combine both pattern and landmine structures into one unified template with comments indicating which sections apply to which type. The template's Language field and code fence language must match the project's detected language — never hardcode a specific language.

---

#### D. Agents

Generate the layoutplan agent for the current tool:

**Claude Code** — `.claude/agents/layoutplan.md`:

```yaml
---
name: layoutplan
description: Build implementation plans from inversion analysis. Reads .plans/INVERT-*.md files and project context to produce structured, session-surviving plan files.
model: opus
tools: Read, Write, Glob, Grep
memory: project
---
```

**VS Code Copilot** — `.github/agents/layoutplan.agent.md`:

```yaml
---
name: layoutplan
description: Build implementation plans from inversion analysis. Reads .plans/INVERT-*.md files and project context to produce structured, session-surviving plan files.
tools: codebase
---
```

The layoutplan agent is spawned by `/invert` to build implementation plans on a separate thread, keeping the main context clean for coding.

Generate the storymap agent for the current tool:

**Claude Code** — `.claude/agents/storymap.md`:

```yaml
---
name: storymap
description: Decompose PRDs into epics and user stories. Reads .plans/PRD-*.md files and produces structured story maps with dependencies and priorities. Runs on a separate thread.
model: opus
tools: Read, Write, Glob, Grep
memory: project
---
```

**VS Code Copilot** — `.github/agents/storymap.agent.md`:

```yaml
---
name: storymap
description: Decompose PRDs into epics and user stories. Reads .plans/PRD-*.md files and produces structured story maps with dependencies and priorities. Runs on a separate thread.
tools: codebase
---
```

The storymap agent is spawned by `/decompose` to break down PRDs into prioritized, dependency-mapped user stories on a separate thread.

Generate the chief-ai-po agent for the current tool:

**Claude Code** — `.claude/agents/chief-ai-po.md`:

```yaml
---
name: chief-ai-po
description: AI Product Owner agent. Reads AI project PRDs and produces user stories with inverted failure modes, AI safety stories, graceful degradation criteria, and human oversight checkpoints. Runs on a separate thread.
model: opus
tools: Read, Write, Glob, Grep, Edit
memory: project
---
```

**VS Code Copilot** — `.github/agents/chief-ai-po.agent.md`:

```yaml
---
name: chief-ai-po
description: AI Product Owner agent. Reads AI project PRDs and produces user stories with inverted failure modes, AI safety stories, graceful degradation criteria, and human oversight checkpoints. Runs on a separate thread.
tools: search/codebase
---
```

The chief-ai-po agent is spawned by `/decompose` when it detects an AI project. It produces story maps enriched with AI-specific failure modes, pre-mortem analysis, inverted user stories, graceful degradation criteria, and human oversight checkpoints.

Generate additional project-specific agents only if the project clearly warrants them (e.g., an explorer agent for very large codebases).

## Post-Bootstrap Checklist

**Files:**
- [ ] `AGENTS.md` at root (always)
- [ ] `CLAUDE.md` at root (if running in Claude Code)
- [ ] Module-level `CLAUDE.md` for each identified danger zone (if running in Claude Code)
- [ ] Pattern rules in the current tool's format — aim for 15-40 depending on project complexity
- [ ] Landmine rules in the current tool's format — aim for 5-15 depending on project maturity
- [ ] `_TEMPLATE.md` in the rules directory — must include ALL sections from reference templates
- [ ] `layoutplan` agent in the current tool's agent directory
- [ ] `storymap` agent in the current tool's agent directory
- [ ] `chief-ai-po` agent in the current tool's agent directory
- [ ] At least one project-tuned explorer agent (optional, for large codebases)

**Quality:**
- [ ] Context files (CLAUDE.md, AGENTS.md) are under 100 lines (max 125)
- [ ] Every pattern rule has: Virtues, When to Use, Problem, Pattern with code, Complete Example, Best Practices, Common Mistakes, Variations, Testing, Performance, Related
- [ ] Every landmine rule has: Severity with evidence, Threatens, Symptoms, Root Cause, Trap, Safe Approach, Validation, Real-World Impact, Prevention, Related, Origin
- [ ] No path glob matches the entire codebase (e.g., `**/*` or `**/*.ext`)
- [ ] Every rule's "Related" section links to at least one other rule
- [ ] All code examples use the project's actual types, imports, and conventions — no generic placeholders
- [ ] `_TEMPLATE.md` Language field matches the detected project language

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

Tool-specific:
- [context file] — [sections included]
- [N] rule files — [N] patterns, [N] landmines — [list names]
- [N] agent files — layoutplan, storymap, chief-ai-po [+ any project-specific]

Module-level:
- [N] CLAUDE.md files — [list directories]

**Recommended First Read:** [2-3 files a newcomer should read first]
**Key Danger Zones:** [areas to approach with caution]
```

## Notes

- This skill is language-agnostic — it detects the project's stack and generates appropriate configuration
- Can be run incrementally — bootstrap just the area you're working in, expand later
- Be thorough — analyze the entire codebase, not a sample. Shallow bootstraps produce shallow configuration that misses real patterns and dangers
- Balance breadth and depth: understand the whole project broadly, then go deep on patterns and landmines with full code examples and operational detail
- Generate only rules for patterns that actually exist — never invent conventions
- If the project already has configuration, build on what exists rather than overwriting
- The generated configuration is a starting point — it improves through subsequent `/learn` invocations
