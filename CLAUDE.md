# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a modern macOS/Linux dotfiles repository with automated setup and bleeding-edge tool integration. The architecture follows a symlink-based approach where all configuration files in `src/` are automatically linked to the home directory.

### Key Components

- **`init.sh`** - Master setup script that orchestrates the entire environment installation
- **`bootstrap.sh`** - Creates symlinks from `src/` to home directory (robust error handling)
- **`brew.sh`** - Uses Brewfile for declarative package management via `brew bundle`
- **`language_installs.sh`** - Sets up programming language toolchains (Rust via rustup, others via mise)
- **`Brewfile`** - Declarative package management with cross-platform conditionals
- **`.mise.toml`** - Project-specific language versions (Node.js, Go, Python)
- **`update-readme.sh`** - Dynamic README generation from current environment
- **`update-alias-descriptions.sh`** - Alias detection and description management
- **`show-alias-tips.sh`** - Random alias reminders on terminal startup
- **`git-config-local.template`** - Secure git identity template (keeps personal details private)
- **`alias-descriptions.txt`** - User-customizable alias descriptions for startup tips
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

# Update alias descriptions for startup tips
./update-alias-descriptions.sh

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

## Tool Stack (2025 Bleeding Edge)

### Package Management
- **Homebrew** - System packages and CLI tools
- **mise** - Universal version manager (replaces nvm, fnm, rbenv, pyenv, etc.)
- **uv** - Modern Python package/project manager (replaces pip/pipenv/poetry)
- **Cargo** - Rust package manager and build system

### Core Development Tools
- **NeoVim** - Primary editor with LazyVim distribution
- **Warp** - AI-enhanced terminal (replaces traditional terminals)
- **ripgrep (rg)** - Fast search tool (replaces grep)
- **fd** - Fast file finder (replaces find)
- **zoxide** - Smart cd replacement with frecency algorithm
- **fzf** - Fuzzy finder for command-line productivity
- **lazygit** - Terminal UI for Git operations

### Language Toolchains
- **Rust** - Primary language with rust-analyzer LSP
- **Go** - Systems programming with full toolchain
- **Node.js** - Web development via mise (latest LTS)
- **Python** - Data/ML development via uv package manager
- **Bun** - Modern JavaScript runtime and package manager

## Configuration Architecture

### Shell Configuration Layers
1. **`.zshenv`** - Environment variables and PATH setup (loaded first)
2. **`.zshrc`** - Interactive shell configuration with Oh My Zsh
3. **`.aliases`** - Custom commands and shortcuts

### Key Environment Variables
- `EDITOR="nvim"` - Default editor for all tools
- `GOPATH="$HOME/go"` - Go workspace
- `UV_PYTHON_PREFERENCE=only-managed` - Python version management via uv

### Modern Zsh Plugin Stack
```bash
plugins=(
  git golang rust docker
  zsh-autosuggestions zsh-syntax-highlighting
)
```

## AI Development Integration

### Claude Code Integration
- **Alias**: `claude` points to `$HOME/.claude/local/claude`
- **Global Config**: `src/.config/claude/CLAUDE.md` contains comprehensive development philosophy
- **Settings**: `.claude/settings.local.json` manages permissions and MCP servers

### Warp Terminal Integration
- **Native Prompting**: Starship prompt disabled in favor of Warp's native UI
- **AI Command Suggestions**: Warp provides context-aware command suggestions
- **Performance Optimization**: Heavy Oh My Zsh plugins removed for Warp compatibility

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
- **Environment-Aware README**: Generated from actual Brewfile and `.mise.toml` contents
- **Static/Dynamic Split**: User content preserved, tool lists auto-updated
- **Accurate Package Counts**: Always reflects current environment state
- **Smart Categorization**: Tools grouped by function based on comments

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