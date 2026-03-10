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
    echo "  shell       Source bashrc/zshrc and add sh/ to PATH"
    echo "  alacritty   Add import to alacritty.toml"
    echo "  tmux        Source tmux.conf"
    echo "  nvim        Neovim (LazyVim) config"
    echo "  vim         Source vimrc"
    echo "  all         Everything (uses hyprland as WM)"
    echo
    echo "Options:"
    echo "  -h, --help  Show this help"
}

backup() {
    local path="$1"
    if [ -e "$path" ] || [ -L "$path" ]; then
        if [ -z "$BACKUP_DIR" ]; then
            BACKUP_DIR="$SCRIPTS_DIR/backups/$(date +%Y%m%d_%H%M%S)"
            mkdir -p "$BACKUP_DIR"
            echo "Backing up existing configs to $BACKUP_DIR"
        fi
        local name
        name=$(basename "$path")
        cp -a "$path" "$BACKUP_DIR/$name"
        echo "  Backed up $path"
    fi
}

link() {
    local src="$1" dest="$2"
    backup "$dest"
    rm -rf "$dest"
    ln -sf "$src" "$dest"
    echo "  Linked $dest -> $src"
}

append_if_missing() {
    local file="$1" line="$2"
    if [ ! -f "$file" ]; then
        echo "$line" > "$file"
        echo "  Created $file with: $line"
    elif ! grep -qF "$line" "$file"; then
        echo "" >> "$file"
        echo "$line" >> "$file"
        echo "  Appended to $file: $line"
    else
        echo "  Already in $file: $line"
    fi
}

install_hyprland() {
    echo "Installing Hyprland configs..."
    "$SCRIPTS_DIR/hypr/build.sh"
    "$SCRIPTS_DIR/waybar/build.sh"
    "$SCRIPTS_DIR/wofi/build.sh"
    mkdir -p "$CONFIG_DIR"
    link "$SCRIPTS_DIR/hypr" "$CONFIG_DIR/hypr"
    link "$SCRIPTS_DIR/waybar" "$CONFIG_DIR/waybar"
    link "$SCRIPTS_DIR/wofi" "$CONFIG_DIR/wofi"
}

install_sway() {
    echo "Installing Sway configs..."
    "$SCRIPTS_DIR/sway/build.sh"
    "$SCRIPTS_DIR/waybar/build.sh"
    "$SCRIPTS_DIR/wofi/build.sh"
    mkdir -p "$CONFIG_DIR"
    link "$SCRIPTS_DIR/sway" "$CONFIG_DIR/sway"
    link "$SCRIPTS_DIR/waybar" "$CONFIG_DIR/waybar"
    link "$SCRIPTS_DIR/wofi" "$CONFIG_DIR/wofi"
}

install_i3() {
    echo "Installing i3 configs..."
    "$SCRIPTS_DIR/i3/build.sh"
    mkdir -p "$CONFIG_DIR"
    link "$SCRIPTS_DIR/i3" "$CONFIG_DIR/i3"
    link "$SCRIPTS_DIR/i3blocks" "$CONFIG_DIR/i3blocks"
    link "$SCRIPTS_DIR/i3status" "$CONFIG_DIR/i3status"
}

install_cursor() {
    echo "Installing cursor theme..."
    mkdir -p "$HOME/.local/share/icons"
    link "$SCRIPTS_DIR/hatsune-miku-windows-linux-cursors/miku-cursor-linux" "$HOME/.local/share/icons/Miku Cursor"
}

install_shell() {
    echo "Installing shell configs..."
    if [ -f "$HOME/.zshrc" ] || [ "$SHELL" = *zsh* ]; then
        append_if_missing "$HOME/.zshrc" "source ~/scripts/zshrc"
        append_if_missing "$HOME/.zshrc" 'export PATH="$HOME/scripts/sh:$PATH"'
    fi
    if [ -f "$HOME/.bashrc" ] || [ "$SHELL" = *bash* ]; then
        append_if_missing "$HOME/.bashrc" "source ~/scripts/bashrc"
        append_if_missing "$HOME/.bashrc" 'export PATH="$HOME/scripts/sh:$PATH"'
    fi
}

install_alacritty() {
    echo "Installing Alacritty config..."
    local conf="$CONFIG_DIR/alacritty/alacritty.toml"
    mkdir -p "$CONFIG_DIR/alacritty"
    append_if_missing "$conf" 'import = ["~/scripts/alacritty.toml"]'
}

install_tmux() {
    echo "Installing tmux config..."
    append_if_missing "$HOME/.tmux.conf" "source ~/scripts/tmux.conf"
}

install_nvim() {
    echo "Installing Neovim config..."
    mkdir -p "$CONFIG_DIR"
    link "$SCRIPTS_DIR/nvim" "$CONFIG_DIR/nvim"
}

install_vim() {
    echo "Installing vim config..."
    append_if_missing "$HOME/.vimrc" "source ~/scripts/vimrc"
}

if [ $# -eq 0 ]; then
    usage
    exit 1
fi

targets=()
for arg in "$@"; do
    case "$arg" in
        -h|--help) usage; exit 0 ;;
        all) targets+=(hyprland cursor shell alacritty tmux nvim vim) ;;
        *) targets+=("$arg") ;;
    esac
done

for target in "${targets[@]}"; do
    case "$target" in
        hyprland)  install_hyprland ;;
        sway)      install_sway ;;
        i3)        install_i3 ;;
        cursor)    install_cursor ;;
        shell)     install_shell ;;
        alacritty) install_alacritty ;;
        tmux)      install_tmux ;;
        nvim)      install_nvim ;;
        vim)       install_vim ;;
        *) echo "Unknown target: $target"; usage; exit 1 ;;
    esac
done

if [ -n "$BACKUP_DIR" ]; then
    echo
    echo "Backups saved to: $BACKUP_DIR"
fi
echo "Done!"
