# Release Process

Tagging a new version triggers the release workflow automatically and keeps all three distributions in sync.

## How to release

```bash
git tag v4.6.0
git push origin v4.6.0
```

That's it. The GitHub Actions workflow handles the rest.

## What the workflow does

| Distribution | What happens | User impact |
|---|---|---|
| **Homebrew** | Updates `Formula/north-starr.rb` URL + SHA256 | Users get it on `brew upgrade north-starr` |
| **Claude Code** | Updates `.claude-plugin/marketplace.json` version | Plugin marketplace shows new version |
| **VS Code** | Bumps `package.json` version, runs `vsce package` + `vsce publish` | Extension auto-updates for all installed users |
| **GitHub Release** | Creates release notes + attaches `.vsix` as downloadable artifact | Manual install fallback via `.vsix` |

## Files updated per release

- `Formula/north-starr.rb` — URL and SHA256 hash
- `bin/north-starr` — `VERSION` string
- `.claude-plugin/marketplace.json` — `version` field
- `package.json` — `version` field

All version bumps are committed back to `main` by the bot before publishing.

## One-time setup: VSCE_PAT secret

The VS Code publish step requires a Personal Access Token stored as a GitHub Actions secret.

1. Create a publisher at [marketplace.visualstudio.com/manage](https://marketplace.visualstudio.com/manage) — publisher name must match `"publisher"` in `package.json` (`selcukyucel`)
2. Go to [dev.azure.com](https://dev.azure.com) → User Settings → Personal Access Tokens
3. Create a token with scope **Marketplace → Publish**
4. Add it to the GitHub repo: Settings → Secrets and variables → Actions → New secret → name: `VSCE_PAT`

## Local testing before release

Before tagging, test the extension locally to verify skills load correctly in Copilot.

### 1. Install vsce (first time only)

```bash
npm install -g @vscode/vsce
```

### 2. Build the .vsix

```bash
cd north-starr
vsce package
# Output: north-starr-<version>.vsix
```

### 3. Install it in VS Code

```bash
code --install-extension north-starr-<version>.vsix
```

Or via the UI: Extensions panel → `...` menu → **Install from VSIX** → select the file.

### 4. Reload VS Code

```
Cmd+Shift+P → Developer: Reload Window
```

### 5. Verify skills appear

Open Copilot chat, type `/` — you should see all 10 north-starr skills in the autocomplete list:

- `/invert`, `/decompose`, `/learn`, `/bootstrap`
- `/generate-commit`, `/generate-pr`, `/analyze-code`
- `/report-weekly`, `/sync`, `/autoimprove`

### 6. Test a skill end-to-end

```
/invert add user authentication to the API
```

Verify the response follows the inversion analysis format from the skill.

### Cleanup

The `.vsix` file is git-ignored — no need to delete it manually. It gets regenerated on each `vsce package`.

---

## Skills source of truth

All three distributions share the same `skills/` directory. There is no copying or syncing — updating a `SKILL.md` file and tagging a release is sufficient to ship it everywhere.

```
north-starr/
├── skills/               ← single source for all distributions
│   ├── invert/SKILL.md
│   └── ... (10 skills)
├── package.json          ← VS Code extension manifest
├── bin/north-starr       ← Homebrew CLI
├── .claude-plugin/       ← Claude Code plugin
└── Formula/              ← Homebrew formula
```
