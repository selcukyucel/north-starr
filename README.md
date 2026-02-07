# north-starr

**Your North Starr for Friction-Free Development**

north-starr is a project bootstrapper for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). It installs skills that analyze any codebase and generate native Claude Code configuration — so the AI works effectively from the first task.

It's language-agnostic. Works for any project — iOS, web, backend, infrastructure, anything.

---

## What it does

Most AI coding tools start every project cold. north-starr gives Claude Code project-specific context by generating:

- **`CLAUDE.md` files** — architecture, grain, module map, danger zones (auto-loaded by Claude Code)
- **`.claude/rules/`** — conventions and constraints scoped by file path (auto-enforced)
- **`.claude/agents/`** — project-tuned specialized agents with persistent memory

This configuration is generated from your actual code — not templates. The `/bootstrap` skill explores your codebase, identifies architecture patterns, detects danger zones, and writes configuration that Claude Code consumes natively.

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

This installs skills and a starter `CLAUDE.md`:

```
your-project/
├── CLAUDE.md                          # Starter — tells you to run /bootstrap
└── .claude/
    └── skills/
        ├── bootstrap/                 # Generate project config
        ├── invert/                    # Deep risk analysis
        ├── document/                  # Module documentation generator
        ├── learn/                     # Update config from experience
        ├── commit-message-generator/
        └── refactoring-analyzer/
```

### Bootstrap your project

Open Claude Code and run:

```
/bootstrap
```

This explores your codebase and generates:

```
your-project/
├── CLAUDE.md                          # Architecture, grain, module map, vocabulary
├── src/
│   ├── payments/CLAUDE.md             # Module-level warnings and patterns
│   └── auth/CLAUDE.md                 # Module-level context
└── .claude/
    ├── rules/
    │   ├── naming-conventions.md      # Scoped to your file types
    │   ├── error-handling.md          # Your project's patterns
    │   └── payments-warnings.md       # Danger zone alerts
    ├── agents/
    │   └── project-explorer.md        # Tuned to your architecture
    └── skills/
        └── ...
```

After bootstrap, Claude Code auto-loads this configuration. Rules fire when touching matching files. Module CLAUDE.md files appear when working in those directories. No ceremony needed.

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

Every codebase has a **grain** — a direction that changes flow easily. Adding a new API endpoint might be straightforward. Adding a new data model might require touching 12 files. The bootstrap skill identifies this grain and documents it, so Claude Code knows which changes are safe and which require extra care.

### Self-improving configuration

The system improves through use:

```
/bootstrap  →  generates initial config
     ↓
  you work  →  Claude Code uses the config automatically
     ↓
  /learn    →  updates config from what was discovered
     ↓
  next task →  Claude Code is smarter than last time
```

Rules, agents, and CLAUDE.md files are all native Claude Code primitives. There's no parallel knowledge system — everything feeds directly into how Claude Code operates.

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

The core insight: *you don't improve productivity by going faster, you improve it by improving control.* north-starr applies this to AI-assisted development by giving Claude Code the context it needs to work with control, not just speed.

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
