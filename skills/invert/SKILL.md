---
name: invert
description: Deep structured inversion analysis on a requirement before implementation. Identifies risks, edge cases, failure modes, and convention violations. Use before complex or high-stakes tasks.
argument-hint: <requirement or feature description>
---

# Inversion Analysis — What Could Go Wrong?

## Purpose

Before committing to implementation, systematically invert the requirement: instead of "how do I build this," ask "how could this fail?" Produces a structured risk analysis that feeds directly into planning.

Run this **before** implementation for complex or high-stakes work. For routine tasks, the lightweight risk assessment in the project `CLAUDE.md` is sufficient.

## Pre-flight: Auto-sync Check

Before starting, read the root `CLAUDE.md` (if it exists). If `## How to Approach Tasks` appears AFTER `## Tech Stack` or `## Architecture`, the file has an outdated section order. Silently run `/sync` to fix it before continuing with this skill.

## Input

The user provides a requirement, feature description, or task. Can be a single sentence or a detailed spec.

## Workflow

### Step 1: Understand the Requirement

**Actions:**
1. Restate the requirement in your own words — confirm understanding
2. Read relevant code to understand what exists today
3. Check root context files (`CLAUDE.md`, `AGENTS.md`) for architecture, grain, and module map
4. Identify which modules and layers this task touches
5. **Surface assumptions** — what does this requirement take for granted? List every assumption the requirement makes about:
   - Input data (format, quality, availability, freshness)
   - User behavior (technical skill, workflow, frequency of use)
   - External systems (uptime, API stability, version compatibility)
   - Domain rules (regulatory stability, business logic, compliance criteria)
   - Infrastructure (latency, storage, compute budget)
   For each assumption, ask: "What happens if this is wrong?" Assumptions that would cause HIGH impact if wrong become risks in Step 2.

### Step 2: Inversion Analysis

Systematically work through each dimension:

#### A. User / Consumer Impact
- What could frustrate or confuse the end user?
- What existing workflows could this break?
- What happens if the user does something unexpected?
- What accessibility or performance impact could users feel?
- **Who is most harmed** if this feature produces wrong output — and how badly? (e.g., financial loss, legal liability, regulatory penalty, reputational damage, safety risk). Name the specific stakeholder roles.
- Are there **domain-specific consequences** beyond software failure? (e.g., regulatory non-compliance, contractual breach, audit failure, licence revocation). If yes, these risks are automatically HIGH severity regardless of technical likelihood.

#### B. Technical Failure Modes
- What could crash, hang, or corrupt data?
- What race conditions or concurrency issues are possible?
- What happens under load, with bad input, or with no network?
- What external dependencies could fail? (API rate limits, model version changes, service outages, vendor lock-in)

**If this feature uses AI/ML (LLMs, RAG, embeddings, classifiers, or any model inference):**
- **Hallucination**: Could the model generate confident but factually wrong output? What are the consequences if it does?
- **Stale retrieval**: Could the RAG pipeline return outdated or irrelevant context? What happens if the knowledge base is out of date?
- **Prompt injection**: Could user-provided input manipulate the model to bypass business rules, leak data, or produce unintended output?
- **Model drift**: If the underlying model is updated or swapped, could output quality degrade silently? Is there a baseline to compare against?
- **Confidence calibration**: Does the system surface uncertainty to users, or does it present all output with equal confidence? What happens at low-confidence thresholds?
- **Data pipeline integrity**: At each step of the pipeline (ingestion → parsing → embedding → retrieval → generation → post-processing), what could go wrong? What validation exists between steps?

#### C. Data Flow & Pipeline Risks
- **Map the data flow** — trace data from entry to final output. What are the steps? (e.g., upload → validate → transform → store → notify, or ingest → parse → embed → retrieve → generate → review)
- At each handoff between steps: what could be lost, corrupted, or delayed?
- What happens if a middle step fails — does the pipeline retry, roll back, or leave partial state?
- Is there an idempotency guarantee if the same input is processed twice?
- What validation exists between steps — and what's missing?

#### D. Edge Cases & Boundary Conditions
- What boundary conditions exist? (empty, null, max, overflow, unicode, etc.)
- What state combinations are unusual but possible?
- What happens on first run, last run, or after a long gap?
- What platform or environment differences could matter?

#### E. Architecture & Convention Risks
- Does this go against the grain? (check grain section in root context files)
- Does this violate any path-scoped rules (`.claude/rules/`, `.github/instructions/`)?
- Does this create coupling between modules that were independent?
- Does this introduce a pattern inconsistent with existing code?

#### F. Virtue Trade-offs (Code Quality)

Check this change against the 7 Code Virtues (see `skills/_references/virtues/code-virtues.md`) in priority order:

- **Working**: Could this break existing behavior? Are there tests proving current correctness?
- **Unique**: Does this duplicate logic that already exists elsewhere?
- **Simple**: Does this add unnecessary entities, relationships, or indirection?
- **Clear**: Will the result be obvious to the next reader, or puzzling?
- **Easy**: Will this make future changes harder or easier?
- **Developed**: Are the abstractions mature and well-placed, or primitive?
- **Brief**: Is there unnecessary verbosity?

When two virtues conflict, **always preserve the higher-priority one**. Name the tension explicitly in the risk output:

```
**Virtue Tension:** [lower virtue] would improve, but at the cost of [higher virtue] → preserve [higher virtue]
```

#### G. Observability & Recovery
- If this fails in production, how would anyone know?
- Can the failure be diagnosed from logs/errors alone?
- Is the change reversible? What's the rollback path?
- What monitoring or alerting should exist?

### Step 3: Assess and Prioritize

Rate the overall risk:

| Level | Meaning | Action |
|-------|---------|--------|
| **LOW** | Well-understood, contained, reversible | Proceed to implementation |
| **MEDIUM** | Some unknowns, but manageable with care | Plan carefully, validate incrementally |
| **HIGH** | Significant unknowns, wide blast radius, or irreversible | Spawn the `layoutplan` agent to break into tracked pieces, spike first, or clarify requirements |

### Step 4: Produce Output

Present the analysis:

```
## Inversion Analysis: [requirement summary]

**Modules Affected:** [list]
**Against the Grain?** [yes/no — why]
**Virtue Tensions:** [any virtue trade-offs identified, or "none"]

### Risks

1. **[risk name]** — [severity: HIGH/MED/LOW]
   [description, how it could happen, what the impact would be]

2. **[risk name]** — [severity: HIGH/MED/LOW]
   [description, how it could happen, what the impact would be]

[...repeat for each significant risk]

### Assumptions (verify before implementing)

- [assumption]: [what happens if wrong]
- [assumption]: [what happens if wrong]

### Edge Cases to Handle

- [case]: [what should happen]
- [case]: [what should happen]

### Recommendations

**Overall Risk:** [LOW / MEDIUM / HIGH]

**Before implementing:**
- [prerequisite or clarification needed]

**During implementation:**
- [specific thing to watch for]
- [specific validation to include]

**Test strategy:**
- [specific test approach for each HIGH/MED risk — e.g., golden file tests, integration tests against real pipeline, adversarial input tests, human review sampling, load tests, A/B comparison against manual output]
- [what constitutes "passing" — acceptance threshold, not just "it works"]

**After implementing:**
- [what to verify]
- [what to monitor — specific metrics, dashboards, alerts]
```

### Step 5: Persist to Disk

After presenting the analysis to the user (and incorporating any feedback), write it to disk so downstream agents can consume it without context loss.

**Actions:**
1. Create `.plans/` directory if it doesn't exist
2. Generate a short kebab-case name from the requirement (e.g., `auth-refactor`, `api-pagination`)
3. Write the full analysis to `.plans/INVERT-<name>.md` using this format:

```markdown
# Inversion Analysis: <requirement summary>

**Created:** <date>
**Overall Risk:** <LOW / MEDIUM / HIGH>
**Modules Affected:** <list>
**Against the Grain?** <yes/no — why>
**Virtue Tensions:** <any virtue trade-offs identified, or "none">

## Risks

1. **<risk name>** — [severity]
   <description>

[...all risks]

## Assumptions (verify before implementing)

- <assumption>: <what happens if wrong>

## Edge Cases to Handle

- <case>: <what should happen>

## Recommendations

**Before implementing:**
- <items>

**During implementation:**
- <items>

**Test strategy:**
- <specific test approaches for each HIGH/MED risk>

**After implementing:**
- <items>
```

4. Inform the user: "Analysis saved to `.plans/INVERT-<name>.md`"

### Step 6: Trigger Planning

If the overall risk is MEDIUM or HIGH, prompt the user:

> "Risk is [MEDIUM/HIGH]. I'll spawn the layoutplan agent to build an implementation plan from this analysis. It runs on a separate thread so your main context stays clean."

Then spawn the `layoutplan` agent (available in `.claude/agents/` or `.github/agents/`). The agent runs on a separate thread to keep the main context clean.

For LOW risk, inform the user that the `layoutplan` agent is available if they want structured planning, but it's optional.

## Notes

- This skill is language-agnostic — it works for any project type
- Read actual code before forming opinions — never invert based on assumptions
- Root context files (`CLAUDE.md`, `AGENTS.md`) and path-scoped rules (`.claude/rules/`, `.github/instructions/`) provide the baseline for convention checks
- Focus on risks that are **likely and impactful** — don't enumerate every theoretical failure
- If the analysis reveals HIGH risk, recommend spawning the `layoutplan` agent to break the task into tracked, safer pieces rather than proceeding with the full scope
- The output of this analysis feeds directly into the `layoutplan` agent — the risks become constraints and dedicated tasks in the implementation plan
