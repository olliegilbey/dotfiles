#!/usr/bin/env bash
#
# configure-brio.sh - Logitech Brio 4K Camera Configuration Script
#
# Configures UVC camera settings for optimal image quality:
# - Disables auto-focus (sets manual focus to 0)
# - Reduces brightness by 5% (exposure compensation)
# - Increases gain for low-light performance
# - Increases contrast by 5%
# - Increases sharpness by 5%
#
# Dependencies: uvcc (npm install -g uvcc)
# Usage: ./configure-brio.sh [--dry-run] [--verbose]

set -e -u -o pipefail

# Colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly RESET='\033[0m'

# Logitech Brio identifiers
readonly BRIO_VENDOR=1133   # 0x046d
readonly BRIO_PRODUCT=2155  # 0x086b

# Configuration - ABSOLUTE target values (idempotent - safe to run repeatedly)
readonly BRIGHTNESS_TARGET=109  # Absolute brightness value (original 115, reduced by ~5%)
readonly GAIN_TARGET=96         # Set gain for low-light (0-255, 96 = strong boost)
readonly CONTRAST_TARGET=134    # Absolute contrast value (original 128, increased by ~5%)
readonly SHARPNESS_TARGET=147   # Absolute sharpness value (original 140, increased by ~5%)
readonly FOCUS_TARGET=0         # Manual focus position (0=close, 255=far)

# Flags
DRY_RUN=false
VERBOSE=false

# Parse arguments
for arg in "$@"; do
  case $arg in
    --dry-run)
      DRY_RUN=true
      ;;
    --verbose)
      VERBOSE=true
      ;;
    --help)
      echo "Usage: $0 [--dry-run] [--verbose] [--help]"
      echo ""
      echo "Options:"
      echo "  --dry-run   Show what would be changed without applying"
      echo "  --verbose   Show detailed output"
      echo "  --help      Show this help message"
      exit 0
      ;;
    *)
      echo -e "${RED}Unknown argument: $arg${RESET}"
      exit 1
      ;;
  esac
done

# Logging functions
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

log_verbose() {
  if [[ "$VERBOSE" == "true" ]]; then
    echo -e "${BLUE}[VERBOSE]${RESET} $*"
  fi
}

# Check if uvcc is installed
check_uvcc() {
  if ! command -v uvcc &> /dev/null; then
    log_error "uvcc not found. Install with: npm install -g uvcc"
    exit 1
  fi
  log_verbose "uvcc found at: $(command -v uvcc)"
}

# Detect Brio camera
detect_camera() {
  log_info "Detecting Logitech Brio camera..."

  local devices
  devices=$(uvcc devices 2>/dev/null)

  if ! echo "$devices" | jq -e ".[] | select(.vendor == $BRIO_VENDOR and .product == $BRIO_PRODUCT)" &> /dev/null; then
    log_warning "Logitech Brio 4K not connected (skipping configuration)"
    if [[ "$VERBOSE" == "true" ]]; then
      echo "Connected cameras:"
      echo "$devices" | jq -r '.[] | "  - \(.name) (vendor: \(.vendor), product: \(.product))"'
    fi
    exit 0
  fi

  log_success "Logitech Brio 4K detected"
}

# Get current value for a control
get_value() {
  local control=$1
  uvcc --vendor "$BRIO_VENDOR" --product "$BRIO_PRODUCT" get "$control" 2>/dev/null
}

# Get range for a control
get_range() {
  local control=$1
  uvcc --vendor "$BRIO_VENDOR" --product "$BRIO_PRODUCT" range "$control" 2>/dev/null | jq -r
}

# Set a control value
set_value() {
  local control=$1
  local value=$2

  if [[ "$DRY_RUN" == "true" ]]; then
    log_verbose "[DRY-RUN] Would set $control to $value"
    return 0
  fi

  uvcc --vendor "$BRIO_VENDOR" --product "$BRIO_PRODUCT" set "$control" "$value" 2>&1
}

# Calculate new value based on percentage change
calculate_new_value() {
  local current=$1
  local percent_change=$2
  local min=$3
  local max=$4

  # Calculate new value: current * (1 + percent_change/100)
  local new_value
  new_value=$(awk "BEGIN {printf \"%.0f\", $current * (1 + $percent_change / 100)}")

  # Clamp to valid range
  if (( new_value < min )); then
    new_value=$min
  elif (( new_value > max )); then
    new_value=$max
  fi

  echo "$new_value"
}

# Configure a control with percentage change
configure_control() {
  local control=$1
  local percent_change=$2
  local description=$3

  log_info "Configuring $description..."

  # Get current value
  local current
  current=$(get_value "$control")
  log_verbose "Current $control: $current"

  # Get valid range
  local range_json
  range_json=$(get_range "$control")
  local min
  min=$(echo "$range_json" | jq -r '.min')
  local max
  max=$(echo "$range_json" | jq -r '.max')
  log_verbose "Valid range: $min - $max"

  # Calculate new value
  local new_value
  new_value=$(calculate_new_value "$current" "$percent_change" "$min" "$max")

  # Show change
  local change_dir="→"
  if (( new_value > current )); then
    change_dir="${GREEN}↑${RESET}"
  elif (( new_value < current )); then
    change_dir="${RED}↓${RESET}"
  fi

  echo -e "  $current $change_dir $new_value (${percent_change:+$percent_change%})"

  # Apply setting
  if [[ "$current" != "$new_value" ]]; then
    set_value "$control" "$new_value"
    log_success "$description updated"
  else
    log_verbose "$description unchanged (already at target value)"
  fi
}

# Configure boolean control
configure_boolean() {
  local control=$1
  local target_value=$2
  local description=$3

  log_info "Configuring $description..."

  local current
  current=$(get_value "$control")
  log_verbose "Current $control: $current"

  if [[ "$current" != "$target_value" ]]; then
    echo "  $current → $target_value"
    set_value "$control" "$target_value"
    log_success "$description updated"
  else
    log_verbose "$description already set correctly"
  fi
}

# Configure control with absolute value
configure_absolute() {
  local control=$1
  local target_value=$2
  local description=$3

  log_info "Configuring $description..."

  # Get current value
  local current
  current=$(get_value "$control")
  log_verbose "Current $control: $current"

  # Get valid range
  local range_json
  range_json=$(get_range "$control")
  local min
  min=$(echo "$range_json" | jq -r '.min')
  local max
  max=$(echo "$range_json" | jq -r '.max')
  log_verbose "Valid range: $min - $max"

  # Clamp to valid range
  local clamped_value=$target_value
  if (( clamped_value < min )); then
    clamped_value=$min
    log_warning "Value $target_value below minimum, clamping to $min"
  elif (( clamped_value > max )); then
    clamped_value=$max
    log_warning "Value $target_value above maximum, clamping to $max"
  fi

  # Show change
  local change_dir="→"
  if (( clamped_value > current )); then
    change_dir="${GREEN}↑${RESET}"
  elif (( clamped_value < current )); then
    change_dir="${RED}↓${RESET}"
  fi

  echo -e "  $current $change_dir $clamped_value"

  # Apply setting
  if [[ "$current" != "$clamped_value" ]]; then
    set_value "$control" "$clamped_value"
    log_success "$description updated"
  else
    log_verbose "$description unchanged (already at target value)"
  fi
}

# Main configuration
main() {
  log_info "Starting Logitech Brio 4K configuration..."
  echo ""

  if [[ "$DRY_RUN" == "true" ]]; then
    log_warning "DRY RUN MODE - No changes will be applied"
    echo ""
  fi

  # Pre-flight checks
  check_uvcc
  detect_camera
  echo ""

  # Configure focus
  # Option 1: Auto-focus enabled (camera manages focus automatically)
  # configure_boolean "auto_focus" 1 "Auto-focus (enable)"

  # Option 2: Manual focus locked at specific position (change FOCUS_TARGET to adjust)
  configure_boolean "auto_focus" 0 "Auto-focus (disable)"
  configure_absolute "absolute_focus" "$FOCUS_TARGET" "Manual focus position"
  echo ""

  # Configure image quality
  configure_absolute "brightness" "$BRIGHTNESS_TARGET" "Brightness (exposure compensation)"
  configure_absolute "gain" "$GAIN_TARGET" "Gain (low-light boost)"
  configure_absolute "contrast" "$CONTRAST_TARGET" "Contrast"
  configure_absolute "sharpness" "$SHARPNESS_TARGET" "Sharpness"
  echo ""

  log_success "Camera configuration complete!"

  # Export current configuration for reference
  if [[ "$DRY_RUN" == "false" ]]; then
    local export_file="${HOME}/.config/brio-settings.json"
    mkdir -p "$(dirname "$export_file")"
    uvcc --vendor "$BRIO_VENDOR" --product "$BRIO_PRODUCT" export > "$export_file" 2>/dev/null
    log_info "Current settings exported to: $export_file"
  fi
}

# Run main function
main "$@"
