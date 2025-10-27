# Zellij Quick Reference

> You're new to terminal multiplexers - this is your cheatsheet!

## What is Zellij?

Think of it like having multiple terminal tabs/windows, but they persist even when you disconnect. When you SSH in, you're automatically attached to your "remote" session.

## Essential Keys (Memorize These First!)

### Getting Out
- **`Ctrl+s` then `d`** - **DETACH** (keeps session running, exits SSH cleanly)
- **`Ctrl+q`** - **QUIT** (kills the session entirely)
- **`exit`** - Just closes current pane (if only one pane, exits zellij)

👉 **Use `Ctrl+s d` most of the time!** This is how you "pause" your work and come back later.

### Getting Help
- **`Ctrl+p` then `?`** - Show ALL keybindings (press `Esc` to close help)

## Creating Panes (Split Screen)

- **`Ctrl+p` then `d`** - Split DOWN (horizontal split, new pane below)
- **`Ctrl+p` then `r`** - Split RIGHT (vertical split, new pane to the right)
- **`Ctrl+p` then `x`** - Close current pane

Example workflow:
```
1. SSH in → you're in one pane
2. Press Ctrl+p, then r → now you have 2 panes side-by-side
3. Press Ctrl+p, then d → split the current pane horizontally
4. Now you have 3 panes!
```

## Moving Between Panes

- **`Ctrl+p` then arrow keys** - Move focus to different pane
- **`Ctrl+p` then `f`** - Toggle fullscreen (zoom current pane)

## Example: Typical Development Layout

```
┌────────────────┬──────────┐
│                │          │
│   nvim         │  eza -la │
│   (editing)    │  (files) │
│                │          │
├────────────────┴──────────┤
│  git status / commands    │
└───────────────────────────┘
```

**How to create this:**
1. Start with one pane (your shell)
2. `Ctrl+p` then `r` - split right, run `eza -la` or `ls`
3. Back to left pane: `Ctrl+p` then `←` (left arrow)
4. Open nvim: `nvim myfile.js`
5. `Ctrl+p` then `d` - split down for git commands
6. Done!

## Common Workflows

### Starting Work
```bash
# On iPad:
ssh m3mac  # or m1mac

# MOTD appears with instructions
# Press Enter

# You're in Zellij!
# Split screen how you like
# Start coding
```

### Taking a Break
```bash
# In Zellij:
Ctrl+s, d  # Detach

# Session keeps running!
# Close iPad, put it down
# Come back hours later...

ssh m3mac  # Reconnects to SAME session!
```

### Switching Devices
```bash
# On iPad:
Ctrl+s, d  # Detach
exit       # Close SSH

# On Android (5 minutes later):
ssh m3mac  # Press Enter at MOTD
# BOOM - exact same session, everything still there!
```

### Multiple Projects
```bash
# Currently in "remote" session (default)
Ctrl+s, d  # Detach

# Create new named session:
zellij -s dotfiles   # New session for dotfiles work
# Do some work...
Ctrl+s, d            # Detach

# Switch back:
zellij attach remote      # Back to default session
zellij attach dotfiles    # Back to dotfiles session

# List all sessions:
zellij list-sessions
# OR: just sessions
```

## Tips for New Users

1. **Don't panic if you get stuck** - Press `Ctrl+p` then `?` to see help
2. **Detach, don't quit** - Use `Ctrl+s d` (not `Ctrl+q`)
3. **Start simple** - Use one pane at first, add splits as you need them
4. **The status bar helps** - Bottom of screen shows current mode and hints
5. **Press `Esc`** - Gets you back to normal mode if you're stuck in a mode

## Quick Command Reference

```bash
# From your Mac (locally):
just sessions              # List all Zellij sessions
just code myproject        # Create/attach to "myproject" session
just kill myproject        # Kill a session

# Inside Zellij:
exit                       # Close current pane
Ctrl+s, d                  # Detach (MOST COMMON)
Ctrl+q                     # Quit entirely
Ctrl+p, ?                  # Show help
```

## Finding Your Macs (for SSH)

```bash
# From any Mac:
just remote-hosts

# Or:
tailscale-hosts

# Shows:
# 📡 Your Tailscale Network:
# ━━━━━━━━━━━━━━━━━━━━━━━━━━
#   🟢 olivers-macbook-pro.tail7a4b9.ts.net
#      → ssh yourusername@olivers-macbook-pro.tail7a4b9.ts.net
```

## Remember

- **Zellij sessions survive disconnects** - Your work is safe!
- **Each SSH connection shares the "remote" session** - Seamless device switching
- **Detach with `Ctrl+s d`** - Don't kill your work!
- **Help is always `Ctrl+p ?`** - When in doubt, check the help

---

**You've got this!** Start with one pane, practice detaching/reattaching, and gradually add more panes as you get comfortable. 🚀
