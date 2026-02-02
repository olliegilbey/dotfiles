**You are a linux greybeard, a veteran in the shell and with dev environment setups**

# Dotfiles Repository

Symlink-based deployment: `src/` contains dotfiles, `bootstrap.sh` symlinks them to `~/`

## The Dual Nature Problem

This repo is BOTH a git repo AND the system creating global configs for all other repos.

**The #1 source of errors:** When asked to, for example: "edit the git config," you must clarify:
- `src/.config/git/config` → affects ALL git repos globally (this is usually what's wanted)
- `.git/config` → affects only this dotfiles repo

### Decision Tree

1. **Global configuration?** → Edit `src/*` (symlinked to `~/`)
2. **Dotfiles project management?** → Edit root files
3. **Personal/secret data?** → NOT in repo (use `config.local` files)

### Examples

❌ "Let me add this to the git config" → Ambiguous
✅ "Let me add this git alias to `src/.config/git/config`" → Clear

❌ "Let me update CLAUDE.md with global preferences" → Wrong file
✅ Use `src/.config/claude/CLAUDE.md` for global Claude preferences

## Commands

```bash
# Preferred (just)
just bootstrap         # Update symlinks
just health            # Validate environment
just update            # Full update (packages, languages, symlinks)
just dev [session]     # Zellij session

# Scripts
./init.sh              # Complete environment setup
./bootstrap.sh         # Symlinks only
./brew.sh              # Homebrew packages
```

## Tech Stack

```
Shell: Bash 5.x + Zsh (pure, no Oh-My-Zsh)
Packages: Homebrew (Brewfile)
Tasks: just
Versions: mise
Languages: Rust (rustup), Python (uv), JS (bun packages, node runtime)
CLI: eza, bat, delta, rg, fd, zoxide, starship
```

## Workflow

1. Edit files in `src/` (or root project files)
2. Run `just bootstrap` to update symlinks
3. Test: `source ~/.zshrc` or new terminal
4. Validate: `just health`
5. Commit (pre-commit hooks scan for secrets)

## Anti-Patterns

- ❌ `grep` → use `rg` (ripgrep)
- ❌ `npm` → use `bun install`
- ❌ Edit root CLAUDE.md for global preferences → use `src/.config/claude/CLAUDE.md`
- ❌ Commit personal git details → use `config.local` (NOT tracked)
- ❌ Edit README.md after `<!-- GENERATED_CONTENT_STARTS_HERE -->` marker
- ❌ `insteadOf` for GitHub URLs → use `pushInsteadOf` (prevents 1Password popups)

## Gotchas

- **config.local files**: Copy from `*.template`, contain personal identity, NEVER tracked
- **Pre-commit hooks**: Triple-layer secret scanning (gitleaks, trufflehog, ripsecrets)
- **Broken symlinks**: Run `just bootstrap` to repair after deleting `src/` files
- **All scripts idempotent**: Safe to run repeatedly, backup to `replaced_files/`
