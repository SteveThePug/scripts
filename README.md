# Linux Scripts and Configs

A collection of Linux scripts and configs for use across multiple machines.

## Installation

When referring to `{repo_dir}`, use absolute paths (e.g., `~/scripts`).

### alacritty configuration
Add this to the `.config/alacritty/alacritty.toml`
```
import = [
  "~/scripts/alacritty.toml"
]
```

### tmux Configuration
This config uses tmux plugin manager to add session save / reloading with tmux-ressurect.
Before using the config, please download the plugin manager with:
```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Then to use the config file, add to `~/.tmux.conf`:
```
source {repo_dir}/tmux.conf
```

### Bash/Zsh Configuration

Add to `~/.bashrc` or `~/.zshrc`:
```bash
source {repo_dir}/bashrc  # or zshrc
export PATH="{repo_dir}/sh:$PATH"
```

### Vim Configuration

Add to `~/.vimrc`:
```
source {repo_dir}/vimrc
```

### i3 Configuration

Add to `~/.i3/config`:
```
include {repo_dir}/i3config
```

## Keybindings

### tmux Keybindings

| Keybinding | Description |
|------------|-------------|
| <kbd>M-f</kbd> | Prefix key (similar to <kbd>$mod</kbd> in i3) |
| <kbd>Prefix</kbd> + <kbd>Space</kbd> | Send prefix |
| <kbd>Prefix</kbd> + <kbd>Ctrl</kbd> + <kbd>s</kbd> | Save session |
| <kbd>Prefix</kbd> + <kbd>Ctrl</kbd> + <kbd>r</kbd> | Restore session |
| <kbd>Prefix</kbd> + <kbd>?</kbd> | List keys |
| <kbd>Prefix</kbd> + <kbd>[</kbd> | Enter copy mode |
| <kbd>Prefix</kbd> + <kbd>]</kbd> | Paste buffer |
| <kbd>Prefix</kbd> + <kbd>r</kbd> | Refresh client |
| <kbd>Prefix</kbd> + <kbd>R</kbd> | Reload tmux configuration |
| <kbd>Prefix</kbd> + <kbd>g</kbd> | Split window horizontally |
| <kbd>Prefix</kbd> + <kbd>v</kbd> | Split window vertically |
| <kbd>Prefix</kbd> + <kbd>h</kbd>/<kbd>j</kbd>/<kbd>k</kbd>/<kbd>l</kbd> | Select pane (left/down/up/right) |
| <kbd>Prefix</kbd> + <kbd>H</kbd>/<kbd>J</kbd>/<kbd>K</kbd>/<kbd>L</kbd> | Resize pane (left/down/up/right) |
| <kbd>Prefix</kbd> + <kbd>w</kbd> | Choose window |
| <kbd>Prefix</kbd> + <kbd>1</kbd>-<kbd>0</kbd> | Select window 1-10 |
| <kbd>M-1</kbd> to <kbd>M-0</kbd> | Create new window 1-10 |
| <kbd>Prefix</kbd> + <kbd>!</kbd>-<kbd>)</kbd> | Move current pane to window 1-10 |
| <kbd>Prefix</kbd> + <kbd>q</kbd> | Kill selected pane |

### i3 Keybindings

| Keybinding | Description |
|------------|-------------|
| <kbd>$mod</kbd> + <kbd>Return</kbd> | Start a terminal (Alacritty) |
| <kbd>$mod</kbd> + <kbd>Shift</kbd> + <kbd>q</kbd> | Kill focused window |
| <kbd>$mod</kbd> + <kbd>d</kbd> | Start program launcher (dmenu) |
| <kbd>$mod</kbd> + <kbd>z</kbd> | Launch categorized menu |
| <kbd>$mod</kbd> + <kbd>Ctrl</kbd> + <kbd>m</kbd> | Launch PulseAudio control |
| <kbd>$mod</kbd> + <kbd>F2</kbd> | Launch Firefox browser |
| <kbd>$mod</kbd> + <kbd>F3</kbd> | Launch PCManFM file manager |
| <kbd>$mod</kbd> + <kbd>h</kbd>/<kbd>j</kbd>/<kbd>k</kbd>/<kbd>l</kbd> | Change focus (left/down/up/right) |
| <kbd>$mod</kbd> + <kbd>Shift</kbd> + <kbd>h</kbd>/<kbd>j</kbd>/<kbd>k</kbd>/<kbd>l</kbd> | Move focused window |
| <kbd>$mod</kbd> + <kbd>g</kbd>/<kbd>v</kbd> | Split horizontally/vertically |
| <kbd>$mod</kbd> + <kbd>f</kbd> | Toggle fullscreen |
| <kbd>$mod</kbd> + <kbd>1</kbd>-<kbd>8</kbd> | Switch to workspace 1-8 |
| <kbd>$mod</kbd> + <kbd>Shift</kbd> + <kbd>1</kbd>-<kbd>8</kbd> | Move container to workspace 1-8 |
| <kbd>$mod</kbd> + <kbd>Shift</kbd> + <kbd>c</kbd> | Reload the configuration file |
| <kbd>$mod</kbd> + <kbd>Shift</kbd> + <kbd>r</kbd> | Restart i3 |

## Additional Scripts

### File Sharing Scripts

- `sharefile {filename}`: Upload file to 0x0.st and return unique identifier
- `getfile {id}`: Retrieve file from 0x0.st

Note: These scripts interact with https://0x0.st for file sharing.
