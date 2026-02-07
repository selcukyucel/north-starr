# [Checklist Name]

**Purpose**: [What this checklist ensures -- e.g., "Consistent implementation of X across the codebase"]
**When to Use**: [Trigger conditions -- e.g., "When adding a new Y" or "When modifying Z"]
**Last Updated**: [Date]

---

## Pre-Implementation

- [ ] Read relevant patterns in `.ai/patterns/`
- [ ] Check relevant landmines in `.ai/landmines/`
- [ ] Review existing code in the affected area
- [ ] Verify requirements are clear and unambiguous
- [ ] Check for existing components, utilities, or abstractions to reuse
- [ ] Identify dependencies and potential blast radius of changes

---

## Implementation

### Phase 1: [Name -- e.g., "Foundation / Data Layer"]

**Location**: `[path to relevant directory or module]`

- [ ] **[Step group]**
  - [ ] [Specific action]
  - [ ] [Specific action]

**Validation checkpoint**: [What to verify before moving to Phase 2]

---

### Phase 2: [Name -- e.g., "Core Logic / Business Layer"]

**Location**: `[path to relevant directory or module]`

- [ ] **[Step group]**
  - [ ] [Specific action]
  - [ ] [Specific action]

**Validation checkpoint**: [What to verify before moving to Phase 3]

---

### Phase 3: [Name -- e.g., "Integration / Presentation Layer"]

**Location**: `[path to relevant directory or module]`

- [ ] **[Step group]**
  - [ ] [Specific action]
  - [ ] [Specific action]

**Validation checkpoint**: [What to verify before moving to Quality Checks]

---

## Quality Checks

### Build and Compilation

- [ ] Build/compile succeeds with no errors
- [ ] No new compiler or linter warnings introduced
- [ ] No deprecation warnings from dependencies

### Code Quality

- [ ] Error handling is appropriate -- no silently swallowed errors
- [ ] No hardcoded values that should be configurable
- [ ] Existing utilities and shared code reused where possible
- [ ] No unnecessary duplication of logic
- [ ] Naming is clear and consistent with codebase conventions

### Security

- [ ] No secrets, credentials, or tokens in source code
- [ ] User input is validated and sanitized where applicable
- [ ] No known vulnerable patterns introduced

---

## Testing

### Unit Tests

- [ ] New or changed logic has corresponding unit tests
- [ ] Edge cases are covered (empty input, nulls, boundaries, error paths)
- [ ] Tests are independent and do not rely on execution order
- [ ] All tests pass

### Integration Tests (if applicable)

- [ ] Cross-component interactions tested
- [ ] External service integrations tested or properly mocked
- [ ] End-to-end flows verified

---

## Pre-Commit

- [ ] All quality checks above pass
- [ ] No debug, temporary, or commented-out code remains
- [ ] No unrelated changes included -- diff is minimal and focused
- [ ] Commit message clearly describes what changed and why

---

## Related

**Patterns**:
- [Pattern Name](../patterns/[pattern-file].md)

**Landmines**:
- [Landmine Name](../landmines/[landmine-file].md)
