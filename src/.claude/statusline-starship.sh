#!/bin/bash
# StatusLine script matching Starship prompt configuration
# Format: directory | git_branch git_status git_metrics | time

set -e -u -o pipefail

# Read JSON input
input=$(cat)

# Extract current directory and model info
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name // "Claude"')

# Colors (dimmed for status line)
CYAN='\033[36m'
YELLOW='\033[33m'
WHITE='\033[37m'
GREEN='\033[32m'
RED='\033[31m'
DIM='\033[2m'
MAGENTA='\033[35m'
RESET='\033[0m'

# Directory formatting with substitutions from starship.toml
format_dir() {
    local dir="$1"
    dir="${dir/#$HOME\/code\/jasho/\~\/jasho}"
    dir="${dir/#$HOME\/code/\~\/code}"
    dir="${dir/#$HOME\/dotfiles/\~\/dotfiles}"
    dir="${dir/#$HOME/\~}"

    # Truncate to 4 levels
    echo "$dir" | awk -F/ '{
        if (NF > 4) {
            printf ".../"
            for (i = NF-2; i <= NF; i++) {
                printf "%s", $i
                if (i < NF) printf "/"
            }
        } else {
            print $0
        }
    }'
}

# Git info (skip optional locks)
get_git_info() {
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        return
    fi

    local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)

    # Status counts
    local status_output=$(git --no-optional-locks status --porcelain=v1 2>/dev/null)
    local modified=$(echo "$status_output" | grep -c '^ M' || true)
    local staged=$(echo "$status_output" | grep -c '^[MARC]' || true)
    local untracked=$(echo "$status_output" | grep -c '^??' || true)
    local deleted=$(echo "$status_output" | grep -c '^ D' || true)

    # Ahead/behind
    local ahead_behind=$(git --no-optional-locks rev-list --left-right --count HEAD...@{upstream} 2>/dev/null || echo "0 0")
    local ahead=$(echo "$ahead_behind" | awk '{print $1}')
    local behind=$(echo "$ahead_behind" | awk '{print $2}')

    # Metrics
    local metrics=$(git --no-optional-locks diff --shortstat 2>/dev/null)
    local added=$(echo "$metrics" | sed -n 's/.* \([0-9]*\) insertion.*/\1/p')
    local removed=$(echo "$metrics" | sed -n 's/.* \([0-9]*\) deletion.*/\1/p')

    # Build git string
    local git_str="${YELLOW}${branch}${RESET}"

    # Status
    local status_parts=""
    [[ $ahead -gt 0 ]] && status_parts="${status_parts}⇡${ahead} "
    [[ $behind -gt 0 ]] && status_parts="${status_parts}⇣${behind} "
    [[ $untracked -gt 0 ]] && status_parts="${status_parts}?${untracked} "
    [[ $modified -gt 0 ]] && status_parts="${status_parts}!${modified} "
    [[ $staged -gt 0 ]] && status_parts="${status_parts}+${staged} "
    [[ $deleted -gt 0 ]] && status_parts="${status_parts}✘${deleted} "

    [[ -n "$status_parts" ]] && git_str="${git_str} ${WHITE}${status_parts}${RESET}"

    # Metrics
    if [[ -n "$added" || -n "$removed" ]]; then
        git_str="${git_str} "
        [[ -n "$added" ]] && git_str="${git_str}${GREEN}+${added}${RESET} "
        [[ -n "$removed" ]] && git_str="${git_str}${RED}-${removed}${RESET}"
    fi

    echo -e "$git_str"
}

# Build status line
formatted_dir=$(format_dir "$cwd")
git_info=$(get_git_info)
current_time=$(date +%H:%M)

if [[ -n "$git_info" ]]; then
    printf "${CYAN}%s${RESET} | %s | ${MAGENTA}%s${RESET} | ${DIM}${WHITE}%s${RESET}" "$formatted_dir" "$git_info" "$model" "$current_time"
else
    printf "${CYAN}%s${RESET} | ${MAGENTA}%s${RESET} | ${DIM}${WHITE}%s${RESET}" "$formatted_dir" "$model" "$current_time"
fi
