#!/usr/bin/env bash
# Dynamic welcome message for remote SSH connections

# Colors
CYAN='\033[36m'
GREEN='\033[32m'
YELLOW='\033[33m'
BOLD='\033[1m'
NC='\033[0m'

# Get hostname
HOSTNAME=$(hostname -s)

# Get Tailscale DNS name
TAILSCALE_HOST=$(tailscale status --json 2>/dev/null | \
    grep -o '"DNSName":"[^"]*"' | cut -d'"' -f4 | sed 's/\.$//' | head -n1)

if [[ -z "$TAILSCALE_HOST" ]]; then
    # Fallback if tailscale command fails - construct from hostname
    TAILSCALE_HOST="${HOSTNAME}.tail7a4b9.ts.net"
fi

# Display welcome message
echo ""
echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  ${BOLD}🚀 ${GREEN}${HOSTNAME}${NC} ${CYAN}(Remote Development)${NC}"
echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  ${YELLOW}Session:${NC} remote"
echo -e "  ${YELLOW}Detach:${NC}  ${GREEN}Ctrl+s d${NC}"
echo -e "  ${YELLOW}Help:${NC}    ${GREEN}Ctrl+p ?${NC}"
echo ""
echo -e "  ${YELLOW}📡 Frontend:${NC} ${GREEN}devserver 3000${NC}"
echo -e "     ${CYAN}http://${TAILSCALE_HOST}:3000${NC}"
echo ""
echo -e "  ${YELLOW}📚 Commands:${NC} ${GREEN}just code${NC} | ${GREEN}just tips${NC} | ${GREEN}just sessions${NC}"
echo ""
echo -e "  ${YELLOW}💡 New to Zellij?${NC} ${CYAN}cat ~/dotfiles/remote/ZELLIJ_CHEATSHEET.md${NC}"
echo ""
echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Show random alias tip
if [[ -f "$HOME/dotfiles/show-alias-tips.sh" ]]; then
    bash "$HOME/dotfiles/show-alias-tips.sh"
fi
