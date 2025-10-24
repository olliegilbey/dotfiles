# Hardware Configuration

Automated hardware setup for macOS peripherals.

## Structure

```
hardware/
├── brio/                   # Logitech Brio 4K webcam config
│   ├── configure-brio.sh   # Main configuration script
│   ├── focus-and-lock.sh   # Focus helper utility
│   └── BRIO-SETUP.md       # Detailed documentation
└── mouse/                  # Logitech G502 X LIGHTSPEED config
    └── g-hub-settings-export.json  # Exported G Hub settings (94KB)
```

## Quick Start

```bash
# Setup all hardware
just hardware-setup

# Or manually:
./hardware/setup.sh
```

## Brio Webcam

**Current Settings:**
- Brightness: 109 (exposure compensation)
- Gain: 96 (strong low-light boost - **boosted for night use**)
- Contrast: 134
- Sharpness: 147
- Focus: Manual at 0 (close range)

Auto-configured via launchd every 30 seconds.

## Mouse (G502 X LIGHTSPEED)

Settings exported from G Hub before uninstallation:
- File: `mouse/g-hub-settings-export.json` (94KB)
- Contains: Button mappings, DPI settings, lighting profiles

**Note:** These settings cannot currently be re-imported to macOS without G Hub. This export serves as documentation only. For functional button remapping without G Hub, consider using external tools like:
- BetterTouchTool
- USB Overdrive
- Karabiner-Elements (keyboard-focused but supports some mice)

## Uninstalling Logitech G Hub

See `mouse/G-HUB-UNINSTALL.md` for complete removal instructions.
