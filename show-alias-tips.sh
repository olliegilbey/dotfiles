#!/usr/bin/env bash

# Script to show random alias tips on startup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DESCRIPTIONS_FILE="$SCRIPT_DIR/alias-descriptions.txt"

# Only show tips if descriptions file exists
[[ ! -f "$DESCRIPTIONS_FILE" ]] && exit 0

# Get aliases with descriptions (not empty after ::)
aliases_with_descriptions=()
while IFS= read -r line; do
    # Skip comments and empty lines
    [[ "$line" =~ ^#.*$ ]] && continue
    [[ -z "$line" ]] && continue
    
    # Split on :: and check if description exists
    if [[ "$line" == *"::"* ]]; then
        alias_name="${line%%::*}"
        description="${line#*::}"
        if [[ -n "$description" && "$description" != "" ]]; then
            aliases_with_descriptions+=("$alias_name::$description")
        fi
    fi
done < "$DESCRIPTIONS_FILE"

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
echo -e "${BLUE}════════════${NC}"

for i in "${selected_indices[@]}"; do
    line="${aliases_with_descriptions[$i]}"
    alias_name="${line%%::*}"
    description="${line#*::}"
    echo -e "${GREEN}$alias_name${NC} - ${YELLOW}$description${NC}"
done

echo ""