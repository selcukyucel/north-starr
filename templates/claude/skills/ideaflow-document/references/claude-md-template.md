# [Module/Feature Name] Documentation

**Last Updated**: [Date]
**Status**: [Active / Deprecated / Beta]

---

## Overview

[What does this module do? Why does it exist? 2-3 sentences.]

**Key Capabilities**:
- [Capability 1]
- [Capability 2]
- [Capability 3]

---

## User/Consumer Flows

### Flow 1: [Primary Flow Name]

**Trigger**: [What initiates this flow]

**Steps**:
1. [Actor] does [action]
2. System [processes/validates]
3. [Data access] reads/writes [what]
4. System responds with [result]
5. [Actor] sees [outcome]

**State Changes**:
- `[state]`: `[before]` --> `[after]`

**Error Paths**:
- If [condition]: [what happens]

### Flow 2: [Secondary Flow Name]

[Same structure]

---

## Architecture

### [Layer/Component 1 Name]

**Location**: `path/to/files/`
**Purpose**: [What this layer does]

**Key Files**:
- `file1.ext` -- [responsibility]
- `file2.ext` -- [responsibility]

**Public Interface**:
- `functionName(params) -> ReturnType` -- [what it does]
- `propertyName: Type` -- [what it holds]

**Dependencies**:
- [What this component depends on]

### [Layer/Component 2 Name]

[Same structure -- repeat for each architectural layer/component]

---

## Data Flow

```
[Input/Trigger]
    |
    v
[Entry Point]
    |
    v
[Business Logic]
    |
    v
[Data Access]
    |
    v
[Output/Response]
```

**Example: [Key Operation Name]**

1. [Step 1 with actual method/function names]
2. [Step 2]
3. [Step 3]
4. [Result]

---

## File Structure

```
module-name/
├── file1.ext              # [Purpose]
├── file2.ext              # [Purpose]
├── subdirectory/
│   ├── file3.ext          # [Purpose]
│   └── file4.ext          # [Purpose]
└── tests/
    └── test_file.ext      # [Purpose]
```

---

## Key Decisions

| Decision | Chosen Approach | Why | Alternatives Rejected |
|----------|----------------|-----|----------------------|
| [Decision 1] | [Approach] | [Rationale] | [What else was considered] |
| [Decision 2] | [Approach] | [Rationale] | [What else was considered] |

---

## Integration Points

**Upstream** (what feeds into this module):
- [Module/Service] -- [how connected]

**Downstream** (what this module feeds into):
- [Module/Service] -- [how connected]

**External Dependencies**:
- [API/Service] -- [what it provides, version/docs link]

---

## Common Tasks

### Add [New Capability]
1. [Step 1 with specific file path]
2. [Step 2]
3. [Step 3]
4. Verify: [how to test this works]

### Modify [Existing Behavior]
1. Locate: `path/to/file.ext` -- [what to look for]
2. Change: [what to modify]
3. Verify: [how to test]

### Debug [Common Issue]
**Symptoms**: [what you observe]
**Likely cause**: [why it happens]
**Solution**: [how to fix]

---

## Edge Cases and Gotchas

- [Non-obvious behavior 1] -- [explanation]
- [Performance consideration] -- [what to watch for]
- [Common mistake] -- See: `.ai/landmines/[name].md`

---

## Testing

**Unit tests**: `path/to/tests/`
- [What's covered]

**Integration tests**: [if any]
- [What scenarios]

**Manual verification**:
- [ ] [Key scenario 1]
- [ ] [Edge case to verify]

---

## Related

**Patterns used**:
- `.ai/patterns/[name].md` -- [how applied here]

**Landmines to watch**:
- `.ai/landmines/[name].md` -- [relevant warning]

**Related modules**:
- [Module] -- [relationship]

---

## Known Issues / Future Improvements

- [Issue/improvement] -- [priority, workaround if any]

---

**Changelog**:
- **v1.0** ([Date]): Initial documentation
