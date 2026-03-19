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
| Project context | `CLAUDE.md` | `.github/copilot-instructions.md` |
| Pattern rules | `.claude/rules/*.md` | `.github/instructions/*.instructions.md` |
| Landmine rules | `.claude/rules/*.md` | `.github/instructions/*.instructions.md` |
| Agents | `.claude/agents/*.md` | `.github/agents/*.agent.md` |
| Module context | `CLAUDE.md` (in module dir) | — |
| Universal | `AGENTS.md` | `AGENTS.md` |

Pattern and landmine rules use the same content — only the frontmatter format differs per tool.

**Only artifacts for enabled targets are generated.** Check `.north-starr.json` at the project root to see which tools are enabled. If the file is missing, generate for all tools (backward compatible).

## Tool Target Preferences

Before generating any output, check for `.north-starr.json` in the project root:

```json
{
  "version": 1,
  "targets": ["claude", "copilot"]
}
```

- If the file exists, only generate artifacts for the listed targets
- If the file is missing, ask the user which tools they use, save their answer to `.north-starr.json`, then generate only for those targets
- `AGENTS.md` is always generated regardless of preferences (it's universal)
- Valid targets: `"claude"`, `"copilot"`
- After confirming build and test commands in Step 1, write them to `.north-starr.json`:
  ```json
  {
    "version": 1,
    "targets": ["claude", "copilot"],
    "build": {
      "commands": ["npm run build"]
    },
    "test": {
      "commands": ["npm test"]
    }
  }
  ```

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

- **Pattern structure** (`skills/_references/patterns/_TEMPLATE.md`) — for conventions and reusable approaches. Each pattern rule follows the full template: When to Use, Problem It Solves, Core Approach with step-by-step code examples, Best Practices, Common Mistakes with wrong/fix code, Variations, Related patterns and landmines.
- **Landmine structure** (`skills/_references/landmines/_TEMPLATE.md`) — for danger zones and known traps. Each landmine rule follows the full template: Severity, Symptoms, Root Cause, The Trap (why devs fall in), Safe Approach (Don't/Do with code), Validation, Prevention, Related patterns and landmines.

**Line limits:**
- **Context files** (CLAUDE.md, AGENTS.md, copilot-instructions.md): MUST stay under **100 lines** (max 125 if critical context would be lost). Split into multiple scoped files rather than exceeding.
- **Pattern and landmine rules**: Should be as detailed as needed to follow the full template — typically **50-150 lines**. Depth and working code examples matter more than brevity. These are the project's knowledge base.

## Workflow

### Step 1: Explore & Detect

**Goal:** Understand the shape and stack of the project before reading code.

**Actions:**
1. Identify the technology stack from config files at the root (package managers, build tools, language configs, CI/CD)
2. Map the top-level directory structure — modules, packages, feature areas
3. Identify entry points (main files, app delegates, index files, server entry points)
4. Check for existing documentation (README, docs/, inline doc comments)
5. Note the build system, test runner, and deployment mechanism
6. Detect the build command(s) from project config files:

| Config file found | Build command |
|---|---|
| `Package.swift` | `swift build` |
| `*.xcodeproj` / `*.xcworkspace` | `xcodebuild -scheme <scheme> -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest' build` (ask user for scheme name) |
| `build.gradle` / `build.gradle.kts` | `./gradlew assembleDebug` |
| `Cargo.toml` | `cargo build` |
| `go.mod` | `go build ./...` |
| `package.json` with `build` script | `npm run build` / `yarn build` / `pnpm build` (based on lockfile) |
| `tsconfig.json` (no build script) | `npx tsc --noEmit` |
| `pyproject.toml` with mypy config | `mypy .` |
| `CMakeLists.txt` | `cmake --build build` |
| `Makefile` | `make` |

When multiple config files exist (e.g., full-stack with `package.json` AND `build.gradle`), include all relevant build commands.

Confirm with the user: "I detected the following build command(s): `[commands]`. Is this correct? You can change this later in `.north-starr.json`."

7. Detect the test command(s) from project config files:

| Config file found | Test command |
|---|---|
| `Package.swift` | `swift test` |
| `*.xcodeproj` / `*.xcworkspace` | `xcodebuild test -scheme <scheme> -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest'` (use same scheme as build) |
| `build.gradle` / `build.gradle.kts` | `./gradlew test` |
| `Cargo.toml` | `cargo test` |
| `go.mod` | `go test ./...` |
| `package.json` with `test` script | `npm test` / `yarn test` / `pnpm test` (based on lockfile) |
| `vitest.config.*` | `npx vitest run` |
| `jest.config.*` | `npx jest` |
| `pyproject.toml` or `pytest.ini` | `pytest` |
| `Makefile` with `test` target | `make test` |

Confirm with the user: "I detected the following test command(s): `[commands]`. Is this correct?"

**Output:** Mental model of project structure + confirmed build and test command(s). No files written yet.

### Step 1.5: Validate Declared Config (if present)

**Goal:** If `/architect` was run previously, validate declarations against reality rather than starting from scratch.

**Actions:**
1. Check root context files (`CLAUDE.md`, `AGENTS.md`, `.github/copilot-instructions.md`) for `[DECLARED]` tags
2. Check `.claude/rules/`, `.github/instructions/` for `<!-- Generated by /architect — [DECLARED] -->` markers
3. If `[DECLARED]` tags are found, enter **validation mode** for each declared section:

**Validation outcomes per section:**
- **CONFIRMED** — the code matches the declaration → remove the `[DECLARED]` tag, keep the content
- **DIVERGED** — the code differs from the declaration → present both versions, ask the user which to keep
- **NOT YET** — no code exists yet for this declaration → keep the `[DECLARED]` tag as-is

**Actions in validation mode:**
1. For each `[DECLARED]` section in context files:
   - Compare the declared architecture, grain, module map, and conventions against what the code actually shows
   - Mark each section CONFIRMED, DIVERGED, or NOT YET
2. For each `[DECLARED]` rule:
   - Check if the convention is followed in actual code
   - CONFIRMED rules get their `[DECLARED]` tag removed
   - DIVERGED rules get flagged for user review
   - NOT YET rules (no matching code exists) keep their tag
3. Present a validation summary before making any changes
4. Continue to Step 2 for any areas not covered by declarations (new modules, undeclared patterns)

**If no `[DECLARED]` tags are found**, skip this step and proceed normally.

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

4. **Cross-reference patterns** — note which patterns work together and which are alternatives to each other.

5. **For each discovered pattern**, capture using the **full pattern structure** from `skills/_references/patterns/_TEMPLATE.md`:
   - **When to Use / Not Good For** — specific situations
   - **Problem It Solves** — what goes wrong without it, what improves with it
   - **Core Approach** — step-by-step with code examples
   - **Best Practices** — do this, why
   - **Common Mistakes** — wrong approach with code, fix with code
   - **Variations** — alternative forms of the pattern found in the codebase
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
    - **Severity** — CRITICAL / HIGH / MEDIUM / LOW based on real-world impact
    - **Symptoms** — observable signs you've hit this
    - **Root Cause** — technical explanation of why this happens
    - **The Trap** — why it seems correct, what makes it non-obvious
    - **Safe Approach** — Don't (dangerous code with explanation) / Do (safe code with explanation)
    - **Validation** — how to verify you're safe, detection in existing code
    - **Prevention** — habits, code review checks, and validation steps
    - **Related** — safe patterns that avoid this, other related landmines

**Aim for completeness.** A thorough bootstrap should discover 5-15 landmines depending on project maturity. If you find fewer than 3, you likely stopped too early — revisit areas beyond the core feature code.

### Step 5: Generate Configuration

**Goal:** Produce configuration files for the AI tools in use. Generate all sections below. The content is the same — only the file locations differ per tool.

---

#### A. Project Context (root-level)

Write the project context to enabled target locations:

- `CLAUDE.md` — Claude Code (auto-loaded) — generate if `claude` target is enabled
- `AGENTS.md` — Universal (works with any AI tool) — always generated
- `.github/copilot-instructions.md` — VS Code Copilot (auto-loaded) — generate if `copilot` target is enabled

All context files get the same content. **Section order matters** — instructional sections (How to Approach Tasks, When to Learn) come FIRST so the AI tool sees them before project context:

```markdown
# [Project Name]

[One-sentence project description]

<!-- [NORTH-STARR:how-to-approach-tasks] -->
## How to Approach Tasks

**CRITICAL — BLOCKING REQUIREMENT: You MUST complete this checklist and show it to the user BEFORE using any code-modifying tool (Edit, Write, Agent with code changes). This is NOT optional. Skipping this step is a rule violation.**

**Step 1: Print this complexity assessment (mandatory output before ANY code change):**

| # | Question                                  | Answer      |
|---|-------------------------------------------|-------------|
| 0 | Is current behavior covered by tests?      | [Yes / No]  |
| 1 | How many files will this change?           | [1-2 / 3+]  |
| 2 | Am I creating new types or protocols?      | [No / Yes]  |
| 3 | Is this module unfamiliar to me?           | [No / Yes]  |
| 4 | Does this require cross-module integration?| [No / Yes]  |

→ Complexity: [Low / Medium-High]
→ Action: [State files / Run /invert → layoutplan agent]

**Step 2: Follow the action:**

- **If Q0 is No** → Write tests for current behavior FIRST. The Working virtue (highest priority) must be preserved before any change.
- **If ANY answer is Medium/High** → Run `/invert` BEFORE writing any code. `/invert` will persist its analysis to `.plans/` and spawn the `layoutplan` agent on a separate thread to build the implementation plan — keeping your main context clean for coding. Do not skip. Do not "just start coding."
- **If ALL answers are Low** → State which files you'll change and wait for user confirmation before proceeding.

**Step 3: Write failing tests first (RED):**

Before writing implementation code, write tests that describe the expected new behavior.
These tests SHOULD FAIL — they define what "done" looks like.
Use edge cases and failure modes from the `/invert` analysis if available.
Skip this step only for: config-only changes, documentation, CI/build scripts, or trivial one-line fixes.

**Step 4: Write code to pass tests (GREEN):**

Write the minimum implementation to make the failing tests pass.
If during implementation you discover more files are affected than initially estimated, STOP and run `/invert`.

**Step 5: Post-implementation build check:**

After completing code changes, spawn the `build` agent to verify the project compiles.
The build agent runs on a separate thread — keeping error output out of your main context.
If the build agent reports failures it cannot fix, address the remaining errors before continuing.

**Step 6: Post-implementation test check:**

After the build passes, spawn the `test` agent to run the full test suite.
The test agent fixes mechanical breakage (missing imports, renamed methods) automatically.
Logic/behavior failures are reported back with analysis — you decide whether the test or the code is wrong.

**REMINDER: Reading/exploring code is allowed before this checklist. The gate is on CODE CHANGES (Edit, Write), not on research (Read, Grep, Glob, Agent with research).**

**Resuming work:** Always check `.plans/` for active implementation plans before starting new work.
<!-- [/NORTH-STARR:how-to-approach-tasks] -->

<!-- [NORTH-STARR:auto-learn] -->
## When to Learn Automatically

**Run `/learn` automatically — do not wait for the user to ask — when any of these signals occur during a session:**

| Signal | Example | What to Capture |
|--------|---------|-----------------|
| **User corrects your approach** | "No, don't do it that way — use X instead" | **Pattern** — the correct approach so it's followed next time |
| **Same fix requested twice** | User asks you to fix the same issue or area more than once in a session | **Landmine** — the fragile area and why it keeps breaking |
| **Your change breaks something** | Tests fail, build breaks, or existing behavior regresses after your edit | **Landmine** — what broke and why, so it's avoided next time |
| **User rejects generated code** | "That's wrong", "revert that", or user manually undoes your change | **Pattern or Landmine** — capture what was wrong and what's correct |
| **You discover an undocumented convention** | Code follows a pattern not captured in any rule or context file | **Pattern** — document it before it's forgotten |
| **You hit a trap not in any landmine rule** | Something looked safe but caused unexpected problems | **Landmine** — document the trap for future sessions |

**How auto-learn works:**
1. Detect the signal during normal work
2. Finish the immediate fix or correction first
3. Then run `/learn` to capture the insight as a pattern or landmine rule
4. If a pattern or landmine already exists for this area, update it — do not create duplicates. Prompt the user when the update contradicts existing content.
<!-- [/NORTH-STARR:auto-learn] -->

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

Generate pattern and landmine rules for each enabled target. The content is the same — only the file location and frontmatter format differ per tool.

**File formats per tool (generate only for enabled targets):**

**Claude Code** — `.claude/rules/*.md` (if `claude` target enabled):
```markdown
---
paths: ["glob/pattern/**"]
---

[Rule content]
```

**VS Code Copilot** — `.github/instructions/*.instructions.md` (if `copilot` target enabled):
```markdown
---
applyTo: "glob/pattern/**"
---

[Same rule content]
```

**Pattern Rules** — one rule file per pattern discovered in Step 3.

Follow the **full pattern template** from `skills/_references/patterns/_TEMPLATE.md`. Each pattern rule file must include:

- **Category** and **Language/Framework**
- `## When to Use` — Good For / Not Good For
- `## Problem It Solves` — what goes wrong without it, what improves with it
- `## The Pattern` — core idea, step-by-step with code examples, complete working example
- `## Best Practices` — do this, why
- `## Common Mistakes` — wrong code with explanation, fix code with explanation
- `## Variations` — alternative forms found in the codebase
- `## Testing This Pattern` — how to verify correct application
- `## Performance Considerations`
- `## Related` — links to related pattern and landmine rule files

**File naming:** `[descriptive-name]-pattern.md` (e.g. `caching-pattern.md`, `repository-pattern.md`)

---

**Landmine Rules** — one rule file per danger zone discovered in Step 4.

Follow the **full landmine template** from `skills/_references/landmines/_TEMPLATE.md`. Each landmine rule file must include:

- **Severity** (CRITICAL / HIGH / MEDIUM / LOW) and **Category**
- `## Quick Summary` — one-line description
- `## Symptoms` — observable signs you've hit this
- `## Root Cause` — technical explanation of why this happens
- `## The Trap` — why developers fall in, what makes it non-obvious
- `## Safe Approach` — Don't (dangerous code with explanation) / Do (safe code with explanation)
- `## Validation` — how to verify you're safe, detection patterns in existing code
- `## Real-World Impact` — what actually happens when this goes wrong
- `## Prevention` — habits, code review checks, validation steps
- `## Related` — safe pattern rules that avoid this, other related landmine rules

**File naming:** `[descriptive-name].md` (e.g. `broken-exists-method.md`, `silent-auth-failure.md`)

---

**What to generate rules for:**

Create one rule file per pattern or landmine discovered in Steps 3 and 4. Patterns become pattern rules, danger zones become landmine rules. The specific concerns depend on the project — generate rules only for what was actually found in the codebase.

**Guidelines:**
- Generate only rules that reflect real patterns or dangers found in the codebase — never invent conventions
- Use specific path globs — broad rules waste context on irrelevant files
- Keep each rule file focused on one concern
- Include code examples in every rule — abstract descriptions without code are not actionable
- Pattern and landmine rules should be as detailed as the templates require — typically 50-150 lines. Depth matters.
- The content is the same across tools — only the frontmatter format differs
- Include a `_TEMPLATE.md` in the rules directory of each tool for future contributions via `/learn`

---

#### D. Agents

Generate agents for each enabled target that supports them:

**Claude Code** — `.claude/agents/*.md` (if `claude` target enabled):

```yaml
---
name: [project]-explorer
description: Deep exploration and analysis of the [project] codebase
model: sonnet
tools: Read, Glob, Grep
memory: project
---
```

**VS Code Copilot** — `.github/agents/*.agent.md` (if `copilot` target enabled):

```yaml
---
name: [project]-explorer
description: Deep exploration and analysis of the [project] codebase
tools: codebase
---
```

The explorer agent prompt should include:
- The discovered architecture and grain
- Key modules and their relationships
- Known danger zones to watch for

**Layoutplan agent** (generate for all enabled targets):

Copy the layoutplan agent template into the project's agent directory for each enabled target. This agent is spawned by `/invert` to build implementation plans on a separate thread, keeping the main context clean for coding.

- **Claude Code** — copy from `templates/claude/agents/layoutplan.md` → `.claude/agents/layoutplan.md`
- **VS Code Copilot** — copy from `templates/github/agents/layoutplan.agent.md` → `.github/agents/layoutplan.agent.md`

**Build agent** (generate for all enabled targets):

Copy the build agent template into the project's agent directory for each enabled target. This agent is spawned after code changes to verify the project compiles on a separate thread, keeping error output out of the main context.

- **Claude Code** — copy from `templates/claude/agents/build.md` → `.claude/agents/build.md`
- **VS Code Copilot** — copy from `templates/github/agents/build.agent.md` → `.github/agents/build.agent.md`

**Test agent** (generate for all enabled targets):

Copy the test agent template into the project's agent directory for each enabled target. This agent runs the test suite on a separate thread, fixes mechanical test breakage (missing imports, renamed methods), and reports logic/behavior failures back for human decision.

- **Claude Code** — copy from `templates/claude/agents/test.md` → `.claude/agents/test.md`
- **VS Code Copilot** — copy from `templates/github/agents/test.agent.md` → `.github/agents/test.agent.md`

Generate additional project-specific agents only if the project clearly warrants them. Default to the explorer + layoutplan + build + test agents.

## Post-Bootstrap Checklist

- [ ] `.north-starr.json` exists (created if missing during this run)
- [ ] `AGENTS.md` at root (always)
- [ ] `CLAUDE.md` at root (if `claude` target enabled)
- [ ] `.github/copilot-instructions.md` (if `copilot` target enabled)
- [ ] Module-level `CLAUDE.md` for each identified danger zone (if `claude` target enabled)
- [ ] Pattern rules in enabled tool formats — aim for 15-40 depending on project complexity
- [ ] Landmine rules in enabled tool formats — aim for 5-15 depending on project maturity
- [ ] `_TEMPLATE.md` in each enabled tool's rules directory for future contributions
- [ ] `layoutplan` agent in `.claude/agents/` (if `claude` target enabled) and/or `.github/agents/` (if `copilot` target enabled)
- [ ] `build` agent in `.claude/agents/` (if `claude` target enabled) and/or `.github/agents/` (if `copilot` target enabled)
- [ ] `test` agent in `.claude/agents/` (if `claude` target enabled) and/or `.github/agents/` (if `copilot` target enabled)
- [ ] `build.commands` configured in `.north-starr.json`
- [ ] `test.commands` configured in `.north-starr.json`
- [ ] At least one project-tuned explorer agent per enabled tool that supports agents

## Output Summary

After completing all steps, present:

```
## Bootstrap Complete

**Project:** [name]
**Tech Stack:** [languages, frameworks, tools]
**Architecture:** [pattern, layers]
**Grain:** [easy changes vs. hard changes]
**Enabled Tools:** [list from .north-starr.json]

**Files Generated:**

Universal:
- AGENTS.md — [sections included]

[Include only sections for enabled targets:]

Claude Code:                              ← if claude target enabled
- CLAUDE.md — [sections included]
- [N] .claude/rules/ files — [N] patterns, [N] landmines — [list names]
- [N] .claude/agents/ files — [list names]

VS Code Copilot:                          ← if copilot target enabled
- .github/copilot-instructions.md
- [N] .github/instructions/ files — [N] patterns, [N] landmines — [list names]
- [N] .github/agents/ files — [list names]

Module-level:                             ← if claude target enabled
- [N] CLAUDE.md files — [list directories]

**Recommended First Read:** [2-3 files a newcomer should read first]
**Key Danger Zones:** [areas to approach with caution]
```

## Notes

- This skill is language-agnostic — it detects the project's stack and generates appropriate configuration
- This skill respects tool target preferences — check `.north-starr.json` for enabled targets, or ask and save if missing. Only generate artifacts for enabled tools.
- Can be run incrementally — bootstrap just the area you're working in, expand later
- Be thorough — analyze the entire codebase, not a sample. Shallow bootstraps produce shallow configuration that misses real patterns and dangers
- Balance breadth and depth: understand the whole project broadly, then go deep on patterns and landmines with full code examples and operational detail
- Generate only rules for patterns that actually exist — never invent conventions
- If the project already has configuration, build on what exists rather than overwriting
- The generated configuration is a starting point — it improves through subsequent `/learn` invocations
