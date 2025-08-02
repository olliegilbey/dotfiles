# Modern macOS Dotfiles

A practical development environment setup with modern tooling and AI-first workflows.

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
cp git-config-local.template ~/.config/git/config.local
# Edit ~/.config/git/config.local with your name, email, and signing key
```

### 2. Verify Everything Works

```bash
dotfiles-health
```

## Customization Guide

These are the key files you'll want to customize for your needs:

### Package Management
- **`Brewfile`** - Add/remove packages (`brew install` automatically adds new ones)
- **`.mise.toml`** - Language versions (Node.js, Go, Python)

### Shell Configuration  
- **`src/.aliases`** - Custom commands and shortcuts
- **`src/.zshrc`** - Shell behavior and environment variables

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

# Regenerate this README
./update-readme.sh

# Update alias descriptions for startup tips
./update-alias-descriptions.sh
```

## Alias Tips & Cheatsheet

The setup includes a smart alias reminder system that shows 2 random aliases on terminal startup.

### Customizing Alias Tips
1. **Edit descriptions**: `alias-descriptions.txt`
2. **Format**: `alias_name::description`
3. **Only aliases with descriptions** appear in startup tips

```bash
# Example entries in alias-descriptions.txt
ll::Enhanced ls with icons, git status, and detailed info
lg::Launch lazygit for terminal Git UI
dev::Quick jump to development directory
```

The system auto-detects new aliases but you need to add descriptions manually to enable them in the tips.

---

<!-- GENERATED_CONTENT_STARTS_HERE -->

## 🔧 Language Toolchains

Managed for consistent versions across environments:

- **node** - lts (via mise)
- **go** - latest (via mise)
- **python** - latest (via mise)

- **rust** - latest stable (via rustup)

## 📦 Package Environment

Currently managing **28 packages**, **2 casks**, and **1 taps** via Brewfile.

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

### System Utilities

- **findutils** - File and directory search tools
- **imagemagick** - Image manipulation utilities
- **nmap** - Network exploration tool and security scanner
- **wget** - Network utility to retrieve files from the web

### Other Tools

- **bash-completion** - Bash autocompletion
- **jq** - JSON processor
- **tree** - Recursive directory listing command

## 🏥 Health Check

Run `dotfiles-health` to verify your environment:

```bash
dotfiles-health
```

This validates all tools, language runtimes, and configurations.

---

*Last updated: 2025-08-02 12:02:57*
