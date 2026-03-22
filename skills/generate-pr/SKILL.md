---
name: generate-pr
description: Generate a pull request description by analyzing git changes against the target branch and filling in the project's PR template. Use this skill when the user asks to "generate PR description", "write PR description", "create PR body", "fill PR template", "prepare pull request", or similar requests related to pull request documentation.
---

# PR Description Generator

## Overview

Analyze git changes (committed or staged) against a target branch and generate a complete pull request description using the project's PR template. The skill examines diffs, affected modules, commit history, and code context to produce a ready-to-paste PR body.

## When to Use

Use this skill when the user requests:
- "Generate a PR description"
- "Write a PR description"
- "Create a PR body"
- "Fill the PR template"
- "Prepare a pull request"
- Any similar request asking for help with pull request documentation

## Workflow

### 1. Determine the Target Branch and Gather Git Info

Ask the user for the target branch if not provided. Default to `main`.

Run the following git commands to understand the scope of changes:

```bash
git branch --show-current
git log --oneline <target>..HEAD
git diff --stat <target>..HEAD
git diff <target>..HEAD
```

Replace `<target>` with the actual target branch.

**Key information to extract:**
- Current branch name (often contains a ticket ID like `feature/PROJ-1234-description`)
- List of commits being merged
- Files changed with summary stats
- The actual code diffs

### 2. Analyze the Changes

Examine the diff output to understand:
- **What** was changed (which files, modules, components, services)
- **Why** it was changed (new feature, bug fix, refactor, tech debt, migration)
- **Scope** — which layers or modules are affected
- **UI changes** — whether any views or components were added or modified
- **Test coverage** — whether tests were added/updated alongside the changes

**Categorize the PR type:**
- Feature — new user-facing functionality
- Bug Fix — corrects incorrect behavior
- Refactor — restructures code without changing behavior
- Tech Debt — cleanup, migration, dependency updates
- Documentation — docs-only changes

### 3. Extract Ticket Link

Look for a ticket identifier in:
1. The branch name (e.g., `feature/PROJ-1234-something`)
2. Commit messages (e.g., `PROJ-1234: Add feature`)

If a project tracking URL pattern is documented in AGENTS.md or CLAUDE.md, use it to construct the full URL. Otherwise, include just the ticket ID.

If no ticket is found, leave a placeholder: `<!-- Add ticket link here -->`

### 4. Generate Validation Steps

Based on the changes, generate concrete steps for local validation:
- If UI changes: include steps to navigate to the affected screen and verify the visual change
- If behavior changes: include steps to trigger the behavior and verify the outcome
- If refactor/migration: include steps to verify existing behavior is unchanged

### 5. Fill the PR Template

Use this template:

```markdown
## Summary
<!-- What does this PR do? One or two sentences max. -->

## Motivation / Context
<!-- WHY are these changes being made? Link to ticket/issue if applicable. -->
Closes #

## Type of Change
- [ ] New feature
- [ ] Bug fix
- [ ] Refactoring (no functional changes)
- [ ] Performance improvement
- [ ] Documentation / CI/CD

## Changes Made
<!-- Bullet points of key changes. Not every file — just the meaningful decisions. -->
-
-

## How to Test
<!-- Step-by-step so a reviewer can verify it works. -->
1.
2.

## Review Focus
<!-- Tell reviewers WHERE you want their attention most. -->
-

## Screenshots / Demo
<!-- For UI changes: before/after screenshots or screen recordings. -->

## Checklist
- [ ] Self-reviewed my own code
- [ ] No new warnings/errors introduced
- [ ] Tests added or updated
- [ ] Existing tests pass locally
- [ ] Docs updated if needed
```

### 6. Present the Output

Output the generated PR description in a fenced markdown block.

Then ask if the user would like to:
- Use this description as-is
- Modify specific sections
- Regenerate with different emphasis

If UI changes were detected, remind the user to add before/after screenshots by uncommenting the table in the template.

**Do not automatically create a PR** — just provide the description and let the user decide what to do with it.

## Guidelines

- **Be specific, not generic** — "Add battery optimization toggle to Energy Settings" not "Update feature"
- **Match project vocabulary** — use terms from AGENTS.md or CLAUDE.md context files
- **Reference modules by name** — "Updates `User` client and `Profile` feature component"
- **Checklist accuracy** — mark the test checkbox as checked only if the diff actually contains test changes
- **Keep descriptions scannable** — use bullet points, keep paragraphs short
- **Validation steps should be actionable** — "Open the app > Navigate to Settings > Tap Profile" not "Test the feature"

## Examples

### Example 1: Feature PR

**Branch:** `feature/PROJ-5678-user-history`
**Changes:** New history screen, new API endpoint

```markdown
## Summary
Add user activity history screen showing past events with timestamps and details.

## Motivation / Context
Users need visibility into their past activity for auditing and personal tracking.
Closes #5678

## Type of Change
- [x] New feature
- [ ] Bug fix
- [ ] Refactoring (no functional changes)
- [ ] Performance improvement
- [ ] Documentation / CI/CD

## Changes Made
- Add `HistoryListView` displaying events in a chronological list
- Add `/api/history` endpoint to `User`
- Add `HistoryEvent` model with JSON decoding
- Cursor-based pagination matching the API contract (limited to 90 days)

## How to Test
1. Build and run the app on simulator
2. Navigate to Profile → Activity History
3. Verify event list loads with timestamps
4. Scroll to bottom to verify pagination loads more events

## Review Focus
- Pagination logic in `HistoryListView` — edge case handling for empty history
- JSON decoding of `HistoryEvent` — nullable fields

## Screenshots / Demo
<!-- Add screenshots of the history screen -->

## Checklist
- [x] Self-reviewed my own code
- [x] No new warnings/errors introduced
- [x] Tests added or updated
- [x] Existing tests pass locally
- [ ] Docs updated if needed
```

### Example 2: Bug Fix PR

**Branch:** `bugfix/PROJ-9012-crash-on-load`
**Changes:** Fix nil handling in data loader

```markdown
## Summary
Fix crash when loading profile for users without premium subscription.

## Motivation / Context
Users without premium subscriptions hit a nil dereference on the profile screen.
Closes #9012

## Type of Change
- [ ] New feature
- [x] Bug fix
- [ ] Refactoring (no functional changes)
- [ ] Performance improvement
- [ ] Documentation / CI/CD

## Changes Made
- Add nil check for `profile.details` in `ProfileLoader`
- Update `UserProfile` model to make `premiumdetails` optional
- Add test case for users without premium subscription

## How to Test
1. Build and run the app on simulator
2. Log in as a user without premium subscription
3. Navigate to Profile
4. Verify the screen loads without crashing
5. Verify premium features are appropriately hidden

## Review Focus
- Optionality change on `UserProfile.premiumDetails` — ensure callers handle nil

## Screenshots / Demo
<!-- N/A — no UI changes -->

## Checklist
- [x] Self-reviewed my own code
- [x] No new warnings/errors introduced
- [x] Tests added or updated
- [x] Existing tests pass locally
- [ ] Docs updated if needed
```
