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
# Note: Zellij session commands (code, attach, sessions, kill, kill-all)
# are in global justfile (~/.config/just/justfile) and work from any directory

# ============================================================================
# Editor & Benchmarking
# ============================================================================
# Note: Editor shortcuts (vim, hx) and benchmarking (bench, bench-startup)
# are in global justfile and work from any directory

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
# Project Templates
# ============================================================================
# Note: Project templates (new-rust, new-go, new-next, new-python)
# are in global justfile and work from any directory

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
