#!/usr/bin/env bash
#
# focus-and-lock.sh - Enable auto-focus briefly, then lock the position
#
# Usage: ./focus-and-lock.sh

set -e -u -o pipefail

readonly BRIO_VENDOR=1133
readonly BRIO_PRODUCT=2155

echo "Enabling auto-focus for 3 seconds..."
uvcc --vendor "$BRIO_VENDOR" --product "$BRIO_PRODUCT" set auto_focus 1

echo "Waiting for camera to focus..."
sleep 3

echo "Reading focused position..."
FOCUS_POS=$(uvcc --vendor "$BRIO_VENDOR" --product "$BRIO_PRODUCT" get absolute_focus)

echo "Disabling auto-focus and locking at position: $FOCUS_POS"
uvcc --vendor "$BRIO_VENDOR" --product "$BRIO_PRODUCT" set auto_focus 0

echo "✓ Focus locked at position: $FOCUS_POS"
echo ""
echo "To use this position in your config, update configure-brio.sh:"
echo "  readonly FOCUS_TARGET=$FOCUS_POS"
