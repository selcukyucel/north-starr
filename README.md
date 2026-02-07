# north-starr

**Your North Starr for Friction-Free Development**

north-starr is a project bootstrapper for AI coding tools. It analyzes any codebase and generates tool-native configuration — so your AI works effectively from the first task.

Supports [Claude Code](https://docs.anthropic.com/en/docs/claude-code), [VS Code Copilot](https://code.visualstudio.com/docs/copilot/overview), [Cursor](https://cursor.sh), and any tool that reads [AGENTS.md](https://github.com/anthropics/agent-protocol).

It's language-agnostic. Works for any project — iOS, web, backend, infrastructure, anything.

---

## What it does

Most AI coding tools start every project cold. north-starr gives them project-specific context by generating:

- **`AGENTS.md`** — universal project context (works with any AI tool)
- **`CLAUDE.md` files** — architecture, grain, module map, danger zones (auto-loaded by Claude Code)
- **`.claude/rules/`** + **`.github/instructions/`** + **`.cursor/rules/`** — conventions scoped by file path (auto-enforced)
- **`.claude/agents/`** + **`.github/agents/`** — project-tuned specialized agents

This configuration is generated from your actual code — not templates. The `/bootstrap` skill explores your codebase, identifies architecture patterns, detects danger zones, and writes configuration in each tool's native format.

---

## Install

### Claude Code Plugin (recommended)

In Claude Code, run:

```
/plugin marketplace add selcukyucel/north-starr
/plugin install north-starr
```

Skills are available immediately across all your projects. Use as `/north-starr:bootstrap`, `/north-starr:invert`, etc.

### Homebrew (alternative)

If you prefer the CLI for per-project setup:

```bash
brew tap selcukyucel/north-starr https://github.com/selcukyucel/north-starr.git && brew install north-starr
```

Then initialize each project:

```bash
cd your-project
north-starr init
```

### Update

**Plugin:**
```
/plugin update north-starr
```

**Homebrew:**
```bash
brew update && brew upgrade north-starr
north-starr update    # updates skills in current project
```

### Uninstall

**Plugin:**
```
/plugin uninstall north-starr
```

**Homebrew:**
```bash
brew uninstall north-starr && brew untap selcukyucel/north-starr
```

---

## Usage

### Initialize a project

```bash
cd your-project
north-starr init
```

This installs skills and starter context for multiple AI tools:

```
your-project/
├── AGENTS.md                          # Universal — works with any AI tool
├── CLAUDE.md                          # Claude Code starter
├── .claude/skills/                    # Claude Code skills
│   ├── bootstrap/
│   ├── invert/
│   ├── document/
│   ├── learn/
│   ├── commit-message-generator/
│   └── refactoring-analyzer/
└── .github/skills/                    # VS Code Copilot skills (same content)
    └── ...
```

### Bootstrap your project

Open your AI tool and run:

```
/bootstrap
```

This explores your codebase and generates config for all supported tools:

```
your-project/
├── AGENTS.md                          # Universal project context
├── CLAUDE.md                          # Claude Code context
├── src/
│   ├── payments/CLAUDE.md             # Module-level warnings
│   └── auth/CLAUDE.md                 # Module-level context
├── .claude/
│   ├── rules/                         # Claude Code path-scoped rules
│   └── agents/                        # Claude Code agents
├── .github/
│   ├── copilot-instructions.md        # VS Code Copilot context
│   ├── instructions/                  # VS Code Copilot path-scoped rules
│   └── agents/                        # VS Code Copilot agents
└── .cursor/
    └── rules/                         # Cursor path-scoped rules
```

After bootstrap, your AI tool auto-loads this configuration. Rules fire when touching matching files. Module context files appear when working in those directories. No ceremony needed.

### Available skills

| Plugin | Homebrew | When to use |
|--------|----------|-------------|
| `/north-starr:bootstrap` | `/bootstrap` | First time in a project — generates rules, agents, and CLAUDE.md from your code |
| `/north-starr:invert` | `/invert` | Before complex tasks — structured risk analysis (what could go wrong?) |
| `/north-starr:document` | `/document` | When a module needs a CLAUDE.md — generates one from actual code |
| `/north-starr:learn` | `/learn` | After completing work — updates rules, agents, or CLAUDE.md from experience |

### CLI commands

```bash
north-starr init            # Install skills in a project
north-starr update          # Update skills (preserves your config)
north-starr status          # Check setup status
north-starr version         # Show version
north-starr help            # Show help
```

---

## How it works

### The grain concept

Every codebase has a **grain** — a direction that changes flow easily. Adding a new API endpoint might be straightforward. Adding a new data model might require touching 12 files. The bootstrap skill identifies this grain and documents it, so your AI tool knows which changes are safe and which require extra care.

### Self-improving configuration

The system improves through use:

```
/bootstrap  →  generates initial config
     ↓
  you work  →  your AI tool uses the config automatically
     ↓
  /learn    →  updates config from what was discovered
     ↓
  next task →  your AI tool is smarter than last time
```

All generated files are native primitives for each tool — CLAUDE.md for Claude Code, copilot-instructions.md for VS Code Copilot, .cursor/rules for Cursor, AGENTS.md for everything. There's no parallel knowledge system — everything feeds directly into how your tools operate.

### Risk analysis on demand

For complex or high-stakes tasks, `/invert` provides deep structured analysis before you commit to implementation:

- User/consumer impact
- Technical failure modes
- Edge cases
- Architecture and convention risks
- Observability and recovery

This is optional — for routine tasks, the lightweight risk assessment baked into the project CLAUDE.md is sufficient.

---

## Inspiration

north-starr is inspired by the [Idea Flow](https://leanpub.com/ideaflow) methodology by **Janelle Arty Starr** — a framework for making invisible friction visible in software development.

The core insight: *you don't improve productivity by going faster, you improve it by improving control.* north-starr applies this to AI-assisted development by giving your tools the context they need to work with control, not just speed.

### Learn more about Idea Flow

- [*Idea Flow: How to Measure the PAIN in Software Development*](https://leanpub.com/ideaflow) — the book
- [Idea Flow — Janelle Arty Starr](https://www.youtube.com/watch?v=qqaOpSJKdWc) — talk
- [Legacy Code Rocks: Idea Flow with Arty Starr](https://legacycoderocks.libsyn.com/idea-flow-with-arty-starr) — podcast
- [*"The most underrated book in software engineering management"*](https://ericnormand.substack.com/p/the-most-underrated-book-in-software) — Eric Normand

---

## Thanks

- [Tolga Ergin](https://github.com/tolgaergin) — for contributions to the v2.0.0 architecture

## Contributing

Contributions are welcome! If you've improved skills, found edge cases, or adapted north-starr for specific workflows, please open a PR.

## License

MIT — see [LICENSE](LICENSE)
