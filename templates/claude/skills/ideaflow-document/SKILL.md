---
name: ideaflow-document
description: Generate or update comprehensive feature/module documentation by analyzing actual code. Creates a Claude.md file documenting architecture, data flow, user flows, key decisions, edge cases, testing strategy, and common tasks. Use after completing Medium/Complex tasks, or anytime you want to document an existing module. Trigger phrases: "document this feature", "generate docs", "create Claude.md", "document the module", "write feature documentation".
---

# Idea Flow Document - Feature/Module Documentation Generator

## Purpose

Generate comprehensive, maintainable documentation for features and modules by analyzing their actual code. The output is a `Claude.md` file that serves as long-term memory -- so the next person (or AI) working on this code reads one document instead of scanning dozens of files.

This skill is **language-agnostic**. It adapts to whatever architecture and patterns exist in the project.

## When to Use

**Recommended after**:
- Completing a Medium or Complex task that created or significantly modified a module
- The `/ideaflow-learn` phase suggests documentation is needed

**On-demand**:
- When you want to document an existing module that has no documentation
- When onboarding to a new area of the codebase
- When existing documentation is outdated

**Skip when**:
- Simple tasks (bug fix, copy change, small UI tweak)
- Internal refactoring with no external impact
- Test-only changes

## Workflow

### Step 1: Determine Scope

Identify what to document:
- **Single module/feature**: One `Claude.md` at the module root
- **Domain/package**: One `Claude.md` covering multiple related modules
- **Task summary**: Documentation in `.ai/tasks/YYYY-MM-DD-name/` for complex work

Ask the user if scope isn't clear:
```
What should I document?
- A specific feature/module (which one?)
- The domain/package this task touched
- A task summary of what was just built
```

### Step 2: Analyze Code Structure

Read all relevant source files and extract:

**Architecture Layer Detection** (adapt to what exists):
- Identify the architectural pattern in use (MVC, MVVM, Clean Architecture, layered, microservices, etc.)
- Map each file to its role in the architecture
- Note which patterns from `.ai/patterns/` are in use

**For each component, extract**:
- **Purpose**: What does this file/class/module do?
- **Public interface**: What methods/functions/endpoints does it expose?
- **Dependencies**: What does it depend on? (imports, injections, external services)
- **State**: What state does it manage? How does state change?
- **Side effects**: API calls, file I/O, database queries, event emissions

**Tools to use**:
- `Read` -- Read source files
- `Glob` -- Find all files in the module
- `Grep` -- Search for patterns (imports, exports, class definitions, public methods)

### Step 3: Map Data Flow

Trace how data moves through the system:

```
[Input/Trigger]
    |
    v
[Entry Point] (API handler, UI event, message consumer)
    |
    v
[Business Logic] (validation, transformation, rules)
    |
    v
[Data Access] (database, API client, file system)
    |
    v
[Output/Response] (UI update, API response, event emission)
```

Document the flow for the 2-3 most important operations.

### Step 4: Document User/Consumer Flows

For each key flow (user journey, API endpoint, event handler):

```markdown
### Flow: [Flow Name]

**Trigger**: [What initiates this flow]

**Steps**:
1. [Actor] does [action]
2. System [processes/validates/transforms]
3. [Data access] reads/writes [what]
4. System responds with [result]
5. [Actor] sees [outcome]

**State Changes**:
- [state property]: [before] --> [after]

**Error Paths**:
- If [condition]: [what happens]
- If [condition]: [what happens]
```

### Step 5: Document Architecture

Adapt the architecture documentation to the actual pattern in use.

**For layered architectures** (MVC, MVVM, Clean, etc.):
Document each layer with its responsibilities, key files, and interfaces.

**For component-based architectures** (React, Vue, etc.):
Document component hierarchy, props/state, and data flow between components.

**For service architectures** (microservices, API modules):
Document endpoints, request/response shapes, middleware, and integration points.

**For each architectural component**:
```markdown
#### [Component Name]

**Location**: `path/to/file`
**Purpose**: [What it does]

**Public Interface**:
- `methodName(params)` -- [what it does]
- `propertyName: Type` -- [what it holds]

**Dependencies**:
- [What it depends on]

**Key Behaviors**:
- [Non-obvious behavior worth noting]
```

### Step 6: Document File Structure

```markdown
## File Structure

\```
module-name/
├── file1.ext          # [Purpose]
├── file2.ext          # [Purpose]
├── subdirectory/
│   ├── file3.ext      # [Purpose]
│   └── file4.ext      # [Purpose]
└── tests/
    └── test_file.ext  # [Purpose]
\```
```

### Step 7: Capture Key Decisions

Document architectural choices and their rationale:

```markdown
## Key Decisions

| Decision | Chosen Approach | Why | Alternatives Rejected |
|----------|----------------|-----|----------------------|
| [Decision] | [What was chosen] | [Rationale] | [What else was considered] |
```

If this was a recent task, pull decisions from the implementation plan or LEARNINGS.md.

### Step 8: Document Integration Points

```markdown
## Integration Points

**Upstream** (what feeds into this module):
- [Module/service] -- [how it connects]

**Downstream** (what this module feeds into):
- [Module/service] -- [how it connects]

**External Dependencies**:
- [API/service] -- [what it provides]
```

### Step 9: Capture Edge Cases and Gotchas

```markdown
## Edge Cases and Gotchas

- [Non-obvious behavior]: [explanation]
- [Performance consideration]: [what to watch for]
- [Common mistake]: [what to avoid] -- See: `.ai/landmines/[name].md`
```

Pull from LEARNINGS.md if available from the recent task.

### Step 10: Write Common Task Guides

The most valuable part -- "how to do things" guides:

```markdown
## Common Tasks

### Add [New Capability]
1. [Step 1 with file path]
2. [Step 2]
3. Verify: [how to test]

### Modify [Existing Behavior]
1. [Where to find the logic]
2. [What to change]
3. Verify: [how to test]

### Debug [Common Issue]
**Symptoms**: [what you see]
**Likely cause**: [why it happens]
**Solution**: [how to fix]
```

### Step 11: Document Testing

```markdown
## Testing

**Unit tests**: `path/to/tests/`
- [What's covered]
- [Key test patterns used]

**Integration tests**: [if any]
- [What scenarios are tested]

**Manual verification**:
- [ ] [Key scenario to check]
- [ ] [Edge case to verify]
```

### Step 12: Link to Related Knowledge

```markdown
## Related

**Patterns used**:
- `.ai/patterns/[name].md` -- [how it's used here]

**Landmines to watch**:
- `.ai/landmines/[name].md` -- [what to avoid]

**Related modules**:
- [Module] -- [relationship]
```

### Step 13: Write the Claude.md File

Assemble all sections into a single `Claude.md` file.

**Location choices** (ask user if unclear):
- `path/to/module/Claude.md` -- alongside the code it documents
- `.ai/tasks/YYYY-MM-DD-name/Claude.md` -- in the task directory for complex work
- Custom location specified by user

**Use the template**: `references/claude-md-template.md`

---

## Output Format

The generated `Claude.md` follows this structure:

```markdown
# [Module Name] Documentation

**Last Updated**: [Date]
**Status**: Active

---

## Overview
[Purpose, capabilities, scope]

## User/Consumer Flows
[Key flows with state changes]

## Architecture
[Components, responsibilities, interfaces -- adapted to actual pattern]

## Data Flow
[How data moves through the system]

## File Structure
[Directory tree with purposes]

## Key Decisions
[Choices and rationale]

## Integration Points
[Upstream, downstream, external]

## Common Tasks
[How-to guides for frequent operations]

## Edge Cases and Gotchas
[Non-obvious behavior, warnings]

## Testing
[Test locations, coverage, manual checklist]

## Related
[Patterns, landmines, related modules]

---

**Changelog**:
- v1.0 ([Date]): Initial documentation
```

---

## Tips for Good Documentation

- **Be specific**: Use actual file paths, method names, and property names from the code
- **Be practical**: "How to add X" guides are more valuable than abstract descriptions
- **Be honest**: Document gotchas and known issues, not just happy paths
- **Be concise**: 200-500 lines for most features, 500-800 for complex domains
- **Link, don't copy**: Reference patterns and landmines by link, don't duplicate content
- **Update, don't stale**: When the code changes significantly, update the docs

---

## When to Update Existing Documentation

- Adding significant new capability to a module
- Changing architecture or data flow
- Discovering new edge cases or gotchas
- After resolving a significant bug (update "Common Tasks > Debug")
- After onboarding someone who found the docs insufficient

---

## Integration with Workflow

This skill integrates with the Idea Flow Agentic Workflow:

- **After `/ideaflow-learn`**: Generate documentation for newly built/modified modules
- **During `/ideaflow-bootstrap`**: Generate initial documentation for key modules
- **During `/ideaflow-sense`**: Read existing Claude.md files for context before starting work
- **Standalone**: User invokes directly to document any module

---

**Version**: 1.0
**Last Updated**: February 2026
