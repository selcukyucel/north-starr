---
name: plan
description: Break complex tasks into persistent implementation plans that survive session boundaries. Tracks progress, session notes, and architecture decisions so any AI tool can resume where the last session left off. Use after /invert for medium and high complexity tasks.
argument-hint: <task description> | resume | status
---

# Plan — Persistent Implementation Plans

## Purpose

Break complex tasks into a persistent plan file with progress tracking, session notes, and resumption support. The plan file survives session boundaries so any AI tool can pick up where the last session left off.

Complex tasks exceed AI context windows. When a new session starts, the AI loses all context — what was done, what was decided, what's next. This skill solves that by making the plan the source of truth.

**Recommended workflow for complex/high-stakes work:**

```
/invert  →  identifies risks, edge cases, failure modes
    ↓
/plan    →  breaks work into tasks, with invert's risks as constraints
    ↓
  work   →  execute tasks, track progress, add session notes
    ↓
/learn   →  capture reusable insights from the experience
```

## When to Use

- Tasks touching 3+ files or unfamiliar areas
- Multi-session work that needs continuity
- After `/invert` reveals medium or high complexity
- When you need to track progress across sessions
- When multiple people (or AI sessions) will work on the same task

## Workflow

### Step 1: Check for Active Plans

**Actions:**
1. Look for `.plans/PLAN-*.md` files in the project root
2. If the user said "resume" or "status":
   - List active plans with their status
   - For "resume": open the most recent active plan, read its state, and continue from the last IN_PROGRESS task
   - For "status": show a summary of all plans (tasks done, in progress, blocked, pending)
3. If an active plan exists and the user is describing new work:
   - Ask whether to resume the existing plan or create a new one
4. If no plans exist, proceed to Step 2

### Step 2: Check for Inversion Analysis

**Actions:**
1. Check if `/invert` was run recently in this session (look for inversion analysis output in the conversation)
2. If inversion analysis is available:
   - Extract risks, edge cases, and failure modes
   - These become constraints and dedicated tasks in the plan
3. If no inversion analysis and the task appears complex:
   - Recommend running `/invert` first
   - Explain: "Inversion analysis discovers risks and edge cases that directly shape how the plan is structured. Without it, the plan may miss critical constraints."
   - If the user wants to proceed without inverting, continue — but note the gap

### Step 3: Understand the Task

**Actions:**
1. Read root context files (`CLAUDE.md`, `AGENTS.md`, `.github/copilot-instructions.md`) for architecture, grain, and module map
2. Explore the relevant code areas to understand current state
3. Identify which modules, layers, and files are affected
4. Note dependencies between affected areas
5. Restate the task in your own words — confirm understanding with the user

### Step 4: Break Down

**Actions:**
1. Decompose into **2-6 main tasks** — each self-contained enough for a fresh session to execute
2. For each task, identify:
   - Subtasks (concrete, checkable items)
   - Key files that will be created or modified
   - Dependencies on other tasks (what must come first)
   - Description sufficient for a fresh session with no prior context
3. Map risks from `/invert` to specific tasks:
   - A risk about race conditions → a concurrency-handling task
   - A risk about data loss → a backup/validation subtask
   - A risk about breaking existing behavior → a dedicated test task
4. Order tasks by dependency — blocked tasks come after their dependencies
5. Keep the total manageable — if you have more than 6 tasks, group related work

### Step 5: Write the Plan File

**Actions:**
1. If `.plans/` directory doesn't exist, create it
2. On first use in a project, ask the user: "Should I add `.plans/` to `.gitignore`? Plans are working documents — most teams prefer to keep them local."
3. Generate a short, descriptive name from the task (e.g., `auth-refactor`, `api-pagination`, `plan-skill`)
4. Write `.plans/PLAN-<name>.md` using the format below
5. Present the plan for review before proceeding to execution

**Plan file format:**

```markdown
# Plan: <name>

**Created:** <date>
**Status:** ACTIVE | COMPLETED
**Source:** <brief origin — e.g., "user request", "invert analysis revealed HIGH risk">

## Goal
<1-3 sentences — enough for a fresh session to understand without prior context>

## Risks & Constraints
<sourced from /invert analysis — risks that shaped this plan's structure>
- **<risk>** [severity] — <how the plan addresses it>

## Architecture Decisions
- [date] <decision and rationale>

## Key Files
- `path/to/file` — <role>

## Tasks

### 1. <task title>
**Status:** PENDING | IN_PROGRESS | DONE | BLOCKED
**Files:** <key files>
**Blocked by:** <task numbers, if any>

<Description — self-contained enough for a fresh session to execute>

**Subtasks:**
- [ ] subtask

**Session Notes:**
- [date] <context that survives session boundaries>

---

## Completion
**Completed:** <date>
**Summary:** <what was accomplished>
**Learnings:** <anything worth capturing via /learn>
```

### Step 6: Execute

When the user is ready to work (or says "resume"):

**Actions:**
1. Find the next task that is PENDING and not blocked
2. Mark it IN_PROGRESS in the plan file
3. Work through the subtasks, checking them off as completed
4. Add timestamped session notes for anything a future session would need to know:
   - Decisions made and why
   - Unexpected discoveries
   - Partial progress details
   - Blockers encountered
5. When a task is complete, mark it DONE
6. If a task is blocked, mark it BLOCKED and note what it's waiting for
7. Move to the next available task

**Session boundary handling:**
- At the end of a session (or if the context is getting long), update the plan file with current state
- A fresh session should be able to read the plan file and know exactly where to pick up

### Step 7: Complete

When all tasks are DONE:

**Actions:**
1. Update the plan status to COMPLETED
2. Fill in the Completion section:
   - Date
   - Summary of what was accomplished
   - Any learnings worth capturing
3. Ask the user: "Plan complete. Would you like to:"
   - **Keep** the plan file (for reference)
   - **Delete** it (clean up)
   - **Run `/learn`** to capture reusable insights from this experience

## Notes

- This skill is language-agnostic — works for any project type
- Plans are working documents, not documentation — keep them practical
- The `.plans/` directory is at project root so any AI tool can discover it (not hidden under `.claude/` or `.github/`)
- Task descriptions should be self-contained — a fresh session reads only the plan file to understand what to do
- Session notes are the most critical feature — they're what makes session-to-session handoff work
- Don't over-plan: 2-6 tasks is the sweet spot. If you need more, you're probably planning too far ahead
- Architecture Decisions section prevents re-litigating settled questions in future sessions
- The plan file is the single source of truth during execution — update it, not a separate tracking system
