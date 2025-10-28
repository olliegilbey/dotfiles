# Pure Zsh Configuration - Modernized October 2025
# Optimized for speed, clarity, and Warp terminal compatibility

# Debug marker for troubleshooting
export ZSHRC_LOADED="$(date +%s)"

# ==============================================================================
# PATH MANAGEMENT
# ==============================================================================
# All PATH modifications centralized for clarity and performance.

# Homebrew - THIS MUST BE FIRST
if [ -x "/opt/homebrew/bin/brew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Base system paths (prepend to preserve existing PATH)
export PATH="/usr/local/sbin:/usr/local/bin:$PATH"

# Homebrew completion paths
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

# ==============================================================================
# ZSH CONFIGURATION
# ==============================================================================

# History Configuration
export HISTSIZE=50000
export SAVEHIST=50000
export HISTFILE=~/.zsh_history
setopt share_history          # Share between sessions
setopt hist_ignore_dups       # Skip duplicate entries
setopt hist_ignore_space      # Ignore commands starting with space
setopt append_history         # Append rather than overwrite

# Completion system
autoload -Uz compinit
# Only regenerate .zcompdump once a day for faster startup
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
# Better completion menu
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ==============================================================================
# MANUAL PLUGINS
# ==============================================================================

# zsh-autosuggestions (manual install via Homebrew)
if [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  ZSH_AUTOSUGGEST_USE_ASYNC=true
  ZSH_AUTOSUGGEST_MANUAL_REBIND=true
fi

# zsh-syntax-highlighting (manual install via Homebrew) - MUST BE LAST PLUGIN
if [ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# ==============================================================================
# GIT ALIASES (from Oh-My-Zsh git plugin)
# ==============================================================================

# Status and info
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gst='git status'
alias gss='git status -s'
alias gd='git diff'
alias gds='git diff --staged'

# Commit
alias gc='git commit -v'
alias gc!='git commit -v --amend'
alias gcn!='git commit -v --no-edit --amend'
alias gcmsg='git commit -m'

# Branches
alias gb='git branch'
alias gba='git branch -a'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gbd='git branch -d'
alias gbD='git branch -D'

# Remote operations
alias gl='git pull'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpsup='git push --set-upstream origin $(git symbolic-ref --short HEAD)'

# Logs
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'
alias glg='git log --stat'

# Stash
alias gsta='git stash'
alias gstaa='git stash apply'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'

# ==============================================================================
# GOLANG ALIASES (from Oh-My-Zsh golang plugin)
# ==============================================================================

alias gob='go build'
alias gor='go run'
alias goc='go clean'
alias goi='go install'
alias got='go test'
alias gof='go fmt'
alias gofa='go fmt ./...'

# ==============================================================================
# RUST ALIASES (from Oh-My-Zsh rust plugin)
# ==============================================================================

alias cr='cargo run'
alias cb='cargo build'
alias cbr='cargo build --release'
alias ct='cargo test'
alias cc='cargo check'
alias ccl='cargo clippy'
alias cca='cargo clean'
alias cu='cargo update'

# ==============================================================================
# VERSION MANAGERS & TOOLS
# ==============================================================================

# Python via uv - lazy load completions for performance
if command -v uv &>/dev/null; then
    # Cache completion for faster startup
    uv_completion_cache="$HOME/.cache/uv-completion.zsh"
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
    mise_completion_cache="$HOME/.cache/mise-completion.zsh"
    if [[ ! -f "$mise_completion_cache" ]] || [[ "$mise_completion_cache" -ot "$(which mise)" ]]; then
        mkdir -p "$(dirname "$mise_completion_cache")"
        mise completion zsh > "$mise_completion_cache"
    fi
    source "$mise_completion_cache"
fi

# Bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# zoxide (modern cd replacement) with z command (cd stays normal)
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

# ==============================================================================
# STARSHIP PROMPT (for Ghostty and other terminals, disabled in Warp)
# ==============================================================================

if [[ "$TERM_PROGRAM" != "WarpTerminal" ]] && command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# ==============================================================================
# REMOTE DEVELOPMENT: Auto-attach to Zellij on SSH
# ==============================================================================

if [[ -n "$SSH_CONNECTION" ]] && [[ -z "$ZELLIJ" ]]; then
    # Only auto-attach if we're in an SSH session and not already in Zellij

    # Show welcome message
    if [[ -f "$HOME/.config/remote/motd.sh" ]]; then
        "$HOME/.config/remote/motd.sh"
        echo ""
        echo -e "\033[2m(Press Enter to continue to Zellij session...)\033[0m"
        read -r
    fi

    # Auto-attach to persistent "remote" session (create if doesn't exist)
    # exec replaces the shell process, so when user detaches, SSH session ends cleanly
    exec zellij attach --create remote
fi

# ==============================================================================
# CUSTOM ALIASES
# ==============================================================================

# Source custom aliases from ~/.aliases
[ -f "$HOME/.aliases" ] && source "$HOME/.aliases"

# ==============================================================================
# HOMEBREW HELPERS
# ==============================================================================

# Homebrew install tracking function
brew_install_with_tracking() {
    command brew install "$@"
    if [ $? -eq 0 ]; then
        # Parse arguments to detect cask installs
        local is_cask=false
        local package_name=""

        for arg in "$@"; do
            if [[ "$arg" == "--cask" ]]; then
                is_cask=true
            elif [[ ! "$arg" =~ ^- ]]; then
                package_name="$arg"
            fi
        done

        if [[ -z "$package_name" ]]; then
            echo "⚠️  Could not determine package name"
            return
        fi

        echo ""
        echo "📝 Would you like to add '$package_name' to your Brewfile? (y/n)"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            brewfile_path="$HOME/dotfiles/Brewfile"
            if [ -f "$brewfile_path" ]; then
                # Get description from brew info
                local desc=""
                if $is_cask; then
                    desc=$(brew info --json=v2 "$package_name" 2>/dev/null | jq -r '.casks[0].desc // empty')
                else
                    desc=$(brew info --json=v2 "$package_name" 2>/dev/null | jq -r '.formulae[0].desc // empty')
                fi

                # Format Brewfile entry
                local entry=""
                if $is_cask; then
                    entry="cask \"$package_name\""
                else
                    entry="brew \"$package_name\""
                fi

                # Add description if available
                if [[ -n "$desc" ]]; then
                    # Pad to align descriptions (3-15 spaces to reach roughly column 25)
                    local spaces=$((25 - ${#entry}))
                    if [[ $spaces -lt 3 ]]; then
                        spaces=3
                    fi
                    local padding=$(printf '%*s' $spaces '')
                    entry="${entry}${padding}# ${desc}"
                fi

                # Append to Brewfile
                echo "" >> "$brewfile_path"
                echo "$entry" >> "$brewfile_path"
                echo "✅ Added to Brewfile: $entry"
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

# ==============================================================================
# STARTUP TIPS
# ==============================================================================

# Show random alias tips on interactive shell startup
if [[ -o interactive ]] && [[ -t 0 ]] && [[ -t 1 ]]; then
    bash "$HOME/dotfiles/show-alias-tips.sh"
fi

# JASHO AI - Colored workflow DSL
[ -f "/Users/olliegilbey/code/jasho/jai/scripts/color_runner.sh" ] && source "/Users/olliegilbey/code/jasho/jai/scripts/color_runner.sh"
# JASHO AI - Pair notification
[ -f "/Users/olliegilbey/code/jasho/jai/scripts/notify_pair.sh" ] && source "/Users/olliegilbey/code/jasho/jai/scripts/notify_pair.sh"

# JASHO AI - Add ~/bin to PATH
export PATH="$HOME/bin:$PATH"
