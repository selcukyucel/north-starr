---
name: document
description: Generate a context file for a module or feature by analyzing its actual code. Produces a CLAUDE.md that AI tools use when working in that area. Use when a module has no context file, or when existing documentation is outdated.
argument-hint: <module path or name>
---

# Document — Generate Module Context File

## Purpose

Analyze a module's actual code and produce a `CLAUDE.md` context file for that directory. Claude Code auto-loads these when working in the directory; other AI tools benefit from them as readable documentation. The goal is practical context — not comprehensive documentation, but what someone (or an AI) needs to work here effectively.

## When to Use

- A module has no context file and you're about to work in it
- After `/learn` identifies a documentation gap
- When existing documentation is outdated after significant changes
- When onboarding to an unfamiliar area of the codebase

## Workflow

### Step 1: Scope

Identify the module to document. If the user didn't specify a path, ask.

The output is a single `CLAUDE.md` file placed at the root of that module's directory.

### Step 2: Analyze

Read all source files in the module and extract:

1. **Purpose** — What does this module do? What problem does it solve?
2. **Architecture** — What pattern is it using? What are the key components and their roles?
3. **Data flow** — How does data enter, get processed, and leave? Trace the 2-3 most important operations.
4. **Public interface** — What does this module expose to the rest of the codebase? Key functions, classes, endpoints, exports.
5. **Dependencies** — What does it depend on? What depends on it?
6. **State** — What state does it manage? How does it change?
7. **Edge cases and gotchas** — Non-obvious behavior, fragile areas, missing tests, known bugs. Check for TODO/FIXME/HACK comments.

### Step 3: Write

Generate the `CLAUDE.md` at the module root. Adapt the structure to what's actually there — not every section applies to every module.

```markdown
# [Module Name]

[One-paragraph summary: what it does, why it exists, how it fits in the project]

## Architecture

[Key components, their roles, how they connect. Adapt to the actual pattern — don't force a template.]

## Data Flow

[How the 2-3 most important operations work, from input to output]

## Public Interface

[What this module exposes — key functions, classes, endpoints, types]

## Dependencies

**Uses:** [what this module depends on]
**Used by:** [what depends on this module]

## Caution

[Gotchas, fragile areas, missing tests, non-obvious behavior, known bugs. Skip if none found.]

## Common Tasks

### How to [add/modify/debug common thing]
1. [Step with file path]
2. [Step]
3. Verify: [how to test]

[Add 2-3 task guides for the most common operations. Skip if not applicable.]
```

### Step 4: Verify

- Confirm the file is at the right path (module root, not project root)
- Check that file paths and names referenced in the doc actually exist
- Keep it concise: 100-300 lines for most modules, up to 500 for complex ones

### Step 5: Update Root Context (if needed)

If documenting the module revealed new project-level insights (architecture patterns, vocabulary, module relationships), update the root context files that exist:

- `CLAUDE.md` — Claude Code
- `AGENTS.md` — Universal
- `.github/copilot-instructions.md` — VS Code Copilot

Only update sections that are affected (Module Map, Vocabulary, Architecture). Don't rewrite unchanged sections.

## Output Summary

```
## Documentation Generated

**Module:** [name]
**File:** [path to CLAUDE.md]
**Sections:** [list of sections included]
**Lines:** [count]
**Root context updated:** [yes/no — what changed, if applicable]
```

## Notes

- This skill is language-agnostic — adapts to whatever architecture exists
- Write from the code, not from assumptions — read every file before documenting
- Be practical: "how to add X" guides are more valuable than abstract descriptions
- Be honest: document gotchas and known issues, not just happy paths
- Skip sections that don't apply — a small, accurate doc beats a comprehensive stale one
- The Caution section is the most important part for preventing friction — prioritize it
- If the module already has a CLAUDE.md, update it rather than overwriting
