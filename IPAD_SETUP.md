# iPad → Mac Remote Development Setup

Complete guide to developing on iPad by connecting to your Mac.

## 🎯 The Dream Workflow

1. Wake up, grab iPad with keyboard
2. Open Blink Shell
3. Connect via Tailscale (works on cellular!)
4. Attach to persistent zellij session
5. Full development environment with NeoVim/Helix, LSPs, everything

## 📱 iPad Apps You Need

### Required
- **Tailscale** (Free) - Zero-config VPN, works anywhere
- **Blink Shell** ($20) - Best iOS terminal, supports mosh + SSH

### Optional but Recommended
- **Working Copy** (Free tier fine) - Git client for offline iPad work
- **iA Writer** or **Textastic** - Quick text editing when offline

## 🚀 Mac Setup (Do This Once)

### 1. Install Tailscale on Mac

```bash
brew install --cask tailscale
```

After install:
1. Open Tailscale from Applications
2. Sign in (Google/GitHub/email)
3. Mac gets a permanent Tailscale IP

### 2. Enable SSH on Mac

```bash
# Enable Remote Login
sudo systemsetup -setremotelogin on

# Verify it's on
sudo systemsetup -getremotelogin
# Should say: Remote Login: On
```

### 3. Generate SSH Key for iPad

```bash
cd ~/dotfiles
./setup-ipad-ssh.sh
```

This will:
- Generate SSH key specifically for iPad
- Add it to authorized_keys
- Show you the public key to copy to iPad

### 4. Get Your Tailscale Hostname

```bash
tailscale status
```

Look for your Mac's hostname (e.g., `macbook-pro` or similar).
Your full address will be: `macbook-pro.tail-scale-name.ts.net`

Or find it in Tailscale app's menu.

## 📱 iPad Setup (Do This Once)

### 1. Install Apps on iPad

- App Store → Tailscale (install & sign in with same account)
- App Store → Blink Shell ($20, worth every penny)

### 2. Configure Blink Shell

Open Blink Shell:

1. **Add SSH Key**:
   - Settings → Keys → +
   - Paste your iPad public key (from setup-ipad-ssh.sh output)
   - Name it "ipad-remote-dev"

2. **Add Host**:
   - Settings → Hosts → +
   - Host: `mac` (friendly name)
   - HostName: `YOUR-MAC.tail-scale-name.ts.net` (from step 4 above)
   - User: `YOUR-USERNAME`
   - Key: Select "ipad-remote-dev"

### 3. Test Connection

In Blink Shell:
```bash
ssh mac
```

Should connect without password! 🎉

## 🔥 Daily Workflow

### Morning Routine

On iPad (anywhere - home wifi, cellular, coffee shop):

```bash
# Connect to Mac
ssh mac

# Attach to your persistent dev session (or create new one)
just dev

# OR manually:
zellij attach main

# Your work is exactly where you left it!
```

### Zellij Quick Keys

Once in zellij:
- `Ctrl-p d` - Split horizontally (new pane below)
- `Ctrl-p r` - Split vertically (new pane right)
- `Ctrl-p x` - Close current pane
- `Ctrl-p f` - Toggle fullscreen on current pane
- `Ctrl-s d` - Detach from session (session keeps running!)
- `Ctrl-q` - Quit zellij

### Working Across Panes

Typical layout:
```
┌──────────────┬─────────┐
│              │         │
│   NeoVim     │  eza    │
│   (code)     │  (tree) │
│              │         │
├──────────────┴─────────┤
│  zsh (git commands)    │
└────────────────────────┘
```

### On Cellular (Use Mosh)

When on flaky connection (train, cafe):
```bash
# Mosh instead of SSH (survives IP changes)
mosh mac

# Then attach to session
just dev
```

Mosh benefits:
- Survives IP address changes
- Works on terrible connections
- Local echo (feels faster)

## 💡 Pro Tips

### Keep Sessions Alive

Your zellij sessions survive even when you:
- Disconnect SSH
- Close iPad
- Switch networks
- Mac sleeps (wake it remotely via Tailscale)

Just reconnect and `just dev` - everything is there!

### Quick Edits

For tiny edits, use helix instead of NeoVim:
```bash
hx config.toml
```

Faster startup, still powerful.

### Offline iPad Work

1. Clone repo with Working Copy on iPad
2. Edit files in Working Copy
3. When back online, push changes
4. On Mac, pull and continue

### Multiple Projects

Create separate zellij sessions:
```bash
just dev dotfiles    # Session for dotfiles
just dev myapp       # Session for myapp
just dev experiment  # Session for experiments

# List all sessions
just sessions

# Switch between them
zellij attach dotfiles
```

## 🔧 Troubleshooting

### Can't Connect via Tailscale

```bash
# On Mac, check Tailscale status
tailscale status

# On iPad, check Tailscale app shows both devices
# Should see Mac and iPad listed
```

### SSH Key Not Working

```bash
# On Mac, verify key in authorized_keys
cat ~/.ssh/authorized_keys | grep ipad-remote-dev

# Re-run setup if needed
cd ~/dotfiles
./setup-ipad-ssh.sh
```

### Zellij Session Not Persisting

```bash
# Check if session exists
zellij list-sessions

# If not, session was killed. Create new one:
just dev
```

### Mac Sleeping (Can't Wake Remotely)

macOS power settings:
1. System Settings → Battery → Options
2. Enable "Wake for network access"
3. Consider keeping Mac plugged in if primary dev machine

## 🎨 Customization

### Different Zellij Layouts

Create layouts in `~/.config/zellij/layouts/`:

```bash
# Use compact layout (default)
zellij --layout compact

# Create custom layout for your workflow
```

### SSH Config Aliases

Add to `~/.ssh/config` on iPad (in Working Copy or Textastic):

```
Host mac
  HostName your-mac.tail-scale-name.ts.net
  User yourusername
  IdentityFile ~/.ssh/id_ed25519_ipad
  ServerAliveInterval 60
  ServerAliveCountMax 10
```

Then just: `ssh mac`

## 🚨 Security Notes

- Tailscale creates encrypted mesh VPN (zero-trust)
- SSH key authentication only (no passwords)
- Keys never leave your devices
- All traffic encrypted end-to-end
- Only your devices can connect (not exposed to internet)

This is more secure than most corporate VPNs!

## ✨ What You've Achieved

You can now:
- Develop on iPad from anywhere with internet
- Full terminal access with persistent sessions
- Work survives disconnects and network changes
- Same dev environment as sitting at your Mac
- Zero latency on cellular (mosh magic)

Welcome to the future of mobile development! 🎉
