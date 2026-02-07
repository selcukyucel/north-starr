# Idea Flow Agentic Workflow -- Quick Start

**Quick reference for using the Idea Flow methodology with Claude Code skills**

---

## When to Use This Workflow

**Always** for: new features, non-trivial bug fixes, enhancements, refactoring.

**How to start**: Describe your task, or invoke `/ideaflow-sense`.

**First time on a project?** Run `/ideaflow-bootstrap` to generate project context.

---

## Complexity Quick Assessment

### Simple (< 3 files, clear solution, familiar code)

**Path**: `/ideaflow-sense` --> SCULPT --> VALIDATE

### Medium (3-10 files, some design needed)

**Path**: `/ideaflow-sense` --> `/ideaflow-model` --> SCULPT --> VALIDATE --> `/ideaflow-learn`

### Complex (10+ files, architecture decisions, unfamiliar territory)

**Path**: Full phases + task directory `.ai/tasks/YYYY-MM-DD-name/`

### Upgrade to Complex if:
- Multiple modules need coordinated changes
- Breaking changes to shared interfaces
- Performance profiling required
- Unfamiliar code with no documentation

---

## Skills Cheat Sheet

| Skill | When | What It Does |
|-------|------|--------------|
| `/ideaflow-bootstrap` | First time on project | Generate project context (architecture, vocabulary, patterns, landmines) |
| `/ideaflow-sense` | Start of any task | Assess friction risks, determine complexity, Friction Forecast |
| `/ideaflow-model` | After Sense (Medium/Complex) | Evaluate strategies, decompose sub-problems, create plan |
| `/ideaflow-sculpt` | During coding | Execute with micro-cycles, 20-minute rule, mistake-proofing |
| `/ideaflow-validate` | After coding | Verify quality, conflict resolution, test triage |
| `/ideaflow-learn` | After validation (Medium/Complex) | Experience review, capture patterns/landmines, document features |
| `/ideaflow-document` | After Learn (Medium/Complex), or on-demand | Generate Claude.md by analyzing actual code |

---

## Example Workflows

### Simple: Fix a Bug

```
User: "Fix the null check in the auth handler"

Claude: [Friction Forecast -- 1 line]
        Simple task, 1 file, familiar code. Proceeding.

        PREDICT: Adding null check will fix the crash
        CHANGE: Added guard clause
        OBSERVE: Tests pass
        RESULT: CONFIRM

        Done. No friction occurred.
```

### Medium: Add Search Feature

```
User: "Add search filtering to the user list"

Claude: /ideaflow-sense
        Complexity: Medium (3 files, new state + UI)
        Path: SENSE --> MODEL --> SCULPT --> VALIDATE --> LEARN

Claude: /ideaflow-model
        Strategy: Add filter state, debounce input, filter in existing list component
        3 phases, ~8 micro-cycles estimated

Claude: [SCULPT with micro-cycles]
        Phase 1: Add state (3 cycles, all CONFIRM)
        Phase 2: Add logic (3 cycles, 1 CONFLICT -- fixed in 5 min)
        Phase 3: Add UI (2 cycles, all CONFIRM)

Claude: /ideaflow-validate
        All tests pass, no warnings

Claude: /ideaflow-learn
        Experience Review: 8 cycles, 7 CONFIRM, 1 CONFLICT
        Lesson: Debounce timing needed adjustment
```

### Complex: New Feature Module

```
User: "Implement team invitation system with email notifications"

Claude: /ideaflow-sense
        Complexity: Complex (12+ files, 3 modules, new API integration)
        Created: .ai/tasks/2026-02-07-team-invitations/CONTEXT.md

Claude: /ideaflow-model
        5 phases planned, strategy evaluated against 2 alternatives
        Created: .ai/tasks/2026-02-07-team-invitations/IMPLEMENTATION_PLAN.md

[Multiple sessions]
Claude: /ideaflow-sculpt (per phase)
        Phase 1-5 with micro-cycles, conflicts documented in LEARNINGS.md

Claude: /ideaflow-validate
        All tests pass, quality checklist complete

Claude: /ideaflow-learn
        New pattern captured: invitation-state-machine.md
        New landmine captured: email-retry-race-condition.md
        Feature documentation generated
```

---

## The Micro-Cycle

**Every change**: PREDICT --> CHANGE --> OBSERVE --> RESULT

```
PREDICT: Adding the filter function will make tests pass
CHANGE:  Implemented filterUsers() with case-insensitive match
OBSERVE: Ran tests -- 3 pass, 1 fails on empty string edge case
RESULT:  CONFLICT -- empty string returns no results instead of all
```

**Sizing**: 1-5 lines for properties, 5-15 for methods, 10-30 for tests. Never > 50 lines without validation.

**If CONFLICT**: Apply 20-Minute Rule (stop, document, check landmines, decompose).

---

## The 5 Most Impactful Habits

1. **Predict before you validate** -- State what you expect before running anything
2. **Stop at conflict** -- Don't pile on more changes when something unexpected happens
3. **20-Minute Rule** -- Stuck 20 min? Stop coding, document, check landmines, decompose
4. **Record friction** -- If it took > 20 min to resolve, write it down
5. **Reuse before you create** -- Check existing code and patterns before building new

---

## Key Directories

| Directory | Purpose | When Created |
|-----------|---------|-------------|
| `.ai/patterns/` | Reusable solutions | When novel solution discovered |
| `.ai/landmines/` | Known dangerous patterns | When gotcha wastes time |
| `.ai/checklists/` | Verification frameworks | When task type recurs |
| `.ai/tasks/` | Per-task context (Complex) | At start of Complex task |
| `.ai/memory/` | Cross-session knowledge | Ongoing |

---

## Getting Stuck?

1. Apply the 20-Minute Rule
2. Check `.ai/landmines/` for similar issues
3. Check `.ai/patterns/` for applicable solutions
4. Decompose into smaller micro-cycles
5. Ask for help

---

**Version**: 2.0
**Last Updated**: February 2026
