#!/usr/bin/env bash

set -e  # Exit on any error
set -u  # Exit on undefined variables
set -o pipefail  # Exit on pipe failures

# Script directory for relative paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
README_FILE="$SCRIPT_DIR/README.md"
BREWFILE="$SCRIPT_DIR/Brewfile"

echo "📝 Updating README.md with current configuration..."

# Check if README has the generated content marker
MARKER="<!-- GENERATED_CONTENT_STARTS_HERE -->"
if ! grep -q "$MARKER" "$README_FILE"; then
    echo "⚠️  Warning: README.md is missing the generated content marker."
    echo "   Please add this line where you want generated content to start:"
    echo "   $MARKER"
    echo "   Aborting to prevent overwriting your content."
    exit 1
fi

# Create temporary file for the new README
TEMP_README=$(mktemp)

# Extract everything before the marker (including the marker line)
sed "/$MARKER/q" "$README_FILE" > "$TEMP_README"

# Function to categorize packages based on their comments in Brewfile
categorize_package() {
    local package="$1"
    local comment="$2"
    
    # Convert to lowercase for easier matching
    local lower_comment=$(echo "$comment" | tr '[:upper:]' '[:lower:]')
    
    # Special case handling for specific packages
    if [[ "$package" == "neovim" || "$package" == "vim" ]]; then
        echo "Editors"
    elif [[ "$package" == "git" || "$package" == "git-extras" || "$package" == "gh" || "$package" == "lazygit" ]]; then
        echo "Version Control"
    elif [[ "$package" == "uv" || "$package" == "bun" || "$package" == "mise" ]]; then
        echo "Package Managers & Runtimes"
    elif [[ "$package" == "bat" || "$package" == "eza" || "$package" == "ripgrep" || "$package" == "fd" || "$package" == "delta" || "$package" == "zoxide" || "$package" == "fzf" ]]; then
        echo "Modern Command-Line Tools"
    # Category detection based on comments (order matters - more specific first)
    elif [[ "$lower_comment" =~ (package.?manager|runtime|installer) ]]; then
        echo "Package Managers & Runtimes"
    elif [[ "$lower_comment" =~ (language|programming|compiler|interpreter) ]]; then
        echo "Development Languages"
    elif [[ "$lower_comment" =~ (editor|vim|text) ]]; then
        echo "Editors"
    elif [[ "$lower_comment" =~ (git|version.?control|repository) ]]; then
        echo "Version Control"
    elif [[ "$lower_comment" =~ (command.?line|cli|terminal|shell|modern|replacement|alternative) ]]; then
        echo "Modern Command-Line Tools"
    elif [[ "$lower_comment" =~ (utility|tool|system|network|image|file) ]]; then
        echo "System Utilities"
    elif [[ "$lower_comment" =~ (font|typeface) ]]; then
        echo "Fonts"
    elif [[ "$lower_comment" =~ (security|auth|password|credential) ]]; then
        echo "Security Tools"
    else
        echo "Other Tools"
    fi
}

# Generate dynamic content
{
    echo ""
    
    # Language toolchains section first (shorter, more important)
    if [[ -f "$SCRIPT_DIR/.mise.toml" ]]; then
        echo "## 🔧 Language Toolchains"
        echo ""
        echo "Managed for consistent versions across environments:"
        echo ""
        
        # Extract tools from .mise.toml
        if grep -A 10 '^\[tools\]' "$SCRIPT_DIR/.mise.toml" | grep -v '^\[' | grep '=' | while read -r line; do
            if [[ "$line" =~ ^([^=]+)=[[:space:]]*\"([^\"]+)\" ]] || [[ "$line" =~ ^([^=]+)=[[:space:]]*([^#]+) ]]; then
                tool="${BASH_REMATCH[1]// /}"
                version="${BASH_REMATCH[2]// /}"
                version="${version//\"/}"
                echo "- **$tool** - $version (via mise)"
            fi
        done; then
            echo ""
        fi
        
        # Add Rust separately since it's managed by rustup
        echo "- **rust** - latest stable (via rustup)"
        echo ""
    fi
    
    echo "## 📦 Package Environment"
    echo ""
    
    if [[ -f "$BREWFILE" ]]; then
        # Count different types
        brew_count=$(grep -c '^brew' "$BREWFILE" 2>/dev/null || echo 0)
        cask_count=$(grep -c '^cask' "$BREWFILE" 2>/dev/null || echo 0)
        tap_count=$(grep -c '^tap' "$BREWFILE" 2>/dev/null || echo 0)
        
        echo "Currently managing **$brew_count packages**, **$cask_count casks**, and **$tap_count taps** via Brewfile."
        echo ""
        
        # Create temporary files for each category
        TEMP_DIR=$(mktemp -d)
        
        # Parse Brewfile and categorize packages
        while IFS= read -r line; do
            if [[ "$line" =~ ^brew[[:space:]]+\"([^\"]+)\"[[:space:]]*#?[[:space:]]*(.*) ]]; then
                package="${BASH_REMATCH[1]}"
                comment="${BASH_REMATCH[2]}"
                category=$(categorize_package "$package" "$comment")
                
                # Create category file if it doesn't exist
                category_file="$TEMP_DIR/$(echo "$category" | tr ' ' '_')"
                echo "$package|$comment" >> "$category_file"
            fi
        done < "$BREWFILE"
        
        # Output categories in a logical order
        category_order=(
            "Development Languages"
            "Modern Command-Line Tools" 
            "Editors"
            "Version Control"
            "Package Managers & Runtimes"
            "System Utilities"
            "Security Tools"
            "Fonts"
            "Other Tools"
        )
        
        for category in "${category_order[@]}"; do
            category_file="$TEMP_DIR/$(echo "$category" | tr ' ' '_')"
            if [[ -f "$category_file" ]]; then
                echo "### $category"
                echo ""
                
                # Sort and output packages in this category
                sort "$category_file" | while IFS='|' read -r package comment; do
                    if [[ -n "$package" ]]; then
                        if [[ -n "$comment" ]]; then
                            echo "- **$package** - $comment"
                        else
                            echo "- **$package**"
                        fi
                    fi
                done
                echo ""
            fi
        done
        
        # Clean up temporary directory
        rm -rf "$TEMP_DIR"
        
    else
        echo "❌ Brewfile not found at $BREWFILE"
        echo ""
    fi
    
    echo "## 🏥 Health Check"
    echo ""
    echo "Run \`dotfiles-health\` to verify your environment:"
    echo ""
    echo "\`\`\`bash"
    echo "dotfiles-health"
    echo "\`\`\`"
    echo ""
    echo "This validates all tools, language runtimes, and configurations."
    echo ""
    
    echo "---"
    echo ""
    echo "*Last updated: $(date '+%Y-%m-%d %H:%M:%S')*"
    
} >> "$TEMP_README"

# Replace the original README with the updated version
mv "$TEMP_README" "$README_FILE"

echo "✅ README.md updated successfully!"
echo "📊 Stats:"
echo "   Lines: $(wc -l < "$README_FILE")"
echo "   Size: $(du -h "$README_FILE" | cut -f1)"

# Make the update script executable
chmod +x "$SCRIPT_DIR/update-readme.sh"