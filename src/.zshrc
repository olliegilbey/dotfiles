# General Configuration
export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nvim"

# Oh-my-zsh core
source $ZSH/oh-my-zsh.sh

# Plugins
plugins=(
  nvm
  node
  golang
  rust
  git-extras
  macos
  yarn
  zsh-completions
  wd
  python
  vi-mode
  colorize
  docker
  docker-compose
  zsh-syntax-highlighting
  history
  pipenv
  compleat
  zsh-autosuggestions
)

# Additional Setup for Plugins
autoload -U compinit && compinit
fpath+=${ZSH_CUSTOM:-${ZSH}/custom}/plugins/zsh-completions/src

# GOPATH Configuration
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$PATH:$GOBIN"

# Other Configuration
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
eval "$(fnm env --use-on-cd)"
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"

# Source Aliases
[ -f "$HOME/.aliases" ] && source "$HOME/.aliases"

# Starship Prompt
eval "$(starship init zsh)"

# Change cd to zoxide
eval "$(zoxide init --cmd cd zsh)"


# fnm
export PATH="/Users/olivergilbey/Library/Application Support/fnm:$PATH"
eval "`fnm env`"
