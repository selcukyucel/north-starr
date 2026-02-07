# North Starr — Friction-Free Development

This project uses [North Starr](https://github.com/selcukyucel/north-starr) skills for Claude Code.

## Getting Started

Run `/bootstrap` to generate project-specific configuration:
- Root `CLAUDE.md` with architecture, grain, module map, and vocabulary
- `.claude/rules/` with conventions scoped by file path
- `.claude/agents/` with a project-tuned explorer agent

## Available Skills

- `/bootstrap` — Generate project configuration (run once)
- `/invert` — Deep risk analysis before complex tasks
- `/document` — Generate CLAUDE.md for a module
- `/learn` — Update rules, agents, and CLAUDE.md from experience

## How to Approach Tasks

Before implementing medium or complex tasks, assess risks first:
- What could go wrong for the user?
- What could fail technically?
- What edge cases might be missed?
- Does this go against the grain of this architecture?

Use plan mode for anything touching 3+ files or unfamiliar areas.
For high-stakes tasks, run `/invert` for deep structured analysis before implementation.
