# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a modern macOS/Linux dotfiles repository with automated setup and bleeding-edge tool integration. Recently underwent a complete overhaul (August 2025) modernizing all components with AI-first workflows. The architecture follows a symlink-based approach where all configuration files in `src/` are automatically linked to the home directory.

### Key Components

- **`init.sh`** - Master setup script that orchestrates the entire environment installation
- **`bootstrap.sh`** - Creates symlinks from `src/` to home directory (robust error handling, validation, idempotent)
- **`brew.sh`** - Uses Brewfile for declarative package management via `brew bundle` (31 packages, casks, taps)
- **`language_installs.sh`** - Sets up programming language toolchains (Rust via rustup, others via mise)
- **`Brewfile`** - Declarative package management with cross-platform conditionals
- **`.mise.toml`** - Project-specific language versions (Node.js, Go, Python)
- **`update-readme.sh`** - Dynamic README generation from current environment
- **`show-alias-tips.sh`** - Random alias reminders on terminal startup (reads inline descriptions from .aliases)
- **`git-config-local.template`** - Secure git identity template (keeps personal details private)
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

## Tool Stack (2025 Bleeding Edge) - Recently Modernized

### Modern Command-Line Tools (Rust-based)
- **eza** - Modern ls replacement with icons, git status, and better defaults
- **bat** - Enhanced cat with syntax highlighting and git integration
- **delta** - Enhanced git diff viewer with syntax highlighting
- **ripgrep (rg)** - Recursive line-oriented search tool (extremely fast)
- **fd** - Fast file finder alternative to find
- **zoxide** - Smart cd replacement with frecency algorithm
- **fzf** - Fuzzy finder for command-line productivity

### Package Management
- **Homebrew** - System packages and CLI tools
- **mise** - Universal version manager (replaces nvm, fnm, rbenv, pyenv, etc.)
- **uv** - Modern Python package/project manager (replaces pip/pipenv/poetry)
- **Cargo** - Rust package manager and build system

### Editors & Development Environment
- **NeoVim** - Primary editor with LazyVim distribution (completely rebuilt configuration)
- **Warp** - AI-enhanced terminal with native prompting (no starship needed)
- **lazygit** - Terminal UI for Git operations

### Language Toolchains
- **Rust** - Primary language with rust-analyzer LSP (managed via rustup)
- **Go** - Systems programming with full toolchain (managed via mise)
- **Node.js** - Web development via mise (latest LTS) + **Bun** for performance
- **Python** - Data/ML development via uv package manager (managed via mise)
- **Bun** - Modern JavaScript runtime and package manager (replaces npm for new projects)

## Configuration Architecture

### Shell Configuration Layers
1. **`.zshenv`** - Environment variables and PATH setup (loaded first)
2. **`.zshrc`** - Interactive shell configuration with Oh My Zsh, mise activation, bun completions
3. **`.aliases`** - Extensive custom commands with inline descriptions (200+ lines, 70+ aliases)

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

### Modern Zsh Plugin Stack
```bash
plugins=(
  git golang rust docker
  zsh-autosuggestions zsh-syntax-highlighting zsh-completions
)
```

### Command Aliases & AI Agent Notes
- **`grep` is aliased to `rg`**: Uses ripgrep syntax, not POSIX grep syntax
  - Shows "🔍 ripgrep:" indicator before all output for context
  - Ripgrep searches files by default: `grep pattern` searches all files in current directory
  - POSIX grep needs input: `echo "text" | /usr/bin/grep pattern` or `/usr/bin/grep pattern file.txt`
  - No `-E` flag needed: `rg 'pattern1|pattern2'` instead of `grep -E '(pattern1|pattern2)'`
- **Python development shortcuts**: 
  - `uvr` alias for `uv run python` (frequently used for Python script execution)
  - Python managed via uv for package/project management

### Alias Tips System
- **Inline Documentation**: Alias descriptions stored as comments in .aliases file
- **Random Startup Tips**: Shows 2 random aliases on terminal startup via show-alias-tips.sh
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
- **Native Prompting**: Starship completely removed in favor of Warp's native UI
- **AI Command Suggestions**: Warp provides context-aware command suggestions
- **Performance Optimization**: Removed atuin (conflicts with Warp history) and other heavy plugins
- **Alias Tips**: Random startup reminders complement Warp's native features

## Maintenance Commands

### Updating Tools
```bash
# Update all Homebrew formulae
brew update && brew upgrade

# Update Rust toolchain
rustup update stable

# Update Node.js to latest LTS via mise
mise install node@lts && mise use -g node@lts

# Update Oh My Zsh and plugins
sh ~/.oh-my-zsh/tools/upgrade.sh
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
- **Template-Based Setup**: `git-config-local.template` provides secure starting point
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