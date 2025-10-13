# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## ⚠️ CRITICAL: Meta-Configuration Awareness

**This repository is uniquely confusing because it manages GLOBAL configurations while also being a git repository itself.**

### The Dual Nature Problem

When working in this dotfiles repo, you must distinguish between:

1. **Global Configuration Sources** (`src/` directory)
   - Files here are symlinked to `~/.config/`, `~/`, etc.
   - Changes to `src/.config/git/config` affect ALL git repos globally
   - Changes to `src/.zshrc` affect ALL shell sessions
   - Changes to `src/.config/nvim/` affect NeoVim in ALL projects
   - **These are the "products" this repo builds**

2. **Dotfiles Project Management** (root directory files)
   - `CLAUDE.md` - Instructions for working on THIS dotfiles repo (NOT global)
   - `.gitignore` - What THIS dotfiles repo ignores (NOT global git ignore)
   - `justfile` - Commands for managing THIS dotfiles repo
   - `README.md`, `init.sh`, `bootstrap.sh` - Setup/maintenance of the dotfiles system
   - **These manage the dotfiles repository itself**

### Examples of Confusion

**WRONG:** "Let me add this setting to the git config for this project"
- Are you editing `src/.config/git/config` (affects all repos) or `.git/config` (affects only dotfiles repo)?

**RIGHT:** "Let me add this git alias to the global config at `src/.config/git/config`"

**WRONG:** "Let me update the CLAUDE.md with global development preferences"
- `CLAUDE.md` is for managing the dotfiles repo, not global preferences
- Global preferences go in `src/.config/claude/CLAUDE.md` (symlinked to `~/.config/claude/CLAUDE.md`)

### When Making Changes, Ask:

1. **Is this a global configuration?** → Edit `src/*` (will be symlinked)
2. **Is this for managing the dotfiles repo?** → Edit root files (project-specific)
3. **Is this personal/secret?** → Should NOT be in the repo (e.g., `config.local` files)

### Git Configuration Special Case

`src/.config/git/config` is particularly tricky because:
- It defines git behavior GLOBALLY for all repos
- But it's also tracked IN this git repo
- Changes to it affect how THIS repo behaves AND how all other repos behave
- Personal details (name, email, signing key) go in `config.local` (NOT tracked)

## Architecture Overview

This is a modern macOS/Linux dotfiles repository with automated setup and bleeding-edge tool integration. The architecture follows a symlink-based approach where all configuration files in `src/` are automatically linked to the home directory.

### Key Components

- **`init.sh`** - Master setup script that orchestrates the entire environment installation
- **`bootstrap.sh`** - Creates symlinks from `src/` to home directory (robust error handling, validation, idempotent)
- **`brew.sh`** - Uses Brewfile for declarative package management via `brew bundle` (31 packages, casks, taps)
- **`language_installs.sh`** - Sets up programming language toolchains (Rust via rustup, others via mise)
- **`Brewfile`** - Declarative package management with cross-platform conditionals
- **`.mise.toml`** - Project-specific language versions (Node.js, Go, Python)
- **`update-readme.sh`** - Dynamic README generation from current environment
- **`show-alias-tips.sh`** - Random alias reminders on terminal startup (reads inline descriptions from .aliases)
- **`config.local.template`** - Secure git identity template (keeps personal details private)
- **`src/`** - Contains all dotfiles that get symlinked to home directory

### Symlink Strategy

The bootstrap system automatically:
1. Backs up existing dotfiles to `trash/` directory
2. Creates symlinks from `~/dotfiles/src/*` to `~/*`
3. Preserves existing symlinks that are already correct
4. Is completely idempotent and safe to run repeatedly

## Common Development Commands

### Environment Setup/Update
```bash
# Complete fresh setup (new machine)
./init.sh

# Update dotfiles symlinks only
./bootstrap.sh

# Update Homebrew packages from Brewfile
./brew.sh

# Update language toolchains only
./language_installs.sh

# Show random alias tips (reads inline descriptions from .aliases)
./show-alias-tips.sh

# Regenerate README from current environment
./update-readme.sh
```

### Development Workflow
```bash
# Apply changes after editing dotfiles
./bootstrap.sh && source ~/.zshrc

# Check environment health
dotfiles-health

# View random alias tips
./show-alias-tips.sh

# Test symlink status
ls -la ~ | grep dotfiles

# Add new packages (automatically tracked in Brewfile)
brew install package-name
```

## Tool Stack - Bleeding Edge

### Modern Command-Line Tools (Rust-based)
- **eza** - Modern ls replacement with icons, git status, and better defaults
- **bat** - Enhanced cat with syntax highlighting and git integration
- **delta** - Enhanced git diff viewer with syntax highlighting
- **ripgrep (rg)** - Recursive line-oriented search tool (extremely fast)
- **fd** - Fast file finder alternative to find
- **zoxide** - Smart cd replacement with frecency algorithm
- **fzf** - Fuzzy finder for command-line productivity
- **just** - Command runner for project tasks (better UX than Make)
- **helix** - Modern modal editor written in Rust (lightweight alternative to NeoVim)
- **hyperfine** - Command-line benchmarking tool
- **starship** - Fast, customizable cross-shell prompt (conditional loading)

### Package Management
- **Homebrew** - System packages and CLI tools
- **mise** - Universal version manager (replaces nvm, fnm, rbenv, pyenv, etc.)
- **uv** - Modern Python package/project manager (replaces pip/pipenv/poetry)
- **ruff** - Extremely fast Python linter and formatter (replaces black/flake8/isort)
- **Cargo** - Rust package manager and build system

### Editors & Development Environment
- **NeoVim** - Primary editor with LazyVim distribution (completely rebuilt configuration)
- **Helix** - Lightweight Rust-based modal editor (quick edits, selection-first workflow)
- **Warp** - AI-enhanced terminal with native prompting
- **Starship** - Cross-shell prompt (conditionally loaded for SSH/non-Warp sessions)
- **Zellij** - Modern terminal multiplexer for persistent remote sessions
- **lazygit** - Terminal UI for Git operations

### Language Toolchains
- **Rust** - Primary language with rust-analyzer LSP (managed via rustup)
- **Go** - Systems programming with full toolchain (managed via mise)
- **Node.js** - Web development via mise (latest LTS), runtime for Next.js projects
- **Python** - Data/ML development via uv package manager (managed via mise), formatted with ruff
- **Bun** - Modern JavaScript package manager (used for dependency management in Next.js, not runtime due to Turbopack compatibility)

## Recent Major Changes (October 2024)

### Git Configuration Consolidation
- **Migrated to XDG Base Directory Specification**: All git config now in `~/.config/git/` (not `~/.gitconfig`)
- **Merged configurations**: Combined legacy `.gitconfig` and XDG `config` into single comprehensive file
- **Fixed 1Password popup issues**: Changed `insteadOf` to `pushInsteadOf` for GitHub/GitLab URLs
  - Fetches/pulls now use HTTPS (no authentication needed for public repos)
  - Pushes still use SSH (secure, authenticated)
  - Eliminates constant 1Password popups during Lazy.nvim plugin updates
- **Separated personal data**: Only name/email/signing key in `config.local` (not tracked)

### File Structure
```
~/.config/git/
├── config              → symlink to ~/dotfiles/src/.config/git/config (tracked, global settings)
├── config.local        → personal file (NOT tracked, user-specific)
├── hooks/              → global git hooks (pre-commit secret scanning)
└── allowed_signers.*   → SSH signing configuration
```

## Configuration Architecture

### Shell Configuration Layers
1. **`.zshenv`** - Environment variables and PATH setup (loaded first)
2. **`.zshrc`** - Pure zsh configuration with manual plugin management, mise activation, completions
3. **`.aliases`** - Extensive custom commands with inline descriptions (200+ lines, 70+ aliases)

**Note**: Oh-My-Zsh has been removed. Pure zsh now uses manual plugin management via Homebrew:
- `zsh-autosuggestions` - Fish-like suggestions from history
- `zsh-syntax-highlighting` - Real-time command syntax validation
- Git, Golang, and Rust aliases extracted and maintained manually

### Debug and Development Tools
- **`ZSHRC_LOADED`** - Environment variable set to Unix timestamp when `.zshrc` loads
  - Used for debugging shell configuration loading issues
  - Displayed in `refresh` alias output for verification
  - Example: `echo $ZSHRC_LOADED` shows when shell was last configured

### NeoVim Configuration (LazyVim-based)
- **Plugin Management**: lazy.nvim with modular plugin architecture
- **LSP Setup**: Comprehensive language server configuration with optimized startup performance
- **UI Enhancement**: Kanagawa theme with transparent background and narrow gutter
- **File Navigation**: Snacks explorer (30-char width), telescope, which-key integration
- **Git Integration**: Built-in git support with LazyVim
- **Todo Integration**: todo.txt plugin with buffer-local keybindings
- **Performance**: Deferred tool installation to prevent startup delays

### Key Environment Variables
- `EDITOR="nvim"` - Default editor for all tools
- `GOPATH="$HOME/go"` - Go workspace
- `UV_PYTHON_PREFERENCE=only-managed` - Python version management via uv
- `HISTSIZE=50000, SAVEHIST=50000` - Large history with cross-session sharing

### Helix Configuration
- **Theme**: Kanagawa with transparent background (matching NeoVim aesthetic)
- **File Picker**: `space + e` for file exploration (no persistent sidebar)
- **Keybindings**: NeoVim-inspired (`jk` for normal mode, `Ctrl-s` to save)
- **Philosophy**: Selection-first editing (select → action vs NeoVim's action → motion)
- **Use Case**: Quick edits over SSH, lightweight alternative when NeoVim feels heavy

### Command Aliases & AI Agent Notes
- **AI agents should prefer `rg` (ripgrep) over `grep`**: Much faster and more user-friendly
  - Use `rg` syntax: `rg pattern` searches all files in current directory recursively
  - No `-r` flag needed: `rg pattern` is equivalent to `grep -r pattern`
  - No `-E` flag needed: `rg 'pattern1|pattern2'` instead of `grep -E '(pattern1|pattern2)'`
  - Both `grep` and `rg` are available with their native behaviors (no aliases)
  - **Installation scripts**: Use POSIX `grep` during bootstrap since `rg` isn't installed yet
  - **Interactive/AI usage**: Prefer `rg` for better performance and output formatting
- **Python development shortcuts**: 
  - `uvr` alias for `uv run python` (frequently used for Python script execution)
  - Python managed via uv for package/project management

### AI Context Helper Function
- **`ai-context`**: New function for onboarding Claude Code instances
  - Provides environment overview and critical notes (including rg preference for AI agents)
  - Gives explicit instructions to read both local and global CLAUDE.md files
  - Suggests `claude init` if no local CLAUDE.md exists
  - Recommends validation commands (dotfiles-health, env-info, proj-context)
  - Usage: Run `ai-context` command and follow all provided instructions


### Alias Tips System
- **Inline Documentation**: Alias descriptions stored as comments in .aliases file
- **Random Startup Tips**: Shows 2 random aliases + just commands on terminal startup via show-alias-tips.sh
- **Just Integration**: Automatically extracts recipes from justfile with their descriptions
- **Centralized Storage**: All aliases are stored in .aliases file for consistent sourcing
- **Maintenance**: Non-obvious aliases should have descriptions added inline for better discoverability
- **Health Checking**: `dotfiles-health` command validates entire environment

## AI Development Integration

### Claude Code Integration
- **Alias**: `claude` points to `$HOME/.claude/local/claude`
- **Project Config**: This `CLAUDE.md` provides repository-specific guidance
- **Global Config**: `src/.config/claude/CLAUDE.md` contains personal development philosophy (symlinked to `~/.config/claude/CLAUDE.md`)
- **Settings**: `.claude/settings.local.json` manages permissions and MCP servers
- **Git Security**: Personal details separated via `config.local` template system

### Warp Terminal Integration
- **Native Prompting**: Starship conditionally loaded (only for SSH/non-Warp sessions)
- **AI Command Suggestions**: Warp provides context-aware command suggestions
- **Performance Optimization**: Pure zsh with manual plugins for faster startup
- **Alias Tips**: Random startup reminders complement Warp's native features

## Remote Development Infrastructure

### iPad → Mac Remote Development
- **Tailscale**: Zero-config mesh VPN for secure remote access (works over cellular)
- **SSH**: Key-based authentication with 1Password integration
- **Mosh**: Mobile shell for unreliable connections (use when cellular is unstable)
- **Zellij**: Persistent terminal sessions that survive disconnects
- **Setup Guide**: See `IPAD_SETUP.md` for complete configuration instructions

### VPN Compatibility Notes
- **Current limitation**: NordVPN blocks Tailscale connections (must pause NordVPN to connect remotely)
- **Future solution**: Switching to Mullvad via Tailscale when NordVPN subscription expires
- **Wake-on-LAN**: Requires network access (complicated by VPN blocking)

### Zellij Session Management
```bash
# Start or attach to session (via justfile)
just dev          # Main development session
just sessions     # List all active sessions

# Manual zellij commands
zellij attach main || zellij -s main
zellij ls         # List sessions
```

## JavaScript/TypeScript Development Strategy

### Next.js + Bun Hybrid Approach (Recommended)
**Problem**: Bun runtime has compatibility issues with Next.js Turbopack
**Solution**: Use Bun for package management, Node.js for runtime

```bash
# Install dependencies (use Bun - 6x faster than npm)
bun install
bun add react-query

# Development (use Node.js runtime for Turbopack compatibility)
npm run dev       # NOT 'bun run dev'

# Production build
npm run build     # NOT 'bun run build'
```

**Why This Works**:
- Bun's package manager is 100% compatible with Next.js
- Vercel automatically detects `bun.lockb` and uses Bun for installs
- Node.js runtime avoids all Turbopack compatibility issues
- Get 3-6x faster dependency installs without runtime risk

**When to Use Bun Runtime**:
- Standalone scripts (native TypeScript execution)
- Non-Next.js projects (Express, Fastify, Vite, etc.)
- Testing with `bun test`

**Future Timeline**: Full Bun runtime support for Next.js expected late 2025/early 2026

## Maintenance Commands

### Updating Tools
```bash
# Update all Homebrew formulae
brew update && brew upgrade

# Update Rust toolchain
rustup update stable

# Update Node.js to latest LTS via mise
mise install node@lts && mise use -g node@lts

# Update zsh plugins (manual via Homebrew)
brew upgrade zsh-autosuggestions zsh-syntax-highlighting
```

### Troubleshooting
```bash
# Re-run symlink setup if configurations seem missing
./bootstrap.sh

# Verify tool installations
which nvim git cargo go node

# Check PATH and environment
echo $PATH | tr ':' '\n' | grep -E "(cargo|go|mise)"
```

## Advanced Features

### Alias Tips System
- **Dynamic Detection**: Automatically finds all aliases in `.aliases` and `.zshrc`
- **Smart Reminders**: Shows 2 random alias tips on terminal startup
- **User Customizable**: Edit `alias-descriptions.txt` to add descriptions
- **Learn by Discovery**: Helps users remember powerful shortcuts they've forgotten

### Security Architecture
- **Git Identity Separation**: Personal details kept in `~/.config/git/config.local` (not in repo)
- **Template-Based Setup**: `config.local.template` and `allowed_signers.local.template` provide secure starting points
- **SSH-First Design**: Repository optimized for SSH cloning and development
- **Private Config Protection**: Sensitive data never committed to public repository

### Dynamic Documentation
- **README.md Structure**: 
  - **Static content (top section)**: Edit README.md directly - setup instructions, customization guide, etc.
  - **Dynamic content (after `<!-- GENERATED_CONTENT_STARTS_HERE -->`)**: Auto-generated from Brewfile and .mise.toml
  - **Regeneration**: Run `./update-readme.sh` to rebuild only the dynamic sections while preserving static content
- **Smart Categorization**: Tools grouped by function based on Brewfile comments
- **IMPORTANT**: Always edit the static part of README.md directly, never the generated sections

## Development Philosophy

This environment prioritizes:
- **Bleeding-edge stability** - Latest stable versions of all tools
- **AI-first workflows** - Integration with Claude Code, Warp, and modern AI tools  
- **Terminal productivity** - Rich command-line experience with modern alternatives
- **Zero-config deployment** - Complete environment setup with single command
- **Security by design** - Personal details separated from public configuration
- **Idempotent operations** - All scripts safe to run multiple times
- **User education** - Alias tips and comprehensive documentation

## File Structure Context

- **`unused/`** - Deprecated configurations kept for reference
- **`trash/`** - Backup location for replaced dotfiles during bootstrap
- **`src/.config/`** - Modern XDG-compliant application configurations
- **`src/.vim/`** - Legacy Vim configuration (maintained alongside NeoVim)
- **`alias-descriptions.txt`** - User-editable alias descriptions for startup tips

The repository maintains both legacy and modern configurations to support gradual migration and cross-system compatibility.