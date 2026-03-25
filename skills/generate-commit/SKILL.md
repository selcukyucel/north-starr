---
name: generate-commit
description: Generate clear, descriptive git commit messages by analyzing staged changes. Use this skill when the user asks to "generate a commit message", "write a commit message", "create a commit message", or similar requests related to git commits.
---

# Commit Message Generator

## Overview

Analyze staged git changes and generate clear, descriptive commit messages that explain what was changed. The skill examines git diffs, file modifications, and code context to produce meaningful commit messages.

## When to Use

Use this skill when the user requests:
- "Generate a commit message"
- "Write a commit message for my changes"
- "Create a commit message"
- "What should my commit message be?"
- Any similar request asking for help with git commit messages

## Workflow

### 1. Gather Git Information

Run the following git commands in parallel to understand the current state:

```bash
git status
git diff --staged
git log -10 --oneline
```

Also check for commit convention config files (run in parallel):

```bash
# Check for conventional commits / commitlint config
ls .commitlintrc* .czrc .cz.json commitlint.config.* 2>/dev/null
# Check package.json for commitizen or commitlint config (if it exists)
grep -l "commitizen\|commitlint\|conventional" package.json .husky/commit-msg 2>/dev/null
```

**Key information to extract:**
- Files that have been staged (from `git status`)
- Files that are modified but NOT staged — if present, warn the user: "Note: you have unstaged changes in [files] that won't be included in this commit."
- The actual code changes (from `git diff --staged`)
- Recent commit message patterns in the repository (from `git log`)
- **Commit convention** — detect from config files first, then infer from the last 10 commit messages:
  - **Conventional Commits**: messages starting with `feat:`, `fix:`, `docs:`, `refactor:`, `chore:`, `test:`, `ci:`, `perf:`, `build:`, `style:`
  - **Scoped conventional**: `feat(auth):`, `fix(api):` — the scope usually maps to a module or directory
  - **Ticket prefixes**: `PROJ-123: description`, `#123 description`
  - **Custom prefixes**: any other consistent pattern (e.g., emoji prefixes, `[module]` tags)
  - **No convention**: free-form messages — use the general guidelines below

  If a convention is detected, ALL generated messages MUST follow it. Do not mix conventions.

### 2. Analyze the Changes

Examine the staged changes to understand:
- **What** was changed (which files, functions, components)
- **Why** it might have been changed (bug fix, new feature, refactor, etc.)
- **Scope** of the changes (single feature, multiple areas, specific module)
- **Cohesion** — do all changes serve a single purpose?

**Important considerations:**
- Focus on the purpose and impact of the changes
- Identify the main theme if multiple files were changed
- Note if changes are related to UI, backend, tests, documentation, etc.
- Consider the magnitude: minor tweak vs. major refactor

**Split detection:** If the staged changes contain **unrelated concerns** (e.g., a bug fix AND a new feature, or changes to two independent modules with no connection), suggest splitting into separate commits:

```
These staged changes appear to contain multiple unrelated concerns:
  1. [concern A] — [files]
  2. [concern B] — [files]

I'd recommend splitting into separate commits for a cleaner history.
Want me to generate messages for each, or create one combined message?
```

Only suggest splitting if the concerns are truly independent. Related changes (e.g., a feature + its tests, a refactor + updated imports) should stay in one commit.

### 3. Generate the Commit Message

Create a clear, concise commit message following these guidelines.

**If a convention was detected in Step 1, use it.** Otherwise, use this default format:

**Format:**
```
<type>(<scope>): <summary>

<optional detailed explanation if needed>

<optional footer: BREAKING CHANGE, references>
```

**Type** — infer from the changes:
- `feat`: new feature or capability
- `fix`: bug fix
- `docs`: documentation only
- `refactor`: code change that neither fixes a bug nor adds a feature
- `test`: adding or updating tests
- `chore`: maintenance, dependencies, CI, tooling
- `perf`: performance improvement
- `style`: formatting, whitespace (no logic change)
- `ci`: CI/CD configuration
- `build`: build system or external dependencies

If the repo doesn't use conventional commits, omit the `type(scope):` prefix and start with a verb instead.

**Scope** — detect from the changed files:
- If all changes are in one module/directory, use that as scope (e.g., `feat(auth):`, `fix(api):`)
- If changes span multiple modules but have a clear theme, use the theme (e.g., `refactor(di):`)
- If changes are too broad to scope, omit the scope (e.g., `feat:` not `feat(everything):`)

**Summary line rules:**
- Keep it under 72 characters
- Use present tense ("add feature" not "added feature")
- Be specific and descriptive
- Focus on the **why** or **what**, not how it was implemented
- Start with a lowercase letter after the prefix (conventional commits convention)

**Breaking changes:** If the staged changes include any of these, add `BREAKING CHANGE:` footer or `!` after the type:
- Public API changes (renamed/removed endpoints, changed signatures)
- Database schema changes (migrations, column removals)
- Configuration format changes
- Removed or renamed exports, types, or public interfaces

```
feat(api)!: change authentication to OAuth2

BREAKING CHANGE: removes basic auth support. All clients must migrate to OAuth2 tokens.
```

**Examples of good summary lines:**
- `feat(auth): add user authentication to profile screen`
- `fix(team): prevent crash when team has no players`
- `refactor(navigation): simplify coordinator initialization`
- `chore(deps): update dependencies to latest versions`
- "Add user authentication to profile screen" (no-convention style)

**Optional detailed explanation:**
- Add when the summary doesn't fully convey the context
- Explain the motivation for complex changes
- Reference related issues or tickets
- Provide context that reviewers might need

### 4. Present the Commit Message

Output the generated commit message in a clear format:

```
Suggested commit message:

<the commit message>
```

Then ask if the user would like to:
- Use this message as-is
- Modify it
- Generate an alternative

**Do not automatically commit** - just provide the message and let the user decide what to do with it.

## Examples

### Example 1: Simple bug fix (conventional commits detected)

**Git diff shows:** Fixed a nil pointer crash in `TeamDetailView.swift`

**Generated message:**
```
fix(team): prevent crash when team has no players assigned

Prevents nil pointer exception when accessing player array in team detail view.
```

### Example 2: New feature (no convention detected)

**Git diff shows:** Added new subscription management screen with multiple files

**Generated message:**
```
Add subscription management screen for organizations

Allows organization admins to view, create, and manage subscription plans.
Includes new view, view model, and coordinator integration.
```

### Example 3: Refactoring with scope

**Git diff shows:** Reorganized authentication logic across multiple files in `src/auth/`

**Generated message:**
```
refactor(auth): simplify repository and view model dependencies

Moves repository logic to dedicated classes and reduces coupling
between auth view models and service layer.
```

### Example 4: Breaking change

**Git diff shows:** Changed API response format, removed deprecated fields

**Generated message:**
```
feat(api)!: update user endpoint response to v2 schema

BREAKING CHANGE: removes `legacy_id` and `display_name` fields from
/api/users response. Use `id` and `name` instead.
```

### Example 5: Multi-concern staged changes

**Git diff shows:** Fixed a login bug AND added a new settings page

**Suggested response:**
```
These staged changes appear to contain multiple unrelated concerns:
  1. Login bug fix — src/auth/login.ts
  2. New settings page — src/settings/

I'd recommend splitting into separate commits for a cleaner history.
Want me to generate messages for each, or create one combined message?
```

## Notes

- This skill only analyzes **staged changes** (files added with `git add`)
- If no changes are staged, inform the user and suggest staging files first
- If there are unstaged changes alongside staged ones, warn the user
- For very large diffs, focus on the high-level changes rather than line-by-line details
- Always respect the existing commit conventions of the repository — config files take precedence over inferred patterns, which take precedence over defaults
- Convention detection is a best-effort heuristic — if unsure, ask the user
- Focus on **why** the change was made, not **what** changed (the diff already shows what)
- One commit should represent one logical change — suggest splitting when concerns are unrelated
