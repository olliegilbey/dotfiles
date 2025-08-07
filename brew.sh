#!/usr/bin/env bash

set -e  # Exit on any error
set -u  # Exit on undefined variables
set -o pipefail  # Exit on pipe failures

# Script directory for relative paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREWFILE="$SCRIPT_DIR/Brewfile"

echo "📦 Homebrew package installation/update (Brewfile)"
echo "================================================="

# Validation: Check if Brewfile exists
if [[ ! -f "$BREWFILE" ]]; then
    echo "❌ Error: Brewfile not found at $BREWFILE"
    exit 1
fi

# Validation: Check if Homebrew is installed
if ! command -v brew &>/dev/null; then
    echo "❌ Error: Homebrew is not installed. Please install it first."
    echo "   Visit: https://brew.sh"
    exit 1
fi

echo "✅ Using Brewfile: $BREWFILE"
echo "📊 Brewfile contains $(grep -c '^brew\|^tap\|^cask' "$BREWFILE" || echo 0) packages"

# Only request sudo if we need it (for linking coreutils) and if interactive
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Check if we're running interactively
    if [[ -t 0 ]] && [[ -t 1 ]]; then
        echo "🔐 Requesting administrative privileges for macOS setup..."
        sudo -v
        
        # Keep-alive: update existing `sudo` time stamp until the script has finished
        while true; do
            sudo -n true
            sleep 60
            kill -0 "$$" || exit
        done 2>/dev/null &
    else
        echo "ℹ️  Non-interactive session detected. Sudo-required operations will be skipped."
        echo "   If you need all features, run this script interactively."
    fi
fi

echo "🔄 Updating Homebrew..."
if ! brew update; then
    echo "⚠️  Warning: Homebrew update failed, continuing anyway..."
fi

echo "⬆️  Upgrading existing formulae..."
if ! brew upgrade; then
    echo "⚠️  Warning: Some packages failed to upgrade, continuing..."
fi

echo "📋 Installing packages from Brewfile..."
if ! brew bundle --file="$BREWFILE"; then
    echo "❌ Error: Brewfile installation failed"
    exit 1
fi

# macOS-specific post-installation setup
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🍎 Performing macOS-specific setup..."
    
    # Link sha256sum for compatibility (with error handling)
    if command -v gsha256sum &>/dev/null; then
        if [[ ! -L "/usr/local/bin/sha256sum" ]]; then
            # Check if we can use sudo (either we have cached credentials or we're interactive)
            if sudo -n true 2>/dev/null; then
                echo "🔗 Creating sha256sum symlink..."
                sudo ln -sf "$(which gsha256sum)" "/usr/local/bin/sha256sum" || {
                    echo "⚠️  Warning: Could not create sha256sum symlink"
                }
            else
                echo "ℹ️  Skipping sha256sum symlink (requires sudo)"
                echo "   Run 'sudo ln -sf \$(which gsha256sum) /usr/local/bin/sha256sum' manually if needed"
            fi
        else
            echo "✅ sha256sum symlink already exists"
        fi
    else
        echo "⚠️  Warning: gsha256sum not found, skipping symlink creation"
    fi
fi

echo "🧹 Running bundle cleanup..."
brew bundle cleanup --file="$BREWFILE" --force || {
    echo "⚠️  Warning: Bundle cleanup had issues, continuing..."
}

echo "Cleaning up outdated versions from Homebrew..."
# Clean up outdated versions from the Homebrew cellar
brew cleanup
echo "Installation complete!"
