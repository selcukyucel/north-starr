# User Flow Documentation Guide

## Purpose

Document how users (or consumers) interact with a feature, step by step. Good flow documentation makes it possible to understand a feature without reading the code.

---

## Flow Template

```markdown
### Flow: [Flow Name]

**Trigger**: [What initiates this flow -- user action, API call, event, timer]
**Actor**: [Who/what triggers it -- user, system, external service]
**Frequency**: [How often -- every page load, on-demand, background]

**Happy Path**:
1. [Actor] [action] (e.g., "User taps Submit button")
2. System [validates/processes] [what] (e.g., "System validates form fields")
3. [Data operation] (e.g., "API call to POST /api/orders")
4. System [responds] (e.g., "System shows success confirmation")
5. [Final state] (e.g., "User sees order in their order list")

**State Changes**:
- `[state property]`: `[before value]` --> `[after value]`
- `[loading state]`: `false` --> `true` --> `false`

**Error Paths**:
- If [validation fails]: System shows [error message], user can [retry/correct]
- If [network fails]: System shows [fallback], [retry behavior]
- If [permission denied]: System [redirects/shows message]

**Edge Cases**:
- [Empty data]: [What happens]
- [Concurrent action]: [What happens]
- [Timeout]: [What happens]
```

---

## Flow Types

### 1. CRUD Flows
Document Create, Read, Update, Delete operations:
- What triggers each operation
- What validation occurs
- What data changes
- What the user sees after

### 2. Navigation Flows
Document how users move between screens/pages:
- Entry points (how they get here)
- Exit points (where they can go)
- Back/cancel behavior
- Deep link support

### 3. Background Flows
Document operations that happen without direct user interaction:
- What triggers them (timer, event, state change)
- What they do
- How the user is notified of results
- What happens on failure

### 4. Integration Flows
Document interactions with external systems:
- What triggers the integration
- What data is exchanged
- How failures are handled
- Retry/fallback behavior

---

## Tips

- Start with the happy path, then document errors and edge cases
- Use actual state property names from the code
- Include the specific UI element or API endpoint names
- Document what the user SEES, not just what the code DOES
- Keep flows independent -- each should be understandable on its own
