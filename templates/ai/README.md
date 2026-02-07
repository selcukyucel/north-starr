# .ai/ -- Project Knowledge Base for AI-Assisted Development

This directory is the project-level knowledge base for the **Idea Flow Agentic Workflow**, a methodology for AI-assisted development that makes friction visible and prevents the Cycle of Chaos.

It is language-agnostic. It works for any project type -- backend, frontend, mobile, CLI, data pipeline, or anything else. The contents grow organically through real work, not upfront planning.

---

## Directory Structure

```
.ai/
├── README.md                    # This file
├── QUICK-START.md              # Quick reference for the workflow
├── patterns/                   # Reusable solutions
│   └── _TEMPLATE.md
├── landmines/                  # Known dangerous patterns
│   └── _TEMPLATE.md
├── checklists/                 # Verification frameworks
│   └── _TEMPLATE.md
└── tasks/                      # Per-task context for complex work
    └── .templates/
        ├── CONTEXT.md
        ├── IMPLEMENTATION_PLAN.md
        ├── LEARNINGS.md
        └── FEATURE_DOCUMENTATION.md
```

---

## How Each Directory Is Used

### patterns/ -- Reusable Solutions

Created when a novel solution is discovered during work. These capture approaches that worked well so they can be applied again.

- Use `_TEMPLATE.md` when creating new patterns
- Categories: Architecture, Data, UI, Testing, Integration, Performance
- Each pattern includes: problem context, solution, trade-offs, and examples
- Review existing patterns before solving a problem that may already have a known approach

### landmines/ -- Dangerous Patterns That Waste Time

Created when you hit a gotcha -- something that caused significant debugging time or subtle breakage. These prevent the same pain from recurring.

- Use `_TEMPLATE.md` when creating new landmines
- Severity levels: CRITICAL, HIGH, MEDIUM, LOW
- Each landmine includes: the dangerous pattern, why it fails, the safe alternative
- Read relevant landmines before working in an area with known hazards

### checklists/ -- Step-by-Step Verification

Created for recurring task types where a consistent sequence of steps prevents mistakes. These encode hard-won procedural knowledge.

- Use `_TEMPLATE.md` when creating new checklists
- Each checklist includes: prerequisites, ordered steps, and validation criteria
- Follow relevant checklists during implementation to avoid skipping steps

### tasks/ -- Per-Task Context for Complex Work

Created at the start of complex tasks (many files, unclear requirements, or high risk). Each task gets its own directory containing working context that evolves during the task.

- Named `YYYY-MM-DD-task-name/` (e.g., `2026-02-07-auth-refactor/`)
- Templates in `.templates/` provide the starting structure:
  - `CONTEXT.md` -- Requirements, scope, constraints, and decisions
  - `IMPLEMENTATION_PLAN.md` -- Decomposed sub-problems with validation criteria
  - `LEARNINGS.md` -- Conflicts encountered and how they were resolved
  - `FEATURE_DOCUMENTATION.md` -- Final summary of what was built and why

---

## Integration with the Idea Flow Workflow

The five phases of the workflow interact with this directory as follows:

| Phase | How .ai/ is used |
|-------|------------------|
| **SENSE** | Read `patterns/` and `landmines/` for known friction in the task area. Check prior `tasks/` for related context. |
| **MODEL** | Reference `patterns/` when evaluating approaches. Use existing solutions as starting points. |
| **SCULPT** | Follow relevant `checklists/`. Avoid documented `landmines/`. Record progress in `tasks/`. |
| **VALIDATE** | When conflicts arise, record them in `tasks/LEARNINGS.md`. Check `landmines/` for known causes. |
| **LEARN** | Extract new `patterns/` from successful solutions. Create new `landmines/` from painful gotchas. Update `checklists/` with missed steps. |

---

## Key Principles

**Language-agnostic.** Nothing in this directory assumes a specific language, framework, or platform. The structure works for any project type.

**Living documentation.** These files are updated as part of normal work, not maintained as a separate activity. If a file stops being useful, delete it.

**Friction-driven.** Only document what caused real pain or saved real time. Do not speculatively create patterns or landmines. Every entry should trace back to a concrete experience.

**Progressive.** A new project starts with empty directories and templates. The knowledge base grows through work, not upfront effort. An empty `.ai/` directory is a valid starting state.

---

## Bootstrap

When first adopting this workflow on an existing project, run:

```
/ideaflow-bootstrap
```

This analyzes the codebase and generates initial patterns, vocabulary, and an architecture overview to give the workflow a useful starting point.

---

## Related Files

- `CLAUDE.md` (project root) -- Workflow operating instructions and behavioral rules
- `IDEAFLOW_AGENTIC_WORKFLOW.md` (project root) -- Full methodology reference
- `memory/` (project root) -- Cross-session friction log, pain map, and strategies

---

*This is a living directory. When you discover something worth capturing, add it here. When something stops being relevant, remove it.*
