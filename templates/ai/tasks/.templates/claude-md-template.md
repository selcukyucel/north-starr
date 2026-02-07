# [Feature Name] - Feature Documentation

**Module**: `Feature/[FeatureName]` or `Domain/[DomainName]`
**Last Updated**: [Date]
**Version**: 1.0

---

## Overview

[Brief description of what this feature does and its purpose in the app]

**Key Capabilities**:
- [Capability 1]
- [Capability 2]
- [Capability 3]

---

## User Flows

### Flow 1: [Main User Journey]

**Steps**:
1. User opens [Feature Name] screen
2. User sees [what they see]
3. User taps [action]
4. System [what happens]
5. User sees [result]

**State Changes**:
- `uiState`: `.loading` → `.ready(nil)`
- `items`: `[]` → `[Item(...)]`

**Navigation**:
- From: [PreviousScreen] via [Coordinator method]
- To: [NextScreen] via [Coordinator method]

### Flow 2: [Secondary User Journey]

[Similar structure]

---

## MVVM Architecture

### Models

#### [ModelName]

**Location**: `Foundation/Models/[ModelName].swift`

**Properties**:
- `id: UUID` - Unique identifier
- `property1: String` - [Description]
- `property2: Int` - [Description]

**Purpose**: [What this model represents]

### Repository

#### [FeatureName]Repository

**Location**: `Domain/[DomainName]/[FeatureName]Repository.swift`

**Dependencies**:
- `networkClient` - API communication
- `storage` - Local persistence

**Key Methods**:
- `func fetchData() async throws -> [Model]` - [Description]
- `func saveData(_ data: Model) async throws` - [Description]

**@Published Properties**:
- `@Published var items: [Model]` - [Description]

### ViewModel

#### [FeatureName]ViewModel

**Location**: `Feature/[FeatureName]/[FeatureName]ViewModel.swift`

**@Published State**:
- `items: [Item]` - [Description]
- `uiState: UIState` - Loading/ready state
- `errorMessage: String?` - Error display
- `searchText: String` - User input (two-way binding)

**Public Methods**:
- `func fetchData()` - [Description]
- `func selectItem(_ item: Item)` - [Description]
- `func clearError()` - [Description]

**Combine Subscriptions**:
- Subscribes to `repository.$items` → updates local items
- Subscribes to `$searchText` (debounced) → triggers search

**Dependencies**:
- `@Dependency(\.repository)` - Data access
- `@Dependency(\.observability)` - Telemetry

### View

#### [FeatureName]View

**Location**: `Feature/[FeatureName]/[FeatureName]View.swift`

**DesignSystem Components**:
- `AppBackground` - Standard background
- `ActivityIndicator` - Loading state
- `ErrorView` - Error display
- `StandardListItem` - List rows
- `PrimaryButton` - Actions

**Bindings**:
- `@ObservedObject var viewModel` - Observes all state
- `$viewModel.searchText` - Two-way input binding

**Delegate Protocol**: `[FeatureName]Delegate`
- `func show(item: Item)` - Navigate to detail
- `func dismiss()` - Close screen

### Coordinator

#### [FeatureName]Coordinator

**Location**: `/Sportio/Navigation/[FeatureName]Coordinator.swift`

**Navigation Methods**:
- `func show(item: Item)` - Push detail view
- `func showCreate()` - Present modal
- `func dismiss()` - Dismiss modal/pop view

**ViewModel Initialization**:
- Creates ViewModels with proper dependencies
- Injects callbacks for navigation

---

## Data Flow

```
View (User Action)
  ↓
Delegate → Coordinator (Navigation)
  ↓
ViewModel (Business Logic)
  ↓
Repository (Data Access)
  ↓
Network/Storage
  ↓
Repository @Published update
  ↓
ViewModel Combine subscription
  ↓
ViewModel @Published update
  ↓
View re-render
```

**Example: Fetching Data**

1. User opens screen → `ViewModel.init()` → `fetchData()`
2. ViewModel → `repository.fetchData()` (async)
3. Repository → Network call
4. Repository updates `@Published items`
5. ViewModel Combine subscription receives update
6. ViewModel updates local `items` property
7. View automatically re-renders with new data

---

## File Structure

```
Feature/[FeatureName]/
├── [FeatureName]ViewModel.swift
├── [FeatureName]View.swift
└── [FeatureName]Subviews/
    ├── Subview1.swift
    └── Subview2.swift

Domain/[DomainName]/
├── [FeatureName]Repository.swift
└── [FeatureName]Service.swift

Foundation/Models/
└── [ModelName].swift

Sportio/Navigation/
└── [FeatureName]Coordinator.swift

SportioTests/
└── [FeatureName]ViewModelTests.swift
```

---

## Edge Cases & Gotchas

### Edge Case 1: [Description]

**Scenario**: [When this happens]

**Handling**: [How it's handled in code]

**Location**: `[FileName].swift:123`

### Edge Case 2: [Description]

[Similar structure]

---

## Testing Strategy

### Unit Tests

**Location**: `SportioTests/[FeatureName]ViewModelTests.swift`

**Test Coverage**:
- Initial state validation
- Fetch data success path
- Fetch data error handling
- User actions (select, filter, search)
- Combine subscription behavior

**Example**:
```swift
@Test func fetchDataSuccess() async {
    let viewModel = await withDependencies {
        $0.repository = .mock
    } operation: {
        [FeatureName]ViewModel()
    }

    await viewModel.fetchData()

    let items = await viewModel.items
    #expect(!items.isEmpty)
}
```

### Integration Tests

- End-to-end user flows
- Repository integration with real/mock network
- Navigation flow testing

### Manual Test Checklist

- [ ] Open feature screen → displays loading indicator
- [ ] Data loads → displays list of items
- [ ] Tap item → navigates to detail
- [ ] Pull to refresh → reloads data
- [ ] Network error → displays ErrorView
- [ ] Clear error → dismisses ErrorView
- [ ] Search input → filters results (debounced)

---

## Related Features

- **[RelatedFeature1]**: [How they're related]
  - **Location**: `Feature/[RelatedFeature1]/`
  - **Connection**: [Shares repository / navigates to]

- **[RelatedFeature2]**: [How they're related]
  - **Location**: `Domain/[RelatedDomain]/`
  - **Connection**: [Uses same models / calls same service]

---

## Patterns Used

- [MVVM ViewModel Pattern](../../.ai/patterns/mvvm-viewmodel-pattern.md)
- [MVVM Coordinator Pattern](../../.ai/patterns/mvvm-coordinator-pattern.md)
- [MVVM Combine Pattern](../../.ai/patterns/mvvm-combine-pattern.md)
- [Design System Usage](../../.ai/patterns/design-system-usage-pattern.md)
- [MVVM Error Handling](../../.ai/patterns/mvvm-error-handling-pattern.md)

---

## Landmines Avoided

- ✅ No property observers on @Published properties (see: [mvvm-published-property-observers.md](../../.ai/landmines/mvvm-published-property-observers.md))
- ✅ All Combine subscriptions stored in cancellables (see: [mvvm-combine-cancellation.md](../../.ai/landmines/mvvm-combine-cancellation.md))
- ✅ All @Published updates on main thread via @MainActor (see: [mvvm-mainactor-viewmodel.md](../../.ai/landmines/mvvm-mainactor-viewmodel.md))
- ✅ Using [weak self] in all closures
- ✅ DesignSystem components used throughout

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
