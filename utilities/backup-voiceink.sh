#!/bin/bash
set -e

BACKUP_DIR="$HOME/voiceink-backup-$(date +%Y%m%d-%H%M%S)"

echo "📦 Backing up VoiceInk to: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# Preferences (includes license, settings)
echo "  → Preferences..."
cp ~/Library/Preferences/com.prakashjoshipax.VoiceInk.plist "$BACKUP_DIR/" 2>/dev/null || echo "    (no plist found)"

# Application Support
echo "  → Application Support..."
cp -R ~/Library/Application\ Support/VoiceInk "$BACKUP_DIR/AppSupport-VoiceInk" 2>/dev/null || echo "    (no VoiceInk dir)"
cp -R ~/Library/Application\ Support/com.prakashjoshipax.VoiceInk "$BACKUP_DIR/AppSupport-com.prakashjoshipax" 2>/dev/null || echo "    (no com.prakashjoshipax dir)"

# Caches (optional - can skip)
echo "  → Caches (models, etc)..."
cp -R ~/Library/Caches/com.prakashjoshipax.VoiceInk "$BACKUP_DIR/Caches" 2>/dev/null || echo "    (no cache dir)"

# Custom sounds
echo "  → Custom sounds..."
cp -R ~/Library/Application\ Support/VoiceInk/CustomSounds "$BACKUP_DIR/CustomSounds" 2>/dev/null || echo "    (no custom sounds)"

echo ""
echo "✅ Backup complete!"
echo ""
echo "To restore after reinstall:"
echo "  cp \"$BACKUP_DIR/com.prakashjoshipax.VoiceInk.plist\" ~/Library/Preferences/"
echo "  cp -R \"$BACKUP_DIR/AppSupport-VoiceInk\" ~/Library/Application\\ Support/VoiceInk"
echo "  cp -R \"$BACKUP_DIR/AppSupport-com.prakashjoshipax\" ~/Library/Application\\ Support/com.prakashjoshipax.VoiceInk"
echo ""
echo "Backup location: $BACKUP_DIR"
