---
name: ideaflow-model
description: Plan implementation for Medium and Complex tasks by building a mental model, evaluating strategies, checking for reuse, and decomposing into sub-problems with micro-cycle estimates. Use after SENSE determines task is Medium or Complex. Trigger phrases: "plan this", "create implementation plan", "model the approach", "evaluate strategies".
---

# Idea Flow MODEL -- Build Understanding Before Building Code

## Purpose

This skill is **Phase 2** of the Idea Flow Agentic Workflow v2.0. It creates an implementation plan by:
1. Loading context from the SENSE phase
2. Building a conceptual model of the relevant code
3. Evaluating 2-3 strategies on safety-oriented axes
4. Checking for reusable solutions before designing new ones
5. Decomposing the task into sub-problems with micro-cycle estimates
6. Generating a structured implementation plan

This skill is **language-agnostic**. It works for any programming language, framework, or project type.

## When to Use

**Use after `/ideaflow-sense` determines the task is Medium or Complex.** Simple tasks skip directly to SCULPT.

**Trigger Phrases**:
- "Plan this"
- "Create implementation plan"
- "Model the approach"
- "Evaluate strategies"
- "How should I implement [task]?"

## Workflow

### Step 1: Load Sense Context

**Actions**:
- Review the Friction Forecast produced by the SENSE phase
- Note the complexity tier, risk dimensions, and expected friction level
- Identify patterns and landmines flagged during SENSE
- Confirm the task scope and requirements are clear before proceeding

If the SENSE phase was not run, stop and recommend running `/ideaflow-sense` first.

**Output**: Confirmed understanding of task scope, risks, and constraints

---

### Step 2: Conceptual Modeling

Build a mental model of the code before proposing changes. The depth of modeling depends on familiarity.

#### For Unfamiliar Code

**Actions**:
- Read and summarize the relevant modules
- Map key entities, relationships, and data flow
- Identify the "grain" of the architecture -- what direction do changes flow easily?
- Flag design-fit concerns early: "This feature goes against the grain of [X pattern]"

**Tools to Use**:
- `Read` -- For specific files identified during SENSE
- `Glob` -- To find related files by pattern
- `Grep` -- To trace data flow, function calls, dependencies

**Output**: Summary of architecture in the affected area, including:
- Key entities and their responsibilities
- Relationships and data flow between components
- The natural "grain" -- where changes fit easily vs. where they resist
- Design-fit concerns (if any)

#### For Familiar Code

**Actions**:
- Verify assumptions by re-reading the actual code (guard against stale memory mistakes)
- Check for recent changes by others that might invalidate prior understanding
- Confirm the mental model still matches reality

**Output**: Confirmed or corrected mental model

---

### Step 3: Strategy Evaluation

Compare 2-3 viable approaches before committing to one. Evaluate each on four axes that map directly to friction sources.

**Evaluation Axes**:

| Axis | What It Measures |
|------|-----------------|
| **Haystack size** | How much changes before we can validate? Smaller = safer. |
| **Cognitive load** | How many details must be held in mind at once? Fewer = safer. |
| **Reversibility** | How hard is it to change direction if wrong? Easier = safer. |
| **Blast radius** | What else could break? Less = safer. |

**Rate each axis**: LOW / MED / HIGH risk

**Format**:

```
### Strategy Comparison

| Axis | Strategy A: [Name] | Strategy B: [Name] | Strategy C: [Name] |
|------|--------------------|--------------------|--------------------|
| Haystack size | [LOW/MED/HIGH] | [LOW/MED/HIGH] | [LOW/MED/HIGH] |
| Cognitive load | [LOW/MED/HIGH] | [LOW/MED/HIGH] | [LOW/MED/HIGH] |
| Reversibility | [LOW/MED/HIGH] | [LOW/MED/HIGH] | [LOW/MED/HIGH] |
| Blast radius | [LOW/MED/HIGH] | [LOW/MED/HIGH] | [LOW/MED/HIGH] |

**Recommendation**: Strategy [X]
**Rationale**: [Explain WHY this strategy has the smallest haystacks and lowest risk. Reference specific tradeoffs.]
```

**Rules**:
- Always recommend the strategy with the smallest haystacks and lowest overall risk
- Explain WHY, not just WHAT -- rationale must reference the axes
- If two strategies are close, prefer the more reversible one
- If a strategy is clever but sacrifices observability, flag that as a concern

**Output**: Strategy comparison table with recommendation and rationale

---

### Step 4: Reuse-First Check

Before designing new components, systematically check for existing solutions. Creating new code when reusable solutions exist is a common source of unnecessary friction.

**Actions** (in order):
1. Search the codebase for similar implementations (`Grep`, `Glob`)
2. Check `.ai/patterns/` for documented solutions that apply
3. Check standard libraries and existing project utilities
4. Only design new components when existing options genuinely do not fit

**Output**: List of reusable components, patterns, and utilities identified. For each:
- What it is and where it lives
- How it applies to this task
- Any adaptations needed

If nothing reusable is found, state that explicitly.

---

### Step 5: Sub-Problem Decomposition

Break the task into sub-problems where each has its own validation cycle. This is the core of keeping haystacks small.

**Each sub-problem must**:
- Be independently verifiable (not just a "step" -- it produces a confirmable result)
- Result in incremental progress toward the goal
- Keep the haystack small for troubleshooting

**For each sub-problem, estimate micro-cycles**:
- A micro-cycle is one PREDICT-CHANGE-OBSERVE-RESULT loop
- Typical micro-cycle touches 1-15 lines of code
- If a sub-problem needs more than 5 micro-cycles, consider decomposing further

**Format**:

```
### Sub-Problems

- [ ] **SP1: [Name]** -- [Description]
  - Validation: [How to verify this is done correctly]
  - Files: [Which files are touched]
  - Estimated micro-cycles: [N]
  - Dependencies: [Which other sub-problems must complete first, or "None"]

- [ ] **SP2: [Name]** -- [Description]
  - Validation: [How to verify]
  - Files: [Which files]
  - Estimated micro-cycles: [N]
  - Dependencies: [SP1 / None / etc.]
```

Use task lists (checkboxes) for 3 or more sub-problems.

**Output**: Ordered list of sub-problems with validation criteria and micro-cycle estimates

---

### Step 6: Generate Implementation Plan

Assemble the outputs from Steps 1-5 into a structured implementation plan.

**For Medium tasks**: Display the plan in the conversation.
**For Complex tasks**: Save to `.ai/tasks/YYYY-MM-DD-name/IMPLEMENTATION_PLAN.md`.

**Plan Template**:

```markdown
# Implementation Plan: [Task Name]

**Date**: [Date]
**Complexity**: [Medium / Complex]
**Estimated micro-cycles**: [Total across all phases]

---

## Chosen Strategy

**Strategy**: [Name]
**Rationale**: [Why this strategy was selected over alternatives]

### Alternatives Considered

| Axis | Chosen: [Name] | Alternative: [Name] | Alternative: [Name] |
|------|----|----|----|
| Haystack size | [LOW/MED/HIGH] | [LOW/MED/HIGH] | [LOW/MED/HIGH] |
| Cognitive load | [LOW/MED/HIGH] | [LOW/MED/HIGH] | [LOW/MED/HIGH] |
| Reversibility | [LOW/MED/HIGH] | [LOW/MED/HIGH] | [LOW/MED/HIGH] |
| Blast radius | [LOW/MED/HIGH] | [LOW/MED/HIGH] | [LOW/MED/HIGH] |

---

## Reusable Components

- [Component/pattern]: [Where it lives] -- [How it applies]
- [Component/pattern]: [Where it lives] -- [How it applies]

---

## Phases

### Phase 1: [Goal]

**Sub-problems**:
- [ ] SP1: [Name] -- [Description]
- [ ] SP2: [Name] -- [Description]

**Files to change**: [List]
**Validation checkpoint**: [What confirms this phase is complete]
**Estimated micro-cycles**: [N]

### Phase 2: [Goal]

**Sub-problems**:
- [ ] SP3: [Name] -- [Description]
- [ ] SP4: [Name] -- [Description]

**Files to change**: [List]
**Validation checkpoint**: [What confirms this phase is complete]
**Estimated micro-cycles**: [N]

[Continue for additional phases...]

---

## Testing Strategy

- **Unit tests**: [What to test, which modules]
- **Integration tests**: [What flows to verify]
- **Manual verification**: [What to check by hand]

---

## Rollback Plan

If the implementation fails or must be abandoned:
- [Step 1: How to revert safely]
- [Step 2: What to clean up]
- [What state the codebase returns to]

---

## Patterns to Apply

- [Pattern name] -- [Why relevant, link to .ai/patterns/ if exists]

## Landmines to Watch

- [Landmine name] -- [What to avoid, link to .ai/landmines/ if exists]

---

## Next Step

Proceed to `/ideaflow-sculpt` to begin executing Phase 1.
```

**Output**: Complete implementation plan, displayed or saved based on complexity tier

---

## Integration with Other Skills

**Receives input from**:
- `/ideaflow-sense` -- Friction Forecast, complexity tier, risk assessment, patterns, landmines

**Outputs used by**:
- `/ideaflow-sculpt` -- Uses the plan to guide micro-cycle execution
- `/ideaflow-validate` -- Uses validation checkpoints and testing strategy
- `/ideaflow-learn` -- Uses estimated vs actual micro-cycles for friction analysis

---

## Tips for Best Results

1. **Do not skip the reuse check.** Reinventing solutions that already exist in the codebase is a common and expensive source of friction.
2. **Keep sub-problems independently verifiable.** If you cannot describe how to confirm a sub-problem is complete, it is not well-defined enough.
3. **Prefer smaller haystacks over fewer phases.** More phases with smaller scopes are safer than fewer phases with larger scopes.
4. **Explain the WHY behind strategy selection.** The rationale is more valuable than the table itself.
5. **Re-read code before modeling.** Stale assumptions about familiar code cause subtle, hard-to-diagnose problems.
6. **Include a rollback plan.** Knowing how to safely undo changes reduces the psychological cost of trying an approach.

---

## Common Mistakes to Avoid

- Skipping MODEL for Medium tasks ("it seems straightforward") -- this is how hidden complexity surprises you during SCULPT
- Choosing a strategy because it is elegant rather than because it is safe
- Decomposing into steps instead of independently verifiable sub-problems
- Forgetting to check `.ai/patterns/` and `.ai/landmines/`
- Underestimating micro-cycles -- when in doubt, estimate higher
- Modeling from memory without re-reading the actual code

---

## Success Indicators

- Clear mental model of the affected code area documented
- Strategy chosen with explicit rationale tied to safety axes
- All sub-problems are independently verifiable with clear validation criteria
- Reuse check completed -- no unnecessary new components planned
- Micro-cycle estimates are realistic (not optimistic)
- Rollback plan exists
- Developer agrees with the plan before SCULPT begins

---

**Version**: 1.0
**Workflow**: Idea Flow Agentic Workflow v2.0, Phase 2 (MODEL)
**Last Updated**: February 2026
