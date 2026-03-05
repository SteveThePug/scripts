alias vim=nvim
alias python=ipython

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="re5et"

plugins=(
  git
  aliases
  docker-compose
  docker
  python
  node
  npm
  golang
  rust
  sudo
  extract
  history
  command-not-found
  archlinux
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
