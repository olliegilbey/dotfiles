#!/bin/bash

set -e  # Exit on any error

echo "💻 Language toolchain setup (bleeding edge updates)"
echo "=================================================="

# Rust Installation - always update to latest
echo ""
echo "🦀 Setting up Rust (latest stable)..."
if command -v rustc &>/dev/null; then
	echo "🔄 Rust found, updating to latest stable..."
	rustup update stable
	rustup default stable
else
	echo "📥 Installing Rust..."
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
	source "$HOME/.cargo/env"
fi
echo "✅ Rust: $(rustc --version 2>/dev/null || echo 'restart terminal to use')"

# Language toolchains via mise (universal version manager)
echo ""
echo "🟢 Setting up language toolchains via mise..."
if command -v mise &>/dev/null; then
	echo "🔄 mise found, updating to latest..."
	# Update mise itself (if installed via homebrew, brew handles this)
	mise self-update 2>/dev/null || echo "ℹ️  mise update handled by homebrew"
	
	# Update mise plugins
	echo "🔄 Updating mise plugins..."
	mise plugins update 2>/dev/null || echo "ℹ️  No plugins to update"
	
	# Install tools from .mise.toml if it exists
	script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
	if [ -f "$script_dir/.mise.toml" ]; then
		echo "🔄 Installing tools from .mise.toml..."
		cd "$script_dir"
		mise install
		cd - >/dev/null
	else
		# Fallback to manual Node.js installation
		echo "🔄 Installing/updating Node.js LTS via mise..."
		mise install node@lts
		mise use -g node@lts
	fi
else
	echo "⚠️  mise not found - it should be installed via Homebrew in brew.sh"
	echo "ℹ️  Skipping language toolchain setup"
fi

# Check if Node.js is available
if command -v node &>/dev/null; then
	echo "✅ Node.js: $(node --version)"
	echo "✅ npm: $(npm --version)"
else
	echo "⚠️  Node.js not available - restart terminal or run 'mise activate'"
fi

# NeoVim Language Support Setup
echo ""
echo "🔧 Setting up NeoVim language support..."

# Python support via uv (cross-platform)
if command -v uv &>/dev/null; then
    nvim_data_dir="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
    mkdir -p "$nvim_data_dir"
    
    if [ -d "$nvim_data_dir/venv" ]; then
        echo "🔄 Updating NeoVim Python environment..."
        uv pip install --python "$nvim_data_dir/venv" --upgrade pynvim >/dev/null 2>&1
    else
        echo "📥 Creating NeoVim Python environment..."
        uv venv "$nvim_data_dir/venv" >/dev/null 2>&1
        uv pip install --python "$nvim_data_dir/venv" pynvim >/dev/null 2>&1
    fi
    echo "✅ NeoVim Python support ready"
else
    echo "⚠️  uv not available, skipping NeoVim Python setup"
fi

# Node.js support via bun (modern JavaScript runtime)
if command -v bun &>/dev/null; then
    if bun pm ls -g 2>/dev/null | grep -q neovim; then
        echo "✅ NeoVim Node.js support already installed"
    else
        echo "📥 Installing NeoVim Node.js support..."
        bun install -g neovim >/dev/null 2>&1
    fi
else
    echo "⚠️  bun not available, skipping NeoVim Node.js setup"
fi

echo ""
echo "✨ Language toolchain setup complete (all latest versions)!"
