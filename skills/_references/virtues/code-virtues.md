# The 7 Code Virtues

**Source**: Tim Ottinger & Jeff Langr (Industrial Logic / Agile in a Flash)
**Core Idea**: A positive vocabulary for describing what makes code *good*, ordered by priority.

---

## The Virtues (in priority order)

Higher virtues take precedence — never sacrifice a higher virtue for a lower one.

| # | Virtue | Opposite | What It Means |
|---|--------|----------|---------------|
| 1 | **Working** | incomplete | Code that functions correctly beats code that's theoretically elegant. Tests prove it. |
| 2 | **Unique** | duplicated | One source of truth. No copy-paste. Duplication is the root of many regression bugs. |
| 3 | **Simple** | complex | Fewer entities, operations, and relationships. Simpler code is easier to verify, optimize, and maintain. |
| 4 | **Clear** | puzzling | Intent is obvious to the reader. Names, structure, and flow communicate meaning without comments. |
| 5 | **Easy** | difficult | Adding and modifying code should not be arduous. When the right approach is as easy as a hack, developers choose correctly. |
| 6 | **Developed** | primitive | Mature abstractions with well-designed types. Functionality lives where expected. Reduces cognitive load. |
| 7 | **Brief** | chatty | As concise as possible without sacrificing higher virtues. Less code means fewer hiding places for bugs. |

---

## How to Use Virtues in north-starr

### In Pattern Rules

Tag each pattern with the primary virtue(s) it serves:

```markdown
**Virtues**: [Working, Unique, Simple, Clear, Easy, Developed, Brief]
```

This makes rules self-justifying — developers understand *why* the pattern matters.

### In Landmine Rules

Tag each landmine with the virtue(s) it threatens:

```markdown
**Threatens**: [Working, Unique, Simple, Clear, Easy, Developed, Brief]
```

This helps prioritize fixes — a landmine that threatens Working is more urgent than one that threatens Brief.

### In Inversion Analysis

When risks involve quality trade-offs, name the competing virtues and resolve by priority order:

```
**Virtue Tension:** Making this Brief sacrifices Clear → preserve Clear (virtue #4 > #7)
```

### In Refactoring Analysis (Virtue Scorecard)

Score each virtue for the analyzed code:

```markdown
## Virtue Scorecard
| Virtue      | Score | Evidence |
|-------------|-------|----------|
| Working     | ★★★★★ | [evidence] |
| Unique      | ★★★★☆ | [evidence] |
| Simple      | ★★★☆☆ | [evidence] |
| Clear       | ★★★★☆ | [evidence] |
| Easy        | ★★☆☆☆ | [evidence] |
| Developed   | ★★★★☆ | [evidence] |
| Brief       | ★★★☆☆ | [evidence] |
```

### In /learn

Tag captured learnings with the virtue they protect:

```
**Virtue:** [virtue name] — [why this learning protects that virtue]
```

---

## The Priority Rule

When virtues conflict, **higher-numbered virtues yield to lower-numbered ones**:

- Don't make code Brief if it stops being Clear
- Don't make code Simple if it stops Working
- Don't make code Easy if it stops being Unique (e.g., duplicating for convenience)

The ordering isn't about importance — all virtues matter. It's about which to preserve when you can't have both.

---

## Relationship to Existing north-starr Concepts

| north-starr Concept | Related Virtue | Connection |
|---------------------|---------------|------------|
| **Grain** (what changes easily) | **Easy** | Grain measures how Easy the codebase is for different types of changes |
| **Patterns** (conventions) | **Unique, Clear, Easy** | Good patterns eliminate duplication, improve clarity, and make changes easier |
| **Landmines** (danger zones) | **Working** (primarily) | Most landmines describe ways code can stop Working |
| **Complexity Assessment** | **Simple** | The checklist gates complexity — a proxy for the Simple virtue |

## Where Virtues Are Used

Virtues are referenced by the following templates and skills:

- **Pattern rules** (`skills/_references/patterns/_TEMPLATE.md`) — `**Virtues**:` field tags which virtues the pattern serves
- **Landmine rules** (`skills/_references/landmines/_TEMPLATE.md`) — `**Threatens**:` field tags which virtues the landmine endangers
- **`/bootstrap`** — tags every generated pattern and landmine rule with virtues
- **`/learn`** — tags captured learnings with the virtue they protect
- **`/analyze-code`** — uses the Virtue Scorecard to rate analyzed code
- **`/invert`** — names competing virtues when risks involve quality trade-offs
