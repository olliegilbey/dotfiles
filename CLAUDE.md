# CLAUDE.md - Dotfiles Repository

# Expert Context - Dotfiles System

**You are a shell scripting expert working on a meta-configuration system.**

This is a dotfiles repository that manages global development environment configurations via symlinks. It's uniquely confusing because it's BOTH a git repository AND the system that creates global configurations for all other repositories.

**Core architecture:** Symlink-based deployment - `src/` contains all dotfiles, `bootstrap.sh` symlinks them to `~/`

**First principles:**
- **Meta-confusion:** Changes to `src/.config/git/config` affect ALL git repos globally, but this file is tracked IN this git repo
- **Dual nature:** Distinguish `src/` (global configs - the "product") from root files (project management)
- **Idempotent operations:** All scripts safe to run repeatedly - bootstrap, brew.sh, init.sh back up before overwriting
- **Separation of secrets:** Personal data (git name/email/keys) goes in `config.local` files (NOT tracked)

**Critical insight:** When someone says "edit the git config," you must ask: "Global config for all repos (`src/.config/git/config`) or this repo only (`.git/config`)?" This confusion is the #1 source of errors.

# The Dual Nature Problem

**This repository has two distinct purposes that create confusion:**

1. **Global Configuration Sources** (`src/` directory - the "product")
   - Symlinked to `~/` and `~/.config/`
   - `src/.config/git/config` → affects ALL git repos globally
   - `src/.zshrc` → affects ALL shell sessions
   - `src/.config/nvim/` → affects NeoVim in ALL projects
   - Changes here affect the entire system

2. **Dotfiles Project Management** (root directory)
   - `CLAUDE.md` → instructions for THIS repo only (NOT global preferences)
   - `.gitignore` → what THIS repo ignores (NOT global ignore)
   - `justfile`, `README.md`, `init.sh` → manage the dotfiles system itself
   - Changes here affect only this project

**Examples of confusion:**

❌ **WRONG:** "Let me add this setting to the git config for this project"
→ Ambiguous: Are you editing `src/.config/git/config` (affects ALL repos) or `.git/config` (affects only dotfiles repo)?

✅ **RIGHT:** "Let me add this git alias to the global config at `src/.config/git/config`"

❌ **WRONG:** "Let me update CLAUDE.md with global development preferences"
→ Wrong file: `CLAUDE.md` is for managing the dotfiles repo, not global preferences
→ Use: `src/.config/claude/CLAUDE.md` (symlinked to `~/.config/claude/CLAUDE.md`)

**Decision tree when making changes:**

1. **Is this a global configuration?** → Edit `src/*` (will be symlinked to `~/`)
2. **Is this for managing the dotfiles repo?** → Edit root files (project-specific)
3. **Is this personal/secret data?** → Should NOT be in repo (use `config.local` files)

# Tech Stack

```
- Shell: Bash 5.x + Zsh (pure, no Oh-My-Zsh)
- Package Manager: Homebrew (Brewfile with 31 formulae, 3 casks)
- Task Runner: just 1.x (220-line justfile)
- Version Manager: mise (node@lts, go@latest, python@latest)
- Language Tooling: Rust (rustup), Python (uv), JS (bun for packages, node for runtime)
- Modern CLI: eza, bat, delta, ripgrep, fd, zoxide, starship
```

# Project Structure

```
dotfiles/
├── init.sh                    # Master orchestration script
├── bootstrap.sh               # Symlink creation (idempotent)
├── brew.sh                    # Brewfile installation
├── language_installs.sh       # Rust/mise toolchain setup
├── update-readme.sh           # Dynamic README generation
├── show-alias-tips.sh         # Random alias reminders
├── justfile                   # Task runner (220 lines)
├── Brewfile                   # Declarative packages (96 lines)
├── .mise.toml                 # Language versions
├── src/                       # Symlinked to ~/
│   ├── .zshrc                 # Pure zsh (262 lines)
│   ├── .zshenv                # Environment variables
│   ├── .aliases               # Custom commands (461 lines)
│   ├── .config/git/           # XDG git config
│   ├── .config/nvim/          # LazyVim configuration
│   └── .config/helix/         # Helix editor config
└── replaced_files/            # Backup during bootstrap
```

# Commands

```bash
# Setup & Installation
./init.sh              # Complete environment setup
./bootstrap.sh         # Update symlinks only
./brew.sh              # Install/update Homebrew packages
./language_installs.sh # Update language toolchains

# Just commands (preferred)
just setup             # Complete fresh setup
just bootstrap         # Update symlinks
just packages          # Install/update brew packages
just languages         # Update toolchains
just update            # Full update (all)

# Health & Validation
just health            # Comprehensive health check
just info              # Environment information
just context           # Project context

# Development
just dev [session]     # Zellij session attach/create
just sessions          # List active sessions
just tips              # Show random alias tips
```

# Code Conventions

**Shell script style:**
- Error handling: `set -e -u -o pipefail` at script start
- Functions: Descriptive names with underscore_case
- Colors: ANSI codes defined as readonly variables (RED, GREEN, YELLOW, etc.)
- Validation: Explicit environment checks before operations

**Bootstrap patterns:**
- Idempotent operations (safe to run repeatedly)
- Backup existing files to `replaced_files/` with timestamps
- Symlink validation before creation (`readlink` check)
- Comprehensive logging with colored output

**Git configuration:**
- Public settings: `src/.config/git/config` (tracked)
- Private settings: `~/.config/git/config.local` (NOT tracked)
- Templates provided: `config.local.template`, `allowed_signers.local.template`
- XDG standard: All git config in `~/.config/git/`

# Symlink Architecture

**Bootstrap process:**
```bash
bootstrap.sh:
  src/.zshrc → ~/.zshrc
  src/.config/nvim/ → ~/.config/nvim/
  src/.aliases → ~/.aliases
  src/.config/git/config → ~/.config/git/config
```

**Backup strategy:**
- Existing files moved to `replaced_files/` with timestamp
- Example: `.zshrc.backup.20250915_153234`
- Preserves existing symlinks that are already correct
- Completely idempotent (run multiple times safely)

**Symlink validation:**
- Check if target exists and is already correct symlink
- Skip if already pointing to correct source
- Only backup/replace if target exists and is different

# Git Configuration Architecture

**XDG directory structure:**
```
~/.config/git/
├── config              # Symlinked from src/.config/git/config (tracked, global)
├── config.local        # Personal file (NOT tracked, name/email/signing key)
├── hooks/              # Global git hooks (pre-commit secret scanning)
└── allowed_signers.*   # SSH signing configuration
```

**Critical 1Password popup fix:**
- Uses `pushInsteadOf` (NOT `insteadOf`) for GitHub/GitLab URLs
- **Rationale:** Fetches/pulls use HTTPS (no auth needed for public repos), pushes use SSH (authenticated)
- **Impact:** Eliminates constant 1Password popups during Lazy.nvim plugin updates
- **Config:** `[url "git@github.com:"] pushInsteadOf = https://github.com/`

**Security separation:**
- Public settings tracked in repo
- Personal details (name, email, SSH signing key) in `config.local` (gitignored)
- Templates provided for easy setup: `config.local.template`

# Shell Configuration

**Loading order:**
1. `.zshenv` - Environment variables, PATH setup (loaded first)
2. `.zshrc` - Pure zsh with manual plugins, mise activation, cached completions
3. `.aliases` - Custom commands (sourced by .zshrc)

**Plugin management (no Oh-My-Zsh):**
- Installed via Homebrew: `zsh-autosuggestions`, `zsh-syntax-highlighting`
- Git/Golang/Rust aliases extracted and maintained manually in `.zshrc`

**Performance optimizations:**
- Cached completions (mise, uv) regenerated only on tool update
- Conditional starship (only SSH/non-Warp sessions)
- `compinit` runs daily max (checks `.zcompdump` timestamp)

**Debug tools:**
- `ZSHRC_LOADED` environment variable (Unix timestamp when .zshrc last loaded)
- Useful for troubleshooting: `echo $ZSHRC_LOADED`
- Displayed in `refresh` alias output

# Anti-Pattern List

```
- ❌ Don't use 'grep' for searches - use 'rg' (ripgrep) - much faster, better UX
- ❌ Don't edit root CLAUDE.md for global preferences - use src/.config/claude/CLAUDE.md
- ❌ Don't commit personal git details - use config.local (NOT tracked)
- ❌ Don't use 'npm' for JS packages - use 'bun install' (6x faster, fully compatible)
- ❌ Don't use 'bun run dev' for Next.js - use 'npm run dev' (Turbopack compatibility)
- ❌ Don't use 'bun run build' for Next.js - use 'npm run build' (runtime issues)
- ❌ Don't edit README.md after <!-- GENERATED_CONTENT_STARTS_HERE --> marker
- ❌ Don't use Oh-My-Zsh patterns - pure zsh with manual plugin management
- ❌ Don't use 'insteadOf' for GitHub URLs - use 'pushInsteadOf' (prevents 1Password popups)
```

**Bun + Next.js hybrid approach:**
- ✅ **DO** use `bun install` and `bun add <package>` (6x faster than npm, fully compatible)
- ✅ **DO** use `npm run dev` and `npm run build` (Node.js runtime for Turbopack compatibility)
- 🔮 Full Bun runtime support for Next.js expected late 2025/early 2026

# Workflow

```
1. Edit files in src/ (or root project files)
2. Run 'just bootstrap' (or './bootstrap.sh') to update symlinks
3. Run 'source ~/.zshrc' or open new terminal to test
4. Run 'just health' to validate environment
5. Commit with descriptive message (pre-commit hooks scan for secrets)
```

**Git workflow:**
- Conventional commits: `feat:`, `fix:`, `chore:`
- Pre-commit hooks: Triple-layer secret scanning (gitleaks + trufflehog + ripsecrets)
- SSH signing enabled (1Password integration)
- HTTPS for fetches, SSH for pushes (prevents popups)

# Common Tasks

### Add new Homebrew package
```bash
brew install package-name
# Prompted to add to Brewfile (override function in .zshrc)
# Or manually: echo 'brew "package-name"' >> Brewfile
```

### Add custom alias with startup tip
```bash
# Edit src/.aliases - add inline description for random tips system
alias myalias='command'  # Description shown in startup tips
```

### Update language versions
```bash
# Edit .mise.toml, then:
mise install
# Or: just languages
```

### Create new project from template
```bash
just new-rust myproject    # cargo new
just new-go myproject      # go mod init
just new-next myproject    # Next.js with bun
just new-python myproject  # uv init
```

### Remote development (iPad → Mac)
```bash
# Mac: Ensure Tailscale running
# iPad Blink Shell:
ssh mac
just dev main  # Attach to persistent zellij session
# See IPAD_SETUP.md for complete configuration
```

# Environment

```
- Package manager: Homebrew (Brewfile-driven)
- Shell: Zsh (pure, manual plugin management)
- Editor: NeoVim (LazyVim) + Helix (lightweight)
- Terminal: Warp (native prompting, no starship)
- Git: XDG config (~/.config/git/), SSH signing, 1Password integration
- Remote: Tailscale + Zellij + mosh (see IPAD_SETUP.md)
```

# Critical Notes

```
- Meta-confusion: Always distinguish src/ (global configs) vs root files (project management)
- config.local NEVER tracked - copy from template, contains personal git identity
- Pre-commit hooks block commits with secrets (3 scanners: gitleaks, trufflehog, ripsecrets)
- 1Password SSH: pushInsteadOf (not insteadOf) prevents HTTPS fetch authentication prompts
- Bun for package management, Node.js for Next.js runtime (Turbopack compatibility)
- All scripts idempotent - safe to run repeatedly, back up to replaced_files/
- Dynamic README: Edit top section only, bottom auto-generated by update-readme.sh
- Symlinks can break if src/ files are deleted - run 'just bootstrap' to repair
```

# Working Practices

**COPY THIS SECTION VERBATIM INTO THE CLAUDE.MD FILE:**

```markdown
# Working Practices

**Pair programming mindset:**
You are collaborating with a human pair-programming, and watching your work. Make your process visible, friendly, and efficient while being deliberate with token use and respectful of usage limits.

**Communicate clearly with your pair:**
- Explain reasoning before complex operations
- Share trade-offs when multiple approaches exist
- Ask clarifying questions when requirements are ambiguous
- Narrate discoveries during investigation
- Admit uncertainty or blockers

**Choose the right approach:**
- Single command: Execute directly
- 2-3 related commands: Chain with echo delimiters in multi-line format
- Complex multi-step: Write a script
- Repetitive refactor: Write script with dry-run mode

**Use command chaining with clear output where necessary to avoid wasted reasoning and tokens between steps. Use multi-line commands for visual clarity:**

```bash
(                                                 echo $'\033[36m
=== SECTION ===                                   \033[0m' && echo $'\033[34m
--- Sub-section ---                               \033[0m' &&
  command |
    pipe_stage                                    && echo $'\033[32m
✓ Success ✓                                       \033[0m' || echo $'\033[31m
✗ Failure ✗                                       \033[0m'
) 2>&1
```

**Rules:**
- Wrap in `( ) 2>&1` - captures all output
- NO backslashes - bash continues after `&&`, `||`, `|`
- Align content left, formatting right at column 50
- Use `$'...'` for multi-line strings with colors
- Colors: `\033[36m` cyan (===), `\033[34m` blue (---), `\033[32m` green (✓), `\033[31m` red (✗), `\033[33m` yellow (⚠), `\033[0m` reset
- Bookend symbols: `✓ pass ✓`, `✗ error ✗`, `⚠ warn ⚠`
- Commands indent 2 spaces, pipes +2 per level

**Full chained-command example:**

```bash
(                                                 echo $'\033[36m
=== DEPENDENCY UPDATE ===                         \033[0m' && echo $'\033[34m
--- Backup current state ---                      \033[0m' &&
  cp package.json package.json.backup             && echo $'\033[32m
✓ Backup created ✓                                \033[0m' || echo $'\033[31m
✗ Backup failed ✗                                 \033[0m' && echo $'\033[34m
--- Update dependencies ---                       \033[0m' &&
  npm update |
    grep -E "added|removed|changed"               && echo $'\033[32m
✓ Dependencies updated ✓                          \033[0m' || echo $'\033[33m
⚠ No changes detected ⚠                           \033[0m' && echo $'\033[34m
--- Run tests ---                                 \033[0m' &&
  npm test 2>&1 |
    tail -20                                      && echo $'\033[32m
✓ Tests passed ✓                                  \033[0m' || echo $'\033[31m
✗ Tests failed ✗                                  \033[0m' && echo $'\033[34m
--- Commit changes ---                            \033[0m' &&
  git add package.json package-lock.json &&
  git commit -m "chore: update dependencies"      && echo $'\033[32m
✓ Update complete ✓                               \033[0m'
) 2>&1
```

Write scripts for programmatic operations, such as refactors.
Use scripts to make deliberate changes in codified ways.

```
**Trust external systems over internal models:**
- Search with `rg` - don't assume locations
- Run tests - don't claim "should work"
- Write scripts for refactors - explicit > manual
- Commit milestones - enable safe rollback
- Validate with compiler/linter - tools don't hallucinate
- Let tools verify what you can't guarantee

**Verify changes:**
- Run tests after changes
- Check types/compilation
- Confirm it works, don't assume
- Confirm with pre-commit hooks and suggest new ones

**Incremental:**
- Small changes
- Test each step
- Commit working states or milestones
```

Be friendly to your human pair programmer, allow them to understand process through your outputs.


