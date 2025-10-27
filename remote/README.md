# Remote Development Setup

Complete guide to developing from any device (iPad, Android, laptop) by connecting to your Mac servers via Tailscale.

## 🎯 The Philosophy

**One dev environment, accessed from anywhere.**

- SSH from iPad/Android/laptop to Mac server (M1 or M3)
- Automatic attachment to persistent Zellij sessions
- Sessions survive disconnects, network changes, device sleeps
- Pick up exactly where you left off (including Claude Code sessions)
- Frontend preview over Tailscale network (no SSH tunneling)

## 🏗️ Architecture

```
Client Device (iPad/Android/Mac)
    ↓ SSH over Tailscale VPN
    ↓ Auto-detect SSH connection (.zshrc)
    ↓ Show MOTD welcome message
    ↓ exec zellij attach --create remote
    ↓ Persistent "remote" session
    ↓ Full dev environment (NeoVim, Helix, all tools)
```

**Key Components:**
- **Tailscale:** Zero-config VPN mesh (works on cellular, any network)
- **Zellij:** Terminal multiplexer with persistent sessions
- **Auto-attach:** SSH connections automatically attach to "remote" session
- **MOTD:** Welcome message with cheatsheet and Tailscale hostname
- **devserver:** Function to bind dev servers to 0.0.0.0 for network access

## 🚀 Server Setup (Mac)

### Quick Setup

**On M1 Mac or M3 Mac:**

```bash
cd ~/dotfiles
git pull  # Get latest changes
./init.sh
# Answer "Yes" when prompted for remote development setup
```

The setup script will:
- ✅ Verify Tailscale is installed and authenticated
- ✅ Verify Zellij is installed
- ✅ Enable SSH (Remote Login) if needed
- ✅ Install MOTD welcome message
- ✅ Configure power management for server mode (optional)
- ✅ Show Tailscale hostname for client configuration

### Manual Setup (Alternative)

If you already ran `./init.sh` without the remote setup:

```bash
cd ~/dotfiles
./remote/setup-server.sh
```

### Prerequisites

Before running setup, ensure:

1. **Tailscale installed:**
   ```bash
   brew install --cask tailscale
   # Open Tailscale app and sign in
   ```

2. **Zellij installed:**
   ```bash
   brew install zellij
   # (Already in Brewfile if you ran ./init.sh)
   ```

3. **Tailscale authenticated:**
   ```bash
   tailscale status
   # Should show your devices
   ```

### Get Your Tailscale Hostname

```bash
tailscale status
# Look for your Mac's hostname, e.g.:
# 100.92.4.70  olivers-macbook-pro  olliegilbey@  macOS

# Full DNS name:
# olivers-macbook-pro.tail7a4b9.ts.net
```

Or check the Tailscale menu bar app.

## 📱 Client Setup (iPad/Android)

### iPad Setup (Termius)

1. **Install Apps:**
   - App Store → Tailscale (free)
   - App Store → Termius (free tier works)

2. **Configure Tailscale:**
   - Open Tailscale app
   - Sign in with same account as Mac
   - Ensure connection is active (green)

3. **Configure Termius:**
   - Add New Host
   - Hostname: `olivers-macbook-pro.tail7a4b9.ts.net` (your Mac's Tailscale hostname)
   - Username: Your Mac username
   - Authentication: SSH key or password
   - Save as "M1 Mac" or "M3 Mac"

4. **Test Connection:**
   ```bash
   # Tap the host in Termius
   # Should connect and show MOTD welcome message
   # Automatically attached to Zellij "remote" session!
   ```

### Android Setup (Termux)

1. **Install Apps:**
   - Play Store → Tailscale (free)
   - Play Store → Termux (free, open-source terminal)

2. **Configure Tailscale:**
   - Same as iPad setup above

3. **SSH from Termux:**
   ```bash
   # In Termux:
   pkg install openssh
   ssh yourusername@olivers-macbook-pro.tail7a4b9.ts.net
   # Should show MOTD and auto-attach to Zellij
   ```

### Other Mac as Client

If you want to SSH from your M3 to M1 (or vice versa):

```bash
# Just SSH to the Tailscale hostname:
ssh olivers-macbook-pro.tail7a4b9.ts.net
# Auto-attaches to "remote" session
```

## 🔥 Daily Workflow

### Connect from Any Device

```bash
# On iPad/Android terminal app:
ssh m1mac  # or use full Tailscale hostname

# MOTD appears with cheatsheet:
# 🚀 Remote Development Server: olivers-macbook-pro
# Session: remote
# Detach: Ctrl+s, d
# Commands: just code, just tips, devserver

# Already attached to Zellij "remote" session!
# Your work from yesterday is RIGHT THERE
```

### Switch Devices Seamlessly

```bash
# Scenario: Working on iPad, need to switch to Android

# On iPad:
Ctrl+s, d  # Detach from Zellij (session keeps running)
# Close Termius

# On Android (5 minutes later):
ssh m1mac
# BOOM - exact same session, Claude Code still running
```

### Zellij Keybindings

**Session Management:**
- `Ctrl+s`, `d` — Detach from session (keeps running)
- `Ctrl+q` — Quit Zellij entirely (kills session)

**Pane Management:**
- `Ctrl+p`, `d` — Split horizontally (new pane below)
- `Ctrl+p`, `r` — Split vertically (new pane right)
- `Ctrl+p`, `x` — Close current pane
- `Ctrl+p`, `f` — Toggle fullscreen on pane
- `Ctrl+p`, `?` — Show all keybindings

**Typical Layout:**
```
┌──────────────┬─────────┐
│              │         │
│   NeoVim     │  eza    │
│   (code)     │  (tree) │
│              │         │
├──────────────┴─────────┤
│  zsh (git/commands)    │
└────────────────────────┘
```

## 📦 Session Management

### Auto-Attach Behavior

SSH connections automatically attach to a persistent session named **"remote"**.

**What happens on SSH:**
1. `.zshrc` detects `$SSH_CONNECTION`
2. Shows MOTD welcome message
3. Runs `exec zellij attach --create remote`
4. If "remote" session exists → attach to it
5. If it doesn't exist → create it and attach

**Multiple devices:**
- All devices attach to the same "remote" session
- You can view/control from multiple devices simultaneously
- Perfect for seamless device switching

### Manual Session Management

If you want separate sessions per project:

```bash
# From local Mac terminal (not over SSH):
just code myproject        # Create/attach to "myproject" session
just code dotfiles         # Create/attach to "dotfiles" session
just sessions              # List all active sessions
just kill myproject        # Kill a specific session

# Over SSH (auto-attached to "remote"):
# Just detach and create a new session manually:
Ctrl+s, d                  # Detach
zellij attach myproject    # Attach to different session
zellij -s newproject       # Create new session
```

## 🌐 Frontend Preview

### Use `devserver` Function

The `devserver` function binds your dev server to `0.0.0.0` so it's accessible over Tailscale network:

```bash
# In your project directory (Next.js, Vite, etc.):
cd ~/my-app
devserver 3000

# Output:
# 🌐 Preview URL: http://olivers-macbook-pro.tail7a4b9.ts.net:3000
# 📱 Access from any device on your Tailscale network
# 📦 Detected Next.js - using npm run dev (Turbopack compatibility)
```

**Auto-detects framework:**
- Next.js → `npm run dev --hostname 0.0.0.0 --port PORT`
- Other frameworks with dev script → `bun run dev` or `npm run dev`
- Falls back to npm if bun not compatible

### Access from iPad/Android

```bash
# In Safari/Chrome on iPad:
http://olivers-macbook-pro.tail7a4b9.ts.net:3000

# Works because:
# 1. Devices on same Tailscale network
# 2. Dev server bound to 0.0.0.0 (all interfaces)
# 3. Tailscale provides direct network access
```

**No SSH port forwarding needed!**

## 📚 Commands & Tips

### Remote Development Commands

```bash
# Server setup
just setup-remote         # Run server setup script
just remote-status        # Show Tailscale connection status
just remote-motd          # Show MOTD (test welcome message)
just remote-test          # Test loopback SSH connection

# Session management
just code [name]          # Create/attach to session (local use)
just sessions             # List active Zellij sessions
just kill [name]          # Kill specific session
just kill-all             # Kill all sessions

# Frontend preview
devserver [port]          # Bind dev server to 0.0.0.0 (default: 3000)

# Utilities
just tips                 # Show random alias tips
```

### Alias Tips on Connection

The MOTD shows a random alias tip each time you connect. To see more:

```bash
just tips
# Shows 2 random aliases from your ~/.aliases file
```

### Starship Prompt

Starship prompt automatically loads on SSH connections (not Warp terminal), giving you a nice prompt with git status, language versions, etc.

## 🔧 Troubleshooting

### SSH Connection Fails

```bash
# On server Mac:
tailscale status                  # Verify Tailscale is running
sudo systemsetup -getremotelogin  # Verify SSH is enabled

# On client device:
# Ensure Tailscale app is connected (green)
# Try full hostname:
ssh yourusername@full-hostname.tail7a4b9.ts.net
```

### No Auto-Attach to Zellij

```bash
# On server Mac:
# Verify .zshrc has auto-attach logic:
grep -A 5 "Auto-attach to Zellij" ~/.zshrc

# Verify MOTD is installed:
ls -la ~/.config/remote/motd.sh

# Test manually:
SSH_CONNECTION="test" zsh  # Should auto-attach
```

### Session Not Persisting

```bash
# Check if session exists:
zellij list-sessions

# If session doesn't exist, it was killed (not detached)
# Common causes:
# - Used Ctrl+q instead of Ctrl+s,d (quit vs detach)
# - Mac rebooted (sessions don't survive reboot)
# - Zellij process crashed (rare)

# Solution: Create new session, sessions auto-recreate anyway
```

### Mac Sleeping (Can't Connect)

```bash
# On server Mac, run the setup again to configure power:
./remote/setup-server.sh
# Answer "Yes" to power management configuration

# Or manually:
sudo pmset -c sleep 0       # Never sleep on AC
sudo pmset -a womp 1        # Wake on network access

# Verify settings:
pmset -g
```

### Frontend Preview Not Accessible

```bash
# Verify dev server is bound to 0.0.0.0 (not 127.0.0.1):
# Use: devserver 3000
# NOT: npm run dev (binds to localhost only)

# Test from server Mac:
curl http://localhost:3000  # Should work

# Test from client device:
# Ping the server first:
ping olivers-macbook-pro.tail7a4b9.ts.net
# Then try preview URL
```

### Multiple Zellij Sessions Confusing

```bash
# Kill all sessions and start fresh:
just kill-all

# SSH in again - auto-creates clean "remote" session
```

## 💡 Pro Tips

### Keep Mac Awake as Server

When using M1 as dedicated server:
- Keep plugged into power
- Run `./remote/setup-server.sh` and enable power management
- Mac won't sleep when on AC power
- Display can sleep (saves energy)
- Wake on network access enabled (remote wake from Tailscale devices)

### Mosh for Flaky Connections

If SSH feels laggy on cellular:

```bash
# Install mosh on server:
brew install mosh

# Connect with mosh from client:
mosh yourusername@olivers-macbook-pro.tail7a4b9.ts.net

# Mosh benefits:
# - Survives IP address changes
# - Local echo (feels instant)
# - Better on high-latency connections
```

(Termius supports mosh, Termux needs `pkg install mosh`)

### Quick Edits with Helix

For small file edits, use Helix instead of NeoVim:

```bash
hx config.toml  # Faster startup, still powerful
```

### Multiple Concurrent Sessions

If you want multiple isolated sessions:

```bash
# Detach from "remote" session:
Ctrl+s, d

# Create named sessions:
zellij -s dotfiles
zellij -s myapp
zellij -s experiment

# List sessions:
zellij list-sessions

# Attach to specific session:
zellij attach dotfiles
```

## 🔐 Security Notes

**This setup is secure:**
- Tailscale creates encrypted VPN mesh (zero-trust architecture)
- SSH key authentication (passwords can be disabled)
- Keys never leave your devices
- All traffic encrypted end-to-end
- Only your authenticated devices can connect
- Not exposed to public internet

**More secure than most corporate VPNs!**

## 🎉 What You've Achieved

You can now:
- ✅ Develop on iPad/Android from anywhere with internet
- ✅ Full terminal access with persistent sessions
- ✅ Work survives disconnects and network changes
- ✅ Switch devices seamlessly (sessions persist)
- ✅ Preview frontends on client devices (Tailscale network)
- ✅ Same dev environment as sitting at your Mac
- ✅ Claude Code sessions persist across device switches
- ✅ Zero latency on cellular (Tailscale magic + mosh)

**Welcome to true mobile development!** 🚀📱💻
