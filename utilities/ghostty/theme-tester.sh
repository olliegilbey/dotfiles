#!/usr/bin/env bash
#
# Ghostty Theme Tester
# Interactive script to preview different themes
#

set -e

# Colors
readonly CYAN='\033[36m'
readonly GREEN='\033[32m'
readonly YELLOW='\033[33m'
readonly RED='\033[31m'
readonly BLUE='\033[34m'
readonly MAGENTA='\033[35m'
readonly NC='\033[0m'

CONFIG_FILE="$HOME/.config/ghostty/config"

# Curated dark themes that work well with teal→black gradient
THEMES=(
    "TokyoNight Storm"
    "TokyoNight Night"
    "Catppuccin Mocha"
    "Dracula"
    "Gruvbox Dark"
    "Gruvbox Material Dark"
    "Nord"
    "Atom One Dark"
    "Monokai Pro"
    "Cyberpunk"
    "Ayu Mirage"
)

show_preview() {
    local current_theme=$(get_current_theme)
    clear
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}  Ghostty Theme Preview${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "  ${GREEN}Current Theme:${NC} ${MAGENTA}$current_theme${NC}"
    echo ""

    # Show colorful output examples
    echo -e "${GREEN}✓${NC} Successfully connected to server"
    echo -e "${YELLOW}⚠${NC} Warning: Configuration file outdated"
    echo -e "${RED}✗${NC} Error: Failed to compile main.rs:42"
    echo -e "${BLUE}ℹ${NC} Info: 15 packages updated"
    echo -e "${MAGENTA}→${NC} Running tests..."
    echo ""

    # Command examples with syntax highlighting
    echo -e "${CYAN}\$ ${NC}ls -la${YELLOW} ~/code${NC}"
    echo -e "${GREEN}drwxr-xr-x${NC}  12 olliegilbey  staff    384 Oct 27 12:34 ${BLUE}dotfiles${NC}"
    echo -e "${GREEN}drwxr-xr-x${NC}   8 olliegilbey  staff    256 Oct 26 18:22 ${BLUE}jasho${NC}"
    echo -e "${GREEN}-rw-r--r--${NC}   1 olliegilbey  staff   1024 Oct 25 09:15 ${YELLOW}README.md${NC}"
    echo ""

    echo -e "${CYAN}\$ ${NC}git status"
    echo -e "On branch ${GREEN}main${NC}"
    echo -e "Your branch is up to date with ${CYAN}'origin/main'${NC}"
    echo ""
    echo -e "Changes not staged for commit:"
    echo -e "  ${RED}modified:   ${NC}src/.zshrc"
    echo -e "  ${GREEN}new file:   ${NC}config/ghostty.conf"
    echo ""

    echo -e "${CYAN}\$ ${NC}npm run dev"
    echo -e "${GREEN}> ${NC}next dev"
    echo -e "${CYAN}  - Local:        ${NC}http://localhost:3000"
    echo -e "${GREEN}✓ Ready${NC} in 1.2s"
    echo ""

    # Programming language examples
    echo -e "${MAGENTA}fn${NC} ${YELLOW}main${NC}() {"
    echo -e "    ${MAGENTA}let${NC} message = ${GREEN}\"Hello, World!\"${NC};"
    echo -e "    println!({}, message);"
    echo -e "}"
    echo ""

    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

get_current_theme() {
    if [ -f "$CONFIG_FILE" ]; then
        grep '^theme = ' "$CONFIG_FILE" | sed 's/theme = "\(.*\)"/\1/' || echo "None"
    else
        echo "None"
    fi
}

set_theme() {
    local theme=$1

    # Update config file with new theme
    if grep -q '^theme = ' "$CONFIG_FILE"; then
        # Replace existing theme line (using | as delimiter to avoid / conflicts)
        sed -i.bak "s|^theme = .*|theme = \"$theme\"|" "$CONFIG_FILE"
    else
        # Add theme line after THEME section header
        sed -i.bak "/# THEME & COLORS/a\\
theme = \"$theme\"
" "$CONFIG_FILE"
    fi

    # Remove backup file
    rm -f "$CONFIG_FILE.bak"

    echo -e "${GREEN}✓${NC} Theme changed: ${MAGENTA}$theme${NC}"
    echo -e "${YELLOW}⟳${NC} Open new window (Cmd+N) or tab (Cmd+T) to see changes"
    echo ""
    echo -e "${CYAN}Note:${NC} The gradient shader affects background only"
    echo -e "      You'll see theme differences mainly in text colors"
}

main() {
    while true; do
        clear
        local current_theme=$(get_current_theme)
        echo ""
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${CYAN}  Ghostty Theme Selector${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        echo -e "  ${GREEN}Current theme:${NC} ${MAGENTA}$current_theme${NC}"
        echo ""
        echo -e "  Select a theme to try (all work well with teal→black gradient):"
        echo ""

        local i=1
        for theme in "${THEMES[@]}"; do
            if [ "$theme" = "$current_theme" ]; then
                echo -e "  ${CYAN}$i${NC}. $theme ${GREEN}← current${NC}"
            else
                echo -e "  ${CYAN}$i${NC}. $theme"
            fi
            ((i++))
        done

        echo ""
        echo -e "  ${CYAN}p${NC}. Show preview"
        echo -e "  ${CYAN}q${NC}. Quit"
        echo ""
        echo -ne "${YELLOW}Choose a theme (1-${#THEMES[@]}, p, q): ${NC}"

        read -r choice

        case "$choice" in
            p|P)
                show_preview
                echo ""
                echo -ne "${YELLOW}Press Enter to continue...${NC}"
                read -r
                ;;
            q|Q)
                echo ""
                echo -e "${GREEN}✓${NC} Done! Restart Ghostty to see your theme."
                echo ""
                exit 0
                ;;
            [1-9]|1[0-1])
                if [ "$choice" -le "${#THEMES[@]}" ]; then
                    theme="${THEMES[$((choice-1))]}"
                    set_theme "$theme"
                    echo ""
                    show_preview
                    echo ""
                    echo -ne "${YELLOW}Press Enter to try another theme...${NC}"
                    read -r
                else
                    echo -e "${RED}Invalid choice${NC}"
                    sleep 1
                fi
                ;;
            *)
                echo -e "${RED}Invalid choice${NC}"
                sleep 1
                ;;
        esac
    done
}

main
