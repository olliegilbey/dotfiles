#!/usr/bin/env bash
#
# hardware/setup.sh - Hardware configuration setup
#
# Sets up automated hardware configurations for peripherals

set -e -u -o pipefail

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly CYAN='\033[0;36m'
readonly RESET='\033[0m'

log_info() {
  echo -e "${CYAN}[INFO]${RESET} $*"
}

log_success() {
  echo -e "${GREEN}[SUCCESS]${RESET} $*"
}

log_warning() {
  echo -e "${YELLOW}[WARNING]${RESET} $*"
}

log_error() {
  echo -e "${RED}[ERROR]${RESET} $*"
}

echo -e "${CYAN}=== Hardware Setup ===${RESET}"
echo ""

# Change to hardware directory
cd "$(dirname "$0")"

# Ensure npm is available by trying multiple methods
ensure_npm_available() {
  # Already available?
  if command -v npm &> /dev/null; then
    return 0
  fi

  log_info "npm not immediately available, trying to activate mise..."

  # Try activating mise
  if command -v mise &> /dev/null; then
    eval "$(mise activate bash)" 2>/dev/null || true

    # Check again
    if command -v npm &> /dev/null; then
      log_success "npm available via mise"
      return 0
    fi
  fi

  # Try common mise installation paths
  for mise_node_path in \
    "$HOME/.local/share/mise/installs/node/lts/bin" \
    "$HOME/.local/share/mise/installs/node/"*/bin \
    "$HOME/.local/share/mise/installs/node/latest/bin"; do

    if [ -d "$mise_node_path" ]; then
      export PATH="$mise_node_path:$PATH"
      if command -v npm &> /dev/null; then
        log_success "npm found at $mise_node_path"
        return 0
      fi
    fi
  done

  # Last resort: check if installed via homebrew node
  if [ -x "/opt/homebrew/bin/npm" ]; then
    export PATH="/opt/homebrew/bin:$PATH"
    log_success "npm found via Homebrew"
    return 0
  fi

  return 1
}

# Setup Brio webcam
log_info "Setting up Logitech Brio 4K webcam..."
echo ""

# Ensure npm is available
if ! ensure_npm_available; then
  log_error "Could not find npm after trying multiple methods."
  log_warning "Please restart your terminal or run: source ~/.zshrc"
  log_info "Then run: bash hardware/setup.sh"
  exit 1
fi

log_info "npm is available: $(npm --version)"

# Check if uvcc is installed
if ! command -v uvcc &> /dev/null; then
  log_warning "uvcc not found. Installing via npm..."
  npm install -g uvcc
  log_success "uvcc installed"
else
  log_info "uvcc already installed"
fi

# Setup launchd agent for Brio
PLIST_PATH="$HOME/Library/LaunchAgents/com.user.brio-config.plist"
SCRIPT_PATH="$(pwd)/brio/configure-brio.sh"

# Make script executable
chmod +x "$SCRIPT_PATH"

# Create launchd plist if it doesn't exist
if [ ! -f "$PLIST_PATH" ]; then
  log_info "Creating launchd agent for Brio auto-configuration..."

  cat > "$PLIST_PATH" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.brio-config</string>

    <key>ProgramArguments</key>
    <array>
        <string>$SCRIPT_PATH</string>
    </array>

    <key>RunAtLoad</key>
    <true/>

    <key>StartInterval</key>
    <integer>30</integer>

    <key>StandardOutPath</key>
    <string>$HOME/Library/Logs/brio-config.log</string>

    <key>StandardErrorPath</key>
    <string>$HOME/Library/Logs/brio-config-error.log</string>

    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/usr/local/bin:/usr/bin:/bin:$HOME/.local/share/mise/installs/node/lts/bin</string>
    </dict>
</dict>
</plist>
EOF

  log_success "Launchd agent created"
fi

# Load the launchd agent
log_info "Loading Brio auto-configuration agent..."
launchctl unload "$PLIST_PATH" 2>/dev/null || true
launchctl load "$PLIST_PATH"
log_success "Brio agent loaded (runs every 30 seconds)"

# Run initial configuration
log_info "Running initial Brio configuration..."
"$SCRIPT_PATH" --verbose
log_success "Brio configured"

echo ""

# G Hub mouse settings restoration
log_info "Logitech G Hub mouse settings..."
echo ""

G_HUB_SETTINGS="$(pwd)/mouse/g-hub-settings-export.json"
G_HUB_RESTORE_PATH="$HOME/Library/Application Support/LGHUB"

if [ -d "$G_HUB_RESTORE_PATH" ]; then
  log_info "G Hub is installed. Restore backup?"
  echo "  This will restore your mouse button mappings and DPI settings."
  echo ""
  read -p "  Restore G Hub settings? (y/N): " -n 1 -r
  echo ""

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    log_info "Restoring G Hub settings..."

    # Backup existing settings
    if [ -f "$G_HUB_RESTORE_PATH/settings.db" ]; then
      cp "$G_HUB_RESTORE_PATH/settings.db" "$G_HUB_RESTORE_PATH/settings.db.backup.$(date +%Y%m%d_%H%M%S)"
      log_info "Existing settings backed up"
    fi

    # Restore from export
    sqlite3 "$G_HUB_RESTORE_PATH/settings.db" "UPDATE data SET file = readfile('$G_HUB_SETTINGS') WHERE _id=1"

    log_success "G Hub settings restored"
    log_warning "Restart G Hub to apply changes"
  else
    log_info "Skipped G Hub restoration"
  fi
else
  log_info "G Hub not installed - settings available at:"
  log_info "  $G_HUB_SETTINGS"
  echo ""
  log_info "To restore later (after installing G Hub):"
  echo "  sqlite3 ~/Library/Application\\ Support/LGHUB/settings.db \\"
  echo "    \"UPDATE data SET file = readfile('$G_HUB_SETTINGS') WHERE _id=1\""
fi

echo ""
log_success "Hardware setup complete!"
echo ""
log_info "Configuration:"
echo "  - Brio: Auto-configured every 30 seconds"
echo "  - Mouse: Settings preserved in hardware/mouse/"
echo ""
log_info "Logs:"
echo "  - Brio: ~/Library/Logs/brio-config.log"
