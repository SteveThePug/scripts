# scripts
A collection of my Linux scripts and configs that I use across my machines.

# .tmux.conf
I use i3 window manager, and I appreciate its default keybindings and navigation.
I also have made the direction navigation the same as VIM.
In the root `~/.tmux.conf` you need to add `source {repo_dir}/.tmux.conf`

# .bashrc ^ .zshrc
I prefer my capslock to be esc, so I have included that in the .bashrc file.
These files will also add the repository to the path so that the bash scripts are accessible by the command line.
Use either file respectively
```
source {repo_dir}/.bashrc
export PATH="$HOME/scripts/sh:$PATH"
```
```
source {repo_dir}/.zshrc`
export PATH="$HOME/scripts/sh:$PATH"
```

# .vimrc
This also needs similar treatment

# getfile ^ sharefile
These are short bash scripts that help upload files to `https://0x0.st`
`sharefile {filename}` Will upload the file to 0x0.st and return the unique identifier
`getfile {id}` Will retrieve the file from 0x0.st
