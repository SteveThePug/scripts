# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a dotfiles/config repository for Arch Linux (Manjaro) using `yay` as the package manager. Configs are installed by symlinking or sourcing from `~/scripts/` into their standard locations. The repo targets Wayland-based desktops (Hyprland and Sway) with an i3 fallback for X11.

## Repository Structure

- **Window managers**: `hyprland/`, `sway/`, `i3/` - config files for each WM
- **Waybar**: `waybar/` - separate config JSONs per WM (`waybar_hyprland_config.json`, `waybar_sway_config.json`) plus shared `waybar_style.css`
- **Shell**: `bashrc`, `zshrc` - sourced from the user's dotfiles, not used directly
- **Terminal**: `alacritty.toml` (imported via alacritty's import system), `kitty.conf`
- **Scripts**: `sh/` - shell utilities added to PATH (`sharefile`, `getfile`, `waybar-history`)
- **Submodule**: `hatsune-miku-windows-linux-cursors` - cursor theme (init with `git submodule update --init --recursive`)
- **Packages**: `packages.txt` - list of packages installed via `yay -S`

## Key Conventions

- Configs are symlinked into `~/.config/` (see README.md for exact symlink commands per component)
- Shell configs (`bashrc`, `zshrc`) are sourced, not symlinked
- `alacritty.toml` uses alacritty's import mechanism rather than symlinking
- Hyprland is the primary/active WM (most recent changes)
- `$mod` in WM configs refers to the Super/Windows key
- Keybindings use vim-style hjkl navigation across all WMs and tmux
