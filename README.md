# north-starr

**Your Development Partner. Friction-Free Development.**

north-starr is your AI development partner — not a code owner, not a scaffolder, a partner that learns your codebase, remembers your patterns, warns you about landmines, and gets smarter every time you work together.

It analyzes any codebase and generates tool-native configuration — rules, instructions, context files, and agents — so your AI works effectively from the first task. Then it keeps learning. Every `/learn` invocation captures what you discovered — conventions worth preserving, dangers worth avoiding — and feeds it back into your tools automatically.

Supports [Claude Code](https://docs.anthropic.com/en/docs/claude-code), [VS Code Copilot](https://code.visualstudio.com/docs/copilot/overview), [Cursor](https://cursor.sh), and any tool that reads [AGENTS.md](https://github.com/anthropics/agent-protocol).

Language-agnostic. Works for any project — iOS, web, backend, infrastructure, anything.

Agent Linter Score: [agentlinter.com/r/w7Jo9X0qVOV8](https://agentlinter.com/r/w7Jo9X0qVOV8)

[![agentlinter score: 96/100 A+](assets/agentlinter-score.png)](https://agentlinter.com/r/w7Jo9X0qVOV8)

---

## What it does

Most AI coding tools start every project cold — no memory, no conventions, no awareness of where the landmines are. north-starr gives them project-specific context by generating:

- **`AGENTS.md`** — universal project context (works with any AI tool)
- **`CLAUDE.md` files** — architecture, grain, module map, danger zones (auto-loaded by Claude Code)
- **`.claude/rules/`** + **`.github/instructions/`** + **`.cursor/rules/`** — conventions scoped by file path (auto-enforced)
- **`.claude/agents/`** + **`.github/agents/`** — project-tuned specialized agents

This configuration is generated from your actual code — not templates. The `/bootstrap` skill explores your codebase, identifies architecture patterns as **pattern rules** (how things are done here) and danger zones as **landmine rules** (what to watch out for), then writes configuration in each tool's native format. After you work, `/learn` captures new patterns and landmines from experience — so your partner gets smarter with every task.

For new projects with no code yet, `/architect` captures your architectural intent and generates the same configuration from declared conventions.

---

## Getting Started

Pick your tool and follow the steps.

### Claude Code

**Option A — Plugin (recommended):**

```
/plugin marketplace add selcukyucel/north-starr
/plugin install north-starr
```

Skills are available immediately across all your projects — nothing is installed into your project directory. Run `/architect` (new project) or `/bootstrap` (existing code) to generate configuration.

**Option B — Homebrew:**

```bash
brew tap selcukyucel/north-starr https://github.com/selcukyucel/north-starr.git && brew install north-starr
cd your-project
north-starr init
```

This copies skills into your project's `.claude/skills/` directory. Then run `/architect` (new project) or `/bootstrap` (existing code) in Claude Code to generate configuration.

### VS Code Copilot

```bash
brew tap selcukyucel/north-starr https://github.com/selcukyucel/north-starr.git && brew install north-starr
cd your-project
north-starr init
```

This installs skills to `.github/skills/` and creates `AGENTS.md`. Skills are auto-activated by Copilot — open Copilot Chat (requires VS Code 1.108+) and type a natural language prompt:

- **New project:** *"Architect this project — define architecture and conventions"*
- **Existing code:** *"Bootstrap this project — generate configuration from the existing code"*

Copilot matches your prompt to the relevant skill and loads its instructions automatically. No `/` commands needed.

### Cursor

```bash
brew tap selcukyucel/north-starr https://github.com/selcukyucel/north-starr.git && brew install north-starr
cd your-project
north-starr init
```

This creates `AGENTS.md` and installs skills. Run `/architect` (new project) or `/bootstrap` (existing code) from Cursor's chat to generate `.cursor/rules/` and other configuration.

### Any other AI tool

```bash
brew tap selcukyucel/north-starr https://github.com/selcukyucel/north-starr.git && brew install north-starr
cd your-project
north-starr init
```

This creates `AGENTS.md` — the universal project context file that works with any AI tool that supports it.

---

## What gets generated

### After `north-starr init` (Homebrew only)

The CLI copies skills and starter context into your project:

```
your-project/
├── AGENTS.md                          # Universal — works with any AI tool
├── CLAUDE.md                          # Claude Code starter
├── .claude/skills/                    # Claude Code skills
│   ├── architect/
│   ├── bootstrap/
│   ├── invert/
│   ├── plan/
│   ├── document/
│   ├── learn/
│   ├── commit-message-generator/
│   └── refactoring-analyzer/
└── .github/skills/                    # VS Code Copilot skills (same content)
    └── ...
```

Plugin users skip this step — skills are already available globally.

### After `/bootstrap`

The bootstrap skill explores your codebase and generates tool-native config:

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

---

## Skills

| Skill | When to use |
|-------|-------------|
| `/architect` | New project with no code yet — define architecture and conventions from intent |
| `/bootstrap` | First time in an existing project — generates rules, agents, and context files from your code |
| `/invert` | Before complex tasks — structured risk analysis (what could go wrong?) |
| `/plan` | For multi-session work — persistent implementation plans with progress tracking |
| `/document` | When a module needs a context file — generates one from actual code |
| `/learn` | After completing work — updates rules, agents, or context files from experience |

---

## Update & Uninstall

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

## CLI commands

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

### A partner that learns

The system improves through use — like a colleague who gets better the longer you work together:

```
/architect  →  declares intent (new projects)
     ↓                    or
/bootstrap  →  generates config from code (existing projects)
     ↓
  you work  →  your AI tool uses the config automatically
     ↓
/bootstrap  →  validates declared config against reality
     ↓
  /learn    →  updates config from what was discovered
     ↓
  next task →  your AI tool is smarter than last time
```

Every learning becomes a native artifact — pattern rules for conventions worth following, landmine rules for dangers worth avoiding. CLAUDE.md for Claude Code, copilot-instructions.md for VS Code Copilot, .cursor/rules for Cursor, AGENTS.md for everything. There's no parallel knowledge system — everything feeds directly into how your tools operate.

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

The core insight: *you don't improve productivity by going faster, you improve it by improving control.* north-starr applies this to AI-assisted development — your AI partner learns your patterns, remembers your landmines, and works with control, not just speed.

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
