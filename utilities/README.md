# Dotfiles Utilities

Utility scripts and tools for managing and testing dotfiles configurations.

## Ghostty

### Theme Tester

**Location:** `ghostty/theme-tester.sh`

Interactive script to preview and test different Ghostty themes with the CyberWave gradient shader.

**Usage:**
```bash
cd ~/dotfiles/utilities/ghostty
./theme-tester.sh
```

**Features:**
- Preview 11 curated dark themes that work well with teal→black gradient
- Shows current active theme
- Displays colorful terminal output examples
- Interactive theme selection
- Updates config file on-the-fly

**Note:** After selecting a new theme, open a new Ghostty window (Cmd+N) to see changes.

**Final Selection:** TokyoNight Storm was selected as the best theme with the CyberWave gradient background.

## VoiceInk

### Audio Recording Monitor

**Location:** `monitor-voiceink.sh`

Monitors VoiceInk audio recording for 15 seconds to debug cutoff issues.

**Usage:**
```bash
sudo ./monitor-voiceink.sh
# Start VoiceInk recording immediately after
# Output: voiceink-debug-TIMESTAMP.log
```

**Captures:**
- System logs (CoreAudio errors, buffer issues)
- File system activity (audio file writes)
- CPU/memory stats every 0.5s
- Audio device state changes (session reconfigs)

### Backup Script

**Location:** `backup-voiceink.sh`

Backs up VoiceInk config, license, and settings before reinstall.

**Usage:**
```bash
./backup-voiceink.sh
# Output: ~/voiceink-backup-TIMESTAMP/
```

**Backs up:**
- License key & settings (preferences plist)
- Application support files
- Custom sounds
- AI model caches

### Troubleshooting Notes

**Location:** `VoiceInkPrompt.md`

Documentation of VoiceInk audio cutoff issue investigation.
