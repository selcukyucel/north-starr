---
name: ideaflow-sense
description: Start any task by assessing friction risks, determining complexity (Simple/Medium/Complex), checking patterns and landmines, and delivering a Friction Forecast. Use at the beginning of every new feature, bug fix, or enhancement. Trigger phrases: "start task", "assess this", "friction forecast", "what's the complexity".
---

# SENSE -- Idea Flow Agentic Workflow v2.0

The SENSE phase is the entry point for every task. Before writing any code, assess friction risks, check project knowledge, and deliver a structured Friction Forecast. This skill is language-agnostic.

---

## Step 1: Gather Context

- Read the user's task description carefully. Restate it in your own words to confirm understanding.
- Search for related files in the codebase using Glob and Grep. Identify which modules, layers, and files are affected.
- Note the scope: how many files, how many modules, how many integration points.

## Step 2: Check Project Knowledge

- Read relevant `.ai/patterns/` files for applicable architectural patterns and conventions.
- Read relevant `.ai/landmines/` files for known warnings, gotchas, and areas of danger.
- Check `memory/vocabulary.md` for codebase-specific terminology and resolved ambiguities.
- Check `memory/friction-log.md` for prior friction events in the affected area.
- Check `memory/strategies.md` for approaches that previously worked or failed in similar contexts.
- Check `memory/pain-map.md` for known pain areas that overlap with this task.

## Step 3: Risk Assessment (4 Dimensions)

Evaluate each dimension as HIGH, MED, or LOW with a brief justification:

| Dimension | Question |
|---|---|
| **Familiarity** | Has this area been worked on before? Is the code well-understood? Are there recent changes? |
| **Quality** | What is the likelihood of mistakes? Is the code complex, are dependencies brittle, are tests missing or noisy? |
| **Assumption** | Are requirements clear and complete? Could the chosen approach be wrong? Are there unstated expectations? |
| **Dependency** | Are external APIs, libraries, shared modules, or other team's code involved? How stable are they? |

## Step 4: Structured Inversion Thinking (Medium/Complex tasks)

Systematically identify what could go wrong by working through each category:

1. **User/Consumer Impact** -- What could frustrate or confuse users? What workflows could break? What expectations might be violated?
2. **Technical Risks** -- What could fail, crash, or produce incorrect results? Race conditions, data corruption, memory issues, error handling gaps?
3. **Edge Cases** -- Unusual scenarios to consider: empty data, excessive data, offline/disconnected state, concurrent access, invalid or malformed input, boundary values, permission issues.
4. **Observability Gaps** -- Can we detect problems in production? Are there sufficient logs, metrics, or alerts? Would a failure be silent?
5. **Convention Violations** -- Does this task go against the codebase's architectural grain? Does it introduce patterns inconsistent with existing conventions? Would it surprise another developer?

Skip this step for Simple tasks unless a specific concern warrants it.

## Step 5: Assess Complexity

Classify the task into one of three levels:

| Level | Criteria |
|---|---|
| **Simple** | Fewer than 3 files affected. Clear solution path. Familiar code. Low risk across all dimensions. |
| **Medium** | 3-10 files affected. Some design decisions required. Moderate risk in one or more dimensions. |
| **Complex** | 10+ files affected. Architecture-level decisions. Unfamiliar territory. High risk in multiple dimensions. |

**Upgrade triggers** -- If any of these apply, consider upgrading the complexity level:

- Changes span multiple modules or architectural layers
- Breaking changes to public interfaces or shared contracts
- Performance profiling or optimization required
- Task likely spans multiple sessions
- Significant unfamiliar code, tools, or libraries involved
- Integration with external systems or APIs with unknown behavior

## Step 6: Determine FLOW Path

Based on the assessed complexity, determine which workflow phases to follow:

| Complexity | Flow Path |
|---|---|
| **Simple** | SENSE --> SCULPT --> VALIDATE |
| **Medium** | SENSE --> MODEL --> SCULPT --> VALIDATE --> LEARN |
| **Complex** | SENSE --> MODEL --> SCULPT --> VALIDATE --> LEARN (full ceremony) + create `.ai/tasks/YYYY-MM-DD-name/` directory for task tracking |

For Complex tasks, create a task directory with a plan document before proceeding to MODEL.

## Step 7: Deliver Friction Forecast

Output the complete Friction Forecast in this format:

```
## Friction Forecast

**Task:** [restate the task in your own words]

**Risk Assessment:**
- Familiarity: [HIGH/MED/LOW] -- [why]
- Quality:     [HIGH/MED/LOW] -- [why]
- Assumption:  [HIGH/MED/LOW] -- [why]
- Dependency:  [HIGH/MED/LOW] -- [why]

**Applicable Patterns:** [list any relevant .ai/patterns/ that apply, or "None found"]
**Known Landmines:** [list any relevant .ai/landmines/ warnings, or "None found"]
**Prior Friction:** [summarize relevant friction-log entries, or "No prior friction recorded"]

**Inversion Findings:** [for Medium/Complex: summarize top risks from Step 4]

**Complexity:** [Simple / Medium / Complex]
**Flow Path:** [the workflow path from Step 6]

**Expected Friction:** [HIGH/MED/LOW -- overall assessment]
**Recommendation:** [proceed normally / break into sub-problems / spike first / clarify requirements first]
```

## Step 8: Ask Clarifying Questions

Use the inversion findings from Step 4 to ask targeted questions about the highest-priority risks. Focus on:

- Requirements that are ambiguous or could be interpreted multiple ways
- Technical decisions where the wrong choice would be costly to reverse
- Dependencies or integrations where behavior is uncertain
- Edge cases where the expected behavior is not obvious

Do not ask questions that can be answered by reading the code. Only ask when human judgment or domain knowledge is needed.

---

## Scaling Guidelines

- **Simple tasks**: Steps 1-3 can be brief (a few lines each). Skip Step 4. Friction Forecast can be compact. Skip clarifying questions if requirements are obvious.
- **Medium tasks**: All steps apply. Inversion thinking focuses on the top 2-3 risk categories. Moderate detail in the Friction Forecast.
- **Complex tasks**: All steps apply with full detail. Inversion thinking covers all 5 categories thoroughly. Create a task tracking directory. Clarifying questions are strongly recommended before proceeding.

**The threshold is friction, not size.** A one-line change in a dangerous area deserves more ceremony than a large change in well-understood, well-tested code.
