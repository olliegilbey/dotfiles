# Dotfiles Management Justfile
# NOTE: This requires `just` to be installed (via brew.sh)
# For fresh machine setup, run ./init.sh directly first
# Run `just` or `just --list` to see all available commands

# Default recipe - show all available commands
default:
    @just --list

# ============================================================================
# Setup & Installation
# ============================================================================

# Complete fresh setup (new machine)
setup:
    ./init.sh

# Install/update all Homebrew packages from Brewfile
packages:
    ./brew.sh

# Update symlinks only (idempotent)
bootstrap:
    ./bootstrap.sh

# Update language toolchains only
languages:
    ./language_installs.sh

# Full update (everything: packages, languages, symlinks)
update:
    ./init.sh

# ============================================================================
# Health & Validation
# ============================================================================

# Run comprehensive dotfiles health check
health:
    @bash -c 'source src/.aliases && dotfiles-health'

# Show environment information
info:
    @bash -c 'source src/.aliases && env-info'

# Show project context (for current directory)
context:
    @bash -c 'source src/.aliases && proj-context'

# Show AI context helper (for Claude Code sessions)
ai-context:
    @bash -c 'source src/.aliases && ai-context'

# ============================================================================
# Documentation
# ============================================================================

# Regenerate README.md with current environment
docs:
    ./update-readme.sh

# Show random alias tips
tips:
    ./show-alias-tips.sh

# ============================================================================
# Git Operations
# ============================================================================

# Quick commit with message
commit message:
    git add -A && git commit -m "{{message}}"

# Show git repository summary
git-status:
    @bash -c 'source src/.aliases && git-summary'

# Stage all changes and show status
stage:
    git add -A && git status

# ============================================================================
# Development Workflow (requires zellij)
# ============================================================================

# Start new development session in zellij (auto-attaches if exists)
code session="main":
    #!/usr/bin/env bash
    if command -v zellij &>/dev/null; then
        zellij attach {{session}} || zellij -s {{session}}
    else
        echo "⚠️  zellij not installed yet - run 'just packages' first"
        exit 1
    fi

# Backwards compatibility alias (temporary - remove after adjustment period)
alias dev := code

# Attach to existing zellij session
attach session="main":
    #!/usr/bin/env bash
    if command -v zellij &>/dev/null; then
        zellij attach {{session}}
    else
        echo "⚠️  zellij not installed yet - run 'just packages' first"
        exit 1
    fi

# List all active zellij sessions
sessions:
    #!/usr/bin/env bash
    if command -v zellij &>/dev/null; then
        echo "📋 Active Zellij Sessions:"
        zellij list-sessions || echo "   No active sessions"
    else
        echo "⚠️  zellij not installed yet - run 'just packages' first"
    fi

# Kill a zellij session
kill session:
    #!/usr/bin/env bash
    if command -v zellij &>/dev/null; then
        zellij delete-session {{session}}
    else
        echo "⚠️  zellij not installed yet"
    fi

# Kill all zellij sessions
kill-all:
    #!/usr/bin/env bash
    if command -v zellij &>/dev/null; then
        zellij list-sessions 2>/dev/null | while read -r session; do
            zellij delete-session "$session" 2>/dev/null || true
        done
        echo "✅ All zellij sessions killed"
    else
        echo "⚠️  zellij not installed yet"
    fi

# ============================================================================
# Editor Shortcuts
# ============================================================================

# Open file with helix (lightweight editor)
hx file:
    #!/usr/bin/env bash
    if command -v helix &>/dev/null; then
        helix {{file}}
    else
        echo "⚠️  helix not installed yet - run 'just packages' first"
        exit 1
    fi

# Open current directory in NeoVim
vim:
    nvim ./

# ============================================================================
# Testing & Benchmarking
# ============================================================================

# Benchmark a command (requires hyperfine)
bench command:
    #!/usr/bin/env bash
    if command -v hyperfine &>/dev/null; then
        hyperfine "{{command}}"
    else
        echo "⚠️  hyperfine not installed yet - run 'just packages' first"
        exit 1
    fi

# Compare shell startup time (old vs new config)
bench-startup:
    #!/usr/bin/env bash
    if command -v hyperfine &>/dev/null; then
        echo "Benchmarking shell startup..."
        hyperfine --warmup 3 'zsh -i -c exit'
    else
        echo "⚠️  hyperfine not installed yet - run 'just packages' first"
        exit 1
    fi

# ============================================================================
# Cleanup & Maintenance
# ============================================================================

# Clean Homebrew caches and old versions
clean-brew:
    brew cleanup --prune=all
    brew autoremove

# Clear shell completion caches
clean-shell:
    @bash -c 'source src/.aliases && clear-shell-cache'

# Clean everything (brew + shell caches)
clean: clean-brew clean-shell
    @echo "✨ Cleanup complete!"

# ============================================================================
# Project Templates (Future expansion)
# ============================================================================

# Create new Rust project
new-rust name:
    cargo new {{name}}
    @echo "✨ Created Rust project: {{name}}"

# Create new Go project
new-go name:
    mkdir -p {{name}} && cd {{name}} && go mod init {{name}}
    @echo "✨ Created Go project: {{name}}"

# Create new Next.js project (with bun)
new-next name:
    bunx create-next-app {{name}}
    @echo "✨ Created Next.js project: {{name}}"

# Create new Python project (with uv)
new-python name:
    uv init {{name}}
    @echo "✨ Created Python project: {{name}}"

# ============================================================================
# Remote Development
# ============================================================================

# Set up this Mac as a remote development server
setup-remote:
    @./remote/setup-server.sh

# Show Tailscale connection status
remote-status:
    @tailscale status

# Show all Tailscale devices with SSH commands
remote-hosts:
    @bash -c 'source ~/.aliases && tailscale-hosts'

# Show MOTD (welcome message)
remote-motd:
    @~/.config/remote/motd.sh || echo "⚠️  MOTD not installed - run 'just setup-remote' first"

# Test remote connection (loopback)
remote-test:
    @echo "🧪 Testing loopback SSH connection..."
    @ssh -o ConnectTimeout=5 $(hostname -s).tail7a4b9.ts.net "echo '✅ Connection successful!'" || echo "❌ Connection failed"
