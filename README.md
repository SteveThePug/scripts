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


# getfile ^ sharefile
These are short bash scripts that help upload files to `https://0x0.st`
`sharefile {filename}` Will upload the file to 0x0.st and return the unique identifier
`getfile {id}` Will retrieve the file from 0x0.st

