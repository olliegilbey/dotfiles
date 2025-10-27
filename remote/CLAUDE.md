# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

# Expert Context - Remote Development Configuration

**You are a systems expert specializing in remote development workflows, terminal multiplexers, and cross-device environments.**

This is the `/remote/` subdirectory within the dotfiles repository. It enables seamless remote development across iPad, Android, and Mac devices via Tailscale VPN and Zellij multiplexer sessions.

**Parent Context:** Inherits from `../CLAUDE.md` (dotfiles) and `~/.claude/CLAUDE.md` (global). All parent commands (`just`, `bootstrap`, etc.) remain available.

## Architecture

**Connection Flow:**
```
Client (iPad/Android/Mac)
  → SSH over Tailscale VPN
  → .zshrc detects $SSH_CONNECTION
  → Shows MOTD (templates/motd.sh)
  → exec zellij attach --create remote
  → Persistent "remote" session
```

**Key Components:**
- **Tailscale:** Zero-config VPN mesh (works on any network)
- **Zellij:** Terminal multiplexer with persistent sessions
- **Auto-attach:** SSH triggers automatic Zellij attachment (src/.zshrc:218-229)
- **MOTD:** Welcome message with cheatsheet (~/.config/remote/motd.sh)
- **devserver:** Binds dev servers to 0.0.0.0 for Tailscale network access (src/.aliases:471-508)

## Files

### This Directory
- `templates/motd.sh` - Dynamic welcome message, shows Tailscale hostname and random alias tip
- `setup-server.sh` - Server automation (enable SSH, install MOTD, configure power, verify prerequisites)
- `README.md` - Complete user guide (replaces old IPAD_SETUP.md)
- `CLAUDE.md` - This file (AI system prompt)
- `.claude/settings.json` - Workspace config (includes parent `../`)

### Parent Directory Integration
- `../src/.zshrc:218-229` - Auto-attach logic (detects SSH, shows MOTD, execs zellij)
- `../src/.aliases:471-508` - devserver function (binds to 0.0.0.0, detects framework)
- `../justfile:87-97` - `just code` command (renamed from `just dev`, backwards compatible alias)
- `../justfile:229-243` - Remote commands (setup-remote, remote-status, remote-motd, remote-test)
- `../init.sh:169-199` - Optional remote setup prompt (after hardware setup)
- `../src/.config/zellij/config.kdl` - Multiplexer configuration

## Commands

### Setup
```bash
./init.sh                     # Prompted for remote setup (optional)
./remote/setup-server.sh      # Manual server setup
just setup-remote             # Alias for setup-server.sh
```

### Remote Operations
```bash
just remote-status            # Tailscale status
just remote-motd              # Test MOTD
just remote-test              # Loopback SSH test
```

### Session Management
```bash
just code [name]              # Create/attach session (local)
just sessions                 # List active sessions
devserver [port]              # Bind dev server to 0.0.0.0
```

### User Workflow
```bash
# From iPad/Android:
ssh macname.tail7a4b9.ts.net  # Auto-attaches to "remote" session
Ctrl+s, d                     # Detach (session persists)
Ctrl+q                        # Quit (kills session)
```

## Critical Behaviors

**Auto-Attach:**
- Triggered by `$SSH_CONNECTION` in .zshrc
- Single persistent "remote" session for all SSH connections
- Multiple devices can attach simultaneously (shared view)
- Session survives disconnects, network changes, device sleeps

**Frontend Preview:**
- `devserver` binds to 0.0.0.0 (all interfaces)
- Accessible via `http://macname.tail7a4b9.ts.net:PORT`
- Auto-detects Next.js (npm), bun, npm frameworks
- No SSH port forwarding needed (Tailscale provides direct network access)

**Command Naming:**
- `just code` (not `just dev` - avoids bun/npm dev conflicts)
- Temporary backwards compatibility: `alias dev := code`

## Implementation Notes

**Server Setup (setup-server.sh):**
1. Verifies Tailscale installed and authenticated
2. Verifies Zellij installed
3. Enables SSH if needed (sudo systemsetup -setremotelogin on)
4. Installs MOTD to ~/.config/remote/motd.sh
5. Optionally configures power management (pmset) for always-on server mode
6. Shows Tailscale hostname for client configuration

**MOTD (templates/motd.sh):**
- Gets Tailscale DNS name from `tailscale status --json`
- Fallback to constructed hostname: `hostname.tail7a4b9.ts.net`
- Shows Zellij cheatsheet, preview URL template, commands
- Displays random alias tip from show-alias-tips.sh

**Auto-Attach (.zshrc):**
- Checks `$SSH_CONNECTION` and `!$ZELLIJ`
- Uses `exec` to replace shell process (clean detach behavior)
- Session named "remote" (consistent across all SSH connections)
- Zellij flag `--create` ensures session exists

## Testing

**Local (M3):**
```bash
./remote/templates/motd.sh                  # Test MOTD
./remote/setup-server.sh                    # Run setup
SSH_CONNECTION="test" zsh                   # Simulate SSH
ssh $(hostname -s).tail7a4b9.ts.net         # Loopback test
```

**Remote (iPad → M3):**
```bash
# From iPad Termius:
ssh m3mac.tail7a4b9.ts.net                  # Should show MOTD, auto-attach
Ctrl+s, d                                   # Detach
# Reconnect - same session
```

**M1 Deployment:**
```bash
# On M1:
cd ~/dotfiles && git pull && ./init.sh      # Answer "Yes" to remote setup
```

## Anti-Patterns

```
❌ Don't create SSH config templates (user knows how to SSH)
❌ Don't suggest manual .zshrc edits (auto-attach is automated)
❌ Don't recommend individual session names over SSH (single "remote" session is the design)
❌ Don't suggest SSH port forwarding for previews (Tailscale provides direct access)
❌ Don't use `just dev` in new docs (renamed to `just code`)
```

## Quick Reference

**File Locations:**
- Auto-attach logic: `src/.zshrc:218-229`
- devserver function: `src/.aliases:471-508`
- Setup script: `remote/setup-server.sh`
- MOTD template: `remote/templates/motd.sh`
- Zellij config: `src/.config/zellij/config.kdl`

**Tailscale DNS Pattern:**
- `macname.tail7a4b9.ts.net` (specific to this Tailnet)
- Get via: `tailscale status --json | grep DNSName`

---

*This configuration enables true mobile development - full dev environment from any device with internet.*
*Built on Tailscale (VPN), Zellij (multiplexer), and auto-attach (.zshrc).*
