---
name: invert
description: Deep structured inversion analysis on a requirement before implementation. Identifies risks, edge cases, failure modes, and convention violations. Use before complex or high-stakes tasks.
argument-hint: <requirement or feature description>
author: Selcuk Yucel
---

# Inversion Analysis — What Could Go Wrong?

## Purpose

Before committing to implementation, systematically invert the requirement: instead of "how do I build this," ask "how could this fail?" Produces a structured risk analysis that feeds directly into planning.

Run this **before** implementation for complex or high-stakes work. For routine tasks, the lightweight risk assessment in the project `CLAUDE.md` is sufficient.

## Input

The user provides a requirement, feature description, or task. Can be a single sentence or a detailed spec.

## Workflow

### Step 1: Understand the Requirement

**Actions:**
1. Restate the requirement in your own words — confirm understanding
2. Read relevant code to understand what exists today
3. Check root context files (`CLAUDE.md`, `AGENTS.md`, `.github/copilot-instructions.md`) for architecture, grain, and module map
4. Identify which modules and layers this task touches

### Step 2: Inversion Analysis

Systematically work through each dimension:

#### A. User / Consumer Impact
- What could frustrate or confuse the end user?
- What existing workflows could this break?
- What happens if the user does something unexpected?
- What accessibility or performance impact could users feel?

#### B. Technical Failure Modes
- What could crash, hang, or corrupt data?
- What race conditions or concurrency issues are possible?
- What happens under load, with bad input, or with no network?
- What external dependencies could fail?

#### C. Edge Cases
- What boundary conditions exist? (empty, null, max, overflow, unicode, etc.)
- What state combinations are unusual but possible?
- What happens on first run, last run, or after a long gap?
- What platform or environment differences could matter?

#### D. Architecture & Convention Risks
- Does this go against the grain? (check grain section in root context files)
- Does this violate any path-scoped rules (`.claude/rules/`, `.github/instructions/`, `.cursor/rules/`)?
- Does this create coupling between modules that were independent?
- Does this introduce a pattern inconsistent with existing code?

#### E. Observability & Recovery
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
| **HIGH** | Significant unknowns, wide blast radius, or irreversible | Run `/plan` to break into tracked pieces, spike first, or clarify requirements |

### Step 4: Produce Output

Present the analysis:

```
## Inversion Analysis: [requirement summary]

**Modules Affected:** [list]
**Against the Grain?** [yes/no — why]

### Risks

1. **[risk name]** — [severity: HIGH/MED/LOW]
   [description, how it could happen, what the impact would be]

2. **[risk name]** — [severity: HIGH/MED/LOW]
   [description, how it could happen, what the impact would be]

[...repeat for each significant risk]

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

**After implementing:**
- [what to verify]
- [what to monitor]
```

## Notes

- This skill is language-agnostic — it works for any project type
- Read actual code before forming opinions — never invert based on assumptions
- Root context files (`CLAUDE.md`, `AGENTS.md`) and path-scoped rules (`.claude/rules/`, `.github/instructions/`, `.cursor/rules/`) provide the baseline for convention checks
- Focus on risks that are **likely and impactful** — don't enumerate every theoretical failure
- If the analysis reveals HIGH risk, recommend running `/plan` to break the task into tracked, safer pieces rather than proceeding with the full scope
- The output of this analysis feeds directly into `/plan` — the risks become constraints and dedicated tasks in the implementation plan
