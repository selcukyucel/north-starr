---
name: decompose
description: Decompose a PRD into prioritized, dependency-mapped epics and user stories. Accepts pasted text, file path, or PDF.
argument-hint: <PRD text, file path, or PDF path>
---

# PRD Decomposition — From Document to Backlog

## Purpose

Break down a Product Requirements Document into structured, prioritized user stories with dependency mapping. Produces a persistent story map that feeds individual stories into the existing `/invert` → `layoutplan` pipeline.

Use this when you receive a PRD, spec, or feature brief that is too large for a single `/invert` analysis — typically anything with multiple workflows, feature areas, or delivery phases.

## Input

The user provides PRD content in one of three forms:
- **Pasted text** directly in the conversation
- **File path** to a markdown, text, or Word document
- **PDF path** (use the Read tool's PDF capability — chunk into 20-page reads if needed)

## Workflow

### Step 1: Read & Validate Input

**Actions:**
1. If a file/PDF path is provided, read the content (for PDFs over 20 pages, read in chunks)
2. If text is pasted, use it directly
3. Verify the content looks like a PRD (has features, requirements, or workflows described)
4. If the content is ambiguous, ask the user what they want decomposed

### Step 2: Scan Structure

Do a lightweight scan of the PRD to identify:

- **Workflows / feature areas** — distinct functional domains (e.g., "Document Ingestion", "Compliance Monitoring")
- **Priority scheme** — MoSCoW, P0/P1/P2, phases, or none (you'll derive priorities if absent)
- **Delivery phases** — timelines or release milestones if present
- **Technical architecture** — stack, components, integrations mentioned
- **Scope indicators** — count of distinct features, workflows, user types

### Step 3: Present Scope Summary & Confirm

Present the user with a scope summary before proceeding:

```
PRD Scan Results:
─────────────────
Workflows detected:    [count] ([list])
Priority scheme:       [MoSCoW / Phases / P0-P3 / None detected]
Feature areas:         [count]
Estimated epics:       [range]
Estimated stories:     [range]
Delivery phases:       [list if present]
Technical stack:       [brief summary if present]

The storymap agent will run on a separate thread to decompose this PRD.
Proceed?
```

Wait for user approval before continuing.

### Step 4: Normalize & Persist PRD

**Actions:**
1. Create `.plans/` directory if it doesn't exist
2. Generate a short kebab-case name from the PRD title or subject (e.g., `ifr-compliance-platform`, `user-onboarding-v2`)
3. Write the PRD content to `.plans/PRD-<name>.md` with a header:

```markdown
# PRD: <name>

**Ingested:** <date>
**Source:** <file path or "pasted text">
**Scope:** <one-line summary>

---

<full PRD content>
```

This serves as the input file for the `storymap` agent and as a permanent record.

### Step 5: Spawn the Storymap Agent

Spawn the `storymap` agent (available in `.claude/agents/` or `.github/agents/`) on a separate thread to keep the main context clean.

Pass the agent the PRD file path:

> "Decompose `.plans/PRD-<name>.md` into epics and user stories. Write output to `.plans/STORIES-<name>.md`."

The agent will:
- Read the PRD file
- Identify epics by theme/workflow
- Decompose each epic into user stories with acceptance criteria
- Map dependencies at both epic and story level
- Assign priorities (from the PRD's scheme or derived)
- Estimate sizes (S/M/L/XL)
- Flag complex stories as "invert candidates"
- Write the complete story map to `.plans/STORIES-<name>.md`

### Step 6: Present Results & Offer GitHub Issues

**IMPORTANT:** This step runs on the main thread after the storymap agent returns. You MUST complete this step — do not end the conversation after the agent summary.

Once the agent completes:

1. Read `.plans/STORIES-<name>.md` and present a summary
2. **Immediately ask** the user whether to create GitHub Issues

Present this as a single message:

```
Story Map: <name>
──────────────────
Epics:    [count]
Stories:  [count]
  MUST:   [count] stories
  SHOULD: [count] stories
  COULD:  [count] stories

Suggested starting stories (no dependencies):
  • S1.1 — <title> [size] [invert candidate?]
  • S2.1 — <title> [size] [invert candidate?]

Full story map: .plans/STORIES-<name>.md
```

Then ask:

> "Would you like to create GitHub Issues for these stories?"

If the user declines, stop here.

### Step 7: Generate GitHub Issues Script

**Pre-flight checks — run these before generating the script:**

```bash
# 1. Is gh CLI installed?
gh --version

# 2. Is gh authenticated?
gh auth status

# 3. Does this repo have a GitHub remote?
gh repo view --json nameWithOwner -q '.nameWithOwner'
```

If any check fails, tell the user what's needed:
- **gh not installed**: `brew install gh` (macOS) or see https://cli.github.com
- **Not authenticated**: Run `gh auth login` — needs a GitHub token with `repo` scope (issues, labels, milestones)
- **No GitHub remote**: The repo needs a GitHub remote to create issues against. Run `gh repo create` or add a remote.

If all checks pass, proceed.

Do NOT run `gh issue create` commands inline — a large PRD can produce 30-50 stories and running them one by one wastes context and is slow. Instead, generate a self-contained shell script the user runs outside Claude.

**Generate `.plans/create-issues-<name>.sh`** with the following structure:

```bash
#!/usr/bin/env bash
set -euo pipefail

# Generated by /decompose from .plans/STORIES-<name>.md
# Run: chmod +x .plans/create-issues-<name>.sh && .plans/create-issues-<name>.sh
#
# Prerequisites:
#   - gh CLI installed (brew install gh)
#   - gh authenticated with repo scope (gh auth login)
#   - Running from a git repo with a GitHub remote

# ─── Pre-flight ───────────────────────────────────────────
if ! command -v gh &> /dev/null; then
  echo "Error: gh CLI not found. Install: brew install gh"
  exit 1
fi
if ! gh auth status &> /dev/null; then
  echo "Error: gh not authenticated. Run: gh auth login"
  exit 1
fi

REPO=$(gh repo view --json nameWithOwner -q '.nameWithOwner')
echo "Creating issues in $REPO..."
echo ""

# ─── Labels ───────────────────────────────────────────────
echo "Creating labels..."
gh label create "priority:must" --color "B60205" --description "Must have — MVP" --force 2>/dev/null || true
gh label create "priority:should" --color "D93F0B" --description "Should have — Phase 2" --force 2>/dev/null || true
gh label create "priority:could" --color "FBCA04" --description "Could have — Phase 3" --force 2>/dev/null || true
gh label create "size:S" --color "C5DEF5" --force 2>/dev/null || true
gh label create "size:M" --color "BFD4F2" --force 2>/dev/null || true
gh label create "size:L" --color "A2C4E0" --force 2>/dev/null || true
# Epic labels (one per epic, each with a distinct color)
gh label create "epic:<epic-slug>" --color "<color>" --force 2>/dev/null || true
# ...repeat for each epic

# ─── Milestones ───────────────────────────────────────────
echo "Creating milestones..."
gh api repos/"$REPO"/milestones -f title="<phase name>" -f description="<description>" -f due_on="<YYYY-MM-DDT00:00:00Z>" 2>/dev/null || true
# ...repeat for each phase

# ─── Issues (dependency order) ────────────────────────────
# Stories with no dependencies are created first.
# Each issue captures its number in a variable so dependent stories can reference it.

echo "Creating issues..."

# --- S1.1: <title> (no dependencies) ---
S1_1=$(gh issue create \
  --title "[S1.1] <story title>" \
  --label "priority:must,size:M,epic:<epic-slug>" \
  --milestone "<phase name>" \
  --body "$(cat <<'ISSUE_EOF'
## User Story

> As a <role>, I want <capability> so that <benefit>.

## Acceptance Criteria

- [ ] Criterion 1
- [ ] Criterion 2

## Technical Notes

<notes>

## Metadata

- **Size:** M
- **Invert Candidate:** Yes
- **Story Map:** `.plans/STORIES-<name>.md`
ISSUE_EOF
)" | grep -oP '\d+$')
echo "  Created #$S1_1 — [S1.1] <title>"

# --- S1.2: <title> (depends on S1.1) ---
S1_2=$(gh issue create \
  --title "[S1.2] <story title>" \
  --label "priority:must,size:S,epic:<epic-slug>" \
  --milestone "<phase name>" \
  --body "$(cat <<ISSUE_EOF
## User Story

> As a <role>, I want <capability> so that <benefit>.

## Acceptance Criteria

- [ ] Criterion 1

## Dependencies

Depends on #$S1_1 (S1.1 — <title>)

## Metadata

- **Size:** S
- **Invert Candidate:** No
- **Story Map:** \`.plans/STORIES-<name>.md\`
ISSUE_EOF
)" | grep -oP '\d+$')
echo "  Created #$S1_2 — [S1.2] <title>"

# ...repeat for ALL stories in dependency order

# ─── Summary ─────────────────────────────────────────────
echo ""
echo "Done! Created <count> issues across <count> epics."
echo "View: gh issue list --label 'epic:<epic-slug>'"
```

**Key rules for the generated script:**
- **Dependency order**: Create dependency-free stories first. Capture each issue number in a shell variable (e.g., `S1_1`, `S3_2`) so dependent stories can reference `#$S1_1` in their body.
- **Heredoc for bodies**: Use `cat <<'ISSUE_EOF'` (single-quoted delimiter) for stories with no dependencies. Use `cat <<ISSUE_EOF` (unquoted delimiter) for stories that need variable expansion (`#$S1_1`).
- **Idempotent labels/milestones**: Use `--force` and `|| true` so the script can be re-run safely.
- **Every story gets an issue**: Do not skip any stories — the full story map becomes the full backlog.
- **Extract issue number**: Use `grep -oP '\d+$'` on `gh issue create` output to capture the issue number into a variable.

After generating the script, tell the user:

```
GitHub Issues script generated: .plans/create-issues-<name>.sh
  • <count> issues will be created across <count> epics
  • <count> labels and <count> milestones will be set up
  • Dependencies are wired via issue number references

Review and run:
  chmod +x .plans/create-issues-<name>.sh
  .plans/create-issues-<name>.sh
```

## Notes

- This skill is domain-agnostic — it works for any PRD regardless of industry or technology
- The `storymap` agent runs on a separate thread to keep main context clean for large PRDs
- Stories are sized by **AI context budget (~300K tokens per story)**, not human effort. This budget covers the full session: codebase exploration, inversion analysis, planning, implementation, and testing. No story should be XL — those get split into sequential S/M stories.
- If the PRD has no explicit priority scheme, the agent derives priorities from: dependency order (foundations first), user-facing value, and technical risk
- GitHub Issues creation is always opt-in — generates a shell script the user reviews and runs, rather than executing 30-50 `gh` commands inline which would waste context
- For very large PRDs (20+ epics), the agent may split output into per-epic files with the main file as an index
- The `.plans/PRD-<name>.md` file preserves the original PRD for traceability — downstream artifacts reference it
