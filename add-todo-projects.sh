#!/usr/bin/env bash
set -uo pipefail  # removed -e, handle errors manually

# Projects list
PROJECTS=("general" "resumate" "jasho_fe" "jasho_be" "dotfiles")
TODO_FILE="$HOME/todo.txt"
BACKUP_FILE="$HOME/todo.txt.bak"

# Colors
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly CYAN='\033[0;36m'
readonly DIM='\033[2m'
readonly NC='\033[0m'

# Create backup
cp "$TODO_FILE" "$BACKUP_FILE"
echo -e "${GREEN}✓${NC} Backed up to ${DIM}$BACKUP_FILE${NC}\n"

# Read all lines into array
mapfile -t lines < "$TODO_FILE"
total=${#lines[@]}
current=0

# Build menu options
menu_options=()
for p in "${PROJECTS[@]}"; do
  menu_options+=("$p")
done
menu_options+=("---" "skip" "back" "quit")

while [[ $current -lt $total ]]; do
  line="${lines[$current]}"

  # Skip empty lines
  if [[ -z "$line" ]]; then
    current=$((current + 1))
    continue
  fi

  # Skip if already has a project tag
  if [[ "$line" =~ \+[a-zA-Z_]+ ]]; then
    echo -e "${DIM}[$((current+1))/$total] Already tagged: $line${NC}"
    current=$((current + 1))
    continue
  fi

  echo -e "\n${CYAN}[$((current+1))/$total]${NC} $line"

  # Use fzf for selection
  selection=$(printf '%s\n' "${menu_options[@]}" | fzf --height=12 --layout=reverse --prompt="Project: " --no-info --pointer="▶") || selection="quit"

  case "$selection" in
    "---")
      # separator selected, re-show menu
      ;;
    "skip")
      current=$((current + 1))
      ;;
    "back")
      if [[ $current -gt 0 ]]; then
        current=$((current - 1))
      fi
      ;;
    "quit")
      echo -e "\n${YELLOW}⚠${NC} Exiting. Changes saved so far."
      break
      ;;
    *)
      # Add project tag after date
      # Pattern: optional "x " + date + rest
      if [[ "$line" =~ ^(x\ )?([-0-9]+)\ (.*)$ ]]; then
        prefix="${BASH_REMATCH[1]:-}"
        date="${BASH_REMATCH[2]}"
        rest="${BASH_REMATCH[3]}"
        lines[$current]="${prefix}${date} +${selection} ${rest}"
        # Write immediately after each change
        printf '%s\n' "${lines[@]}" > "$TODO_FILE"
        echo -e "${GREEN}✓${NC} Tagged as ${GREEN}+${selection}${NC}"
      else
        echo -e "${YELLOW}⚠${NC} Line format not recognized, skipping tag"
      fi
      current=$((current + 1))
      ;;
  esac
done

# Write back to file
printf '%s\n' "${lines[@]}" > "$TODO_FILE"
echo -e "\n${GREEN}✓${NC} Saved to ${DIM}$TODO_FILE${NC}"
echo -e "${DIM}Restore with: cp $BACKUP_FILE $TODO_FILE${NC}"
