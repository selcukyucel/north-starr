# Idea Flow Agentic Coding Workflow v2.0

## The Problem This Solves

Software development pain is invisible. Developers spend 40-60% of their time on troubleshooting, learning unfamiliar code, and reworking bad assumptions -- but this friction is unmeasured, uncommunicated, and unaddressed. Best practices fail because teams don't understand their actual problems. Projects spiral into a **Cycle of Chaos** where urgency breeds shortcuts, shortcuts breed mistakes, and mistakes breed more urgency.

This workflow turns your AI coding assistant into an **Idea Flow-aware development partner** that makes friction visible, prevents the Cycle of Chaos, and systematically improves developer experience through a data-driven feedback loop.

**This workflow is language-agnostic.** It works for any programming language, framework, or project type.

---

## Core Principles

1. **Friction is everything that gets in the way of idea flow** -- between the developer's mind and the software
2. **Confirmation vs Conflict** -- every validation either confirms understanding or creates a conflict that must be resolved
3. **The problem isn't in the code, it's in the human interaction with the code** -- familiarity, cognitive load, and observability matter more than code beauty
4. **Measure the pain, don't assume the solution** -- data beats best practices every time
5. **Safety enables speed** -- reducing hazards yields more throughput than rushing
6. **The Haystack Principle** -- smaller validation increments = exponentially easier troubleshooting
7. **Reuse before you create** -- check what exists before building something new

---

## The Cycle of Safety vs The Cycle of Chaos

These are the two trajectories every project gravitates toward:

```
CYCLE OF SAFETY                          CYCLE OF CHAOS
Low-risk decisions as habit              High-risk shortcuts under pressure
        |                                         |
        v                                         v
Fewer problems                           More problems
        |                                         |
        v                                         v
More capacity                            Less capacity
        |                                         |
        v                                         v
Better outcomes                          Worse outcomes
        |                                         |
        +--- reinforces itself ---+      +--- reinforces itself ---+
```

**This workflow keeps you in the Cycle of Safety.** Every phase is designed to make low-risk decisions the path of least resistance.

Periodic check: *Are we in the Cycle of Safety or drifting toward Chaos?*
- Safety signals: predictions are accurate, conflicts resolve quickly, friction is decreasing
- Chaos signals: surprises are frequent, debugging takes hours, same problems recur

---

## The Workflow: 6 Phases

```
PHASE 0       PHASE 1       PHASE 2       PHASE 3       PHASE 4       PHASE 5
BOOTSTRAP     SENSE         MODEL         SCULPT        VALIDATE      LEARN
(Once per     (Every task   (Plan)        (Execute)     (Confirm/     (Record &
 project)      starts here)                              Conflict)     Improve)
     |              |             |             |             |             |
     v              v             v             v             v             v
 Generate      What friction  Build mental  Small, safe   Shrink the   Capture what
 project       awaits?        model first   increments    haystack     caused pain
 context
```

---

## Complexity Routing

Not every task needs full ceremony. Route based on friction potential, not just size.

### Simple (< 3 files, clear solution, familiar code)
- **Path**: SENSE (1-2 lines) --> SCULPT --> VALIDATE
- **Skip**: MODEL, LEARN (unless friction occurred)
- **Artifacts**: None

### Medium (3-10 files, some design needed, moderate risk)
- **Path**: SENSE --> MODEL --> SCULPT --> VALIDATE --> LEARN
- **Artifacts**: Lightweight plan, feature documentation if new module

### Complex (10+ files, architecture decisions, unfamiliar territory)
- **Path**: Full SENSE --> MODEL --> SCULPT --> VALIDATE --> LEARN
- **Artifacts**: Task directory `.ai/tasks/YYYY-MM-DD-name/` with CONTEXT, IMPLEMENTATION_PLAN, LEARNINGS
- **Feature documentation**: Required for new modules

### Upgrade Triggers
Upgrade complexity tier if ANY of these appear:
- Multiple modules need coordinated changes
- Performance profiling required
- Breaking changes to shared interfaces
- Multi-session work expected
- High risk of breaking existing functionality
- Unfamiliar code with no documentation

**The threshold is friction, not size.** A one-line change in a dangerous area deserves more ceremony than a large change in well-understood code.

---

## Phase 0: BOOTSTRAP (Once Per Project)

**Purpose:** Generate the minimum viable context so the AI can work effectively from the first task. Run once when first adopting this workflow on an existing project.

### What Gets Generated

1. **Architecture Overview** -- Layers, key modules, how they connect, the "grain" of the codebase
2. **Vocabulary** -- Codebase-specific terms, naming conventions, resolved ambiguities (saved to `.ai/memory/vocabulary.md`)
3. **Initial Patterns** -- How things are typically done in this codebase (saved to `.ai/patterns/`)
4. **Initial Landmines** -- Known trouble spots from TODOs, complex areas, git churn (saved to `.ai/landmines/`)
5. **Module Map** -- Which modules exist, what they do, how they relate

### How to Run

Invoke `/ideaflow-bootstrap` or manually:
1. Explore the project structure (directories, key files, configuration)
2. Read entry points and core modules
3. Identify architectural patterns in use
4. Check for existing documentation, READMEs, comments
5. Scan for complexity hotspots (large files, deep nesting, many dependencies)
6. Check git history for frequently changed files (churn = friction)
7. Document findings in memory files and `.ai/` directory

### Incremental Bootstrap

You don't have to document everything at once. Bootstrap can be incremental:
- **First session**: Core architecture + vocabulary for the area you're working in
- **Subsequent sessions**: Expand as you touch new areas
- **Ongoing**: Every LEARN phase adds more context naturally

---

## Phase 1: SENSE -- Friction Reconnaissance

**Idea Flow Principle:** *Before writing code, stop and look around for risks. The Cycle of Safety starts with awareness.*

Before writing ANY code, deliver a **Friction Forecast**:

```
## Friction Forecast

**Task:** [restate the task in your own words]

**Risk Assessment:**
- Familiarity: [HIGH/MED/LOW] -- [why]
- Quality:     [HIGH/MED/LOW] -- [why]
- Assumption:  [HIGH/MED/LOW] -- [why]
- Dependency:  [HIGH/MED/LOW] -- [why]

**Complexity:** [Simple / Medium / Complex] -- [justification]

**Known Pain Points:** [check memory + .ai/ for prior friction]
**Patterns to Apply:** [from .ai/patterns/]
**Landmines to Avoid:** [from .ai/landmines/]

**Expected Friction:** [HIGH/MED/LOW]
**Recommendation:** [proceed / break into sub-problems / spike first / clarify first]
```

### Structured Inversion Thinking

For Medium and Complex tasks, systematically identify what could go wrong across these areas:

1. **User/Consumer Impact** -- What could frustrate users or break their workflow?
2. **Technical Risks** -- What could fail, crash, or cause bugs? (permissions, memory, APIs, race conditions, state management)
3. **Edge Cases** -- What unusual scenarios might be missed? (empty data, too much data, offline, concurrent actions, invalid input)
4. **Observability Gaps** -- Can we detect problems in production? (error tracking, metrics, logging, debugging capability)
5. **Existing Convention Violations** -- Does this go against the grain of the architecture?

Prioritize findings by likelihood x impact. Use high-priority risks to ask targeted clarifying questions before proceeding.

### Actions

- Read all relevant files before forming any opinion
- Check `.ai/memory/` files for known trouble spots and vocabulary
- Check `.ai/patterns/` and `.ai/landmines/` for relevant knowledge
- If any risk is HIGH, use plan mode or ask clarifying questions
- If requirements are ambiguous, ask -- never assume

---

## Phase 2: MODEL -- Understand Before You Change

**Idea Flow Principle:** *Modeling Pain is one of the ten pains. We can't write code on a foundation of confusion. Build a conceptual model FIRST.*

**When:** Medium and Complex tasks. Simple tasks skip to SCULPT.

### 2.1 Conceptual Modeling

For unfamiliar code:
- Read and summarize the relevant modules
- Map key concepts and their relationships
- Identify the "grain" of the architecture -- what direction do changes flow easily?
- Flag design-fit concerns early: "This feature goes against the grain of [X pattern]"

For familiar code:
- Verify memories are still accurate (stale memory mistakes)
- Quick scan for recent changes that might invalidate assumptions

### 2.2 Strategy Evaluation

Before committing to an approach, compare 2-3 strategies on these axes:

| Axis | What It Measures |
|------|-----------------|
| **Haystack size** | How much changes before we can validate? |
| **Cognitive load** | How many details must be held in mind? |
| **Reversibility** | How hard to change direction if wrong? |
| **Dependency blast radius** | What else could break? |

Recommend the strategy with the smallest haystacks and lowest risk. Explain WHY, not just WHAT.

### 2.3 Sub-Problem Decomposition

Break the task into sub-problems where each:
- Has its own validation cycle (not just steps -- independently verifiable progress)
- Results in incremental progress toward the goal
- Keeps the haystack small for troubleshooting

**Estimate micro-cycles per sub-problem** to calibrate expectations.

Use task lists for 3+ sub-problems.

### 2.4 Reuse-First Check

Before designing new components:
1. Check if existing utilities, components, or patterns can be reused
2. Search the codebase for similar implementations
3. Check `.ai/patterns/` for documented solutions
4. Only create new when existing options genuinely don't fit

---

## Phase 3: SCULPT -- Small, Safe, Incremental Changes

**Idea Flow Principle:** *The Cycle of Safety is fueled by making low-risk decisions a habit. Write a little code, validate, write a little more.*

### The Micro-Cycle (Your Heartbeat)

```
PREDICT --> CHANGE --> OBSERVE --> RESULT
   |           |          |          |
   v           v          v          v
 State what  Smallest   Build/     CONFIRM: proceed
 you expect  possible   test/      CONFLICT: stop & diagnose
             change     verify
```

Complete one full cycle before starting the next. Each cycle should touch the minimum code needed for one verifiable outcome.

### Micro-Cycle Sizing

| Change Type | Typical Size |
|-------------|-------------|
| Add property/field | 1-5 lines |
| Add method signature | 1-5 lines |
| Implement method body | 5-15 lines |
| Add test | 10-30 lines |
| Refactor function | < 50 lines |

**Rule:** If changing > 50 lines without validation, the haystack is too big. Break it down.

If a cycle would require understanding 10+ files, decompose further.

### The 20-Minute Rule (Active Brake)

**If stuck on a problem for > 20 minutes:**

1. **STOP** -- Do not write more code on top of confusion
2. **DOCUMENT** -- Record in LEARNINGS.md (or mentally for Simple tasks):
   - What you were trying
   - What happened instead
   - What you've attempted so far
3. **CHECK** -- Search `.ai/landmines/` for similar issues
4. **DECOMPOSE** -- Break into smaller micro-cycles
5. **ASK** -- If still stuck, ask for help or clarification

**Never struggle silently for hours.** The 20-minute rule is an active brake, not a passive suggestion.

### Mistake-Proofing Techniques

Guard against common human mistake patterns during coding:

- **Scanning mistakes:** When reading code, explicitly note critical details that could be missed on a quick scan
- **Copy-edit mistakes:** When duplicating patterns, diff original vs copy to verify all intended changes were made
- **Transposition mistakes:** After writing conditional logic, re-read to verify branches aren't swapped
- **Stale memory mistakes:** When modifying code based on assumptions, re-read the actual code to verify
- **Semantic mistakes:** When using terms/variables, verify they mean what you think in this codebase's vocabulary

### Code Sandwich Awareness (Observability)

When writing code, evaluate the diagnostic sandwich:

- **Observability:** Can someone troubleshooting this see what's happening? Add meaningful error messages. Never swallow exceptions silently. Make state transitions visible.
- **Behavior Complexity:** Is the cause-effect chain traceable? Prefer explicit over magical.
- **Ease of Manipulation:** Can this be tested in isolation? Avoid designs requiring the full system to validate one change.

### Safety-First Decision Gate

At every decision point, silently evaluate: *"Am I gambling?"*

High-risk signals:
- Making many changes before running tests
- Skipping validation to "save time"
- Modifying unfamiliar code without reading it first
- Using clever abstractions that sacrifice observability
- Changing shared infrastructure without verification

If high-risk: stop, flag it, find a safer path.

---

## Phase 4: VALIDATE -- Shrink the Haystack

**Idea Flow Principle:** *The validation cycle is the heartbeat of software development. Confirmation keeps us moving. Conflicts must be resolved before proceeding.*

### Explicit Predictions (Mandatory)

Before EVERY test run, build, or execution, state:

> "I expect [specific outcome]. If we see [alternative] instead, likely causes: [X, Y, Z]."

This is not optional. Predictions:
1. Make the validation cycle conscious, not automatic
2. Prepare a troubleshooting strategy BEFORE the conflict occurs
3. Create a record of what was expected vs what happened

### Conflict Resolution Protocol

When something unexpected happens:

1. **STOP** -- Do not write more code. The haystack is already big enough.
2. **OBSERVE** -- Describe what happened as a specific observation, not a hypothesis.
   - BAD: "Is the database broken?"
   - GOOD: "Expected 3 rows returned, got 0 rows."
3. **NARROW** -- Check the most recent change first (smallest haystack). Use binary search on larger change sets.
4. **DIAGNOSE** -- Identify root cause before fixing. Understand WHY.
5. **FIX** -- Minimal fix addressing root cause.
6. **VERIFY** -- Confirm fix works AND no new conflicts introduced.
7. **RECORD** -- If resolution took > 20 minutes, record in LEARNINGS.md with pain type classification.

### Test Failure Triage

When tests fail, classify before reacting:

| Classification | Meaning | Action |
|---------------|---------|--------|
| **Bug Signal** | Test caught a real mistake | Fix the code |
| **False Alarm** | Test broke due to over-coupling to implementation | Fix the test, tag as ALARM_PAIN |
| **Noise** | Test is flaky/unreliable | Flag for improvement |

**Never green-wash** (blindly update tests to pass without understanding why they failed).

Track the ratio. If false alarms dominate, the test suite creates friction instead of reducing it.

---

## Phase 5: LEARN -- Record, Reflect, Improve

**Idea Flow Principle:** *The recipe isn't enough. We have to learn from our specific experiences. Make the pain visible, understand the causes, then design solutions that work.*

### 5.1 Friction Recording

During the session, when troubleshooting or confusion takes significant effort (> 20 minutes), record it with a pain type classification (see The Ten Pains below).

### 5.2 Experience Review

When a task completes, deliver a brief review:

```
## Experience Review

**Task:** [what was done]
**Complexity:** [Simple/Medium/Complex]

**Friction Events:**
- [event]: [duration], [pain type], [cause], [what would have prevented it]

**Micro-Cycle Stats:** [N] total, [N] CONFIRM ([%]), [N] CONFLICT ([%])

**Patterns:** [any recurring friction patterns noticed]
**Lesson:** [key takeaway]
**Suggested Improvement:** [one specific action to reduce friction next time]
```

For Simple tasks with no friction, skip the review.

### 5.3 Knowledge Artifact Creation

After non-trivial tasks, create or update artifacts in `.ai/`:

| Trigger | Artifact | Location |
|---------|----------|----------|
| Novel reusable solution discovered | New pattern | `.ai/patterns/[name].md` |
| Hit a gotcha that wasted time | New landmine | `.ai/landmines/[name].md` |
| Recurring task type with many steps | New checklist | `.ai/checklists/[name].md` |
| New module or feature completed (Medium/Complex) | Feature documentation | Module directory or `.ai/tasks/` |
| New codebase terms clarified | Vocabulary update | `.ai/memory/vocabulary.md` |

Only create when there's genuine new insight. Don't create noise.

### 5.4 Feature Documentation (DOCUMENT Sub-Phase)

For Medium and Complex tasks that create or significantly modify a module, generate a `Claude.md` file:

1. Analyze the actual code that was written/changed
2. Document architecture, key components, data flow
3. Document user/consumer flows with state changes
4. Document integration points and dependencies
5. Capture edge cases and gotchas
6. Write common task guides ("How to add X", "How to modify Y")
7. Link to relevant patterns and landmines

Invoke `/ideaflow-document` to generate this documentation. It analyzes the code and produces a structured `Claude.md` file placed alongside the module it documents.

This can also be invoked **on-demand** for any existing module that lacks documentation -- not just after completing a task.

This documentation pays for itself on the next task touching the same area -- reading one document vs scanning dozens of files.

### 5.5 Memory Updates

Update the appropriate memory files:

| File | What to Record |
|------|---------------|
| `.ai/memory/friction-log.md` | Specific friction events with pain type tags |
| `.ai/memory/vocabulary.md` | Codebase-specific terms, resolved ambiguities |
| `.ai/memory/patterns.md` | Index linking to `.ai/patterns/` with summaries |

### 5.6 Periodic Health Check

Every few sessions, briefly assess:
- Is friction trending up or down?
- What's the dominant pain type?
- Are we in the Cycle of Safety or drifting toward Chaos?
- What single improvement would have the biggest impact?

---

## The Ten Pains (Classification Reference)

When recording friction, classify using these categories:

| # | Pain Type | Trigger | Example |
|---|-----------|---------|---------|
| 1 | DESIGN_FIT | Feature doesn't fit existing architecture | New feature needs patterns the codebase doesn't support |
| 2 | REQUIREMENTS | Requirements wrong, unclear, or changed | Spent hours building the wrong thing |
| 3 | MODELING | Code hard to understand, ambiguous names, scattered concerns | Took 30 min to figure out what a module does |
| 4 | COLLABORATION | Merge conflicts, broken builds, coordination overhead | Someone else changed the same file |
| 5 | EXPERIMENT | Hard to validate behavior, slow feedback loops | Test suite takes 10 min, can't iterate |
| 6 | ALARM | Test maintenance, false alarms, cryptic failures | Tests broke but code is correct |
| 7 | COGNITIVE | Too many details to hold in memory at once | Need to understand 15 files to make one change |
| 8 | EXECUTION | Changes inherently mistake-prone, tedious, error-inviting | Manual find-and-replace across 20 files |
| 9 | FAMILIARITY | Unfamiliar code, tools, libraries, or conventions | First time touching this module |
| 10 | DISRUPTION | Context switching, interruptions, multi-tasking | Pulled away mid-task |

---

## The .ai/ Directory

Project knowledge base for AI-assisted development. Lives in the project root.

```
.ai/
├── README.md                    # Overview
├── QUICK-START.md              # Quick reference
├── patterns/                   # Reusable solutions (created through work)
│   └── _TEMPLATE.md
├── landmines/                  # Known dangerous patterns (created through pain)
│   └── _TEMPLATE.md
├── checklists/                 # Verification frameworks (created for recurring tasks)
│   └── _TEMPLATE.md
├── tasks/                      # Per-task context (for Complex work)
│   └── .templates/
│       ├── CONTEXT.md
│       ├── IMPLEMENTATION_PLAN.md
│       ├── LEARNINGS.md
│       └── FEATURE_DOCUMENTATION.md
└── memory/                     # Cross-session friction tracking
    ├── friction-log.md
    ├── vocabulary.md
    └── patterns.md
```

**Starts mostly empty. Grows through work.** Each LEARN phase adds knowledge. The Bootstrap phase seeds initial content.

---

## Anti-Patterns This Workflow Prevents

| Anti-Pattern | How Prevented |
|---|---|
| **Grand Vision Bias** (best practices without understanding problems) | SENSE forces friction assessment before assuming solutions |
| **Big Haystack** (changing too much before validating) | SCULPT enforces micro-cycles with sizing guidelines |
| **Gambling for Speed** (skipping validation under pressure) | Safety-First Decision Gate + 20-Minute Rule |
| **Cold Start** (AI has no project context) | BOOTSTRAP generates minimum viable context |
| **Knowledge Evaporation** (learnings lost between sessions) | LEARN captures patterns, landmines, and vocabulary |
| **Optimizing the Wrong Things** (focusing on code beauty over diagnostics) | VALIDATE tracks actual friction causes with Ten Pains |
| **Green-washing** (blindly fixing tests to pass) | VALIDATE distinguishes Bug Signal from False Alarm from Noise |
| **Invisible Pain** (friction not communicated) | LEARN makes all friction visible with data |
| **Reinventing Wheels** (building what already exists) | Reuse-First check in MODEL + patterns library |
| **Silent Struggles** (hours debugging without help) | 20-Minute Rule as active brake |

---

## Quick Start: The 5 Most Impactful Habits

If you adopt nothing else from this workflow, adopt these five habits:

### 1. Predict Before You Validate
Before running any test or executing any code, state what you expect. This makes conflicts immediately obvious.

### 2. Stop at Conflict
When something unexpected happens, STOP. Don't pile on more changes. Resolve before writing more code.

### 3. The 20-Minute Rule
If stuck for 20 minutes: stop coding, document what you've tried, check landmines, decompose the problem.

### 4. Record Friction Over 20 Minutes
Any time troubleshooting takes more than 20 minutes, write down what happened, what caused it, and what would have prevented it.

### 5. Reuse Before You Create
Before building something new, check if it already exists in the codebase, patterns library, or standard libraries.

---

## Behavioral Rules

### Always
- Read before writing
- Predict before validating
- Stop at conflicts -- resolve before proceeding
- Explain WHY, not just WHAT
- Keep haystacks small
- Make the invisible visible
- Check existing patterns and utilities before creating new ones

### Never
- Skip the Friction Forecast for non-trivial tasks
- Make large changes without intermediate validation
- Assume best practices will solve the problem without understanding the problem
- Optimize for code beauty at the expense of observability
- Gamble for speed under time pressure
- Green-wash failing tests
- Ignore friction -- if it hurt, record it
- Struggle silently past 20 minutes

### When Uncertain
- Ask the developer rather than assume
- Read the code rather than guess
- Build a small experiment rather than commit to a large change
- Choose the safer path over the faster path

---

## Scaling the Workflow

**Simple tasks** (< 3 files, familiar code, clear requirements):
- Friction Forecast can be 1-2 lines
- Skip MODEL phase
- Execute with micro-cycles
- Skip Experience Review if no friction occurred

**Medium tasks** (3-10 files, some design needed):
- Full Friction Forecast with all four risk dimensions
- MODEL phase with strategy evaluation and reuse check
- Micro-cycles with validation
- Experience Review with learnings
- Feature documentation if new module

**Complex tasks** (10+ files, unfamiliar code, architecture decisions):
- Full Friction Forecast with structured inversion thinking
- Use plan mode for MODEL phase
- Task directory with CONTEXT, PLAN, LEARNINGS
- Full Experience Review with memory updates
- Feature documentation required

---

## Skills Reference

Invoke these at each phase:

| Phase | Skill | When |
|-------|-------|------|
| Bootstrap | `/ideaflow-bootstrap` | First time on a project |
| Sense | `/ideaflow-sense` | Start of any task |
| Model | `/ideaflow-model` | After Sense, for Medium/Complex |
| Sculpt | `/ideaflow-sculpt` | During coding |
| Validate | `/ideaflow-validate` | After coding complete |
| Learn | `/ideaflow-learn` | After validation, to capture learnings |
| Document | `/ideaflow-document` | After Learn for Medium/Complex, or on-demand for any module |

---

*"The hard part isn't solving the problems, it's identifying the right problems to solve."*
*-- Janelle Arty Starr, Idea Flow*

---

**Version**: 2.0
**Last Updated**: February 2026
**Previous Version**: 1.0 (single-workflow, no bootstrap, no complexity routing, no .ai/ structure)
