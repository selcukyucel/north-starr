---
name: sync
description: "Inject managed sections into existing CLAUDE.md and AGENTS.md after a plugin update without re-bootstrapping. Preserves all project-specific content."
---

# Sync — Inject Managed Sections After Plugin Update

## Purpose

After updating the North Starr plugin, inject any new or updated managed sections into your existing CLAUDE.md and AGENTS.md without re-running `/bootstrap`. This preserves all your project-specific content (architecture, module map, vocabulary, etc.) while adding new North Starr sections.

**This skill is for Claude Code plugin users only.** If you installed via Homebrew, run `north-starr update` from the terminal instead — it does the same thing without using AI tokens.

## When to Use

- After updating the North Starr plugin in Claude Code
- When you see new features in the skills (like auto-learn) but your CLAUDE.md and AGENTS.md don't have them
- As a lightweight alternative to re-running `/bootstrap` when only managed sections need updating

## How It Works

Managed sections are wrapped in marker comments:
```markdown
<!-- [NORTH-STARR:section-name] -->
## Section Content
...
<!-- [/NORTH-STARR:section-name] -->
```

The sync process:
1. Reads your existing CLAUDE.md and AGENTS.md
2. For each managed section defined below, checks the target file
3. If the section exists (has markers) → **replaces it in place** with the latest version
4. If the section is missing → **appends it** at the end
5. If the heading exists without markers (pre-v2.3.9 file) → **skips it** and tells you
6. **Reorders sections** so managed sections (instructions) appear BEFORE project context (Tech Stack, Architecture, etc.)
7. All project-specific content outside managed sections is **never touched**

## Workflow

### Step 1: Read Existing Files

Read the root context files in the project:
- `CLAUDE.md` — always (if it exists)
- `AGENTS.md` — always (if it exists)
- `.github/copilot-instructions.md` — if `copilot` target is enabled in `.north-starr.json` (if it exists)

If a file doesn't exist, skip it.

### Step 2: Sync Each Managed Section

For each managed section defined in the **Canonical Sections** below, apply the sync logic to all context files found in Step 1:

**Decision logic for each section:**

| Current state of target file | Action |
|------------------------------|--------|
| Section exists with `<!-- [NORTH-STARR:name] -->` markers | **Replace** everything between the open and close markers (inclusive) with the canonical version below |
| Section heading (e.g. `## How to Approach Tasks`) exists but WITHOUT markers | **Skip** — tell the user: "Section exists without markers. Run `/bootstrap` to get marker support, or manually wrap the section with markers." |
| Section is completely absent | **Append** the canonical version at the end of the file |

### Step 3: Reorder Sections

After syncing content, check if managed sections appear AFTER project context headings (`## Tech Stack`, `## Architecture`, `## Grain`, `## Module Map`, `## Conventions`). If so, move them:

1. Extract all managed sections (between their markers)
2. Remove them from their current positions
3. Re-insert them immediately after the first heading (`# Project Name`) and its description line, BEFORE any project context headings
4. Preserve all other content and ordering

**Correct order:**
```
# Project Name
[description]

<!-- [NORTH-STARR:how-to-approach-tasks] -->
## How to Approach Tasks
...
<!-- [/NORTH-STARR:how-to-approach-tasks] -->

<!-- [NORTH-STARR:auto-learn] -->
## When to Learn Automatically
...
<!-- [/NORTH-STARR:auto-learn] -->

## Tech Stack
## Architecture
## Grain
## Module Map
```

If sections are already in the correct order, skip this step.

### Step 4: Sync Agents

Check if the North Starr plugin includes agent templates. Look for agent files in both:
- `templates/claude/agents/*.md` — Claude Code agents
- `templates/github/agents/*.agent.md` — VS Code Copilot agents

**Actions:**
1. Read `.north-starr.json` to determine which tool targets are enabled
2. For each enabled target with agent templates:
   - **Claude Code** (`claude` target): Copy agent files to `.claude/agents/`
   - **VS Code Copilot** (`copilot` target): Copy agent files to `.github/agents/`
   - Create the agents directory if it doesn't exist
   - Overwrite existing agent files — agents are managed by North Starr and always updated to the latest version
3. Report which agents were added or updated per target

This ensures projects get new agents (like `layoutplan`) without needing to re-run `/bootstrap`.

### Step 5: Present Summary

```
## Sync Complete

**Files updated:**
- CLAUDE.md — [added: section-name, section-name] [updated: section-name] [skipped: section-name (no markers)]
- AGENTS.md — [added: section-name, section-name] [updated: section-name] [skipped: section-name (no markers)]
- .github/copilot-instructions.md — [added / updated / skipped / not found]  ← if copilot target

**Agents:**
- .claude/agents/layoutplan.md — [added / updated / already current]  ← if claude target
- .claude/agents/build.md — [added / updated / already current]  ← if claude target
- .claude/agents/test.md — [added / updated / already current]  ← if claude target
- .github/agents/layoutplan.agent.md — [added / updated / already current]  ← if copilot target
- .github/agents/build.agent.md — [added / updated / already current]  ← if copilot target
- .github/agents/test.agent.md — [added / updated / already current]  ← if copilot target

**No changes needed:**
- [file] — all managed sections are up to date
```

---

## Canonical Sections

These are the managed sections that `/sync` injects. Each section below is the **single source of truth** — what gets written into CLAUDE.md and AGENTS.md.

### Section: `how-to-approach-tasks`

```markdown
<!-- [NORTH-STARR:how-to-approach-tasks] -->
## How to Approach Tasks

**CRITICAL — BLOCKING REQUIREMENT: You MUST complete this checklist and show it to the user BEFORE using any code-modifying tool (Edit, Write, Agent with code changes). This is NOT optional. Skipping this step is a rule violation.**

**Step 1: Print this complexity assessment (mandatory output before ANY code change):**

```
## Complexity Assessment
| # | Question                                  | Answer      |
|---|-------------------------------------------|-------------|
| 0 | Is current behavior covered by tests?      | [Yes / No]  |
| 1 | How many files will this change?           | [1-2 / 3+]  |
| 2 | Am I creating new types or protocols?      | [No / Yes]  |
| 3 | Is this module unfamiliar to me?           | [No / Yes]  |
| 4 | Does this require cross-module integration?| [No / Yes]  |

→ Complexity: [Low / Medium-High]
→ Action: [State files / Run /invert → layoutplan agent]
```

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
```

### Section: `auto-learn`

```markdown
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
```

## Notes

- This skill is Claude Code plugin-only (`tool: claude`)
- Brew/CLI users should run `north-starr update` instead — same result, no AI tokens
- Only managed sections (wrapped in `<!-- [NORTH-STARR:...] -->` markers) are touched
- All project-specific content is preserved
- When new managed sections are added in future versions, they'll be included in this skill's Canonical Sections — running `/sync` after a plugin update will pick them up
- If you want full marker support on a pre-v2.3.9 file, run `/bootstrap` once to regenerate with markers
