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
1. If a file/PDF path is provided, read the content. For PDFs over 20 pages, read in sequential 20-page chunks (pages 1-20, 21-40, etc.) — the Read tool supports a `pages` parameter. Read ALL chunks before proceeding; do not start scanning until the full document is loaded. For very large PDFs (60+ pages), note the page count in the scope summary so the user knows the full document was read.
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
- **AI project indicators** — scan for keywords: AI, ML, model, LLM, GPT, inference, training, embeddings, RAG, vector, prompt, hallucination, confidence, fine-tuning, NLP, neural, agent, orchestration. If 3+ distinct indicators found, flag as AI project. List the specific AI components detected (e.g., "RAG pipeline, LLM generation, document parsing, embeddings, compliance mapping engine").
- **User personas** — identify named personas or user roles with their key workflows
- **Hard deadlines** — regulatory deadlines, contractual dates, market windows, launch dates that constrain story priority and sequencing
- **Non-development sections** — identify sections that are NOT engineering deliverables: go-to-market strategy, pricing, sales channels, marketing campaigns, team hiring, competitive analysis, business metrics. These sections provide context but MUST NOT become user stories. Flag them so the agent skips them during decomposition.
- **Out of scope / Won't Have** — if the PRD has an explicit "Won't Have", "Out of Scope", or "Exclusions" section, extract the items. Pass these to the agent as a blocklist: "Do NOT create stories for: [items]. These are explicitly out of scope per the PRD."

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
User personas:         [count] ([names and roles])
AI Project:           [Yes / No]

[If AI Project = Yes:]
AI components:         [list specific components: RAG pipeline, LLM generation, embeddings, etc.]

This PRD describes an AI project. The chief-ai-po agent will produce AI-augmented stories
with inverted failure modes, safety stories, and graceful degradation criteria.

[If hard deadlines detected:]
Hard deadlines:
  • [date] — [what happens] (e.g., "Nov 2026 — IFR opens applications")
  • [date] — [what happens] (e.g., "Feb 2027 — final submission deadline")
These deadlines will be used to sequence story priority.

[If non-development sections detected:]
Skipping non-dev sections: [list — e.g., "Go-to-Market (§5.1-5.4), Pricing (§5.2), Sales Channels (§5.3)"]
These provide context but will NOT become user stories.

[If out-of-scope items detected:]
Out of scope (per PRD): [list — e.g., "Financial fair play, UEFA licensing, player transfers"]
No stories will be created for these items.

Options:
  1. chief-ai-po only — AI-augmented stories (recommended for AI-native projects)
  2. storymap only — standard stories (no AI-specific analysis)
  3. Both — storymap first, then chief-ai-po augments with AI layer

[If AI Project = No:]
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
**Priority Scheme:** <MoSCoW / Phases / P0-P3 / Derived>
**AI Project:** <Yes (components: ...) / No>
**Personas:** <list of names and roles>
**Hard Deadlines:** <list of dates and events, or "None detected">
**Non-Dev Sections:** <list of sections skipped, or "None">

---

<full PRD content>
```

This serves as the input file for the `storymap` agent and as a permanent record.

### Step 5: Spawn the Decomposition Agent

Choose the agent based on AI project detection and the user's selection from Step 3.

**Context to pass to every agent prompt** (append to the decomposition instruction):

- If the PRD has an existing priority scheme, name it: "The PRD uses MoSCoW prioritization — respect it."
- If hard deadlines were detected, list them: "Hard deadlines: [date — event]. Use these to sequence story priority — stories required before the earliest deadline are MUST."
- If non-development sections were identified, list them: "Skip these sections — they are business/GTM context, not engineering deliverables: [section list]. Do NOT create stories for go-to-market, pricing, sales, marketing, or hiring activities."
- If personas were identified, list them: "User personas: [names and roles]. Reference these in user stories."

**Option 1 — chief-ai-po only (AI projects):**
Spawn the `chief-ai-po` agent on a separate thread:

> "Decompose `.plans/PRD-<name>.md` into AI-augmented epics and user stories. Write output to `.plans/STORIES-AI-<name>.md`. [Append context above.]"

The agent will produce stories with inverted failure modes, 6 mandatory AI safety stories (SA.1-SA.6), human oversight checkpoints, and graceful degradation criteria on every AI-touching story.

**Option 2 — storymap only (non-AI projects, or user choice):**
Spawn the `storymap` agent on a separate thread:

> "Decompose `.plans/PRD-<name>.md` into epics and user stories. Write output to `.plans/STORIES-<name>.md`. [Append context above.]"

The agent will identify epics, decompose into user stories with acceptance criteria, map dependencies, assign priorities, estimate sizes, and flag invert candidates.

**Option 3 — Both (storymap then chief-ai-po):**
Spawn `storymap` first. After it completes and writes `.plans/STORIES-<name>.md`, spawn `chief-ai-po`:

> "Augment `.plans/PRD-<name>.md` with AI-specific analysis. The base story map is at `.plans/STORIES-<name>.md`. Write output to `.plans/STORIES-AI-<name>.md`."

The chief-ai-po agent will read both files and produce an AI-augmented version that cross-references existing stories rather than duplicating them.

### Step 6: Present Results & Offer GitHub Issues

**IMPORTANT:** This step runs on the main thread after the storymap agent returns. You MUST complete this step — do not end the conversation after the agent summary.

Once the agent completes:

1. Read the output file (`.plans/STORIES-<name>.md` or `.plans/STORIES-AI-<name>.md`) and present a summary
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

If chief-ai-po was used, add these lines to the summary:

```
AI Analysis:
  Pre-mortem risks:              [count]
  AI safety stories (SA.1-SA.6): 6
  Human oversight checkpoints:   [count]
  Graceful degradation coverage: [count]/[total] stories

Full AI story map: .plans/STORIES-AI-<name>.md
```

Then ask:

> "Would you like to create GitHub Issues for these stories?"

If the user declines, stop here.

### Step 7: Create GitHub Issues Directly

**Pre-flight checks — run these before creating issues:**

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
- **Not authenticated**: Run `gh auth login` — needs a GitHub token with `repo` and `project` scope (issues, labels, milestones, projects)
- **No GitHub remote**: The repo needs a GitHub remote to create issues against. Run `gh repo create` or add a remote.

If all checks pass, proceed.

**Create issues directly using the Bash tool.** Do NOT generate a shell script file. Run `gh` commands inline during the conversation. This gives the user real-time feedback and avoids an extra file they need to review and execute.

#### 7a: Create Labels and Milestones

Run label and milestone creation commands via the Bash tool. Use `--force` and `|| true` for idempotency. Batch independent label commands into a single Bash call:

```bash
REPO=$(gh repo view --json nameWithOwner -q '.nameWithOwner')

# Priority labels
gh label create "priority:must" --color "B60205" --description "Must have — MVP" --force 2>/dev/null || true
gh label create "priority:should" --color "D93F0B" --description "Should have — Phase 2" --force 2>/dev/null || true
gh label create "priority:could" --color "FBCA04" --description "Could have — Phase 3" --force 2>/dev/null || true

# Size labels
gh label create "size:S" --color "C5DEF5" --force 2>/dev/null || true
gh label create "size:M" --color "BFD4F2" --force 2>/dev/null || true
gh label create "size:L" --color "A2C4E0" --force 2>/dev/null || true

# Epic labels — one per epic, each with a distinct color
gh label create "epic:<epic-slug>" --color "<color>" --force 2>/dev/null || true
# ...one per epic
```

Create milestones for delivery phases:

```bash
gh api repos/"$REPO"/milestones -f title="<phase name>" -f description="<description>" -f due_on="<YYYY-MM-DDT00:00:00Z>" 2>/dev/null || true
```

#### 7b: Create Epic Parent Issues

Create one parent issue per epic. These serve as containers for sub-issues. After creating each epic issue, also fetch its GraphQL node ID — this is needed to link sub-issues later.

```bash
EPIC1_NUM=$(gh issue create \
  --title "Epic: <epic title>" \
  --label "epic:<epic-slug>" \
  --milestone "<phase name>" \
  --body "## Epic: <epic title>

<epic description — 2-3 sentences summarizing the epic's goal>

## Stories

_Sub-issues will be linked to this issue._

## Metadata

- **Story count:** <count>
- **Priority mix:** <N> MUST, <N> SHOULD, <N> COULD
- **Story Map:** \`.plans/STORIES-<name>.md\`
" | grep -o '[0-9]*$')
echo "Created epic #$EPIC1_NUM — <epic title>"

# Get the GraphQL node ID for the epic (needed for addSubIssue mutation)
EPIC1_ID=$(gh issue view "$EPIC1_NUM" --json id --jq '.id')
```

Repeat for each epic — capture both the issue number (`EPIC1_NUM`) and the node ID (`EPIC1_ID`).

#### 7c: Create Story Issues and Link as Sub-Issues (Dependency Order)

Creating sub-issues is a **two-step process** because `gh issue create` has no `--parent` flag:
1. Create the story issue normally with `gh issue create`
2. Link it as a sub-issue of its epic using the `addSubIssue` GraphQL mutation

Process stories in dependency order — stories with no dependencies first.

```bash
# --- S1.1: <title> (no dependencies, under Epic 1) ---
# Step 1: Create the issue
S1_1=$(gh issue create \
  --title "[S1.1] <story title>" \
  --label "priority:must,size:M,epic:<epic-slug>" \
  --milestone "<phase name>" \
  --body "## User Story

> As a <role>, I want <capability> so that <benefit>.

## Acceptance Criteria

- [ ] Criterion 1
- [ ] Criterion 2

## Technical Notes

<notes>

## Metadata

- **Size:** M
- **Invert Candidate:** Yes
- **Story Map:** \`.plans/STORIES-<name>.md\`
" | grep -o '[0-9]*$')
echo "  Created #$S1_1 — [S1.1] <title>"

# Step 2: Link as sub-issue of Epic 1 via GraphQL
S1_1_ID=$(gh issue view "$S1_1" --json id --jq '.id')
gh api graphql -f query='
  mutation($parentId: ID!, $childId: ID!) {
    addSubIssue(input: {issueId: $parentId, subIssueId: $childId}) {
      issue { number title }
      subIssue { number title }
    }
  }
' -f parentId="$EPIC1_ID" -f childId="$S1_1_ID"
echo "    Linked #$S1_1 as sub-issue of epic #$EPIC1_NUM"
```

For stories with dependencies, include the dependency reference in the body:

```bash
# --- S1.2: <title> (depends on S1.1, under Epic 1) ---
# Step 1: Create the issue
S1_2=$(gh issue create \
  --title "[S1.2] <story title>" \
  --label "priority:must,size:S,epic:<epic-slug>" \
  --milestone "<phase name>" \
  --body "## User Story

> As a <role>, I want <capability> so that <benefit>.

## Acceptance Criteria

- [ ] Criterion 1

## Dependencies

Depends on #$S1_1 (S1.1 — <title>)

## Metadata

- **Size:** S
- **Invert Candidate:** No
- **Story Map:** \`.plans/STORIES-<name>.md\`
" | grep -o '[0-9]*$')
echo "  Created #$S1_2 — [S1.2] <title>"

# Step 2: Link as sub-issue of Epic 1
S1_2_ID=$(gh issue view "$S1_2" --json id --jq '.id')
gh api graphql -f query='
  mutation($parentId: ID!, $childId: ID!) {
    addSubIssue(input: {issueId: $parentId, subIssueId: $childId}) {
      issue { number title }
      subIssue { number title }
    }
  }
' -f parentId="$EPIC1_ID" -f childId="$S1_2_ID"
echo "    Linked #$S1_2 as sub-issue of epic #$EPIC1_NUM"
```

**Key rules for issue creation:**
- **Dependency order**: Create dependency-free stories first. Capture each issue number in a variable (e.g., `S1_1`, `S3_2`) so dependent stories can reference `#$S1_1` in their body.
- **Two-step sub-issue linking**: After creating each story issue, immediately fetch its node ID with `gh issue view <num> --json id --jq '.id'` and link it to the epic parent using the `addSubIssue` GraphQL mutation. The mutation requires the parent's node ID (`$EPICN_ID`) and the child's node ID.
- **GraphQL mutation reference**: `addSubIssue(input: {issueId: <parent_node_id>, subIssueId: <child_node_id>})` — both IDs are GraphQL node IDs (not issue numbers).
- **Variable expansion in body**: Use unquoted heredocs or inline strings so `$S1_1` variables expand to the actual issue number.
- **Every story gets an issue**: Do not skip any stories — the full story map becomes the full backlog.
- **Extract issue number**: Use `grep -o '[0-9]*$'` on `gh issue create` output to capture the issue number.
- **Batch Bash calls**: Where stories have no dependency on each other (e.g., two foundation stories in different epics), create them in parallel using multiple Bash tool calls in a single message. Each Bash call should create the issue AND link it as a sub-issue in one command chain.
- **Progress updates**: After each batch of issues, print a running count so the user sees progress (e.g., "Created 8/24 issues...").

#### 7d: Create or Use a GitHub Project Board

After all issues are created, set up a GitHub Project for visual ordering.

**Ask the user:**

```
Issues created! Would you like to:
  1. Create a new GitHub Project board for this PRD
  2. Add issues to an existing Project (provide project number)
  3. Skip project board setup
```

If the user chooses option 1 or 2:

**Create a new project (option 1):**

```bash
# Get the repo owner (org or user)
OWNER=$(gh repo view --json owner -q '.owner.login')

# Create the project
PROJECT_NUM=$(gh project create --owner "$OWNER" --title "<PRD name> — Backlog" --format json | jq -r '.number')
echo "Created project #$PROJECT_NUM"

# Add a custom "Priority Order" number field for implementation sequencing
gh project field-create "$PROJECT_NUM" --owner "$OWNER" --name "Priority Order" --data-type NUMBER
```

**Add issues to the project with priority ordering:**

Assign each issue a `Priority Order` value that matches the implementation sequence (1 = first to implement, N = last). This overrides GitHub's default newest-first display.

```bash
# Get the field ID for Priority Order
FIELD_ID=$(gh project field-list "$PROJECT_NUM" --owner "$OWNER" --format json | jq -r '.fields[] | select(.name == "Priority Order") | .id')

# Add each issue to the project and set its priority order
# Epic parent issues get Priority Order = 0 so they sort to the top
ITEM_ID=$(gh project item-add "$PROJECT_NUM" --owner "$OWNER" --url "https://github.com/$REPO/issues/$EPIC1_NUM" --format json | jq -r '.id')
gh project item-edit --project-id "$PROJECT_NUM" --id "$ITEM_ID" --field-id "$FIELD_ID" --number 0

# S1.1 is the first story to implement → Priority Order = 1
ITEM_ID=$(gh project item-add "$PROJECT_NUM" --owner "$OWNER" --url "https://github.com/$REPO/issues/$S1_1" --format json | jq -r '.id')
gh project item-edit --project-id "$PROJECT_NUM" --id "$ITEM_ID" --field-id "$FIELD_ID" --number 1

# S1.2 depends on S1.1 → Priority Order = 2
ITEM_ID=$(gh project item-add "$PROJECT_NUM" --owner "$OWNER" --url "https://github.com/$REPO/issues/$S1_2" --format json | jq -r '.id')
gh project item-edit --project-id "$PROJECT_NUM" --id "$ITEM_ID" --field-id "$FIELD_ID" --number 2

# ...repeat for all issues, incrementing the priority order
```

**For existing projects (option 2):** Skip project creation, just add issues and set Priority Order using the user-provided project number.

After project setup, tell the user:

```
GitHub Project board ready!
  • <count> issues added with Priority Order field
  • Sort by "Priority Order" to see implementation sequence
  • Epic parent issues are at the top
  • View: gh project view <PROJECT_NUM> --owner <OWNER> --web
```

## Notes

- This skill is domain-agnostic — it works for any PRD regardless of industry or technology
- The `storymap` agent runs on a separate thread to keep main context clean for large PRDs
- Stories are sized by **AI context budget (~300K tokens per story)**, not human effort. This budget covers the full session: codebase exploration, inversion analysis, planning, implementation, and testing. No story should be XL — those get split into sequential S/M stories.
- If the PRD has no explicit priority scheme, the agent derives priorities from: dependency order (foundations first), user-facing value, and technical risk
- GitHub Issues are created directly via `gh` commands during the conversation — no intermediate shell script is generated. This provides real-time feedback and keeps the workflow within the skill.
- Stories are linked as **sub-issues** of their epic parent issue using the `addSubIssue` GraphQL mutation (`gh api graphql`). This is a two-step process: create the issue first, then link it. The `gh issue create` command has no `--parent` flag — sub-issue linking must be done separately via GraphQL.
- The GitHub Project board with a custom "Priority Order" field ensures issues display in implementation order, not creation order. This solves the problem of GitHub's default newest-first sorting inverting the dependency chain.
- For very large PRDs (20+ epics), the agent may split output into per-epic files with the main file as an index
- The `.plans/PRD-<name>.md` file preserves the original PRD for traceability — downstream artifacts reference it
