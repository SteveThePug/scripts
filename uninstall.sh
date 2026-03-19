#!/usr/bin/env bash
set -euo pipefail

SCRIPTS_DIR="$HOME/scripts"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR=""

usage() {
  echo "Usage: $(basename "$0") [OPTIONS] <target>..."
  echo
  echo "Targets:"
  echo "  hyprland    Hyprland + waybar + wofi"
  echo "  sway        Sway + waybar + wofi"
  echo "  i3          i3 + i3blocks + i3status"
  echo "  cursor      Miku cursor theme"
  echo "  shell       Remove sourced bashrc/zshrc and sh/ from PATH"
  echo "  alacritty   Remove import from alacritty.toml"
  echo "  tmux        Remove sourced tmux.conf"
  echo "  nvim        Neovim (LazyVim) config"
  echo "  vim         Remove sourced vimrc"
  echo "  all         Everything (uses hyprland as WM)"
  echo
  echo "Options:"
  echo "  -h, --help         Show this help"
  echo "  --backup <dir>     Use specific backup directory for restoring"
  echo "                     (default: most recent in $SCRIPTS_DIR/backups/)"
}

# Find the backup directory to restore from
find_backup() {
  if [ -n "$BACKUP_DIR" ]; then
    if [ ! -d "$BACKUP_DIR" ]; then
      echo "Error: backup directory not found: $BACKUP_DIR"
      exit 1
    fi
    return
  fi
  local backups_root="$SCRIPTS_DIR/backups"
  if [ -d "$backups_root" ]; then
    local latest
    latest=$(ls -1d "$backups_root"/*/ 2>/dev/null | sort | tail -n1 || true)
    if [ -n "$latest" ]; then
      BACKUP_DIR="${latest%/}"
      echo "Using backup: $BACKUP_DIR"
    fi
  fi
  if [ -z "$BACKUP_DIR" ]; then
    echo "No backups found, will only remove without restoring"
  fi
}

# Remove a symlink if it points into $SCRIPTS_DIR, then restore from backup if available
restore() {
  local dest="$1"
  local name
  name=$(basename "$dest")

  if [ -L "$dest" ]; then
    local target
    target=$(readlink "$dest")
    if [[ "$target" == "$SCRIPTS_DIR"* ]]; then
      rm "$dest"
      echo "  Removed symlink $dest"
    else
      echo "  Skipping $dest (symlink does not point into $SCRIPTS_DIR)"
      return
    fi
  elif [ -e "$dest" ]; then
    echo "  Skipping $dest (not a symlink, won't remove)"
    return
  else
    echo "  $dest does not exist, nothing to remove"
  fi

  # Restore from backup if available
  if [ -n "$BACKUP_DIR" ] && [ -e "$BACKUP_DIR/$name" ]; then
    cp -a "$BACKUP_DIR/$name" "$dest"
    echo "  Restored $dest from backup"
  fi
}

# Remove exact matching lines from a file
remove_line() {
  local file="$1" line="$2"
  if [ ! -f "$file" ]; then
    echo "  $file does not exist, nothing to remove"
    return
  fi
  if grep -qF "$line" "$file"; then
    local tmp
    tmp=$(mktemp)
    grep -vF "$line" "$file" > "$tmp" || true
    mv "$tmp" "$file"
    echo "  Removed from $file: $line"
    # Delete file if only whitespace remains
    if [ ! -s "$file" ] || ! grep -q '[^[:space:]]' "$file"; then
      rm "$file"
      echo "  Deleted empty $file"
    fi
  else
    echo "  Line not found in $file: $line"
  fi
}

uninstall_hyprland() {
  echo "Uninstalling Hyprland configs..."
  restore "$CONFIG_DIR/hypr"
  restore "$CONFIG_DIR/waybar"
  restore "$CONFIG_DIR/wofi"
}

uninstall_sway() {
  echo "Uninstalling Sway configs..."
  restore "$CONFIG_DIR/sway"
  restore "$CONFIG_DIR/waybar"
  restore "$CONFIG_DIR/wofi"
}

uninstall_i3() {
  echo "Uninstalling i3 configs..."
  restore "$CONFIG_DIR/i3"
  restore "$CONFIG_DIR/i3blocks"
  restore "$CONFIG_DIR/i3status"
}

uninstall_cursor() {
  echo "Uninstalling cursor theme..."
  restore "$HOME/.local/share/icons/Miku Cursor"
}

uninstall_shell() {
  echo "Uninstalling shell configs..."
  if [ -f "$HOME/.zshrc" ]; then
    remove_line "$HOME/.zshrc" "source ~/scripts/zshrc"
    remove_line "$HOME/.zshrc" 'export PATH="$HOME/scripts/sh:$PATH"'
  fi
  if [ -f "$HOME/.bashrc" ]; then
    remove_line "$HOME/.bashrc" "source ~/scripts/bashrc"
    remove_line "$HOME/.bashrc" 'export PATH="$HOME/scripts/sh:$PATH"'
  fi
}

uninstall_alacritty() {
  echo "Uninstalling Alacritty config..."
  local conf="$CONFIG_DIR/alacritty/alacritty.toml"
  remove_line "$conf" 'import = ["~/scripts/alacritty.toml"]'
}

uninstall_tmux() {
  echo "Uninstalling tmux config..."
  remove_line "$HOME/.tmux.conf" "source ~/scripts/tmux.conf"
}

uninstall_nvim() {
  echo "Uninstalling Neovim config..."
  restore "$CONFIG_DIR/nvim"
}

uninstall_vim() {
  echo "Uninstalling vim config..."
  remove_line "$HOME/.vimrc" "source ~/scripts/vimrc"
}

if [ $# -eq 0 ]; then
  usage
  exit 1
fi

targets=()
while [ $# -gt 0 ]; do
  case "$1" in
  -h | --help)
    usage
    exit 0
    ;;
  --backup)
    if [ $# -lt 2 ]; then
      echo "Error: --backup requires a directory argument"
      exit 1
    fi
    BACKUP_DIR="$2"
    shift 2
    ;;
  all)
    targets+=(hyprland cursor shell alacritty tmux nvim vim)
    shift
    ;;
  *)
    targets+=("$1")
    shift
    ;;
  esac
done

find_backup

for target in "${targets[@]}"; do
  case "$target" in
  hyprland) uninstall_hyprland ;;
  sway) uninstall_sway ;;
  i3) uninstall_i3 ;;
  cursor) uninstall_cursor ;;
  shell) uninstall_shell ;;
  alacritty) uninstall_alacritty ;;
  tmux) uninstall_tmux ;;
  nvim) uninstall_nvim ;;
  vim) uninstall_vim ;;
  *)
    echo "Unknown target: $target"
    usage
    exit 1
    ;;
  esac
done

echo "Done!"
