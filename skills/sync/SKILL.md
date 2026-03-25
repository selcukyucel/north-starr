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
<!-- [NORTH-STARR:section-name v1.2] -->
## Section Content
...
<!-- [/NORTH-STARR:section-name] -->
```

The open marker includes an optional version tag (e.g., `v1.2`). When syncing, the version in the canonical section is compared to the version in the file. If versions match, the content is assumed current and skipped. If versions differ (or no version exists), content comparison is used as fallback.

The sync process:
1. Reads your existing CLAUDE.md and AGENTS.md
2. For each managed section defined below, checks the target file
3. If the section exists (has markers) → **replaces it in place** with the latest version
4. If the section is missing → **appends it** at the end
5. If the heading exists without markers (pre-v2.3.9 file) → **skips it** and tells you
6. **Reorders sections** so managed sections (instructions) appear BEFORE project context (Tech Stack, Architecture, etc.)
7. All project-specific content outside managed sections is **never touched**

## Workflow

### Step 0: Check Plugin Freshness

Before syncing, check whether the installed plugin is stale. This prevents syncing against outdated templates that silently serve old content.

1. **Locate the marketplace cache:** Check if `~/.claude/plugins/marketplaces/north-starr/` exists (this is where Claude Code caches the plugin repo).

2. **Fetch and compare:** Run these commands via Bash:
   ```bash
   cd ~/.claude/plugins/marketplaces/north-starr && git fetch origin 2>/dev/null && git rev-parse HEAD && git rev-parse origin/main
   ```

3. **Evaluate freshness:**
   - If the directory doesn't exist → skip this check (user may have installed differently)
   - If `HEAD` equals `origin/main` → plugin is current, proceed to Step 1
   - If `HEAD` is behind `origin/main` → the plugin cache is stale

4. **If stale**, present this warning and stop:
   ```
   ⚠ Your North Starr plugin cache is stale.
   The installed version is behind the latest release. Syncing now would
   use outdated templates — your agents and managed sections would not
   actually update.

   Run these commands to update, then re-run /sync:

     cd ~/.claude/plugins/marketplaces/north-starr && git reset --hard origin/main && cd -
     rm -rf ~/.claude/plugins/cache/north-starr

   Then reload plugins (restart Claude Code or run /plugin install north-starr).
   ```

   Do NOT proceed with the sync. The user must update the cache first, otherwise `/sync` silently syncs stale content and reports "already current."

5. **Version cross-check (optional):** If `.claude-plugin/marketplace.json` is readable, compare its `metadata.version` with the version in the marketplace cache's `marketplace.json`. Log the versions in the sync preview for transparency:
   ```
   Plugin version: 4.4.0 (installed) vs 4.5.0 (latest) — STALE
   Plugin version: 4.5.0 (installed) vs 4.5.0 (latest) — current
   ```

### Step 1: Read Existing Files

Read the root context files in the project:
- `CLAUDE.md` — always (if it exists)
- `AGENTS.md` — always (if it exists)

If a file doesn't exist, skip it.

### Step 2: Sync Each Managed Section

For each managed section defined in the **Canonical Sections** below, apply the sync logic to all context files found in Step 1:

**Decision logic for each section:**

| Current state of target file | Action |
|------------------------------|--------|
| Section exists with markers AND content is **identical** to canonical | **Skip** — already up to date, no write needed |
| Section exists with markers AND content **differs** from canonical | **Replace** everything between the open and close markers (inclusive) with the canonical version below |
| Section heading (e.g. `## How to Approach Tasks`) exists but WITHOUT markers | **Skip** — tell the user: "Section exists without markers. Run `/bootstrap` to get marker support, or manually wrap the section with markers." |
| Section is completely absent | **Append** the canonical version at the end of the file |

**Comparison:** Compare the existing content (between markers) with the canonical version. Normalize whitespace before comparing — trailing newlines and minor formatting differences should not trigger an unnecessary rewrite.

**Dry-run preview:** Before writing any changes, collect all planned actions (replace, append, skip) and present them as a summary:

```
Sync preview:
  CLAUDE.md:
    how-to-approach-tasks — UPDATE (content differs)
    auto-learn — SKIP (already current)
  AGENTS.md:
    how-to-approach-tasks — APPEND (section missing)
    auto-learn — APPEND (section missing)
  Agents:
    chief-ai-po.md — ADD (new)
    layoutplan.md — SKIP (identical)

Apply changes? (y/n)
```

Wait for user confirmation before writing. If the user runs `/sync` with `--force` or says "just do it", skip the preview.

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

Sync agent definitions for each enabled tool:

**Claude Code** — from `templates/claude/agents/` into `.claude/agents/`:
1. List all `.md` files in `templates/claude/agents/`
2. For each agent, copy to `.claude/agents/` — create if missing, update if content differs, skip if identical
3. Create `.claude/agents/` if it doesn't exist

**VS Code Copilot** — from `templates/github/agents/` into `.github/agents/` (only if `.github/agents/` exists or AGENTS.md references Copilot):
1. List all `.agent.md` files in `templates/github/agents/`
2. For each agent, copy to `.github/agents/` — create if missing, update if content differs, skip if identical
3. Create `.github/agents/` if it doesn't exist

**Do not hardcode the agent list.** Dynamically list all files in the template directories. This ensures new agents added in future plugin versions are automatically synced. Current agents as of v4.3.0: `layoutplan`, `storymap`, `chief-ai-po`.

### Step 4b: Validate Sync Results

After syncing, verify the files weren't corrupted:

1. **Marker integrity** — Every `<!-- [NORTH-STARR:name] -->` open marker must have a matching `<!-- [/NORTH-STARR:name] -->` close marker. If any are orphaned, warn the user.
2. **No duplicate headings** — Check that no `##` heading appears more than once in the file. Duplicates indicate a botched append.
3. **Line limit check** — CLAUDE.md and AGENTS.md should stay under 125 lines total. If syncing pushed a file over, warn the user: "File is [N] lines (recommended max: 125). Consider moving project-specific content to module-level CLAUDE.md files."
4. **Section order** — Verify managed sections appear before project context sections (confirmed by Step 3).

If any check fails, present the issue before the summary so the user can fix it.

### Step 5: Present Summary

```
## Sync Complete

**Files updated:**
- CLAUDE.md — [added: section-name, section-name] [updated: section-name] [skipped: section-name (no markers)]
- AGENTS.md — [added: section-name, section-name] [updated: section-name] [skipped: section-name (no markers)]

**Agents:**
- .claude/agents/<name>.md — [added / updated / already current]
[...repeat for each agent found in templates/claude/agents/]

**No changes needed:**
- [file] — all managed sections are up to date
```

---

## Canonical Sections

These are the managed sections that `/sync` injects. CLAUDE.md and AGENTS.md get **different variants** of the `how-to-approach-tasks` section — CLAUDE.md uses plain text prompts while AGENTS.md uses `vscode_askQuestions`.

### Section: `how-to-approach-tasks` (CLAUDE.md variant)

Use this version when syncing `CLAUDE.md`:

```markdown
<!-- [NORTH-STARR:how-to-approach-tasks] -->
## How to Approach Tasks

Before ANY code change, print this assessment:

| # | Question | Answer |
|---|----------|--------|
| 0 | Is current behavior covered by tests? | Yes / No |
| 1 | How many files will this change? | 1-2 / 3+ |
| 2 | Am I creating new types or protocols? | No / Yes |
| 3 | Does this require cross-module integration? | No / Yes |

**Rules:**
- **Fast-path**: 1 file, no new types, no cross-module impact, existing test coverage → state the file and proceed. No table needed.
- Q0 = No → Write tests for current behavior FIRST
- Q1 = 3+ OR Q2/Q3 = Yes → Run `/invert` automatically. Once the inversion analysis is ready, ask "Proceed with layout plan?" before spawning the `layoutplan` agent. Do not proceed without approval.
- All Low → State files and wait for confirmation

**Workflow:** RED (failing tests) → GREEN (implementation) → Completion summary listing files modified → Ask the user: "What would you like to do next?" with options: Generate commit message, Generate PR description, Run /learn (capture learnings), or Done. Do not run any of these automatically — wait for the user's choice.

**Todo discipline:** Never create a todo item for verification steps like "run tests", "build project", or "verify changes". Testing and building are implicit parts of the implementation workflow, not standalone tasks.

Skip test-first for: config, docs, CI, trivial one-line fixes.
If more files are affected than estimated mid-implementation, STOP and run `/invert`.
Always check `.plans/` for active plans before starting new work.
<!-- [/NORTH-STARR:how-to-approach-tasks] -->
```

### Section: `how-to-approach-tasks` (AGENTS.md variant)

Use this version when syncing `AGENTS.md`:

```markdown
<!-- [NORTH-STARR:how-to-approach-tasks] -->
## How to Approach Tasks

Before ANY code change, print this assessment:

| # | Question | Answer |
|---|----------|--------|
| 0 | Is current behavior covered by tests? | Yes / No |
| 1 | How many files will this change? | 1-2 / 3+ |
| 2 | Am I creating new types or protocols? | No / Yes |
| 3 | Does this require cross-module integration? | No / Yes |

**Rules:**
- **Fast-path**: 1 file, no new types, no cross-module impact, existing test coverage → state the file and proceed. No table needed.
- Q0 = No → Write tests for current behavior FIRST
- Q1 = 3+ OR Q2/Q3 = Yes → Run `/invert` automatically. Once the inversion analysis is ready, use `vscode_askQuestions` to ask "Proceed with layout plan?" (options: "Yes, run layoutplan", "No, let me review first"). Once the plan is ready, use `vscode_askQuestions` again to ask "Plan is ready. Start implementation?" (options: "Yes, start coding", "No, I want to adjust the plan"). Do not proceed without approval at each gate.
- All Low → State files and wait for confirmation

**Workflow:** RED (failing tests) → GREEN (implementation) → Completion summary listing files modified → Use `vscode_askQuestions` to prompt the developer with options: "Generate commit message", "Generate PR description", "Run /learn (capture learnings)", "Done". Do not run any of these automatically — wait for the developer's choice. If the developer chooses "Generate commit message", generate it, then use `vscode_askQuestions` again to ask "Commit message generated. What next?" with options: "Generate PR description", "Run /learn (capture learnings)", "Done".

**Todo discipline:** Never create a todo item for verification steps like "run tests", "build project", or "verify changes". Testing and building are implicit parts of the implementation workflow, not standalone tasks.

Skip test-first for: config, docs, CI, trivial one-line fixes.
If more files are affected than estimated mid-implementation, STOP and run `/invert`.
Always check `.plans/` for active plans before starting new work.
<!-- [/NORTH-STARR:how-to-approach-tasks] -->
```

### Section: `auto-learn` (same for both files)

```markdown
<!-- [NORTH-STARR:auto-learn] -->
## When to Learn Automatically

Run `/learn` automatically when: user corrects your approach, same fix requested twice, your change breaks something, user rejects generated code, you discover an undocumented convention, or you hit a trap not in any landmine rule. Finish the immediate fix first, then capture the insight.
<!-- [/NORTH-STARR:auto-learn] -->
```

## Notes

- This skill is Claude Code plugin-only (`tool: claude`)
- Brew/CLI users should run `north-starr update` instead — same result, no AI tokens
- Only managed sections (wrapped in `<!-- [NORTH-STARR:...] -->` markers) are touched
- All project-specific content is preserved
- When new managed sections are added in future versions, they'll be included in this skill's Canonical Sections — running `/sync` after a plugin update will pick them up
- If you want full marker support on a pre-v2.3.9 file, run `/bootstrap` once to regenerate with markers
