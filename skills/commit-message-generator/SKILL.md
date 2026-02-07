---
name: commit-message-generator
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
git log -5 --oneline
```

**Key information to extract:**
- Files that have been staged (from `git status`)
- The actual code changes (from `git diff --staged`)
- Recent commit message patterns in the repository (from `git log`)

### 2. Analyze the Changes

Examine the staged changes to understand:
- **What** was changed (which files, functions, components)
- **Why** it might have been changed (bug fix, new feature, refactor, etc.)
- **Scope** of the changes (single feature, multiple areas, specific module)

**Important considerations:**
- Focus on the purpose and impact of the changes
- Identify the main theme if multiple files were changed
- Note if changes are related to UI, backend, tests, documentation, etc.
- Consider the magnitude: minor tweak vs. major refactor

### 3. Generate the Commit Message

Create a clear, concise commit message following these guidelines:

**Format:**
```
<summary line>

<optional detailed explanation if needed>
```

**Summary line rules:**
- Keep it under 72 characters
- Use present tense ("Add feature" not "Added feature")
- Be specific and descriptive
- Focus on what changed, not how it was implemented
- Start with a verb when possible (Add, Fix, Update, Remove, Refactor, etc.)

**Examples of good summary lines:**
- "Add user authentication to profile screen"
- "Fix crash when loading team details"
- "Update navigation bar styling for iOS 15"
- "Remove deprecated payment API calls"
- "Refactor team list view model for better performance"

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

### Example 1: Simple bug fix

**Git diff shows:** Fixed a nil pointer crash in `TeamDetailView.swift`

**Generated message:**
```
Fix crash when team has no players assigned

Prevents nil pointer exception when accessing player array in team detail view.
```

### Example 2: New feature

**Git diff shows:** Added new subscription management screen with multiple files

**Generated message:**
```
Add subscription management screen for organizations

Allows organization admins to view, create, and manage subscription plans.
Includes new view, view model, and coordinator integration.
```

### Example 3: Refactoring

**Git diff shows:** Reorganized authentication logic across multiple files

**Generated message:**
```
Refactor authentication module for better separation of concerns

Moves repository logic to dedicated classes and simplifies view model dependencies.
```

## Tips for Better Commit Messages

- **Be consistent**: Match the style of recent commits in the repository
- **Be specific**: "Fix payment bug" → "Fix payment processing for expired cards"
- **Avoid technical jargon**: Write for other developers who may not know implementation details
- **Group related changes**: If changes span multiple areas, mention the main theme
- **Keep it simple**: One commit should represent one logical change

## Notes

- This skill only analyzes **staged changes** (files added with `git add`)
- If no changes are staged, inform the user and suggest staging files first
- For very large diffs, focus on the high-level changes rather than line-by-line details
- Always respect the existing commit conventions of the repository when detected
