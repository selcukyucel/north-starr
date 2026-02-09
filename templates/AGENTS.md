# North Starr — Friction-Free Development

This project uses [North Starr](https://github.com/selcukyucel/north-starr) for AI-assisted development.

## Getting Started

Run `/architect` (new project) or `/bootstrap` (existing code) to generate project-specific configuration:
- Project context with architecture, grain, module map, and vocabulary
- Path-scoped rules for conventions and constraints
- A project-tuned explorer agent

## Available Skills

- `/architect` — Define architecture for a new project (before code exists)
- `/bootstrap` — Generate project configuration from existing code (run once)
- `/invert` — Deep risk analysis before complex tasks
- `/plan` — Break complex tasks into persistent, trackable implementation plans
- `/document` — Generate documentation for a module
- `/learn` — Update configuration from experience

<!-- [NORTH-STARR:how-to-approach-tasks] -->
## How to Approach Tasks

**Before starting any task, assess its complexity:**

| Complexity | Signals | Action |
|------------|---------|--------|
| **Low** | Single file, straightforward change, well-understood area | Implement directly |
| **Medium** | 3+ files, unfamiliar area, non-trivial logic, or integration points | Run `/invert` then `/plan` automatically |
| **High** | Wide blast radius, irreversible changes, unfamiliar domain, or critical system | Run `/invert` then `/plan` automatically |

**For Medium and High complexity tasks — do this automatically, don't wait for the user to ask:**
1. Run `/invert` — identify risks, edge cases, and failure modes
2. Run `/plan` — break the work into tracked tasks, using invert's risks as constraints
3. Execute the plan with progress tracking and session notes

**Resuming work:** Always check `.plans/` for active implementation plans before starting new work. If an active plan exists, resume it instead of starting fresh.
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
