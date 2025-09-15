#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")"

echo "🚀 Initializing development environment..."
echo "=========================================="

# Create necessary directories
echo "📁 Creating necessary directories..."
mkdir -p /usr/local/ 2>/dev/null || true
mkdir -p "$HOME/go" 2>/dev/null || true

# Execute bootstrap (this is idempotent)
echo ""
echo "🔗 Setting up dotfiles symlinks..."
bash bootstrap.sh

# Check if Homebrew is installed
echo ""
echo "🍺 Checking Homebrew installation..."
if command -v brew &>/dev/null; then
	echo "✅ Homebrew is already installed."
else
	echo "📦 Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	# Add Homebrew to PATH for this session
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Execute brew installations (idempotent)
echo ""
echo "📦 Installing/updating Homebrew packages..."
bash brew.sh

# Set default shell (idempotent)
echo ""
echo "🐚 Configuring shell..."
current_shell=$(dscl . -read ~/ UserShell | sed 's/UserShell: //')
zsh_path=$(which zsh)
if [ "$current_shell" != "$zsh_path" ]; then
	echo "🔄 Setting default shell to zsh"
	sudo chsh -s "$zsh_path" "$USER" || echo "⚠️  Could not change shell - you may need to do this manually"
else
	echo "✅ Shell is already set to zsh"
fi

# Install Oh My Zsh (idempotent)
echo ""
echo "⚡ Setting up Oh My Zsh..."
if [ -d "$HOME/.oh-my-zsh" ]; then
	echo "✅ Oh My Zsh is already installed."
	# Update Oh My Zsh
	echo "🔄 Updating Oh My Zsh..."
	env ZSH="$HOME/.oh-my-zsh" sh "$HOME/.oh-my-zsh/tools/upgrade.sh" || true
else
	echo "📥 Installing Oh My Zsh..."
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

	# Restore our symlinked .zshrc (Oh My Zsh overwrites it)
	echo "🔄 Restoring dotfiles .zshrc..."
	rm -f "$HOME/.zshrc"
	bash bootstrap.sh  # Re-run bootstrap to restore .zshrc symlink
fi

# Install/update zsh plugins (idempotent)
echo ""
echo "🔌 Setting up zsh plugins..."
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
mkdir -p "$ZSH_CUSTOM/plugins"

zsh_plugins=(
	"zsh-users/zsh-completions:zsh-completions"
	"zsh-users/zsh-syntax-highlighting:zsh-syntax-highlighting"
	"zsh-users/zsh-autosuggestions:zsh-autosuggestions"
)

for plugin_info in "${zsh_plugins[@]}"; do
	repo=$(echo $plugin_info | cut -d: -f1)
	name=$(echo $plugin_info | cut -d: -f2)
	plugin_dir="$ZSH_CUSTOM/plugins/$name"
	
	if [ -d "$plugin_dir" ]; then
		echo "🔄 Updating $name..."
		(cd "$plugin_dir" && git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || echo "Could not update $name")
	else
		echo "📥 Installing $name..."
		git clone "https://github.com/$repo.git" "$plugin_dir"
	fi
done

# Install/update language toolchains (idempotent)
echo ""
echo "💻 Setting up language toolchains..."
bash language_installs.sh

# Update additional tools if they exist (idempotent)
echo ""
echo "🔄 Updating additional development tools..."

# Update mise (universal version manager)
if command -v mise &>/dev/null; then
	echo "🔄 Updating mise..."
	mise self-update 2>/dev/null || echo "ℹ️  mise update handled by homebrew"
	mise plugins update 2>/dev/null || echo "ℹ️  No mise plugins to update"
fi

# Update bun (JavaScript runtime)
if command -v bun &>/dev/null; then
	echo "🔄 Updating bun..."
	bun upgrade 2>/dev/null || echo "ℹ️  bun update handled by homebrew"
fi

# Shell history handled by Warp Terminal natively

echo ""
echo "🔄 Activating environment for immediate use..."

# Source the new shell configuration
if [ -f "$HOME/.zshrc" ]; then
    echo "📥 Loading shell configuration..."
    export SHELL=$(which zsh)
    if source "$HOME/.zshrc" 2>/dev/null; then
        echo "✅ Shell configuration loaded successfully"
    else
        echo "⚠️  Shell config loaded with warnings (this is normal for init)"
    fi
fi

# Activate mise for language toolchains
if command -v mise &>/dev/null; then
    echo "🟢 Activating mise environment..."
    eval "$(mise activate bash)" 2>/dev/null || echo "ℹ️  mise activation will be available in new shells"
fi

# Test environment activation
echo ""
echo "🏥 Running environment validation..."

# Core tools check
tools_ready=true

if command -v node &>/dev/null; then
    echo "✅ Node.js:  $(node --version)"
else
    echo "⚠️  Node.js: Will be available after terminal restart"
    tools_ready=false
fi

if command -v bun &>/dev/null; then
    echo "✅ Bun:  $(bun --version)"
else
    echo "⚠️  Bun: Installation may need terminal restart"
    tools_ready=false
fi

if command -v mise &>/dev/null; then
    echo "✅ mise:  $(mise --version | head -1)"
else
    echo "⚠️  mise: Installation may need terminal restart"
    tools_ready=false
fi

if command -v delta &>/dev/null; then
    echo "✅ delta:  $(delta --version)"
else
    echo "⚠️  delta: Installation may need terminal restart"
    tools_ready=false
fi

# Summary
if [ "$tools_ready" = true ]; then
    echo ""
    echo "🎉 All tools are immediately available!"
else
    echo ""
    echo "ℹ️  Some tools need terminal restart to be available"
fi

# Alias descriptions are now inline with aliases - no separate update needed
echo ""
echo "📝 Alias descriptions are managed inline with aliases"

echo ""
echo "✨ Environment setup complete!"
echo ""
echo "📋 Next steps:"

# Check if git config.local exists
if [ ! -f "$HOME/.config/git/config.local" ]; then
	echo "   1. 🔑 Set up your git identity (REQUIRED):"
	echo "      cp src/.config/git/config.local.template ~/.config/git/config.local"
	echo "      # Then edit ~/.config/git/config.local with your name, email, and signing key"
	echo ""
	echo "      # For SSH commit signing (optional but recommended):"
	echo "      cp src/.config/git/allowed_signers.local.template ~/.config/git/allowed_signers.local"
	echo "      # Then edit ~/.config/git/allowed_signers.local with your SSH public key"
	echo ""
	echo "   2. 🔄 Restart your terminal or run: source ~/.zshrc"
	echo ""
	echo "   3. 🏥 Run 'dotfiles-health' to verify everything is working"
else
	echo "   ✅ Git config already set up"
	echo "   1. 🔄 Restart your terminal or run: source ~/.zshrc"
	echo "   2. 🏥 Run 'dotfiles-health' to verify everything is working"
fi