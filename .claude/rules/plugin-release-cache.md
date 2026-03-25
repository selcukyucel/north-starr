---
description: Post-release checklist — Claude Code plugin cache invalidation
paths:
  - ".github/workflows/release.yml"
  - ".claude-plugin/**"
  - "bin/north-starr"
---

# Plugin Release Cache Invalidation

After every release (tag push + CI workflow), the local Claude Code plugin
marketplace cache does NOT auto-update. Users (including us) will still see
the old version until the cache is refreshed.

## Post-release steps (run locally after CI completes)

```bash
# 1. Pull the CI-generated version-bump commit
git pull origin main

# 2. Refresh the marketplace cache so `/plugin install` sees the new version
cd ~/.claude/plugins/marketplaces/north-starr && git fetch origin && git reset --hard origin/main && cd -

# 3. Clear the stale plugin install cache
rm -rf ~/.claude/plugins/cache/north-starr

# 4. In any consuming project, re-run:  /plugin install north-starr
```

## Why this matters

Claude Code's plugin resolver caches a shallow clone of the marketplace repo
at `~/.claude/plugins/marketplaces/<name>/` and the installed plugin at
`~/.claude/plugins/cache/<name>/<version>/`. Both are keyed by git commit
SHA. Pushing a new tag + CI commit to `main` does NOT invalidate these
caches. Without the steps above, `/plugin install` silently keeps the old
version.
