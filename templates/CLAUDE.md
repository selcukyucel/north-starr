# [Project Name]

[One-sentence project description]

<!-- [NORTH-STARR:how-to-approach-tasks] -->
## How to Approach Tasks

Before ANY code change, print this assessment:

| # | Question | Answer |
|---|----------|--------|
| 0 | Is current behavior covered by tests? | Yes / No |
| 1 | How many files will this change? | 1-2 / 3+ |
| 2 | Am I creating new types or protocols? | No / Yes |
| 3 | Does this require cross-module integration? | No / Yes |

**Rules:**
- **Fast-path**: 1 file, no new types, no cross-module impact, existing test coverage → state the file and proceed. No table needed.
- Q0 = No → Write tests for current behavior FIRST
- Q1 = 3+ OR Q2/Q3 = Yes → Run `/invert` automatically. Once the inversion analysis is ready, ask "Proceed with layout plan?" before spawning the `layoutplan` agent. Do not proceed without approval.
- All Low → State files and wait for confirmation

**Workflow:** RED (failing tests) → GREEN (implementation) → Completion summary listing files modified → Ask the user: "What would you like to do next?" with options: Generate commit message, Generate PR description, Run /learn (capture learnings), or Done. Do not run any of these automatically — wait for the user's choice.

**Todo discipline:** Never create a todo item for verification steps like "run tests", "build project", or "verify changes". Testing and building are implicit parts of the implementation workflow, not standalone tasks.

Skip test-first for: config, docs, CI, trivial one-line fixes.
If more files are affected than estimated mid-implementation, STOP and run `/invert`.
Always check `.plans/` for active plans before starting new work.
<!-- [/NORTH-STARR:how-to-approach-tasks] -->

<!-- [NORTH-STARR:auto-learn] -->
## When to Learn Automatically

Run `/learn` automatically when: user corrects your approach, same fix requested twice, your change breaks something, user rejects generated code, you discover an undocumented convention, or you hit a trap not in any landmine rule. Finish the immediate fix first, then capture the insight.
<!-- [/NORTH-STARR:auto-learn] -->

## Tech Stack

[List languages with versions, frameworks, key dependencies, build tools, package manager, test runner, CI/CD — be specific, not generic]

## Architecture

[Name the pattern (MVVM, Clean, etc.), topology (monolith, modular, etc.). List each layer with its responsibility and dependency direction. Include DI approach and state management strategy.]

## Grain

[What changes easily (e.g. adding a new feature screen) vs. what is hard (e.g. changing navigation pattern). State what to avoid going against and why.]

## Module Map

[List each top-level module with one-line purpose. Show key dependencies between modules. Note shared infrastructure.]
