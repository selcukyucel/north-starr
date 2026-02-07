# [Feature Name] - Feature Documentation

**Module**: `[module/package path]`
**Last Updated**: [Date]
**Version**: 1.0

---

## Overview

[Brief description of what this feature does and its purpose in the application]

**Key Capabilities**:
- [Capability 1]
- [Capability 2]
- [Capability 3]

---

## User Flows

### Flow 1: [Main User Journey]

**Steps**:
1. User opens [Feature Name] screen/page
2. User sees [what they see]
3. User interacts with [action]
4. System [what happens]
5. User sees [result]

**State Changes**:
- `uiState`: `loading` → `ready`
- `items`: `[]` → `[...]`

**Navigation**:
- From: [PreviousScreen/Page] via [routing method]
- To: [NextScreen/Page] via [routing method]

### Flow 2: [Secondary User Journey]

[Similar structure]

---

## Architecture

> Adapt this section to your project's architecture pattern (MVC, MVVM, Clean Architecture, Hexagonal, etc.)

### Models / Entities

#### [ModelName]

**Location**: `[path/to/model file]`

**Properties**:
- `id` - Unique identifier
- `property1` - [Description]
- `property2` - [Description]

**Purpose**: [What this model represents]

### Data Layer (Repository / Service / Store)

#### [FeatureName]Repository

**Location**: `[path/to/repository file]`

**Dependencies**:
- `networkClient` / `httpClient` - API communication
- `storage` / `database` - Local persistence

**Key Methods**:
- `fetchData()` - [Description]
- `saveData(data)` - [Description]

**Reactive State** (if applicable):
- `items` - [Description of observable/reactive property]

### Business Logic Layer (ViewModel / Controller / UseCase)

#### [FeatureName]ViewModel

**Location**: `[path/to/viewmodel file]`

**Observable State**:
- `items` - [Description]
- `uiState` - Loading/ready/error state
- `errorMessage` - Error display
- `searchText` - User input (two-way binding)

**Public Methods**:
- `fetchData()` - [Description]
- `selectItem(item)` - [Description]
- `clearError()` - [Description]

**Reactive Subscriptions** (if applicable):
- Subscribes to repository items → updates local items
- Subscribes to search text (debounced) → triggers search

**Dependencies**:
- Repository / data layer - Data access
- Logger / telemetry - Observability

### View / UI Layer

#### [FeatureName]View

**Location**: `[path/to/view file]`

**Design System Components**:
- [Background component] - Standard background
- [Loading indicator] - Loading state
- [Error component] - Error display
- [List item component] - List rows
- [Button component] - Actions

**State Bindings**:
- Observes view model state
- Two-way binding on user input fields

**Delegate / Callbacks**:
- `showItem(item)` - Navigate to detail
- `dismiss()` - Close screen

### Navigation (Router / Coordinator / Controller)

#### [FeatureName]Router

**Location**: `[path/to/router file]`

**Navigation Methods**:
- `showItem(item)` - Navigate to detail view
- `showCreate()` - Present creation form
- `dismiss()` - Go back / close

**Initialization**:
- Creates view models / controllers with proper dependencies
- Injects callbacks for navigation

---

## Data Flow

```
View / UI (User Action)
  ↓
Router / Coordinator (Navigation)
  ↓
ViewModel / Controller (Business Logic)
  ↓
Repository / Service (Data Access)
  ↓
Network / Storage
  ↓
Repository state update
  ↓
ViewModel reactive subscription
  ↓
ViewModel state update
  ↓
View re-render
```

**Example: Fetching Data**

1. User opens screen → ViewModel initializes → `fetchData()`
2. ViewModel → `repository.fetchData()` (async)
3. Repository → Network call
4. Repository updates its observable state
5. ViewModel subscription receives update
6. ViewModel updates local state
7. View automatically re-renders with new data

---

## File Structure

```
[feature-path]/
├── [FeatureName]ViewModel.[ext]
├── [FeatureName]View.[ext]
└── components/
    ├── SubComponent1.[ext]
    └── SubComponent2.[ext]

[data-layer-path]/
├── [FeatureName]Repository.[ext]
└── [FeatureName]Service.[ext]

[models-path]/
└── [ModelName].[ext]

[navigation-path]/
└── [FeatureName]Router.[ext]

[tests-path]/
└── [FeatureName]ViewModel.test.[ext]
```

---

## Edge Cases & Gotchas

### Edge Case 1: [Description]

**Scenario**: [When this happens]

**Handling**: [How it's handled in code]

**Location**: `[file path:line number]`

### Edge Case 2: [Description]

[Similar structure]

---

## Testing Strategy

### Unit Tests

**Location**: `[path/to/test file]`

**Test Coverage**:
- Initial state validation
- Fetch data success path
- Fetch data error handling
- User actions (select, filter, search)
- Reactive subscription behavior

**Example**:
```
// Pseudocode - adapt to your testing framework
test "fetchData populates items on success" {
    // Arrange
    repository = MockRepository(items: [sampleItem])
    viewModel = FeatureNameViewModel(repository: repository)

    // Act
    viewModel.fetchData()

    // Assert
    expect(viewModel.items).not.toBeEmpty()
}
```

### Integration Tests

- End-to-end user flows
- Repository integration with real/mock network
- Navigation flow testing

### Manual Test Checklist

- [ ] Open feature screen → displays loading indicator
- [ ] Data loads → displays list of items
- [ ] Select item → navigates to detail
- [ ] Refresh → reloads data
- [ ] Network error → displays error state
- [ ] Dismiss error → clears error state
- [ ] Search input → filters results (debounced)

---

## Related Features

- **[RelatedFeature1]**: [How they're related]
  - **Location**: `[path/to/related feature]`
  - **Connection**: [Shares repository / navigates to]

- **[RelatedFeature2]**: [How they're related]
  - **Location**: `[path/to/related feature]`
  - **Connection**: [Uses same models / calls same service]

---

## Patterns Used

> Link to your project's pattern documentation as applicable.

- [Pattern 1](../../.ai/patterns/[pattern-name].md)
- [Pattern 2](../../.ai/patterns/[pattern-name].md)
- [Pattern 3](../../.ai/patterns/[pattern-name].md)

---

## Landmines Avoided

> Link to your project's landmine documentation as applicable.

- [Landmine 1 avoided and why](../../.ai/landmines/[landmine-name].md)
- [Landmine 2 avoided and why](../../.ai/landmines/[landmine-name].md)

---

## Known Issues / Future Improvements

### Issue 1: [Description]

**Problem**: [What's the issue]

**Workaround**: [Current solution]

**Future**: [Planned improvement]

### Improvement 1: [Description]

**Current**: [How it works now]

**Planned**: [How it could be better]

**Priority**: [Low / Medium / High]

---

**Changelog**:
- **[Date]**: Initial feature documentation
- **[Date]**: Updated [what changed]

---

**Generated with Claude Code FLOW methodology**
