# North Starr — Friction-Free Development

This project uses [North Starr](https://github.com/selcukyucel/north-starr) skills for Claude Code.

## Getting Started

Run `/architect` (new project) or `/bootstrap` (existing code) to generate project-specific configuration:
- Root `CLAUDE.md` with architecture, grain, module map, and vocabulary
- `.claude/rules/` with conventions scoped by file path
- `.claude/agents/` with a project-tuned explorer agent

## Available Skills

- `/architect` — Define architecture for a new project (before code exists)
- `/bootstrap` — Generate project configuration from existing code (run once)
- `/invert` — Deep risk analysis before complex tasks
- `/plan` — Break complex tasks into persistent, trackable implementation plans
- `/document` — Generate CLAUDE.md for a module
- `/learn` — Update rules, agents, and CLAUDE.md from experience

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
