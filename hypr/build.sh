#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
cat colors.lua base.lua >hyprland.lua
