# Changelog

## v3.0.1 (2026-03-19)

### Build/Test Command Detection

- **Simplified agents**: Removed bloated fallback detection tables from build and test agents. Agents now only read from `.north-starr.json` — no runtime detection.
- **CLI detection**: `north-starr update` now auto-detects build and test commands from project config files and prompts to save them to `.north-starr.json`.
- **Sync detection**: `/sync` now detects missing build/test commands and offers to configure them (Step 3.5).
- Detection logic is centralized: `/bootstrap` detects during initial setup, `north-starr update` and `/sync` detect during upgrades.

## v3.0.0 (2026-03-19)

### TDD Workflow

north-starr now encourages Test-Driven Development by default. The "How to Approach Tasks" workflow has been restructured:

- **Step 3: Write failing tests first (RED)** — before writing implementation code, write tests that describe the expected behavior. Tests should fail.
- **Step 4: Write code to pass tests (GREEN)** — write the minimum implementation to make tests pass.
- **Q0: "Is current behavior covered by tests?"** — added to the complexity assessment. If No, write tests for existing behavior before making changes.
- Layoutplan agents and skill now produce test-first task structures (RED → GREEN → verify).

### Build Agent (NEW)

A dedicated agent that compiles the project on a separate thread, keeping build errors out of your main context.

- Auto-detects build commands from project config files (iOS, Android, Go, Rust, JS/TS, Python, etc.)
- Fixes compile errors automatically (up to 3 iterations)
- Returns a structured SUCCESS/FAILURE summary
- Build commands are stored in `.north-starr.json` under `build.commands`
- Templates: `templates/claude/agents/build.md`, `templates/github/agents/build.agent.md`

### Test Agent (NEW)

A dedicated agent that runs the test suite on a separate thread with smart failure classification.

- **Mechanical failures** (missing imports, renamed methods) are auto-fixed
- **Logic/behavior failures** (wrong values, assertion mismatches) are reported back with analysis for human decision
- Returns `SUCCESS`, `NEEDS INPUT`, or `FAILURE` status
- Detects "no tests exist" and returns `SKIPPED` immediately
- Test commands are stored in `.north-starr.json` under `test.commands`
- Templates: `templates/claude/agents/test.md`, `templates/github/agents/test.agent.md`

### 7 Code Virtues Integration

Positive quality vocabulary based on Tim Ottinger & Jeff Langr's Code Virtues, ordered by priority: Working > Unique > Simple > Clear > Easy > Developed > Brief.

- **Pattern template** — new `Virtues` field (which virtues the pattern serves)
- **Landmine template** — new `Threatens` field (which virtues the landmine endangers)
- **`/invert`** — new Section F: Virtue Trade-offs with priority-based resolution
- **`/learn`** — captured learnings are tagged with the virtue they protect
- **`/refactoring-analyzer`** — new Virtue Scorecard (Step 6.5) scoring code against all 7 virtues
- Reference: `skills/_references/virtues/code-virtues.md`

### Bootstrap Enhancements

- Detects and confirms build commands during Step 1 (Explore & Detect)
- Detects and confirms test commands during Step 1
- Writes `build.commands` and `test.commands` to `.north-starr.json`
- Copies build and test agents alongside layoutplan agent
- Inline managed section updated to match v3.0.0 workflow

### Sync Improvements

- `/sync` now also syncs managed sections to `.github/copilot-instructions.md` (if copilot target enabled)
- Summary output lists all agents (layoutplan, build, test) per target

### Other Changes

- `bin/north-starr` preserves existing `build` and `test` config in `.north-starr.json` on update
- Architect skill inline managed section updated to v3.0.0 workflow
- All 5 files with inline managed sections are now consistent

---

## v2.5.1 (2026-03-17)

- Add VS Code Copilot layoutplan agent
- Bug fixes

## v2.5.0 (2026-03-17)

- Add VS Code Copilot support for layoutplan agent
