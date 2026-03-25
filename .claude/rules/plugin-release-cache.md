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

## Automated fix

Run the CLI command:

```bash
git pull origin main && north-starr cache-update
```

This fetches the latest marketplace commit, resets the local clone, and
clears the install cache. Then restart Claude Code (or `/plugin install
north-starr`) and run `/sync` in consuming projects.

`/sync` also detects staleness automatically — if the plugin cache is behind
`origin/main`, it warns and stops before syncing stale templates.

## Manual fallback

If `north-starr cache-update` isn't available (older CLI version):

```bash
git pull origin main
cd ~/.claude/plugins/marketplaces/north-starr && git fetch origin && git reset --hard origin/main && cd -
rm -rf ~/.claude/plugins/cache/north-starr
# then /plugin install north-starr + /sync
```

## Why this matters

Claude Code's plugin resolver caches a shallow clone of the marketplace repo
at `~/.claude/plugins/marketplaces/<name>/` and the installed plugin at
`~/.claude/plugins/cache/<name>/<version>/`. Both are keyed by git commit
SHA. Pushing a new tag + CI commit to `main` does NOT invalidate these
caches. Without the steps above, `/plugin install` silently keeps the old
version.
