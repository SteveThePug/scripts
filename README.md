# scripts
A collection of my Linux scripts and configs that I use across my machines.

When refering to {repo_dir}, be sure to use absolute paths! I am using
repo_dir = ~/scripts

# .tmux.conf
I use i3 window manager, and I appreciate its default keybindings and navigation.
They have been ported over to tmux, please read the file for information on the keys.
The direction navigation is the same as vim.
In the root `~/.tmux.conf`
add 
```
source {repo_dir}/tmux.conf
```
## Keyboard binding for Tmux
| Keybinding | Description |
|------------|-------------|
| <kbd>M-f</kbd> | Prefix key (similar to <kbd>$mod</kbd> in i3) |
| <kbd>Prefix</kbd> + <kbd>Space</kbd> | Send prefix |
| <kbd>Prefix</kbd> + <kbd>?</kbd> | List keys |
| <kbd>Prefix</kbd> + <kbd>[</kbd> | Enter copy mode |
| <kbd>Prefix</kbd> + <kbd>]</kbd> | Paste buffer |
| <kbd>Prefix</kbd> + <kbd>r</kbd> | Refresh client |
| <kbd>Prefix</kbd> + <kbd>R</kbd> | Reload tmux configuration |
| <kbd>Prefix</kbd> + <kbd>g</kbd> | Split window horizontally |
| <kbd>Prefix</kbd> + <kbd>v</kbd> | Split window vertically |
| <kbd>Prefix</kbd> + <kbd>h</kbd> | Select pane on the left |
| <kbd>Prefix</kbd> + <kbd>j</kbd> | Select pane below |
| <kbd>Prefix</kbd> + <kbd>k</kbd> | Select pane above |
| <kbd>Prefix</kbd> + <kbd>l</kbd> | Select pane on the right |
| <kbd>Prefix</kbd> + <kbd>H</kbd> | Resize pane left |
| <kbd>Prefix</kbd> + <kbd>J</kbd> | Resize pane down |
| <kbd>Prefix</kbd> + <kbd>K</kbd> | Resize pane up |
| <kbd>Prefix</kbd> + <kbd>L</kbd> | Resize pane right |
| <kbd>Prefix</kbd> + <kbd>w</kbd> | Choose window |
| <kbd>Prefix</kbd> + <kbd>1</kbd>-<kbd>0</kbd> | Select window 1-10 |
| <kbd>M-1</kbd> to <kbd>M-0</kbd> | Create new window 1-10 |
| <kbd>Prefix</kbd> + <kbd>!</kbd> | Move current pane to window 1 |
| <kbd>Prefix</kbd> + <kbd>@</kbd> | Move current pane to window 2 |
| <kbd>Prefix</kbd> + <kbd>#</kbd> | Move current pane to window 3 |
| <kbd>Prefix</kbd> + <kbd>$</kbd> | Move current pane to window 4 |
| <kbd>Prefix</kbd> + <kbd>%</kbd> | Move current pane to window 5 |
| <kbd>Prefix</kbd> + <kbd>^</kbd> | Move current pane to window 6 |
| <kbd>Prefix</kbd> + <kbd>&</kbd> | Move current pane to window 7 |
| <kbd>Prefix</kbd> + <kbd>*</kbd> | Move current pane to window 8 |
| <kbd>Prefix</kbd> + <kbd>(</kbd> | Move current pane to window 9 |
| <kbd>Prefix</kbd> + <kbd>)</kbd> | Move current pane to window 10 |
| <kbd>Prefix</kbd> + <kbd>q</kbd> | Kill selected pane |

# .bashrc ^ .zshrc
I prefer my capslock to be esc, so I have included that in the .bashrc file.
These files will also add the repository to the path so that the bash scripts are accessible by the command line.
Use either file respectively
```
source {repo_dir}/bashrc
export PATH="{repo_dir}/sh:$PATH"
```
```
source {repo_dir}/zshrc`
export PATH="{repo_dir}/sh:$PATH"
```

# .vimrc
This also needs similar treatment
```
source {repo_dir}/vimrc
```

# i3config
I also have my own personal i3 bindings, that mimic vim.
Please add to your `~/.i3/config` file:
```
include {repo_dir}/i3config
```
## Keybindings for i3
| Keybinding | Description |
|------------|-------------|
| <kbd>$mod</kbd> + <kbd>Return</kbd> | Start a terminal (Alacritty) |
| <kbd>$mod</kbd> + <kbd>Shift</kbd> + <kbd>q</kbd> | Kill focused window |
| <kbd>$mod</kbd> + <kbd>d</kbd> | Start program launcher (dmenu) |
| <kbd>$mod</kbd> + <kbd>z</kbd> | Launch categorized menu |
| <kbd>$mod</kbd> + <kbd>Ctrl</kbd> + <kbd>m</kbd> | Launch PulseAudio control |
| <kbd>$mod</kbd> + <kbd>Ctrl</kbd> + <kbd>b</kbd> | Launch bmenu in terminal |
| <kbd>$mod</kbd> + <kbd>F2</kbd> | Launch Pale Moon browser |
| <kbd>$mod</kbd> + <kbd>F3</kbd> | Launch PCManFM file manager |
| <kbd>$mod</kbd> + <kbd>Shift</kbd> + <kbd>F3</kbd> | Launch PCManFM file manager with elevated privileges |
| <kbd>$mod</kbd> + <kbd>F5</kbd> | Launch MOCP music player |
| <kbd>$mod</kbd> + <kbd>t</kbd> | Kill Picom compositor |
| <kbd>$mod</kbd> + <kbd>Ctrl</kbd> + <kbd>t</kbd> | Start Picom compositor |
| <kbd>$mod</kbd> + <kbd>Shift</kbd> + <kbd>d</kbd> | Restart Dunst notification daemon |
| <kbd>Print</kbd> | Take a screenshot |
| <kbd>$mod</kbd> + <kbd>Print</kbd> | Take a screenshot of active window |
| <kbd>$mod</kbd> + <kbd>Shift</kbd> + <kbd>Print</kbd> | Take a screenshot of selected area |
| <kbd>$mod</kbd> + <kbd>Ctrl</kbd> + <kbd>x</kbd> | Launch xkill |
| <kbd>$mod</kbd> + <kbd>h</kbd>/<kbd>j</kbd>/<kbd>k</kbd>/<kbd>l</kbd> | Change focus (left/down/up/right) |
| <kbd>$mod</kbd> + <kbd>Shift</kbd> + <kbd>h</kbd>/<kbd>j</kbd>/<kbd>k</kbd>/<kbd>l</kbd> | Move focused window (left/down/up/right) |
| <kbd>$mod</kbd> + <kbd>b</kbd> | Switch to previous workspace |
| <kbd>$mod</kbd> + <kbd>g</kbd> | Split horizontally |
| <kbd>$mod</kbd> + <kbd>v</kbd> | Split vertically |
| <kbd>$mod</kbd> + <kbd>f</kbd> | Toggle fullscreen |
| <kbd>$mod</kbd> + <kbd>s</kbd> | Layout stacking |
| <kbd>$mod</kbd> + <kbd>w</kbd> | Layout tabbed |
| <kbd>$mod</kbd> + <kbd>e</kbd> | Toggle split layout |
| <kbd>$mod</kbd> + <kbd>Shift</kbd> + <kbd>space</kbd> | Toggle floating |
| <kbd>$mod</kbd> + <kbd>space</kbd> | Toggle focus between tiling/floating windows |
| <kbd>$mod</kbd> + <kbd>a</kbd> | Focus parent container |
| <kbd>$mod</kbd> + <kbd>1</kbd>-<kbd>8</kbd> | Switch to workspace 1-8 |
| <kbd>$mod</kbd> + <kbd>Shift</kbd> + <kbd>1</kbd>-<kbd>8</kbd> | Move container to workspace 1-8 |
| <kbd>$mod</kbd> + <kbd>Shift</kbd> + <kbd>c</kbd> | Reload the configuration file |
| <kbd>$mod</kbd> + <kbd>Shift</kbd> + <kbd>r</kbd> | Restart i3 |
| <kbd>$mod</kbd> + <kbd>0</kbd> | Enter system mode (lock, exit, suspend, etc.) |
| <kbd>$mod</kbd> + <kbd>r</kbd> | Enter resize mode |
| <kbd>$mod</kbd> + <kbd>9</kbd> | Lock screen |
| <kbd>$mod</kbd> + <kbd>m</kbd> | Toggle i3bar visibility |
| <kbd>$mod</kbd> + <kbd>Shift</kbd> + <kbd>g</kbd> | Enter gap adjustment mode |

# getfile ^ sharefile
These are short bash scripts that help upload files to `https://0x0.st`
`sharefile {filename}` Will upload the file to 0x0.st and return the unique identifier
`getfile {id}` Will retrieve the file from 0x0.st

