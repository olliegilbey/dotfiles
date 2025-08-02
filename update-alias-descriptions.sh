#!/usr/bin/env bash

set -e

# Script to detect aliases and maintain descriptions file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DESCRIPTIONS_FILE="$SCRIPT_DIR/alias-descriptions.txt"
ALIASES_FILE="$SCRIPT_DIR/src/.aliases"

echo "🔍 Scanning for aliases..."

# Create descriptions file if it doesn't exist
if [[ ! -f "$DESCRIPTIONS_FILE" ]]; then
    echo "# Alias Descriptions" > "$DESCRIPTIONS_FILE"
    echo "# Format: alias_name::description" >> "$DESCRIPTIONS_FILE"
    echo "# Leave description blank if you don't want it in startup reminders" >> "$DESCRIPTIONS_FILE"
    echo "" >> "$DESCRIPTIONS_FILE"
fi

# Function to extract aliases from a file
extract_aliases() {
    local file="$1"
    if [[ -f "$file" ]]; then
        # Find alias definitions (alias name='command' or alias name="command")
        grep -E '^alias [a-zA-Z0-9_-]+=' "$file" | sed 's/alias \([^=]*\)=.*/\1/' | sort -u
    fi
}

# Function to check if alias already exists in descriptions file
alias_exists_in_descriptions() {
    local alias_name="$1"
    grep -q "^$alias_name::" "$DESCRIPTIONS_FILE" 2>/dev/null
}

# Scan for aliases
echo "📝 Detecting aliases from:"
echo "  - $ALIASES_FILE"

# Get all aliases
aliases_found=()
while IFS= read -r alias_name; do
    [[ -n "$alias_name" ]] && aliases_found+=("$alias_name")
done < <(extract_aliases "$ALIASES_FILE")

# Also check .zshrc for any aliases there
if [[ -f "$SCRIPT_DIR/src/.zshrc" ]]; then
    echo "  - $SCRIPT_DIR/src/.zshrc"
    while IFS= read -r alias_name; do
        [[ -n "$alias_name" ]] && aliases_found+=("$alias_name")
    done < <(extract_aliases "$SCRIPT_DIR/src/.zshrc")
fi

# Remove duplicates and sort
aliases_found=($(printf '%s\n' "${aliases_found[@]}" | sort -u))

echo "✅ Found ${#aliases_found[@]} aliases"

# Add new aliases to descriptions file
new_aliases=0
for alias_name in "${aliases_found[@]}"; do
    if ! alias_exists_in_descriptions "$alias_name"; then
        echo "$alias_name::" >> "$DESCRIPTIONS_FILE"
        ((new_aliases++))
    fi
done

if [[ $new_aliases -gt 0 ]]; then
    echo "📋 Added $new_aliases new aliases to descriptions file"
    echo "📝 Edit $DESCRIPTIONS_FILE to add descriptions for startup reminders"
else
    echo "✅ All aliases already in descriptions file"
fi

echo ""
echo "🎯 To enable startup reminders:"
echo "   1. Edit $DESCRIPTIONS_FILE"
echo "   2. Add descriptions after '::' for aliases you want featured"
echo "   3. Example: 'll::Enhanced ls with icons and git status'"