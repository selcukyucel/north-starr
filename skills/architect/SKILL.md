---
name: architect
description: Define architecture and conventions for a new project before code exists. Produces the same AI configuration as /bootstrap (CLAUDE.md, rules, agents, AGENTS.md) but declared from intent rather than discovered from code. Run once at project start, then validate later with /bootstrap.
argument-hint: "[project name or description]"
---

# Architect — Proactive Configuration for New Projects

## Purpose

Capture architectural intent **before** code exists, so AI tools enforce conventions from line one. This is the same AI configuration layer that `/bootstrap` produces (CLAUDE.md, rules, agents, AGENTS.md) — but declared from intent rather than discovered from code.

This is NOT scaffolding — no code is generated. Only AI tool configuration.

**Lifecycle:**
```
/architect     →  declares intent, generates [DECLARED] config
  write code   →  AI tools enforce declared conventions
/bootstrap     →  validates reality vs declarations
                   CONFIRMED → remove [DECLARED] tag
                   DIVERGED  → present both, ask user
                   NOT YET   → keep [DECLARED] tag
/learn         →  ongoing refinement
```

## When to Use

- Starting a brand new project with no code yet
- When you know the tech stack and architecture but haven't written code
- When you want AI tools to enforce conventions from the first commit

## Prerequisites

- A target directory (can be empty)
- The user has an idea of what they're building (at minimum: stack and project name)

## Tool Target Preferences

Before generating any output, check for `.north-starr.json` in the project root:

```json
{
  "version": 1,
  "targets": ["claude", "copilot"]
}
```

- If the file exists, only generate artifacts for the listed targets
- If the file is missing, ask the user which tools they use (as part of Phase 1), save their answer to `.north-starr.json`, then generate only for those targets
- `AGENTS.md` is always generated regardless of preferences (it's universal)
- Valid targets: `"claude"`, `"copilot"`

## Workflow

### Phase 1: Identity (Required)

**Goal:** Capture the minimum viable project identity — enough for smart defaults.

Ask these questions **one at a time**, adapting based on answers:

1. **Project name + description**
   - "What's the project name and a one-sentence description?"
   - Accept anything — this becomes the header in context files

2. **Tech stack**
   - "What tech stack? (e.g., 'React TS', 'Go API', 'iOS SwiftUI', 'Rails', 'Python FastAPI')"
   - Accept shorthand — resolve to full stack details using `references/stack-conventions.md`
   - If ambiguous, offer the 2-3 most likely interpretations

3. **Architecture pattern**
   - Based on the chosen stack, propose 2-3 common patterns from `references/stack-conventions.md`
   - "For [stack], the most common patterns are [X, Y, Z]. Which fits, or describe your own?"
   - If the user isn't sure, suggest the default for that stack
   - Accept custom patterns — just document what the user describes

4. **AI tools** (only if `.north-starr.json` is missing)
   - "Which AI tools do you use? (Claude Code, VS Code Copilot — or both?)"
   - Save the answer to `.north-starr.json` in the project root
   - If the file already exists, skip this question and use the saved preferences

**After Phase 1:** You have enough to generate useful configuration. Offer to continue to Phase 2 or generate now with smart defaults.

### Phase 2: Conventions (Recommended)

**Goal:** Refine defaults — confirm or override what the stack conventions suggest.

4. **File/directory organization**
   - Propose the default layout from `references/stack-conventions.md` for the chosen stack+pattern
   - "Here's the typical structure for [stack] + [pattern]. Does this match your plan, or would you change anything?"
   - User can confirm, modify, or skip (defaults apply)

5. **Conventions to enforce**
   - Propose defaults from the stack conventions: naming, error handling, testing strategy, state management
   - "These are the standard conventions for [stack]. Any changes or additions?"
   - Focus on things that are enforceable via rules (not aspirational guidelines)

6. **Hard constraints / danger zones**
   - "Are there any hard rules — things that should never happen? (e.g., 'no direct DB access outside the repository layer', 'never force-unwrap optionals')"
   - These become high-priority rules

**After Phase 2:** Configuration is well-tailored. Offer Phase 3 or generate.

### Phase 3: Context (Optional)

**Goal:** Capture extra context that improves AI effectiveness.

7. **Reference project**
   - "Is there an existing north-starr project to adapt config from?"
   - If yes, read that project's config and adapt (preserving the new project's identity)

8. **Catch-all**
   - "Anything else? Domain vocabulary, team preferences, external constraints, API contracts?"
   - Capture whatever the user offers

### Phase 4: Generate Configuration

**Goal:** Produce all configuration artifacts, marked `[DECLARED]` to distinguish from discovered config.

Use `references/stack-conventions.md` to fill in smart defaults for anything the user didn't explicitly specify.

---

#### A. Project Context (root-level)

Write to enabled target locations:

- `CLAUDE.md` — Claude Code (auto-loaded) — generate if `claude` target is enabled
- `AGENTS.md` — Universal (works with any AI tool) — always generated
- `.github/copilot-instructions.md` — VS Code Copilot (auto-loaded) — generate if `copilot` target is enabled

All context files get the same content:

All context files get the same content. **Section order matters** — instructional sections (How to Approach Tasks, When to Learn) come FIRST so the AI tool sees them before project context:

```markdown
# [Project Name]

[One-sentence project description]

<!-- Generated by /architect — [DECLARED] config. Run /bootstrap after writing code to validate. -->

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

[Languages, frameworks, key dependencies, build tools, test runner]

## Architecture [DECLARED]

[Pattern, topology, layers and their responsibilities]

## Grain [DECLARED]

[What changes easily, what is hard — based on declared architecture]

## Module Map [DECLARED]

[Planned modules/packages with one-line descriptions and intended relationships]

## Conventions [DECLARED]

[Naming, error handling, testing, state management — from stack defaults + user overrides]
```

If any of these files already exist with project-specific content, merge rather than overwrite.

---

#### B. Path-Scoped Rules

Generate rules based on the declared architecture and conventions. Create for each enabled target:

**Claude Code** — `.claude/rules/*.md` (if `claude` target enabled):
```markdown
---
paths: ["glob/pattern/**"]
---
<!-- Generated by /architect — [DECLARED] -->

[Clear, concise instruction based on declared conventions]
```

**VS Code Copilot** — `.github/instructions/*.instructions.md` (if `copilot` target enabled):
```markdown
---
applyTo: "glob/pattern/**"
---
<!-- Generated by /architect — [DECLARED] -->

[Same instruction content]
```

**What to generate rules for:**
- Naming conventions — scoped to the project's file extensions
- Architecture layer constraints — what each layer can/cannot import
- Error handling — the declared pattern for the stack
- Testing conventions — naming, location, style
- Any hard constraints from Phase 2

**Guidelines:**
- Generate rules from declared conventions and stack defaults — not discovered code
- Use specific path globs based on the declared directory structure
- Keep each rule file focused on one concern
- Mark every rule with `<!-- Generated by /architect — [DECLARED] -->`

---

#### C. Agents

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

The agent prompt should include:
- The declared architecture and grain
- Planned modules and their relationships
- Declared conventions to watch for

---

#### D. Startup Plan (Optional)

Offer to generate `.plans/PLAN-project-setup.md` — an initial implementation plan that bridges into `/layoutplan`:

```markdown
# Plan: project-setup

**Created:** [date]
**Status:** ACTIVE
**Source:** /architect — initial project setup

## Goal
Set up the project structure, dependencies, and initial code based on the declared architecture.

## Tasks

### 1. Initialize project
**Status:** PENDING
- [ ] Create project with [stack's init tool]
- [ ] Configure [build tool, linter, formatter]
- [ ] Set up directory structure per declared module map

### 2. Implement foundational patterns
**Status:** PENDING
**Blocked by:** 1
- [ ] Create base types/interfaces for [architecture pattern]
- [ ] Set up [error handling, DI, state management] patterns
- [ ] Add first example following all declared conventions

### 3. Validate with /bootstrap
**Status:** PENDING
**Blocked by:** 2
- [ ] Run /bootstrap to validate declared config against actual code
- [ ] Review any DIVERGED items
- [ ] Confirm conventions are reflected in the codebase
```

Adapt the tasks to the specific stack and architecture.

## Post-Architect Checklist

- [ ] `.north-starr.json` exists (created if missing during Phase 1)
- [ ] `AGENTS.md` at root (always)
- [ ] `CLAUDE.md` at root (if `claude` target enabled)
- [ ] `.github/copilot-instructions.md` (if `copilot` target enabled)
- [ ] Path-scoped rules in enabled tool formats
- [ ] At least one project-tuned agent per enabled tool that supports agents
- [ ] All sections marked `[DECLARED]`
- [ ] Startup plan offered

## Output Summary

After completing all phases, present:

```
## Architect Complete

**Project:** [name]
**Tech Stack:** [languages, frameworks, tools]
**Architecture:** [pattern] [DECLARED]
**Grain:** [easy changes vs. hard changes] [DECLARED]
**Enabled Tools:** [list from .north-starr.json]

**Files Generated:**

Universal:
- AGENTS.md — [sections included]

[Include only sections for enabled targets:]

Claude Code:                              ← if claude target enabled
- CLAUDE.md — [sections included]
- [N] .claude/rules/ files — [list names]
- [N] .claude/agents/ files — [list names]

VS Code Copilot:                          ← if copilot target enabled
- .github/copilot-instructions.md
- [N] .github/instructions/ files — [list names]
- [N] .github/agents/ files — [list names]

**All config marked [DECLARED].**
Run /bootstrap after writing code to validate declarations against reality.
```

## Notes

- This skill is language-agnostic — it uses `references/stack-conventions.md` for smart defaults across 11+ stacks
- This skill respects tool target preferences — check `.north-starr.json` for enabled targets, or ask and save if missing. Only generate artifacts for enabled tools.
- Even answering only Phase 1 should produce useful, non-trivial configuration via smart stack-aware defaults
- The `[DECLARED]` tag is critical — it tells `/bootstrap` to validate rather than regenerate
- Conversational style — ask questions one at a time, adapt based on answers, offer smart defaults
- No code generation — only AI tool configuration
- Works best as a complement to `/bootstrap`: architect declares, bootstrap validates
- The generated configuration is a starting point — it improves through `/bootstrap` validation and `/learn` refinement
