# Logitech G502 X LIGHTSPEED Mouse Configuration

Backup of mouse settings from Logitech G Hub.

## What's Backed Up

File: `g-hub-settings-export.json` (94KB)

**Contents:**
- ✅ Mouse button assignments (G4, G5, G7, G9, G10, G11)
- ✅ DPI settings (1600 default, 12000 max, 800 shift)
- ✅ Mode configurations
- ✅ Generic command mappings (Cut, Copy, Paste, Undo, etc.)
- ✅ Shift button behaviors
- ✅ Bonus: Logitech Brio webcam settings

**Privacy:**
- ❌ NO personal information
- ❌ NO email addresses or names
- ❌ NO serial numbers
- ✅ Safe for public repo

## Restoring Settings

### If G Hub is Installed

```bash
# Automatic (via hardware setup)
just hardware-setup

# Or manual restoration:
sqlite3 ~/Library/Application\ Support/LGHUB/settings.db \
  "UPDATE data SET file = readfile('$(pwd)/g-hub-settings-export.json') WHERE _id=1"

# Restart G Hub to apply
```

### If G Hub Not Installed

The mouse will work with basic functionality:
- All buttons functional (OS default mappings)
- DPI buttons cycle through hardware profiles
- RGB uses last-configured settings

**To reinstall G Hub:**
1. Download from https://www.logitechg.com/innovation/g-hub.html
2. Install normally
3. Run hardware setup: `bash hardware/setup.sh`

## Button Mappings in Export

The JSON contains slot IDs like:
- `g502x-lightspeed_g4_m1` - Button G4, Mode 1
- `g502x-lightspeed_g4_m1_shifted` - Button G4, Mode 1, Shift held
- `g502x-lightspeed_g5_m1` - Button G5 (DPI down)
- `g502x-lightspeed_g9_m1` - Button G9 (thumb button)
- `g502x-lightspeed_g10_m1` - Button G10 (sniper)
- `g502x-lightspeed_g11_m1` - Button G11 (DPI up)

## Alternative: Button Remapping Without G Hub

If you prefer not to use G Hub:

**BetterTouchTool** (Recommended):
```bash
brew install --cask bettertouchtool
```
- Supports mouse button remapping
- Per-app profiles
- More flexible than G Hub

**USB Overdrive**:
```bash
brew install --cask usb-overdrive
```
- Comprehensive mouse control
- System-wide button customization

## File Format

The export is a SQLite database dump in JSON format from:
```
~/Library/Application Support/LGHUB/settings.db
```

Table: `data`, Column: `file`, Row ID: `1`

Contains the complete G Hub configuration including device-specific settings and application integrations.
