---
name: ideaflow-learn
description: Capture learnings from completed tasks by generating Experience Review, creating patterns and landmines from conflicts, documenting features, and updating memory files. Use after validation is complete for Medium and Complex tasks. Trigger phrases: "extract learnings", "capture patterns", "document what we learned", "experience review".
---

# LEARN -- Idea Flow Agentic Workflow v2.0

Record friction, capture reusable knowledge, and document features for future work. This is the LEARN phase of the Idea Flow Agentic Workflow v2.0. Language-agnostic.

---

## When to Use

- After `/ideaflow-validate` for Medium and Complex tasks.
- Skip for Simple tasks with no friction.

---

## Step 1: Generate Experience Review

Summarize what happened during the task:

```
## Experience Review

**Task:** [what was done]
**Complexity:** [Simple/Medium/Complex]

**Friction Events:**
- [event]: [duration], [pain type], [cause], [what would have prevented it]

**Micro-Cycle Stats:** [N] total, [N] CONFIRM ([%]), [N] CONFLICT ([%])

**Patterns:** [any recurring friction patterns noticed]
**Lesson:** [key takeaway]
**Suggested Improvement:** [one specific action to reduce friction next time]
```

---

## Step 2: Extract Patterns (If Novel Solutions Discovered)

For each reusable solution discovered during the task:

1. Check if a similar pattern already exists in `.ai/patterns/`.
2. If new, create `.ai/patterns/[name].md` using `_TEMPLATE.md`.
3. Include: when to use, problem it solves, implementation, best practices, common mistakes, testing.

---

## Step 3: Extract Landmines (If Gotchas Discovered)

For each gotcha that wasted time:

1. Check if a similar landmine already exists in `.ai/landmines/`.
2. If new, create `.ai/landmines/[name].md` using `_TEMPLATE.md`.
3. Include: severity, symptoms, root cause, safe approach, validation, prevention.

---

## Step 4: Feature Documentation (Medium/Complex New Modules)

If the task created or significantly modified a module:

1. Use template from `.ai/tasks/.templates/FEATURE_DOCUMENTATION.md`.
2. Document: architecture, key components, data flow, integration points, edge cases, common tasks.
3. Save to appropriate location (within feature directory or `.ai/tasks/`).

---

## Step 5: Update Memory Files

- `memory/friction-log.md` -- Add friction events with pain type tags.
- `memory/vocabulary.md` -- Add any new codebase terms discovered.
- `memory/patterns.md` -- Update index if new patterns created.

---

## Step 6: Cycle of Safety Check

Briefly assess:

- Is friction trending up or down compared to recent sessions?
- What is the dominant pain type?
- Are we in the Cycle of Safety (predictions accurate, conflicts resolve quickly) or drifting toward Chaos (surprises frequent, debugging takes hours)?
- What single improvement would have the biggest impact?

---

## Step 7: Classify Friction with Ten Pains

Tag each friction event from Step 1 using the Ten Pains classification:

| # | Pain Type | Trigger |
|---|---|---|
| 1 | DESIGN_FIT | Feature does not fit architecture |
| 2 | REQUIREMENTS | Requirements wrong, unclear, or changed |
| 3 | MODELING | Code hard to understand, ambiguous names, scattered concerns |
| 4 | COLLABORATION | Merge conflicts, broken builds, coordination overhead |
| 5 | EXPERIMENT | Hard to validate behavior, slow feedback loops |
| 6 | ALARM | Test maintenance, false alarms, cryptic test failures |
| 7 | COGNITIVE | Too many details to hold in memory at once |
| 8 | EXECUTION | Changes inherently mistake-prone, tedious, error-inviting |
| 9 | FAMILIARITY | Unfamiliar code, tools, libraries, or conventions |
| 10 | DISRUPTION | Context switching, interruptions, multi-tasking |

Keep concise. No emojis.
