# Linux Scripts and Configs

Dotfiles and scripts for Arch Linux (Manjaro), targeting Wayland (Hyprland / Sway) with an i3 fallback.

## Setup

```bash
git clone --recurse-submodules <repo-url> ~/scripts
```

If already cloned without submodules:

```bash
git submodule update --init --recursive
```

Install all packages:

```bash
yay -S $(grep -v '^\s*$' ~/scripts/packages.txt | tr '\n' ' ')
```

## Linking Configs

Pick a window manager section below, then add the shared configs.

### Hyprland

```bash
ln -sf ~/scripts/hyprland/hyprland.conf ~/.config/hypr/hyprland.conf
ln -sf ~/scripts/waybar/waybar_hyprland_config.json ~/.config/waybar/config
ln -sf ~/scripts/waybar/waybar_style.css ~/.config/waybar/style.css
ln -sf ~/scripts/wofi/wofi_style.css ~/.config/wofi/style.css
```

### Sway

```bash
ln -sf ~/scripts/sway/swayconfig ~/.config/sway/config
ln -sf ~/scripts/waybar/waybar_sway_config.json ~/.config/waybar/config
ln -sf ~/scripts/waybar/waybar_style.css ~/.config/waybar/style.css
ln -sf ~/scripts/wofi/wofi_style.css ~/.config/wofi/style.css
```

### i3

```bash
ln -sf ~/scripts/i3/i3config ~/.config/i3/config
ln -sf ~/scripts/i3/i3blocks.conf ~/.config/i3blocks/config
ln -sf ~/scripts/i3/i3status.conf ~/.config/i3status/config
```

### Cursor

```bash
ln -sf ~/scripts/hatsune-miku-windows-linux-cursors/miku-cursor-linux ~/.local/share/icons/"Miku Cursor"
```

### Shell

Add to `~/.bashrc` or `~/.zshrc`:

```bash
source ~/scripts/bashrc  # or zshrc
export PATH="~/scripts/sh:$PATH"
```

### Terminals

**Alacritty** - add to `~/.config/alacritty/alacritty.toml`:

```toml
import = ["~/scripts/alacritty.toml"]
```

**Kitty** - kitty.conf is used directly by the WM configs.

### tmux

Install the plugin manager first:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Add to `~/.tmux.conf`:

```
source ~/scripts/tmux.conf
```

### Vim

Add to `~/.vimrc`:

```
source ~/scripts/vimrc
```

## Keybindings

All window managers and tmux use vim-style <kbd>h</kbd><kbd>j</kbd><kbd>k</kbd><kbd>l</kbd> navigation. `$mod` is the Super key.

### Shared across WMs

| Key | Action |
| --- | --- |
| `$mod + Return` | Terminal (kitty) |
| `$mod + Shift + q` | Kill window |
| `$mod + d` | Launcher (wofi / dmenu) |
| `$mod + h/j/k/l` | Focus left/down/up/right |
| `$mod + Shift + h/j/k/l` | Move window left/down/up/right |
| `$mod + g` / `$mod + v` | Split horizontal / vertical |
| `$mod + f` | Fullscreen |
| `$mod + Shift + Space` | Toggle floating |
| `$mod + 1-8` | Switch workspace |
| `$mod + Shift + 1-8` | Move window to workspace |
| `$mod + Ctrl + 1-8` | Move window silently |
| `$mod + -` | Scratchpad show |
| `$mod + Shift + -` | Move to scratchpad |
| `$mod + b` | Previous workspace |
| `$mod + 9` | Lock screen |
| `$mod + 0` | System menu (lock/suspend/reboot/shutdown) |
| `$mod + r` | Resize mode (hjkl) |
| `$mod + m` | Toggle bar |
| `$mod + Shift + c` | Reload config |
| `$mod + Ctrl + m` | PulseAudio control |
| `$mod + F2` | Browser (Waterfox) |
| `$mod + F3` | File manager (ranger) |
| `$mod + F5` | Music (mocp) |
| `Print` | Screenshot |

### System menu (`$mod + 0`)

| Key | Action |
| --- | --- |
| `l` | Lock |
| `s` | Suspend |
| `h` | Hibernate |
| `r` | Reboot |
| `Shift + s` | Power off |
| `e` | Exit session |
| `Return` / `Esc` | Cancel |

### tmux

Prefix is <kbd>Ctrl</kbd> + <kbd>f</kbd>.

| Key | Action |
| --- | --- |
| `Prefix + g` | Split horizontal |
| `Prefix + v` | Split vertical |
| `Prefix + h/j/k/l` | Select pane |
| `Prefix + Ctrl + H/J/K/L` | Resize pane |
| `Prefix + 1-0` | Select window 1-10 |
| `Alt + 1-0` | Create window 1-10 |
| `Prefix + !/@ etc.` | Move pane to window 1-10 |
| `Prefix + w` | Choose window |
| `Prefix + q` | Kill pane |
| `Prefix + [` / `]` | Copy mode / Paste |
| `Prefix + r` | Refresh |
| `Prefix + R` | Reload config |
| `Prefix + Ctrl + s` | Save session (resurrect) |
| `Prefix + Ctrl + r` | Restore session (resurrect) |

## Scripts

All in `sh/`, added to `$PATH` via the shell config above.

| Script | Description |
| --- | --- |
| `sharefile <file>` | Upload a file to 0x0.st |
| `getfile <id>` | Download a file from 0x0.st |
| `waybar-history` | Stream the last zsh history entry to waybar |
