---
name: autoimprove
description: Autonomously improve any skill prompt using a measure-change-test loop inspired by Karpathy's autoresearch. Runs the skill repeatedly, scores output against a yes/no checklist, makes one small change per round, keeps improvements, reverts regressions. Use when the user asks to "improve a skill", "optimize a skill", "autoimprove", "run autoresearch on a skill", or similar requests about iteratively improving skill quality.
argument-hint: <skill name to improve>
---

# Autoimprove — Autonomous Skill Optimization

## Overview

Iteratively improve any skill's prompt using the autoresearch pattern: **small change -> measure -> keep/revert -> repeat**. The agent runs the target skill, scores output against a user-defined checklist, makes one targeted prompt change per round, and keeps only changes that improve the score.

Inspired by [Karpathy's autoresearch](https://github.com/karpathy/autoresearch) — the same hill-climbing loop applied to ML training, here adapted for skill prompt optimization.

## When to Use

Use this skill when the user requests:
- "Improve my [skill name] skill"
- "Optimize the [skill name] prompt"
- "Run autoresearch on [skill name]"
- "Autoimprove [skill name]"
- "My [skill name] skill gives inconsistent results"
- Any request to iteratively tighten or refine a skill's output quality

## Workflow

### Step 1: Identify the Target Skill

**Actions:**
1. Determine which skill to optimize from the user's request
2. Read the skill's `SKILL.md` file to understand its current prompt
3. If the skill name is ambiguous, list available skills and ask the user to pick one

**Validation:**
- The target must be a skill with a `SKILL.md` file
- Do NOT optimize this skill (autoimprove) — that creates infinite recursion

### Step 2: Gather Test Inputs

Ask the user for **test inputs** — the scenarios the skill will be run against each round.

```
What test input should I use when running this skill?

Examples:
  - For /generate-commit: "use the current staged changes"
  - For /analyze-code: "run it on src/auth/middleware.ts"
  - For /generate-pr: "use the current branch diff"

You can provide 1-3 test inputs. More inputs = more robust but slower rounds.
```

If the user provides no test input, suggest reasonable defaults based on the skill's purpose.

### Step 3: Define the Scoring Checklist

The checklist is the **only metric**. Each item is a yes/no question that checks one specific quality of the skill's output.

**First, offer to help generate the checklist:**

```
I need a scoring checklist — 3-6 yes/no questions that define what "good output" looks like
for this skill. I can help you create one.

Option 1: I'll analyze the skill and propose a checklist (recommended)
Option 2: You provide your own checklist
Option 3: I'll propose one, then you refine it
```

**If generating the checklist (Option 1 or 3):**

1. Read the skill's purpose, workflow, and output format
2. Identify the most common failure modes for this type of output
3. Generate 3-6 yes/no questions that catch those failures
4. Each question must be:
   - **Binary** — unambiguous yes or no, no "sometimes" or "partially"
   - **Specific** — tests one concrete thing, not a vague quality
   - **Observable** — can be answered by reading the output alone
   - **Independent** — doesn't overlap with other checklist items

**Checklist anti-patterns to avoid:**
- "Is the output high quality?" (vague, not binary)
- "Does it follow best practices?" (not specific)
- "Is it good?" (not observable)
- More than 6 items (the skill starts gaming the checklist)

**Example checklist for `/generate-commit`:**

```
1. Does the subject line start with a conventional commit prefix (feat/fix/docs/refactor/test/chore)?
2. Is the subject line under 72 characters?
3. Does the body explain WHY the change was made, not just WHAT changed?
4. Is the message free of filler phrases like "various improvements" or "minor updates"?
```

Present the checklist and get user approval before proceeding.

### Step 4: Run Baseline

**Actions:**
1. Create the output directory: `.plans/autoimprove-<skill-name>/`
2. Copy the original skill file to `.plans/autoimprove-<skill-name>/SKILL-original.md` as backup
3. Run the target skill with each test input
4. Score each output against the checklist (count yes answers / total items)
5. Calculate the baseline score as the average across all test inputs

**Present the baseline:**

```
Baseline Results
────────────────
Skill:      /[skill-name]
Test runs:  [count]
Score:      [X]/[total] ([percentage]%)

Checklist breakdown:
  [x] Question 1                    — passed [N]/[N] runs
  [ ] Question 2                    — passed [N]/[N] runs
  [x] Question 3                    — passed [N]/[N] runs
  [ ] Question 4                    — passed [N]/[N] runs

Weakest items: Question 2, Question 4

Starting optimization loop. I'll make one change per round,
targeting the weakest checklist items first.
```

Write the baseline to `.plans/autoimprove-<skill-name>/results.tsv`:

```
round	change	score	kept	details
0	baseline	[score]	-	Initial score: [X]/[total] per-item breakdown
```

### Step 5: The Optimization Loop

Repeat until **stop condition** is met:

#### 5a. Analyze Failures

Look at which checklist items are failing most across test runs. Identify the **single weakest item** — this is the optimization target for this round.

Read the current skill prompt and identify which part of the prompt is responsible for the failing behavior. Common prompt weaknesses:
- Missing explicit instruction for the failing criterion
- Instruction is present but too vague
- Conflicting instructions that cancel each other out
- Missing worked example showing correct output
- Missing negative example (what NOT to do)

#### 5b. Hypothesize One Change

Formulate **exactly one** small, targeted change to the skill prompt. The change should directly address the weakest checklist item.

**Types of changes (in order of preference):**

1. **Add a specific rule** — "Your headline MUST include a specific number or result."
2. **Add a banned list** — "NEVER use these words: revolutionary, synergy, cutting-edge"
3. **Add a worked example** — show what correct output looks like for the failing criterion
4. **Tighten existing language** — replace vague instruction with specific one
5. **Restructure prompt order** — move critical instructions higher (closer to the top)
6. **Remove conflicting instruction** — if two instructions fight each other, remove the weaker one

**Rules for changes:**
- ONE change per round. Never combine multiple changes — you can't tell which helped.
- The change must be small — a few lines, not a rewrite
- The change must target a specific failing checklist item
- Log the hypothesis: what you're changing, why, and which checklist item it targets

#### 5c. Apply the Change

1. Edit the working copy of the skill prompt (not the original backup)
2. Log the change in the results file

#### 5d. Test the Change

1. Run the skill with ALL test inputs using the modified prompt
2. Score each output against the full checklist
3. Calculate the new average score

#### 5e. Keep or Revert

**If score improved** (new score > previous best score):
- **KEEP** the change
- Log as "advance" in results.tsv
- Update the current best score

**If score stayed the same or decreased:**
- **REVERT** the change (restore the prompt to its state before this round)
- Log as "reverted" in results.tsv
- Note why it didn't help — this prevents trying the same type of change again

**Important edge case:** A change might improve one checklist item but worsen another. Only keep if the **total score** improved. If total is the same but distribution shifted, revert — we want broad improvement, not whack-a-mole.

#### 5f. Log the Round

Append to `.plans/autoimprove-<skill-name>/results.tsv`:

```
[round]	[change description]	[new score]	[kept/reverted]	[per-item breakdown]
```

#### 5g. Check Stop Conditions

Stop the loop if ANY of these are true:
- **Score hit 95%+ three consecutive rounds** — the skill is good enough
- **Max 15 rounds reached** — diminishing returns beyond this
- **3 consecutive reverts** — the remaining failures may not be fixable through prompt changes alone
- **Perfect score (100%) achieved** — nothing left to improve

#### 5h. Present Round Summary

After each round, show a brief status:

```
Round [N]: [kept/reverted]
  Change: [one-line description]
  Target: Question [X] — [question text]
  Score:  [old]% -> [new]% [arrow up/down/same]
  Status: [X] kept, [Y] reverted so far
```

Then continue to the next round without waiting for user input (unless at a checkpoint — see Step 6).

### Step 6: Human Checkpoints

After every **5 rounds**, pause and ask the user:

```
Progress Check (Round [N])
──────────────────────────
Starting score:  [baseline]%
Current score:   [current]%
Changes kept:    [count]
Changes reverted: [count]

Continue optimizing? (y/n/adjust checklist)
```

This prevents runaway loops and lets the user adjust the checklist if the optimization is heading in the wrong direction.

If the user says "autopilot" or "don't ask me" at any checkpoint, skip future checkpoints and run until a stop condition is hit.

### Step 7: Produce Final Output

When the loop stops, generate three artifacts:

#### 7a. Improved Skill File

Save the optimized prompt to `.plans/autoimprove-<skill-name>/SKILL-improved.md`

**Do NOT overwrite the original skill.** The user decides whether to adopt the improved version.

#### 7b. Results Log

The `results.tsv` file already has every round. Add a final summary row:

```
FINAL	-	[final score]	-	Improved from [baseline]% to [final]%. [kept] changes kept, [reverted] reverted across [total] rounds.
```

#### 7c. Changelog

Write `.plans/autoimprove-<skill-name>/CHANGELOG.md`:

```markdown
# Autoimprove Changelog: /[skill-name]

**Date:** [date]
**Baseline Score:** [X]%
**Final Score:** [Y]%
**Rounds:** [total] ([kept] kept, [reverted] reverted)

## Changes Applied (in order)

### Round [N] — KEPT
**Target:** [checklist item]
**Change:** [what was changed in the prompt]
**Why:** [what failure this addressed]
**Score:** [before]% -> [after]%

### Round [N] — REVERTED
**Target:** [checklist item]
**Change:** [what was attempted]
**Why it failed:** [why it didn't improve the score]
**Score:** [before]% -> [after]%

[...repeat for all rounds]

## Checklist Performance

| Question | Baseline | Final | Delta |
|----------|----------|-------|-------|
| [Q1]     | [X]/[N]  | [Y]/[N] | [+/-] |
| [Q2]     | [X]/[N]  | [Y]/[N] | [+/-] |

## Recommendations

[Any observations about remaining failures that can't be fixed through prompt changes —
e.g., "Question 3 fails when the input is very short; this may be an inherent limitation
rather than a prompt issue."]
```

### Step 8: Present Final Summary

```
Autoimprove Complete: /[skill-name]
────────────────────────────────────
Score:   [baseline]% -> [final]% ([+delta]%)
Rounds:  [total] ([kept] kept, [reverted] reverted)

Files:
  Original backup:  .plans/autoimprove-<skill-name>/SKILL-original.md
  Improved version: .plans/autoimprove-<skill-name>/SKILL-improved.md
  Results log:      .plans/autoimprove-<skill-name>/results.tsv
  Changelog:        .plans/autoimprove-<skill-name>/CHANGELOG.md

To adopt the improved skill:
  cp .plans/autoimprove-<skill-name>/SKILL-improved.md skills/<skill-name>/SKILL.md
```

### Step 9: Offer /learn Integration

After presenting the final summary, offer to capture learnings:

```
The changelog contains [N] insights about what works and what doesn't
for this skill. Want me to run /learn to capture these as pattern rules?
```

If the user agrees, run `/learn` with the changelog as context. The patterns discovered during optimization (e.g., "banned buzzword lists improve output quality") become reusable rules.

## Scoring Protocol

When scoring skill output against the checklist, follow these rules:

1. **Read the full output** before scoring any item
2. **Score each item independently** — don't let one answer influence another
3. **Be strict** — "partially" counts as NO. The item either clearly passes or it doesn't.
4. **Score consistently** — apply the same standard across all rounds. If you're lenient in round 1, be equally lenient in round 5.
5. **Score all test inputs** — the round score is the average across all test inputs, not cherry-picked from the best one

**Scoring format per test input:**

```
Test input: [input description]
  Q1: [YES/NO] — [brief evidence]
  Q2: [YES/NO] — [brief evidence]
  Q3: [YES/NO] — [brief evidence]
  Score: [X]/[total]
```

## Notes

- This skill optimizes **prompts**, not code. For code quality improvements, use `/analyze-code`
- The original skill is never modified — all work happens on copies in `.plans/autoimprove-<skill-name>/`
- The changelog is the most valuable artifact — it captures what works and what doesn't for the specific skill, and persists across sessions
- 3-6 checklist items is the sweet spot. Fewer than 3 gives too little signal. More than 6 and the skill starts gaming individual items at the expense of overall quality
- If the baseline score is already above 90%, the skill may not need optimization — tell the user and ask if they still want to proceed
- Each round's test runs should use the SAME test inputs as the baseline for fair comparison
- The loop runs autonomously but is not infinite — stop conditions and human checkpoints keep it bounded
- When the agent can't improve the score further, it's often because the remaining failures are inherent to the task or the test inputs, not the prompt. The changelog should note this distinction.
