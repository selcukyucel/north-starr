# north-starr

**Your North Star for Friction-Free Development**

> *"We don't improve productivity by trying to go faster, we improve productivity by improving control."*
> — Idea Flow

north-starr brings the [Idea Flow](https://leanpub.com/ideaflow) methodology by **Janelle Arty Starr** into your AI-assisted development workflow. It transforms [Claude Code](https://docs.anthropic.com/en/docs/claude-code) from a code generator into a **development partner** that makes invisible friction visible, prevents the Cycle of Chaos, and builds project knowledge that compounds over time.

---

## What is this?

Most AI coding tools optimize for speed. north-starr optimizes for **control**.

Based on the book *[Idea Flow: How to Measure the PAIN in Software Development](https://leanpub.com/ideaflow)*, this tool installs a structured agentic workflow into any project. It gives Claude Code the methodology to:

- **Assess risk before writing code** — not after things break
- **Work in small, safe micro-cycles** — predict, change, observe, confirm
- **Classify friction** using the Ten Pains framework — so you fix the right problems
- **Build compounding project knowledge** — patterns, landmines, and vocabulary that grow with your codebase
- **Never gamble for speed** — because high-risk shortcuts cost 10-100x more than they save

It's language-agnostic. It works for any project — iOS, web, backend, infrastructure, anything.

## The Idea Flow Methodology

Janelle Arty Starr spent 17+ years as a developer, consultant, and CTO studying why software teams slow down. Her answer: **invisible friction**. Bugs, unclear requirements, unfamiliar code, over-engineering — these are all forms of friction that compound silently until everything feels slow.

Idea Flow makes friction visible and measurable through the **Ten Pains**:

| # | Pain | What it means |
|---|------|---------------|
| 1 | DESIGN_FIT | Feature doesn't fit existing architecture |
| 2 | REQUIREMENTS | Requirements wrong, unclear, or changed |
| 3 | MODELING | Code hard to understand |
| 4 | COLLABORATION | Merge conflicts, coordination overhead |
| 5 | EXPERIMENT | Hard to validate, slow feedback |
| 6 | ALARM | Test maintenance, false alarms |
| 7 | COGNITIVE | Too many details at once |
| 8 | EXECUTION | Changes mistake-prone, tedious |
| 9 | FAMILIARITY | Unfamiliar code/tools/libraries |
| 10 | DISRUPTION | Context switching, interruptions |

north-starr encodes this methodology into a structured workflow with six phases:

```
BOOTSTRAP → SENSE → MODEL → SCULPT → VALIDATE → LEARN
     ↑                                           |
     └───────────── knowledge compounds ──────────┘
```

**BOOTSTRAP** — Generate project context (once per project)
**SENSE** — Assess risk and friction before every task
**MODEL** — Plan implementation for medium/complex tasks
**SCULPT** — Execute in small, safe micro-cycles
**VALIDATE** — Verify with explicit predictions
**LEARN** — Capture patterns, landmines, and lessons learned

## Watch

Janelle Arty Starr explains the Idea Flow methodology:

[**Idea Flow — Janelle Arty Starr**](https://www.youtube.com/watch?v=qqaOpSJKdWc)

## Read

- [*Idea Flow: How to Measure the PAIN in Software Development*](https://leanpub.com/ideaflow) — the book
- [Legacy Code Rocks: Idea Flow with Arty Starr](https://legacycoderocks.libsyn.com/idea-flow-with-arty-starr) — podcast episode
- [*"The most underrated book in software engineering management"*](https://ericnormand.substack.com/p/the-most-underrated-book-in-software) — Eric Normand

---

## Install

```bash
brew tap selcukyucel/north-starr https://github.com/selcukyucel/north-starr.git
brew install north-starr
```

### Update

```bash
brew update && brew upgrade north-starr
```

Then update the workflow files in your project (preserves your patterns, landmines, and memory):

```bash
north-starr update
```

### Uninstall

Remove north-starr from your system:

```bash
brew uninstall north-starr && brew untap selcukyucel/north-starr
```

Remove from a project:

```bash
rm -rf .ai .claude/skills/ideaflow-* .claude/skills/commit-message-generator .claude/skills/refactoring-analyzer memory CLAUDE.md IDEAFLOW_AGENTIC_WORKFLOW.md
```

---

## Usage

### Initialize a project

```bash
cd your-project
north-starr init
```

This creates:

```
your-project/
├── CLAUDE.md                          # Active workflow instructions
├── IDEAFLOW_AGENTIC_WORKFLOW.md       # Full methodology reference
├── .ai/                               # Project knowledge base
│   ├── README.md                      # What goes here
│   ├── QUICK-START.md                 # Quick reference
│   ├── patterns/                      # Reusable solutions (grows through work)
│   │   └── _TEMPLATE.md
│   ├── landmines/                     # Known dangers (grows through pain)
│   │   └── _TEMPLATE.md
│   ├── checklists/                    # Verification frameworks
│   │   └── _TEMPLATE.md
│   └── tasks/                         # Per-task context (complex work)
│       └── .templates/
│           ├── CONTEXT.md
│           ├── IMPLEMENTATION_PLAN.md
│           ├── LEARNINGS.md
│           └── FEATURE_DOCUMENTATION.md
├── .claude/
│   └── skills/                        # Claude Code workflow skills
│       ├── ideaflow-bootstrap/
│       ├── ideaflow-sense/
│       ├── ideaflow-model/
│       ├── ideaflow-sculpt/
│       ├── ideaflow-validate/
│       ├── ideaflow-learn/
│       ├── ideaflow-document/
│       ├── commit-message-generator/
│       └── refactoring-analyzer/
└── memory/
    ├── friction-log.md                # Friction events with pain type tags
    ├── vocabulary.md                  # Codebase terms and conventions
    └── patterns.md                    # Index of discovered patterns
```

### Use the workflow

Open Claude Code in your project and use the slash commands:

| Command | Phase | When to use |
|---------|-------|-------------|
| `/ideaflow-bootstrap` | BOOTSTRAP | First time in a project — generates architecture overview, vocabulary, initial patterns |
| `/ideaflow-sense` | SENSE | **Start every task here** — risk assessment, friction forecast, complexity routing |
| `/ideaflow-model` | MODEL | Medium/complex tasks — strategy evaluation, decomposition, reuse-first check |
| `/ideaflow-sculpt` | SCULPT | Execution — micro-cycles, 20-minute rule, mistake-proofing |
| `/ideaflow-validate` | VALIDATE | After coding — explicit predictions, conflict resolution, test triage |
| `/ideaflow-learn` | LEARN | After validation — experience review, pattern/landmine extraction |
| `/ideaflow-document` | Utility | Generate module documentation from actual code |

### Other commands

```bash
north-starr status          # Check if Idea Flow is set up
north-starr update          # Update skills and templates (preserves your data)
north-starr version         # Show version
north-starr help            # Show help
```

---

## How it works

### The Friction Forecast

Every task starts with a Friction Forecast — a structured risk assessment that determines how to approach the work:

```
## Friction Forecast

Task: Add user authentication

Risk Assessment:
- Familiarity: LOW — first time working with auth in this codebase
- Quality:     MED — existing patterns to follow, but gaps
- Assumption:  HIGH — requirements not fully specified
- Dependency:  MED — touches middleware, routes, and database

Complexity: Complex
Expected Friction: HIGH
Recommendation: clarify requirements first, then spike on auth approach
```

### The Micro-Cycle

Execution happens in small, safe increments:

```
PREDICT → CHANGE → OBSERVE → RESULT
   ↓         ↓         ↓         ↓
 "I expect  smallest   run it   CONFIRM
  this to   possible   and      or
  work      change     watch"   CONFLICT
  because..."
```

If a micro-cycle produces a **CONFLICT**, you stop, diagnose, and fix before moving forward. No piling code on top of broken assumptions.

### Knowledge that compounds

As you work, the `.ai/` directory fills up organically:

- **Patterns** — solutions that worked well, captured for reuse
- **Landmines** — gotchas that wasted time, documented so they don't bite again
- **Vocabulary** — codebase-specific terms so AI and humans stay aligned
- **Friction log** — pain events classified by type, revealing systemic issues

This knowledge persists across sessions and grows with the project.

---

## Philosophy

> *Friction is the enemy. Safety enables speed. Measure the pain, don't assume the solution. Reuse before you create.*

- You are a development partner, not a code generator
- Your job is to make invisible friction visible and prevent the Cycle of Chaos
- Never gamble for speed — high-risk shortcuts cost 10-100x more than they save
- The developer's brain is the most precious resource; protect it from unnecessary cognitive load
- Keep haystacks small — the smaller the change, the easier it is to troubleshoot

---

## Credits

**Methodology:** [Janelle Arty Starr](https://leanpub.com/u/artystarr) — creator of Idea Flow, founder of [Twilight City, Inc.](https://www.crunchbase.com/person/janelle-arty-starr), and pioneering researcher on making software friction visible.

**Book:** [*Idea Flow: How to Measure the PAIN in Software Development*](https://leanpub.com/ideaflow)

**Agentic implementation:** This project adapts the Idea Flow methodology for AI-assisted development with [Claude Code](https://docs.anthropic.com/en/docs/claude-code), encoding the principles into structured skills and workflow phases.

---

## Contributing

Contributions are welcome! If you've found patterns, improved skills, or adapted the workflow for specific tech stacks, please open a PR.

## License

MIT — see [LICENSE](LICENSE)
