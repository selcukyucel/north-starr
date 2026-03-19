# [Project Name]

[One-sentence project description]

<!-- [NORTH-STARR:how-to-approach-tasks] -->
## How to Approach Tasks

**CRITICAL — BLOCKING REQUIREMENT: You MUST complete this checklist and show it to the user BEFORE using any code-modifying tool (Edit, Write, Agent with code changes). This is NOT optional. Skipping this step is a rule violation.**

**Step 1: Print this complexity assessment (mandatory output before ANY code change):**

```
## Complexity Assessment
| # | Question                                  | Answer      |
|---|-------------------------------------------|-------------|
| 0 | Is current behavior covered by tests?      | [Yes / No]  |
| 1 | How many files will this change?           | [1-2 / 3+]  |
| 2 | Am I creating new types or protocols?      | [No / Yes]  |
| 3 | Is this module unfamiliar to me?           | [No / Yes]  |
| 4 | Does this require cross-module integration?| [No / Yes]  |

→ Complexity: [Low / Medium-High]
→ Action: [State files / Run /invert → layoutplan agent]
```

**Step 2: Follow the action:**

- **If Q0 is No** → Write tests for current behavior FIRST. The Working virtue (highest priority) must be preserved before any change.
- **If ANY answer is Medium/High** → Run `/invert` BEFORE writing any code. `/invert` will persist its analysis to `.plans/` and spawn the `layoutplan` agent on a separate thread to build the implementation plan — keeping your main context clean for coding. Do not skip. Do not "just start coding."
- **If ALL answers are Low** → State which files you'll change and wait for user confirmation before proceeding.

**Step 3: Write failing tests first (RED):**

Before writing implementation code, write tests that describe the expected new behavior.
These tests SHOULD FAIL — they define what "done" looks like.
Use edge cases and failure modes from the `/invert` analysis if available.
Skip this step only for: config-only changes, documentation, CI/build scripts, or trivial one-line fixes.

**Step 4: Write code to pass tests (GREEN):**

Write the minimum implementation to make the failing tests pass.
If during implementation you discover more files are affected than initially estimated, STOP and run `/invert`.

**Step 5: Post-implementation build check:**

After completing code changes, spawn the `build` agent to verify the project compiles.
The build agent runs on a separate thread — keeping error output out of your main context.
If the build agent reports failures it cannot fix, address the remaining errors before continuing.

**Step 6: Post-implementation test check:**

After the build passes, spawn the `test` agent to run the full test suite.
The test agent fixes mechanical breakage (missing imports, renamed methods) automatically.
Logic/behavior failures are reported back with analysis — you decide whether the test or the code is wrong.

**REMINDER: Reading/exploring code is allowed before this checklist. The gate is on CODE CHANGES (Edit, Write), not on research (Read, Grep, Glob, Agent with research).**

**Resuming work:** Always check `.plans/` for active implementation plans before starting new work.
<!-- [/NORTH-STARR:how-to-approach-tasks] -->

<!-- [NORTH-STARR:auto-learn] -->
## When to Learn Automatically

**Run `/learn` automatically — do not wait for the user to ask — when any of these signals occur during a session:**

| Signal | Example | What to Capture |
|--------|---------|-----------------|
| **User corrects your approach** | "No, don't do it that way — use X instead" | **Pattern** — the correct approach so it's followed next time |
| **Same fix requested twice** | User asks you to fix the same issue or area more than once in a session | **Landmine** — the fragile area and why it keeps breaking |
| **Your change breaks something** | Tests fail, build breaks, or existing behavior regresses after your edit | **Landmine** — what broke and why, so it's avoided next time |
| **User rejects generated code** | "That's wrong", "revert that", or user manually undoes your change | **Pattern or Landmine** — capture what was wrong and what's correct |
| **You discover an undocumented convention** | Code follows a pattern not captured in any rule or context file | **Pattern** — document it before it's forgotten |
| **You hit a trap not in any landmine rule** | Something looked safe but caused unexpected problems | **Landmine** — document the trap for future sessions |

**How auto-learn works:**
1. Detect the signal during normal work
2. Finish the immediate fix or correction first
3. Then run `/learn` to capture the insight as a pattern or landmine rule
4. If a pattern or landmine already exists for this area, update it — do not create duplicates. Prompt the user when the update contradicts existing content.
<!-- [/NORTH-STARR:auto-learn] -->

## Tech Stack

[List languages with versions, frameworks, key dependencies, build tools, package manager, test runner, CI/CD — be specific, not generic]

## Architecture

[Name the pattern (MVVM, Clean, etc.), topology (monolith, modular, etc.). List each layer with its responsibility and dependency direction. Include DI approach and state management strategy.]

## Grain

[What changes easily (e.g. adding a new feature screen) vs. what is hard (e.g. changing navigation pattern). State what to avoid going against and why.]

## Module Map

[List each top-level module with one-line purpose. Show key dependencies between modules. Note shared infrastructure.]
