#!/usr/bin/env bash
#
# remote/setup-server.sh - Configure Mac as remote development server
#
# Sets up SSH auto-attachment to Zellij, MOTD, and power management

set -e -u -o pipefail

# Colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

# Error handler - show clear message when script exits unexpectedly
trap 'echo -e "\n${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"; echo -e "${RED}❌ Setup failed at line $LINENO${NC}"; echo -e "${RED}⚠️  The remaining setup steps were NOT completed${NC}"; echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"; exit 1' ERR

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}        Remote Development Server Setup${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check prerequisites
echo -e "${CYAN}Checking prerequisites...${NC}"

# Check Tailscale
if ! command -v tailscale >/dev/null 2>&1; then
    echo -e "${RED}✗ Tailscale not installed${NC}"
    echo "Please install Tailscale first: brew install --cask tailscale"
    exit 1
fi

if ! tailscale status >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠ Tailscale not authenticated${NC}"
    echo "Please run: sudo tailscale up"
    exit 1
fi
echo -e "${GREEN}✓ Tailscale is installed and authenticated${NC}"

# Check Zellij
if ! command -v zellij >/dev/null 2>&1; then
    echo -e "${RED}✗ Zellij not installed${NC}"
    echo "Please install Zellij first: brew install zellij"
    exit 1
fi
echo -e "${GREEN}✓ Zellij is installed${NC}"

# Check SSH is enabled
if ! sudo systemsetup -getremotelogin | grep -q "On"; then
    echo -e "${YELLOW}⚠ SSH (Remote Login) is not enabled${NC}"
    read -p "Enable SSH now? (y/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo systemsetup -setremotelogin on
        echo -e "${GREEN}✓ SSH enabled${NC}"
    else
        echo -e "${RED}✗ SSH must be enabled for remote development${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✓ SSH is enabled${NC}"
fi

echo ""

# Install MOTD script
echo -e "${CYAN}Installing welcome message (MOTD)...${NC}"
MOTD_DIR="$HOME/.config/remote"
mkdir -p "$MOTD_DIR"
cp "$SCRIPT_DIR/templates/motd.sh" "$MOTD_DIR/motd.sh"
chmod +x "$MOTD_DIR/motd.sh"
echo -e "${GREEN}✓ MOTD installed to ~/.config/remote/motd.sh${NC}"

# Configure power management for server mode
echo ""
echo -e "${CYAN}Configuring power management for server mode...${NC}"
echo ""
echo "Server mode optimizes for always-on reliability:"
echo "  • AC Power: Never sleep (server mode)"
echo "  • Battery: Normal sleep (preserves battery when traveling)"
echo "  • Auto-restart after power failure"
echo "  • Wake on network access"
echo ""

# Check if running interactively
CONFIGURE_POWER="y"
if [[ -t 0 ]]; then
    read -p "Configure server power management? (Y/n): " -n 1 -r
    echo ""
    CONFIGURE_POWER="$REPLY"
else
    echo -e "${YELLOW}ℹ️  Non-interactive mode: Skipping power management setup${NC}"
    echo -e "${YELLOW}   Run './remote/setup-server.sh' manually to configure${NC}"
    CONFIGURE_POWER="n"
fi

if [[ ! $CONFIGURE_POWER =~ ^[Nn]$ ]]; then
    # Server mode (AC power - plugged in at home)
    sudo pmset -c sleep 0          # Never sleep on AC
    sudo pmset -c displaysleep 10  # Display can sleep after 10 min
    sudo pmset -c disksleep 0      # Disk never sleeps

    # Portable mode (Battery - when traveling)
    sudo pmset -b sleep 15         # Sleep after 15 min on battery
    sudo pmset -b displaysleep 5   # Display sleeps after 5 min
    sudo pmset -b disksleep 10     # Disk sleeps after 10 min

    # All power modes (reliability features)
    sudo pmset -a womp 1           # Wake on network access
    sudo pmset -a autorestart 1    # Auto-restart after power failure
    sudo pmset -a powernap 0       # Disable Power Nap (prevents unexpected wakes)

    echo -e "${GREEN}✓ Power management configured${NC}"
    echo ""
    echo -e "  ${GREEN}Server Mode (AC Power):${NC}"
    echo "    • Never sleeps when plugged in"
    echo "    • Display sleeps after 10 minutes"
    echo "    • Always available for SSH"
    echo ""
    echo -e "  ${GREEN}Portable Mode (Battery):${NC}"
    echo "    • Sleeps after 15 minutes (preserves battery)"
    echo "    • Normal battery management"
    echo ""
    echo -e "  ${GREEN}Reliability:${NC}"
    echo "    • Auto-restarts after power failure"
    echo "    • Wakes on network access (Tailscale connections)"
else
    echo -e "${YELLOW}⊘ Skipped power management configuration${NC}"
fi

# Get Tailscale hostname
echo ""
echo -e "${CYAN}Getting Tailscale network information...${NC}"
TAILSCALE_HOST=$(tailscale status --json 2>/dev/null | jq -r '.Self.DNSName // empty' | sed 's/\.$//')

if [[ -z "$TAILSCALE_HOST" ]]; then
    TAILSCALE_HOST="$(hostname -s).tail7a4b9.ts.net"
fi

echo -e "${GREEN}✓ Tailscale hostname: ${TAILSCALE_HOST}${NC}"

# Test MOTD
echo ""
echo -e "${CYAN}Testing welcome message...${NC}"
"$MOTD_DIR/motd.sh"

# Final instructions
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}        Setup Complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "This Mac is now configured as a remote development server."
echo ""
echo "📋 Next steps:"
echo ""
echo "1. 🔄 Restart terminal or run: source ~/.zshrc"
echo ""
echo "2. 📱 Client Setup (iPad/Android):"
echo "   • Install Tailscale app and sign in"
echo "   • Install SSH client (Termius for iPad, Termux for Android)"
echo "   • Configure SSH connection:"
echo "     Host: ${TAILSCALE_HOST}"
echo "     User: $USER"
echo ""
echo "3. 🧪 Test connection:"
echo "   ssh ${TAILSCALE_HOST}"
echo "   # Should show welcome message and auto-attach to Zellij"
echo ""
echo "4. 📖 Full documentation:"
echo "   cat $DOTFILES_ROOT/remote/README.md"
echo ""
