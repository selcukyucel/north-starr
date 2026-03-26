# Changelog

## v4.4.2 (2026-03-26)

### Fixed

- **`/bootstrap` managed sections** — bootstrap now copies the "How to Approach Tasks" and "When to Learn Automatically" sections verbatim from templates instead of generating simplified paraphrases. Previously, the instruction to "use the managed section content" was too vague, causing the LLM to rewrite the assessment table, decision rules, and workflow steps.

## v4.4.1 (2026-03-25)

### Plugin Cache Staleness Fix

**Action required for existing Claude Code users:** Claude Code caches the plugin locally and does not auto-update when a new version is released. If you installed north-starr before v4.4.1, run this once to get the latest version:

```bash
cd ~/.claude/plugins/marketplaces/north-starr && git fetch origin && git reset --hard origin/main && cd -
rm -rf ~/.claude/plugins/cache/north-starr
```

Then restart Claude Code (or run `/plugin install north-starr`), and run `/sync` in your projects. **You only need to do this once** — from v4.4.1 onward, `/sync` detects stale caches automatically.

### Added

- **`/sync` staleness detection (Step 0)** — before syncing, `/sync` now fetches from origin and compares HEAD vs origin/main. If the plugin cache is behind, it warns and stops — preventing silent stale syncs that report "already current" with outdated templates
- **`north-starr cache-update` CLI command** — automates the marketplace fetch + install cache clear in a single command. Replaces the manual 4-step post-release workaround
- Updated `.claude/rules/plugin-release-cache.md` with automated fix instructions

## v4.4.0 (2026-03-25)

### Autoimprove — Systematic Skill Optimization

Every skill in this release was improved using the `autoimprove` methodology — inspired by [Andrej Karpathy's autoresearch](https://github.com/karpathy/autoresearch). The same hill-climbing loop used for ML training, applied to skill prompt optimization: define a scoring checklist, make one small change per round, measure, keep improvements, revert regressions. 8 skills and 1 agent went through this process, producing 45 total rounds with 0 reverts.

### Skill Improvements

- **`/bootstrap`** — added quality gate (Step 4b) for self-review before writing files, Virtues integration for all generated rules, path glob specificity guidance with anti-patterns, concrete stack detection matrix for all major ecosystems, stronger cross-referencing requirements (4 relationship types), chief-ai-po agent added to generated agents, full reference template alignment
- **`/decompose`** — added non-development content filtering (GTM, pricing, marketing sections skipped), hard deadline awareness (deadlines drive story priority), AI component listing (not just yes/no), out-of-scope blocklist from PRD, Won't Have detection, PDF chunking strategy for large documents, enriched PRD normalization header with scan metadata
- **`/invert`** — added AI-specific failure modes (hallucination, stale retrieval, prompt injection, model drift, confidence calibration), domain/regulatory risk dimension with auto-escalation to HIGH, assumptions surfacing (5 categories), data flow & pipeline analysis (new Section C), specific test strategies per risk, fixed dimension lettering (was D, D, F, E → now A-G)
- **`/generate-commit`** — added commit convention detection (config files + git log inference), multi-concern split suggestion, breaking change handling (BREAKING CHANGE footer), scope detection from changed files, unstaged change warning, convention precedence order (config > inferred > defaults)
- **`/generate-pr`** — added project PR template detection (.github/PULL_REQUEST_TEMPLATE.md), breaking change flagging, large PR warning (500-line threshold with split suggestion), dependency/migration callouts, 5-factor risk assessment matrix, reviewer suggestion via git blame
- **`/learn`** — aligned Content Depth and Step 3 with updated reference templates (Virtues, Complete Example, Testing, Performance, Origin), added Step 3.7 validation (glob verification, line limit check, bidirectional cross-references, template completeness, code example audit), clear skill suggestion criteria (2+ times, consistent shape)
- **`/report-weekly`** — added cross-platform date command (macOS/Linux fallback), custom date ranges ("last week", "last 7 days", "this sprint", custom), accurate conventional commit prefix parsing (not arbitrary first words), configurable output directory (auto-detects docs/, reports/, Documentation/), optional PR/merge activity via gh CLI, trend comparison with previous period (arrows + percentage)
- **`/sync`** — added dynamic agent discovery (no hardcoded list), skip-if-identical content comparison, post-sync validation (marker integrity, duplicate headings, line limits), Copilot agent syncing, dry-run preview before writing, version tags in markers

### Agent Improvements

- **`chief-ai-po`** — added SA.6 "Observability & Cost Control" as 6th mandatory safety story (LLM logging, pipeline tracing, cost alerts, usage analytics), non-development content filtering, hard deadline awareness with auto-MUST priority, out-of-scope blocklist, AI cost signals in technical notes (LLM calls per action, embedding volume, batch/realtime, caching), story map header now includes deadlines and exclusions
- All agent templates synced across `agents/`, `templates/claude/agents/`, and `templates/github/agents/`

### Reference Template Updates

- **Pattern template** (`skills/_references/patterns/_TEMPLATE.md`) — added HTML guidance comments for code example sourcing, Complete Example section, structured Related section with 4 relationship types (composes, alternative, prevents, misapplication), Path Glob Guidance section, language-adaptive field
- **Landmine template** (`skills/_references/landmines/_TEMPLATE.md`) — severity now requires evidence justification, Real-World Impact requires specific file/module citations, Detection section requires concrete grep commands, structured Related with 3 relationship types, Path Glob Guidance, Prevention expanded to include automated checks
- **Code Virtues** (`skills/_references/virtues/code-virtues.md`) — added "Where Virtues Are Used" section linking back to all consuming skills and templates
- **GitHub instructions template** (`templates/github/instructions/_TEMPLATE.instructions.md`) — complete rewrite to include all pattern and landmine sections from updated references

### Breaking Changes

- `.github/copilot-instructions.md` references removed from all skills — `AGENTS.md` is now the single source for VS Code Copilot context
- AI safety stories increased from 5 (SA.1-SA.5) to 6 (SA.1-SA.6) — SA.6 is Observability & Cost Control
- macOS-incompatible `grep -oP` replaced with portable `grep -o '[0-9]*$'` in `/decompose` GitHub Issues script

### README

- Updated bootstrap output table (AGENTS.md replaces copilot-instructions.md, chief-ai-po added)
- Updated decompose flow diagram showing AI project detection branching
- Added chief-ai-po to agents table
- Updated all skill descriptions to reflect improvements

## v4.3.0 (2026-03-23)

### Added

- **Chief AI Product Owner agent (`chief-ai-po`)** — reads AI project PRDs and produces story maps with inverted failure modes, 5 mandatory AI safety stories (SA.1–SA.5), graceful degradation criteria, and human oversight checkpoints
- Agent available for both Claude Code (`.claude/agents/`) and VS Code Copilot (`.github/agents/`)

### Changed

- **`/decompose` skill** — now auto-detects AI projects (3+ keyword matches) and offers routing to `chief-ai-po`, `storymap`, or both
- Decompose summary output includes AI-specific metrics (pre-mortem risks, safety stories, oversight checkpoints, degradation coverage)

## v4.2.1 (2026-03-22)

### Changed

- **`/generate-pr`** — replaced generic PR template with a structured format (Summary, Motivation/Context, Type of Change, Changes Made, How to Test, Review Focus, Screenshots/Demo, Checklist)
- Removed automatic PR template detection — the skill now always uses the built-in template

## v4.2.0 (2026-03-22)

### Plugin Auto-Discovery

- Added root-level `agents/` directory and `plugin.json` for Claude Code auto-discovery — agents (layoutplan, storymap) are now picked up automatically when the plugin is installed
- Fixed plugin manifest conflict by setting `strict: true` in marketplace entry

### Storymap Agent Improvements

- Replaced project-specific example with generic `PRD-my-feature` in storymap agent for broader applicability

## v4.1.1 (2026-03-22)

### Patch

- Clean release of `/decompose` skill and storymap agent (version bump only)

## v4.1.0 (2026-03-21)

### Added

- **`/decompose` skill** — decomposes PRDs into prioritized, dependency-mapped epics and user stories
- **Storymap agent** — thread-isolated agent for PRD-to-backlog workflows, available for both Claude Code (`.claude/agents/storymap.md`) and VS Code Copilot (`.github/agents/storymap.agent.md`)
- `/sync` now handles all agents (layoutplan, storymap) instead of only layoutplan
- Rewrote README for agentic workflow with Inspiration section upfront

## v4.0.1 (2026-03-21)

### Changed

- Layoutplan agent now uses Opus model for higher quality plan generation

## v4.0.0 (2026-03-21)

### Agentic Flow Architecture

north-starr adopts the battle-tested agentic flow approach. The entire project has been restructured to match this proven workflow pattern.

### Distribution Simplification

- **Claude Code** → install via the marketplace (`/plugin install north-starr`)
- **VS Code Copilot** → install via Homebrew (`brew install north-starr`)
- Removed `.north-starr.json` — distribution channel determines the tool, no config needed
- Removed `north-starr config` command

### Added

- **`/generate-pr`** — generates pull request descriptions from git diffs against target branch
- **`/report-weekly`** — generates weekly commit reports as markdown and styled HTML
- **Release automation** — GitHub Actions workflow tags, calculates SHA256, and updates the Homebrew formula automatically

### Renamed

- `/commit-message-generator` → **`/generate-commit`**
- `/refactoring-analyzer` → **`/analyze-code`**

### Removed

- **`/architect` skill** — use `/bootstrap` on existing code instead
- **`/document` skill** — removed
- **`/layoutplan` skill** — now an agent-only (spawned by `/invert`, available for both Claude Code and Copilot)
- **Build agent** — removed (users run build/test directly)
- **Test agent** — removed (users run build/test directly)
- **`.north-starr.json`** — no longer needed; existing files are safely ignored with a deprecation notice

### Tool-Aware Approval Gates

- `CLAUDE.md` uses plain text prompts for user approval ("What would you like to do next?")
- `AGENTS.md` uses `vscode_askQuestions` for interactive approval gates in VS Code Copilot
- Both files share the same project context, only the managed sections differ
- Bootstrap generates both `CLAUDE.md` and `AGENTS.md` with their respective approval styles

### Simplified Workflow

- "How to Approach Tasks" managed section is more concise (matches agentic flow style)
- Post-implementation flow now prompts: "Generate commit message", "Generate PR description", "Run /learn", or "Done"
- Added `.github/instructions/_TEMPLATE.instructions.md` for pattern/landmine rules
- Layoutplan agent template available for both Claude Code (`.claude/agents/layoutplan.md`) and Copilot (`.github/agents/layoutplan.agent.md`)

### Migration

- `north-starr update` automatically removes old architect skill, build/test agents
- `.north-starr.json` files are safely ignored with a deprecation notice
- Existing rules, context files, and project config are preserved

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
