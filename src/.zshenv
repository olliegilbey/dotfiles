# Environment variables loaded by all shell sessions
# This file should be kept minimal and fast.

# Homebrew PATH (required for SSH sessions)
# Apple Silicon Macs (M1/M2/M3)
if [[ -d "/opt/homebrew/bin" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
# Intel Macs
elif [[ -d "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Set the default editor
export EDITOR='nvim'

# Default development directory (customize as needed)
export DEV_DIR="$HOME/code"
export WORK_DIR="$HOME/code/jasho"

# Set vi mode switching to 100ms instead of default 400ms
export KEYTIMEOUT=1

# Increase Bash history size. Allow 32³ entries; the default is 500.
export HISTSIZE='32768'
export HISTFILESIZE="${HISTSIZE}"
# Omit duplicates and commands that begin with a space from history.
export HISTCONTROL='ignoreboth'

# Prefer US English and use UTF-8.
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

# Highlight section titles in manual pages.
export LESS_TERMCAP_md="${yellow}"

# Don’t clear the screen after quitting a manual page.
export MANPAGER='less -X'

# Homebrew temp directory
export HOMEBREW_TEMP=/usr/local/homebrew_temp

# Go Path
export GOPATH=$HOME/go

# Stop tmux from renaming windows
DISABLE_AUTO_TITLE=true
