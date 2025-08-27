# Warp-Optimized .zshrc Configuration
# Streamlined for performance and Warp compatibility

# ------------------------------------------------------------------------------
# PATH MANAGEMENT
# ------------------------------------------------------------------------------
# All PATH modifications are centralized here for clarity and order.

# Homebrew - THIS MUST BE FIRST
if [ -x "/opt/homebrew/bin/brew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Base system paths (prepend to preserve existing PATH)
export PATH="/usr/local/sbin:/usr/local/bin:$PATH"

# Homebrew
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
  # Add GNU gettext for envsubst
  export PATH="$(brew --prefix)/opt/gettext/bin:$PATH"
fi

# Go paths (GOPATH defined in .zshenv)
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:/usr/local/go/bin"

# Cargo (Rust)
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# Bun (JavaScript)
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Ruby (from Homebrew)
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="/opt/homebrew/lib/ruby/gems/3.4.0/bin:$PATH"

# Other custom paths
export PATH="$PATH:$HOME/.bin"
export PATH="$PATH:$HOME/.composer/vendor/bin"
export PATH="$PATH:/Library/TeX/Root/bin/x86_64-darwin/"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.krew/bin"
export PATH="$PATH:$HOME/.foundry/bin"

# Visual Studio Code
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"

# ------------------------------------------------------------------------------
# SHELL CONFIGURATION
# ------------------------------------------------------------------------------

# History Configuration (balanced performance and persistence)
export HISTSIZE=50000
export SAVEHIST=50000  
export HISTFILE=~/.zsh_history
setopt share_history          # Share between sessions with batched writes
setopt hist_ignore_dups       # Skip duplicate entries

# General Configuration
export ZSH="$HOME/.oh-my-zsh"
# EDITOR is defined in .zshenv

# Essential OMZ plugins only
plugins=(
  git
  golang
  rust
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Configure zsh-autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_MANUAL_REBIND=true

# Load Oh My Zsh (theme is disabled for Warp)
ZSH_THEME=""
source $ZSH/oh-my-zsh.sh

# Essential completions
autoload -U compinit && compinit

# Python via uv - lazy load completions for performance
if command -v uv &>/dev/null; then
    # Cache completion for faster startup
    local uv_completion_cache="$HOME/.cache/uv-completion.zsh"
    if [[ ! -f "$uv_completion_cache" ]] || [[ "$uv_completion_cache" -ot "$(which uv)" ]]; then
        mkdir -p "$(dirname "$uv_completion_cache")"
        uv generate-shell-completion zsh > "$uv_completion_cache"
    fi
    source "$uv_completion_cache"
fi
export UV_PYTHON_PREFERENCE=only-managed

# mise - Universal version manager with cached completions
if command -v mise &>/dev/null; then
    eval "$(mise activate zsh)"
    
    # Cache mise completions for faster startup
    local mise_completion_cache="$HOME/.cache/mise-completion.zsh"
    if [[ ! -f "$mise_completion_cache" ]] || [[ "$mise_completion_cache" -ot "$(which mise)" ]]; then
        mkdir -p "$(dirname "$mise_completion_cache")"
        mise completion zsh > "$mise_completion_cache"
    fi
    source "$mise_completion_cache"
fi

# Bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Source aliases
[ -f "$HOME/.aliases" ] && source "$HOME/.aliases"

# zoxide (modern cd replacement) with cached initialization
if command -v zoxide &>/dev/null; then
    local zoxide_init_cache="$HOME/.cache/zoxide-init.zsh"
    if [[ ! -f "$zoxide_init_cache" ]] || [[ "$zoxide_init_cache" -ot "$(which zoxide)" ]]; then
        mkdir -p "$(dirname "$zoxide_init_cache")"
        zoxide init --cmd cd zsh > "$zoxide_init_cache"
    fi
    source "$zoxide_init_cache"
fi

# Custom aliases are in ~/.aliases (sourced above)

# Homebrew install tracking function
brew_install_with_tracking() {
    command brew install "$@"
    if [ $? -eq 0 ]; then
        echo ""
        echo "📝 Would you like to add '$*' to your Brewfile? (y/n)"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            brewfile_path="$HOME/dotfiles/Brewfile"
            if [ -f "$brewfile_path" ]; then
                echo "" >> "$brewfile_path"
                echo "# $*" >> "$brewfile_path"
                echo "brew \"$*\"" >> "$brewfile_path"
                echo "✅ Added 'brew \"$*\"' to Brewfile"
            else
                echo "⚠️  Brewfile not found at $brewfile_path"
            fi
        fi
    fi
}

# Override brew command for install operations
brew() {
    if [[ "$1" == "install" ]]; then
        brew_install_with_tracking "${@:2}"
    else
        command brew "$@"
    fi
}

# Show random alias tips on startup
if [[ -o interactive ]] && [[ -t 0 ]] && [[ -t 1 ]]; then
    bash "$HOME/dotfiles/show-alias-tips.sh"
fi

# bun completions
[ -s "/Users/olivergilbey/.bun/_bun" ] && source "/Users/olivergilbey/.bun/_bun"
