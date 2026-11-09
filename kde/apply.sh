#!/usr/bin/env bash
# Make KDE Plasma 6 (Steam Deck desktop mode) behave like hypr/base.lua:
# Krohnkite tiling, 8 virtual desktops, Hyprland-style global shortcuts.
# Safe to re-run. Undo with: kde/apply.sh --reset  (or uninstall.sh kde)
set -euo pipefail

KDE_DIR="$(cd "$(dirname "$0")" && pwd)"
APPS_DIR="$HOME/.local/share/applications"
KROHNKITE_VERSION="0.9.9.2"
KROHNKITE_URL="https://github.com/anametologin/krohnkite/releases/download/$KROHNKITE_VERSION/krohnkite.kwinscript"

kwin_reconfigure() { qdbus org.kde.KWin /KWin reconfigure >/dev/null 2>&1 || true; }

if [ "${1:-}" = "--reset" ]; then
  echo "Resetting KDE shortcuts and tiling..."
  python3 "$KDE_DIR/shortcuts.py" --reset
  rm -f "$APPS_DIR"/hyprkeys-*.desktop
  kwriteconfig6 --file kwinrc --group Plugins --key krohnkiteEnabled false
  kwin_reconfigure
  kbuildsycoca6 >/dev/null 2>&1 || true
  echo "Done. (Virtual desktops and Krohnkite itself are left in place.)"
  exit 0
fi

# ---- Krohnkite -----------------------------------------------------------------
installed=$(kpackagetool6 --type KWin/Script --show krohnkite 2>/dev/null | sed -n 's/.*Version *: *//p' || true)
if [ "$installed" != "$KROHNKITE_VERSION" ]; then
  echo "Installing Krohnkite $KROHNKITE_VERSION..."
  tmp=$(mktemp -d)
  curl -fsSL -o "$tmp/krohnkite.kwinscript" "$KROHNKITE_URL"
  if [ -n "$installed" ]; then
    kpackagetool6 --type KWin/Script -u "$tmp/krohnkite.kwinscript"
  else
    kpackagetool6 --type KWin/Script -i "$tmp/krohnkite.kwinscript"
  fi
  rm -rf "$tmp"
fi

kw() { kwriteconfig6 --file kwinrc --group "$1" --key "$2" "$3"; }
kw Plugins krohnkiteEnabled true
# gaps: hyprland gaps_in = 5, gaps_out = 0
kw Script-krohnkite screenGapBetween 5
for side in Left Right Top Bottom; do kw Script-krohnkite "screenGap$side" 0; done
# layouts cycled by Super+T: spiral (~dwindle), tile (~master), monocle. 0 disables.
for l in threeColumn quarter stacked columns spread floating stair binaryTree cascade; do
  kw Script-krohnkite "${l}LayoutOrder" 0
done
kw Script-krohnkite spiralLayoutOrder 1
kw Script-krohnkite tileLayoutOrder 2
kw Script-krohnkite monocleLayoutOrder 3
# hyprland: hyprpwcenter / pavucontrol float
kw Script-krohnkite floatingClass "org.pulseaudio.pavucontrol,pavucontrol,org.kde.spectacle,krunner"

# Super + left/right drag moves/resizes (KWin default, set explicitly)
kw MouseBindings CommandAllKey Meta

# caps:swapescape, as in hyprland input.kb_options
kwriteconfig6 --file kxkbrc --group Layout --key ResetOldOptions true
kwriteconfig6 --file kxkbrc --group Layout --key Options caps:swapescape
# tell KWin to re-read kxkbrc now (same signal the Keyboard KCM sends on Apply)
dbus-send --session --type=signal /Layouts org.kde.keyboard.reloadConfig 2>/dev/null || true

kwin_reconfigure

# ---- 8 virtual desktops -------------------------------------------------------
count=$(qdbus org.kde.KWin /VirtualDesktopManager org.kde.KWin.VirtualDesktopManager.count 2>/dev/null || echo 8)
while [ "$count" -lt 8 ]; do
  qdbus org.kde.KWin /VirtualDesktopManager org.kde.KWin.VirtualDesktopManager.createDesktop "$count" "$((count + 1))" >/dev/null
  count=$((count + 1))
done

# ---- launchers for commands that have no KDE action ---------------------------
mkdir -p "$APPS_DIR"
launcher() {
  local id="$1" name="$2" exec="$3"
  cat >"$APPS_DIR/hyprkeys-$id.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=$name
Exec=$exec
NoDisplay=true
X-KDE-StartupNotify=false
EOF
}
launcher screenshot-clip "Screenshot region to clipboard" "spectacle -b -n -r -c"
launcher screenshot-save "Screenshot region to ~/screenshot.png" "sh -c 'spectacle -b -n -r -o \"\$HOME/screenshot.png\"'"
launcher reload "Reload Hyprland-style KDE config" "sh -c '$KDE_DIR/apply.sh && notify-send \"KDE config reloaded\"'"
for n in 1 2 3 4 5 6 7 8; do
  launcher "move-follow-$n" "Move window to desktop $n and follow" "$KDE_DIR/move-follow $n"
done
kbuildsycoca6 >/dev/null 2>&1 || true

# ---- shortcuts ------------------------------------------------------------------
sleep 1 # let Krohnkite register its actions after the reconfigure
echo "Applying shortcuts..."
python3 "$KDE_DIR/shortcuts.py"

echo "Done. If caps:swapescape doesn't take effect, log out and back in."
