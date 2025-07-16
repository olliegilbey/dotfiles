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
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="/opt/homebrew/lib/ruby/gems/3.4.0/bin:$PATH"
export PATH=$PATH:$(go env GOPATH)/bin
export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:$(go env GOPATH)/bin
export PATH=$PATH:$HOME/go/bin
export l5rpc=https://rpc.lavenderfive.com:443/cosmoshub

# bun completions
[ -s "/Users/olivergilbey/.bun/_bun" ] && source "/Users/olivergilbey/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

alias ctp='cargo test --color=always 2>&1 | tee /dev/tty | sed "s/\x1b\[[0-9;]*m//g" | pbcopy'
alias crp="RUST_BACKTRACE=1 cargo run --color=always 2> >(tee error.log | sed \"s/\[[0-9;]*m//g\" | pbcopy)"
export PATH=~/.npm-global/bin:$PATH
alias claude="/Users/olivergilbey/.claude/local/claude"
alias csvlint="/opt/homebrew/lib/ruby/gems/3.4.0/bin/csvlint"
