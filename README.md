# Modern macOS Dotfiles

A practical development environment setup with bleeding-edge tooling, AI-first workflows, and comprehensive automation.

## Quick Start

```bash
# Clone the repository
git clone git@github.com:olliegilbey/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Run complete setup
./init.sh
```

## Essential Setup Steps

### 1. Configure Your Git Identity (Required)

```bash
# Set up git user configuration
cp src/.config/git/config-local.template ~/.config/git/config.local
# Edit ~/.config/git/config.local with your name, email, and signing key

# Set up SSH commit verification (optional, for signed commits)
cp src/.config/git/allowed-signers.template ~/.config/git/allowed_signers
# Edit ~/.config/git/allowed_signers with your SSH public key
```

### 2. Set Up Raycast (macOS)

Raycast is installed via Homebrew but requires manual setup:

1. Open Raycast from Applications to start the service
2. Set as Spotlight replacement (`Cmd+Space`)  
3. Install extensions: GitHub, Spotify Controls, Arc Browser, Obsidian, Slack
4. Sign in to extension services as needed

### 3. Verify Everything Works

```bash
dotfiles-health
```

## Customization Guide

These are the key files you'll want to customize for your needs:

### Package Management
- **`Brewfile`** - Add/remove packages (`brew install` automatically adds new ones)
- **`.mise.toml`** - Language versions (Node.js, Go, Python)

### Shell Configuration
- **`src/.aliases`** - Custom commands and shortcuts (uses `$DEV_DIR` variable)
- **`src/.zshrc`** - Shell behavior and environment variables
- **`src/.zshenv`** - Environment variables including `DEV_DIR` (default: `~/code`)

### Application Configs
- **`src/.config/nvim/`** - NeoVim editor configuration
- **`src/.config/git/config`** - Git settings (public only)

### Quick Commands
```bash
# Add new packages (automatically tracked in Brewfile)
brew install package-name

# Update everything
./init.sh

# Health check
dotfiles-health

# This README has GENERATED_CONTENT at the bottom, that pulls the info on your env. Regenerate with:
./update-readme.sh

# Random alias tips on terminal startup
./show-alias-tips.sh
```

## Alias Tips & Cheatsheet

The setup includes a smart alias reminder system that shows 2 random aliases on terminal startup.

### Adding Alias Descriptions
Add descriptions directly inline with your aliases in `src/.aliases`:

```bash
# Example: Add description as comment after the alias
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'  # Simple command-line timer
alias lg='lazygit'  # Quick git UI
alias dev='cd ~/Documents/code'  # Quick access to dev directory
```

Only aliases with descriptions appear in startup tips. Non-obvious aliases should have descriptions added for better discoverability.

---

<!-- GENERATED_CONTENT_STARTS_HERE -->

## 🔧 Language Toolchains

Managed for consistent versions across environments:

- **node** - lts (via mise)
- **go** - latest (via mise)
- **python** - latest (via mise)

- **rust** - latest stable (via rustup)

## 📦 Package Environment

Currently managing **31 packages**, **3 casks**, and **1 taps** via Brewfile.

### Development Languages

- **go** - Go programming language
- **lua** - Lightweight, high-performance programming language
- **rust-analyzer** - Language server for Rust

### Modern Command-Line Tools

- **bash** - POSIX shell - required for script compatibility
- **bat** - Enhanced cat with syntax highlighting and git integration
- **delta** - Enhanced git diff viewer with syntax highlighting
- **eza** - Modern ls replacement with icons, git status, and better defaults
- **fd** - Fast file finder alternative to find (used by LazyVim)
- **fzf** - Fuzzy finder for command-line (works with zoxide)
- **ripgrep** - Recursive line-oriented search tool (extremely fast)
- **todo-txt** - Simple todo.txt manager for command line
- **zoxide** - Smart cd replacement with frecency algorithm
- **zsh** - Your primary shell

### Editors

- **neovim** - Modern text editor, enhancement from Vim
- **vim** - Highly configurable and robust text editor

### Version Control

- **gh** - GitHub CLI for command-line GitHub interaction
- **git-extras** - Useful git extensions for common tasks
- **git** - Distributed version control system
- **lazygit** - Terminal UI for Git operations

### Package Managers & Runtimes

- **bun** - Modern JavaScript runtime and package manager (faster than npm/node)
- **mise** - Universal version manager (replaces nvm, rbenv, pyenv, etc.)
- **uv** - Modern Python package manager (replaces pip, pipenv, poetry)

### Productivity Apps

- **raycast** - Spotlight replacement with extensible functionality

### System Utilities

- **csvkit** - CSV processing tools including csvstat
- **findutils** - File and directory search tools
- **imagemagick** - Image manipulation utilities
- **wget** - Network utility to retrieve files from the web

### Security Tools

- **1password-cli** - 1Password command-line interface

### Fonts

- **font-fira-code-nerd-font** - Programming font with ligatures and icons

### Other Tools

- **bash-completion** - Bash autocompletion
- **curl**
- **gemini-cli**
- **jq** - JSON processor
- **tree** - Recursive directory listing command

## 🏥 Health Check

Run `dotfiles-health` to verify your environment:

```bash
dotfiles-health
```

This validates all tools, language runtimes, and configurations.

---

*Last updated: 2025-08-26 21:21:52*
