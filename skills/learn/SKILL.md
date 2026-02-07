---
name: learn
description: After completing a task, capture learnings by updating AI tool configuration. Creates or updates rules, agents, and context files based on what was discovered — in the native format for each tool (Claude Code, VS Code Copilot, Cursor, AGENTS.md). Use after any task where something surprised you, went wrong, or produced a reusable insight.
argument-hint: [optional: brief description of what was learned]
---

# Learn — Update AI Tool Configuration From Experience

## Purpose

After completing a task, turn what you learned into native artifacts for all configured AI tools so the next task benefits automatically. The output is always a rule, agent update, or context file update — never a log file or template.

## When to Use

- After any task where something surprised you or went wrong
- After discovering a pattern worth preserving
- After stepping on a landmine that wasn't documented
- After working in a module that had no CLAUDE.md context
- Skip for routine tasks where nothing new was learned

## Workflow

### Step 1: Identify What Was Learned

Ask these questions about the completed task:

1. **Surprises** — Did anything behave differently than expected?
2. **Friction** — Where did you slow down, get stuck, or make a mistake?
3. **Patterns** — Did you discover a reusable approach that should be followed again?
4. **Danger zones** — Did you find an area that's more fragile or complex than it appeared?
5. **Vocabulary** — Did any terms turn out to mean something non-obvious?
6. **Rule gaps** — Did an existing rule fail to fire, or was a rule missing?

If the answer to all of these is "nothing" — skip the rest. Not every task produces learnings.

### Step 2: Decide What to Create or Update

Map each learning to the right artifact:

| What you learned | Artifact to create/update |
|---|---|
| A convention that should always be followed | Path-scoped rules — update all formats present (`.claude/rules/`, `.github/instructions/`, `.cursor/rules/`) |
| A danger zone in a specific module | Module-level `CLAUDE.md` — add Caution section |
| A reusable pattern for how things are done | Path-scoped rules, or root context files |
| Architecture understanding deepened | Root context — update `CLAUDE.md`, `AGENTS.md`, `.github/copilot-instructions.md` (whichever exist) |
| A new term was clarified | Root context — update Vocabulary section in all context files |
| The explorer agent needs more context | Agent files — update `.claude/agents/` and/or `.github/agents/` |
| A recurring task type was identified | Suggest creating a new skill |

### Step 3: Generate the Artifacts

For each learning, create or update the appropriate file:

#### New Rule

When a convention or constraint was discovered, create in all applicable formats:

**Claude Code** — `.claude/rules/*.md`:
```markdown
---
paths: ["glob/pattern/**"]
---

[What to do or not do, and why]
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

- Scope the glob as narrowly as possible
- State the rule as a clear instruction, not a description
- Include the "why" — it helps AI tools apply the rule correctly
- Name the file after the concern: `api-error-handling.md`, `state-mutation-rules.md`
- The content is the same across tools — only the frontmatter format differs

#### Module CLAUDE.md Update

When a danger zone or module-specific pattern was found:

- If no `CLAUDE.md` exists in that directory, create one
- If one exists, add to the relevant section (Caution, Patterns)
- Keep it concise — only what someone working in this module needs to know

#### Root Context File Update

When project-level understanding changed, update all root context files that exist:

- `CLAUDE.md` — Claude Code
- `AGENTS.md` — Universal
- `.github/copilot-instructions.md` — VS Code Copilot

For each:
- Update the specific section (Architecture, Grain, Module Map, Vocabulary)
- Don't rewrite sections that haven't changed

#### Agent Update

When the explorer agent's prompt should include new knowledge, update all applicable formats:

- `.claude/agents/*.md` — Claude Code
- `.github/agents/*.agent.md` — VS Code Copilot

For each:
- Add to the agent's context about architecture, danger zones, or module relationships
- Keep the agent prompt focused — it's context, not a manual

### Step 4: Present Summary

```
## Learnings Applied

**Task:** [what was completed]

**Updates Made:**
- [artifact type]: [file path] — [what was added/changed]
- [artifact type]: [file path] — [what was added/changed]

**Why:** [brief explanation of what triggered these updates]
```

## Notes

- This skill is language-agnostic — works for any project type
- Every output must be a native artifact for the AI tools in use (rules, agents, context files) — not a log or template file
- Read existing files before updating — build on what's there, don't duplicate
- Keep rules and CLAUDE.md content concise — verbose documentation goes stale and wastes context
- Not every task produces learnings — it's fine to run this and conclude "nothing to update"
- When unsure whether something deserves a rule vs. a CLAUDE.md note: rules are for constraints that should always be enforced, CLAUDE.md is for context that helps Claude make better decisions
