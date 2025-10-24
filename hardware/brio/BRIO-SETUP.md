# Logitech Brio 4K Camera Configuration

Automated configuration script for optimal Logitech Brio 4K image quality on macOS.

## What It Does

The `configure-brio.sh` script automatically configures your Brio camera with these settings:

- **Auto-focus**: Disabled (manual focus at position 0)
- **Brightness**: Reduced by 5% (acts as exposure compensation)
- **Gain**: Set to 64/255 (moderate low-light boost)
- **Contrast**: Increased by 5%
- **Sharpness**: Increased by 5%

Settings are applied via UVC (USB Video Class) controls using the `uvcc` tool.

## Quick Start

### Manual Usage

```bash
# Apply settings once
./configure-brio.sh

# Preview changes without applying
./configure-brio.sh --dry-run

# Verbose output for debugging
./configure-brio.sh --verbose
```

### Automatic Startup Configuration

A launchd agent runs the script automatically:
- On login
- Every 30 seconds (ensures settings persist if camera is reconnected)

**Manage the launchd agent:**

```bash
# Load (enable) the agent
launchctl load ~/Library/LaunchAgents/com.user.brio-config.plist

# Unload (disable) the agent
launchctl unload ~/Library/LaunchAgents/com.user.brio-config.plist

# Check if it's running
launchctl list | grep brio-config

# View logs
tail -f ~/Library/Logs/brio-config.log
tail -f ~/Library/Logs/brio-config-error.log
```

## Customizing Settings

Edit the configuration variables at the top of `configure-brio.sh`:

```bash
# Configuration changes (percentages and absolute values)
readonly BRIGHTNESS_CHANGE=-5  # Reduce by 5% (exposure compensation)
readonly GAIN_VALUE=64         # Set gain for low-light (0-255, 64 = moderate boost)
readonly CONTRAST_CHANGE=5     # Increase by 5%
readonly SHARPNESS_CHANGE=5    # Increase by 5%
```

### Recommended Gain Values

- **0**: No boost (well-lit environments)
- **32**: Slight boost (office lighting)
- **64**: Moderate boost (default - good for most conditions)
- **96**: Strong boost (dim rooms)
- **128+**: Maximum boost (very dark environments, may add noise)

## Manual Focus Adjustment

The script sets auto-focus off and manual focus to 0. To adjust focus manually:

```bash
# Check current focus position
uvcc --vendor 1133 --product 2155 get absolute_focus

# Set focus (0-255 range)
# Lower values = closer focus
# Higher values = farther focus
uvcc --vendor 1133 --product 2155 set absolute_focus 50

# To re-enable auto-focus temporarily
uvcc --vendor 1133 --product 2155 set auto_focus 1
```

**Pro tip**: Find your ideal focus position, then update the script:

```bash
# In configure-brio.sh, change this line:
configure_control "absolute_focus" 0 "Manual focus position"

# To your preferred value (e.g., 50):
configure_control "absolute_focus" 50 "Manual focus position"
```

## Available Controls

View all camera controls and current values:

```bash
# List all available controls
uvcc --vendor 1133 --product 2155 controls

# Get current value of any control
uvcc --vendor 1133 --product 2155 get <control_name>

# Get valid range for a control
uvcc --vendor 1133 --product 2155 range <control_name>

# Export all current settings to JSON
uvcc --vendor 1133 --product 2155 export > brio-backup.json

# Import settings from JSON
cat brio-backup.json | uvcc --vendor 1133 --product 2155 import
```

### Brio 4K Control Reference

| Control | Range | Description |
|---------|-------|-------------|
| `brightness` | 0-255 | Exposure compensation (acts like EV adjustment) |
| `gain` | 0-255 | ISO/sensor gain (low-light boost) |
| `contrast` | 0-255 | Image contrast |
| `sharpness` | 0-255 | Image sharpness/clarity |
| `saturation` | 0-255 | Color saturation |
| `absolute_focus` | 0-255 | Manual focus distance (0=close, 255=far) |
| `absolute_zoom` | 100-500 | Digital zoom level |
| `white_balance_temperature` | 2000-7500 | Color temperature (K) |
| `backlight_compensation` | 0-1 | Backlight compensation on/off |
| `auto_exposure_mode` | 1,8 | 1=Manual, 8=Aperture Priority |

## Troubleshooting

### Camera not detected
```bash
# List all connected UVC devices
uvcc devices

# Ensure camera is plugged in and recognized by macOS
# Check System Settings > Privacy & Security > Camera
```

### Settings not persisting
- The launchd agent should reapply settings every 30 seconds
- Some apps (Zoom, OBS) may override camera settings
- FOV (Field of View) must be set in Logitech's official software (it persists on camera firmware)

### Permission errors
```bash
# Ensure uvcc is installed globally
npm list -g uvcc

# Reinstall if needed
npm install -g uvcc
```

### Logs not appearing
```bash
# Create log directory if it doesn't exist
mkdir -p ~/Library/Logs

# Check launchd agent status
launchctl list | grep brio-config
```

## Dependencies

- **uvcc**: USB Video Class control tool (installed via npm)
  ```bash
  npm install -g uvcc
  ```

- **jq**: JSON processor (usually pre-installed on macOS or via Homebrew)
  ```bash
  brew install jq
  ```

## Notes

- **FOV (Field of View)**: Not controllable via UVC. Set via Logitech Tune app (persists in camera firmware)
- **4K Quality**: Resolution/quality set by capture application (OBS, Zoom, etc.), not camera controls
- **Settings export**: Each run exports current settings to `~/.config/brio-settings.json`
- **Graceful failure**: Script exits cleanly if camera not connected (safe for launchd)

## Further Customization

Create a custom preset by exporting your ideal settings:

```bash
# Configure camera manually to your liking
# Then export settings
uvcc --vendor 1133 --product 2155 export > ~/my-brio-preset.json

# Apply your preset
cat ~/my-brio-preset.json | uvcc --vendor 1133 --product 2155 import
```

For advanced scripting, integrate with your dotfiles or shell startup files.
