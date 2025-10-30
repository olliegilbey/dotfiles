#!/usr/bin/env bash

# Script to show random alias tips on startup (reads inline descriptions)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ALIASES_FILE="$SCRIPT_DIR/src/.aliases"

# Only show tips if aliases file exists
[[ ! -f "$ALIASES_FILE" ]] && exit 0

# Function to extract aliases with descriptions from inline comments
extract_aliases_with_descriptions() {
    local file="$1"
    if [[ -f "$file" ]]; then
        # Find alias definitions with trailing comments
        # Pattern: alias name='command'  # description
        grep -E '^[[:space:]]*alias [a-zA-Z0-9_-]+=' "$file" | while IFS= read -r line; do
            # Check if line has a description comment
            if [[ "$line" == *"#"* ]]; then
                # Extract alias name
                alias_name=$(echo "$line" | sed -E 's/^[[:space:]]*alias ([^=]*)=.*/\1/')
                # Extract description (everything after the last #)
                description=$(echo "$line" | sed 's/.*#[[:space:]]*//')

                # Only include if description is not empty
                if [[ -n "$description" && "$description" != "" ]]; then
                    echo "$alias_name::$description"
                fi
            fi
        done
    fi
}

# Function to extract just commands from justfile
extract_just_commands() {
    local justfile="$SCRIPT_DIR/justfile"
    if [[ -f "$justfile" ]]; then
        # Extract recipes with their comments
        grep -E "^[a-z].*:.*#" "$justfile" | while IFS= read -r line; do
            # Extract recipe name (before :)
            recipe_name=$(echo "$line" | sed -E 's/^([a-z][a-z0-9_-]*).*/\1/')
            # Extract description (after #)
            description=$(echo "$line" | sed 's/.*#[[:space:]]*//')

            if [[ -n "$description" && "$description" != "" ]]; then
                echo "just $recipe_name::$description"
            fi
        done
    fi
}

# Get aliases with descriptions (not empty)
aliases_with_descriptions=()
while IFS= read -r line; do
    [[ -n "$line" ]] && aliases_with_descriptions+=("$line")
done < <(extract_aliases_with_descriptions "$ALIASES_FILE")

# Add just commands to the pool
while IFS= read -r line; do
    [[ -n "$line" ]] && aliases_with_descriptions+=("$line")
done < <(extract_just_commands)

# Exit if no aliases with descriptions
if [[ ${#aliases_with_descriptions[@]} -eq 0 ]]; then
    exit 0
fi

# Pick 2 random aliases (or fewer if we don't have enough)
num_aliases=${#aliases_with_descriptions[@]}
num_to_show=$((num_aliases >= 2 ? 2 : num_aliases))

# Generate random indices
selected_indices=()
while [[ ${#selected_indices[@]} -lt $num_to_show ]]; do
    random_index=$((RANDOM % num_aliases))
    # Check if we already selected this index
    if [[ ! " ${selected_indices[@]} " =~ " ${random_index} " ]]; then
        selected_indices+=($random_index)
    fi
done

# Colors for output
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Show the tips
echo ""
echo -e "${BLUE}💡 Alias Tips${NC}"
echo -e "${BLUE}═══════════════${NC}"

for i in "${selected_indices[@]}"; do
    line="${aliases_with_descriptions[$i]}"
    alias_name="${line%%::*}"
    description="${line#*::}"
    echo -e "${GREEN}$alias_name${NC} - ${YELLOW}$description${NC}"
done

echo ""
