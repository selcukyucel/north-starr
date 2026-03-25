---
name: report-weekly
description: Generate a weekly commit report from git history as both markdown and a styled HTML page. Use this skill when the user asks to "generate a weekly report", "write a commit report", "analyse commits this week", "create a weekly summary", or similar requests about summarizing recent git activity.
---

# Weekly Commit Report Generator

## Overview

Analyze git commit history for a given date range and produce two deliverables: a structured markdown report and a single-page HTML report with styled bar charts, badges, area breakdowns, and highlights. Reports live in `Documentation/`.

## When to Use

Use this skill when the user requests:
- "Generate a weekly report"
- "Analyse the commits since Monday"
- "Write a commit report"
- "Summarize this week's git activity"
- Any similar request asking for a summary of recent commits

## Workflow

### 1. Determine the Date Range

The user may specify a range or use defaults. Supported inputs:

| User says | Date range |
|-----------|-----------|
| (nothing / "this week") | Monday of current week → today |
| "last week" | Previous Monday → previous Sunday |
| "last 7 days" / "past week" | 7 days ago → today |
| "this sprint" | Ask for sprint start date |
| "since March 1" / custom date | Parse the date → today |
| "March 1 to March 15" | Custom range |

Resolve to explicit ISO dates. Use a cross-platform date command:

```bash
# macOS
date -v-monday "+%Y-%m-%d"
# Linux
date -d 'last monday' "+%Y-%m-%d"
```

**Cross-platform approach:** Try the macOS syntax first. If it fails (exit code != 0), fall back to the Linux syntax. Or simply ask the user to confirm the resolved date:

```
Report period: 2026-03-23 (Mon) → 2026-03-25 (today)
Proceed?
```

Use explicit ISO dates with `--since` and `--until` to avoid ambiguity (e.g., `--since='2026-03-23 00:00:00' --until='2026-03-26 00:00:00'`).

### 2. Collect Git Data

Run these commands to gather all metrics. Use `--no-merges` on the target branch (usually `main`):

```bash
# Full commit list
git log --no-merges --since='YYYY-MM-DD 00:00:00' --format='%h | %ad | %aN | %s' --date=short

# Total commit count
git rev-list --no-merges --count --since='YYYY-MM-DD 00:00:00' HEAD

# Unique contributor count
git log --no-merges --since='YYYY-MM-DD 00:00:00' --format='%aN' | sort -u | wc -l

# Aggregate churn (files, insertions, deletions)
git log --no-merges --since='YYYY-MM-DD 00:00:00' --shortstat | tail -1

# Per-commit churn for totals
git log --no-merges --since='YYYY-MM-DD 00:00:00' --format='' --shortstat | awk '/file/ {f+=$1; i+=$4; d+=$6} END {print f, i, d}'

# Daily commit counts
git log --no-merges --since='YYYY-MM-DD 00:00:00' --format='%ad' --date=short | sort | uniq -c

# Commit type breakdown (conventional commit prefix)
# Only match actual conventional commit prefixes, not arbitrary first words
git log --no-merges --since='YYYY-MM-DD 00:00:00' --format='%s' | grep -oE '^(feat|fix|docs|refactor|test|chore|ci|perf|build|style|revert)(\(.+\))?[!]?:' | grep -oE '^[a-z]+' | sort | uniq -c | sort -rn
# Note: commits not matching conventional format are categorized as "other"

# Contributor leaderboard
git log --no-merges --since='YYYY-MM-DD 00:00:00' --format='%aN' | sort | uniq -c | sort -rn

# Workstream prefixes (ticket keys)
git log --no-merges --since='YYYY-MM-DD 00:00:00' --format='%s' | grep -oE '\[([A-Z]+-[0-9]+)\]' | grep -oE '[A-Z]+' | sort | uniq -c | sort -rn

# Most touched top-level areas
git log --no-merges --since='YYYY-MM-DD 00:00:00' --name-only --format='' | grep -oE '^[^/]+/' | sort | uniq -c | sort -rn | head -10
```

**macOS caveats:**
- Use `grep -oE` + `cut` instead of `sed -E` for extracting commit type prefixes
- Use `awk` without named captures (BSD awk limitation)

**Optional: PR/merge activity** — If `gh` CLI is available and authenticated, also collect PR data:

```bash
# Check if gh is available
gh auth status 2>/dev/null

# If authenticated, get merged PRs in the date range
gh pr list --state merged --search "merged:>=YYYY-MM-DD" --json number,title,author,mergedAt,additions,deletions,reviewDecision --limit 50

# Get open PRs for "in progress" section
gh pr list --state open --json number,title,author,createdAt,isDraft --limit 20
```

If `gh` is not available or not authenticated, skip PR data silently — the report works fine with commits only. When PR data is available, add these sections to the report:
- **Merged PRs** — count, list with title/author/review status
- **Open PRs** — count, list with draft status
- **Review coverage** — percentage of merged PRs that had an approved review

### 3. Analyze and Group Changes

**Previous period comparison:** Also collect the same key metrics for the equivalent previous period (e.g., if reporting Mon-Fri this week, also get Mon-Fri last week). Only need totals — not full detail:

```bash
# Previous period commit count (for trend comparison)
git rev-list --no-merges --count --since='PREV-START' --until='PREV-END' HEAD
# Previous period contributor count
git log --no-merges --since='PREV-START' --until='PREV-END' --format='%aN' | sort -u | wc -l
```

Use these to show trends in the Key Metrics section: `12 commits (↑ 20% vs last week)`, `3 contributors (→ same)`, `+450 / -120 lines (↓ 30%)`. If the previous period had zero activity, show "N/A" instead of a percentage.

Group commits by workstream (ticket key prefix) and create descriptive summaries:

- **Read each commit message** and categorize by sub-theme (Infrastructure, UX, Features, Reliability, etc.)
- **Combine related commits** into concise bullet points with ticket references
- **Identify highlights** — notable achievements, migrations, new capabilities, or risk areas
- **Compute bar chart percentages** — daily activity bars relative to the max day, contributor bars relative to top contributor

### 4. Write the Markdown Report

**Output directory:** Check if any of these exist: `Documentation/`, `docs/`, `reports/`. Use the first match. If none exist, create `Documentation/`. The user can also specify a custom output directory.

Create `<output-dir>/weekly-report-YYYY-MM-DD.md` with these sections:

1. **Header** — Window, branch, scope
2. **Executive Summary** — 2-3 sentence overview
3. **Key Metrics** — Commits, contributors, files changed, insertions, deletions
4. **Daily Activity** — Table with date and count
5. **Commit Type Breakdown** — Table with conventional type and count
6. **Top Workstreams** — Table with ticket prefix and count
7. **Most Touched Areas** — Table with top-level directory and file touch count
8. **Changes by Area** — Grouped by workstream with descriptive bullets per sub-theme
9. **Highlights** — 4-6 key takeaways as bold-label bullet points
10. **Analysis** — Numbered observations with supporting data
11. **Contributor Activity** — Table
12. **Full Commit Log** — All commits with SHA, date, author, subject

### 5. Generate the HTML Report

Create `<output-dir>/weekly-report-YYYY-MM-DD.html` as a self-contained single-page report:

**Layout structure:**
- **Header** — Dark gradient (`#1a1a2e` → `#16213e`) with title, subtitle (date range, week number, branch badge), and stats-bar (commits, contributors, insertions in green, deletions in red)
- **Grid row 1** — Daily Activity card (table with bar charts) + Commit Types card (badge rows with counts)
- **Full-width** — Top Contributors table with bar charts
- **Full-width** — Changes by Area card with area-sections (header with title + count badge pill, descriptive bullet list)
- **Full-width** — Highlights card with highlight-grid (accent-border cards)
- **Footer** — Branch name, project name, generation date

**Key CSS classes:**
- `.header`, `.stats-bar`, `.stat`, `.stat-value`, `.stat-label`
- `.container`, `.grid`, `.card`, `.card.full`
- `.bar-container`, `.bar`, `.bar-label` (for horizontal bar charts)
- `.badge-feat`, `.badge-fix`, `.badge-chore`, `.badge-bot`, `.badge-test` (colored pills)
- `.type-row`, `.type-count`
- `.area-section`, `.area-header`, `.area-title`, `.area-count`, `.area-items`
- `.highlight-grid`, `.highlight-item`
- `.diff-plus` (green), `.diff-minus` (red)

**Color scheme:**
- Header gradient: `#1a1a2e` → `#16213e`
- Primary accent: `#4361ee`
- Bar charts: `#4361ee` (primary), `#94a3b8` (secondary)
- Badges: feat `#3b82f6`, fix `#ef4444`, chore `#8b5cf6`, test `#10b981`, bot `#94a3b8`
- Diff: insertions `#22c55e`, deletions `#ef4444`

**Bar width calculation:**
- Daily activity: `(day_count / max_day_count) * 100`%
- Contributors: `(author_count / max_author_count) * 100`%

### 6. Verify Output

- Confirm both files exist in the output directory
- Open the HTML in a browser to verify layout renders correctly
- Ensure all commit counts in area breakdowns sum to the total
- Check that bar chart percentages are relative to their section's maximum

## Decision Points

| Situation | Action |
|-----------|--------|
| Partial week (mid-week generation) | Use actual date range in title, note "mid-week" in subtitle |
| Very few commits (< 5) | Skip bar charts, simplify to a single summary card |
| No ticket keys in commits | Skip workstream section, group by top-level directory instead |
| Single dominant contributor (> 50%) | Note in highlights as a concentration risk |
| Weekend commits present | Include in daily table but flag in analysis |

## Quality Criteria

- All metrics are internally consistent (area commit counts sum to total)
- HTML passes basic visual check — no broken layout or missing sections
- Markdown renders cleanly on GitHub
- No PII beyond author names already in git history
- Descriptive bullets add context beyond raw commit messages
