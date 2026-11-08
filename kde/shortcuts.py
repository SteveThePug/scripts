#!/usr/bin/env python3
"""Apply Hyprland-style global shortcuts to KDE Plasma 6 through kglobalaccel's D-Bus API.

kglobalaccel lives inside kwin_wayland and keeps shortcuts in memory, writing them
back to ~/.config/kglobalshortcutsrc itself, so editing that file by hand while the
session is running does not stick. This sets them live instead.

Usage: shortcuts.py            apply the bindings below
       shortcuts.py --reset    put every action we touched back to its KDE default
"""

import json
import os
import sys

import dbus

STATE_FILE = os.path.expanduser("~/.local/state/hyprkeys/cleared.json")

# ---- key encoding (Qt6 QKeyCombination as int) -------------------------------

MODS = {"Meta": 0x10000000, "Shift": 0x02000000, "Ctrl": 0x04000000, "Alt": 0x08000000}
NAMED = {
    "Return": 0x01000004, "Esc": 0x01000000, "Tab": 0x01000001, "Print": 0x01000009,
    "Left": 0x01000012, "Up": 0x01000013, "Right": 0x01000014, "Down": 0x01000015,
    "PgUp": 0x01000016, "PgDown": 0x01000017, "Space": 0x20,
}
NAMED.update({f"F{n}": 0x0100002F + n for n in range(1, 13)})
# US-layout symbols typed with Shift+digit / Shift+minus
SHIFTED = {"1": "!", "2": "@", "3": "#", "4": "$", "5": "%", "6": "^", "7": "&", "8": "*", "-": "_"}


def key(spec):
    """'Meta+Shift+Q' -> int. The final part is a key name or a single character."""
    *mods, k = spec.split("+")
    code = sum(MODS[m] for m in mods)
    return code | (NAMED[k] if k in NAMED else ord(k.upper()))


def keys(*specs):
    """Expand specs into key ints. Meta+Shift+<digit> also adds the shifted symbol
    (Meta+!), because on Wayland the keysym carries the Shift."""
    out = []
    for s in specs:
        out.append(key(s))
        mods, _, k = s.rpartition("+")
        if "Shift" in mods.split("+") and k in SHIFTED:
            out.append(key(f"{mods}+{SHIFTED[k]}"))
    return out


# ---- binding table -------------------------------------------------------------
# (component, action, keys, mode)   mode: "set" replaces the keys, "add" keeps existing ones

K = "kwin"
BINDINGS = [
    # apps
    ("org.kde.konsole.desktop", "_launch", keys("Meta+Return"), "add"),
    ("org.kde.krunner.desktop", "_launch", keys("Meta+D"), "add"),
    ("org.mozilla.firefox.desktop", "_launch", keys("Meta+F2"), "set"),
    ("org.kde.dolphin.desktop", "_launch", keys("Meta+F3", "Meta+Shift+F3"), "set"),
    ("org.pulseaudio.pavucontrol.desktop", "_launch", keys("Meta+Ctrl+M"), "set"),
    # screenshots
    ("org.kde.spectacle.desktop", "RectangularRegionScreenShot", keys("Print"), "set"),
    ("hyprkeys-screenshot-clip.desktop", "_launch", keys("Meta+Print"), "set"),
    ("hyprkeys-screenshot-save.desktop", "_launch", keys("Meta+Shift+Print"), "set"),
    # window actions
    (K, "Window Close", keys("Meta+Shift+Q"), "add"),
    (K, "Kill Window", keys("Meta+Ctrl+X"), "add"),
    (K, "Window Fullscreen", keys("Meta+F"), "set"),
    (K, "Window Resize", keys("Meta+R"), "set"),
    (K, "Window On All Desktops", keys("Meta+Shift+S"), "set"),
    (K, "Window Minimize", keys("Meta+Shift+-"), "add"),
    (K, "Walk Through Windows", keys("Meta+Space"), "add"),
    (K, "Overview", keys("Meta+Shift+W"), "set"),
    # session
    ("ksmserver", "Lock Session", keys("Meta+9"), "add"),
    ("ksmserver", "Log Out", keys("Meta+0", "Meta+Shift+E"), "add"),
    ("hyprkeys-reload.desktop", "_launch", keys("Meta+Shift+C"), "set"),
    # Krohnkite tiling
    (K, "KrohnkiteFocusLeft", keys("Meta+H", "Meta+Left"), "set"),
    (K, "KrohnkiteFocusDown", keys("Meta+J", "Meta+Down"), "set"),
    (K, "KrohnkiteFocusUp", keys("Meta+K", "Meta+Up"), "set"),
    (K, "KrohnkiteFocusRight", keys("Meta+L", "Meta+Right"), "set"),
    (K, "KrohnkiteShiftLeft", keys("Meta+Shift+H", "Meta+Shift+Left"), "set"),
    (K, "KrohnkiteShiftDown", keys("Meta+Shift+J", "Meta+Shift+Down"), "set"),
    (K, "KrohnkiteShiftUp", keys("Meta+Shift+K", "Meta+Shift+Up"), "set"),
    (K, "KrohnkiteShiftRight", keys("Meta+Shift+L", "Meta+Shift+Right"), "set"),
    (K, "KrohnkiteShrinkWidth", keys("Meta+Ctrl+H"), "set"),
    (K, "KrohnkiteGrowHeight", keys("Meta+Ctrl+J"), "set"),
    (K, "KrohnkiteShrinkHeight", keys("Meta+Ctrl+K"), "set"),
    (K, "KrohnkitegrowWidth", keys("Meta+Ctrl+L"), "set"),
    (K, "KrohnkiteToggleFloat", keys("Meta+Shift+Space"), "set"),
    (K, "KrohnkiteNextLayout", keys("Meta+T"), "set"),
    (K, "KrohnkiteMonocleLayout", keys("Meta+W"), "set"),
    (K, "KrohnkiteRotate", keys("Meta+E"), "set"),
    (K, "KrohnkiteRotatePart", keys("Meta+V"), "set"),
    (K, "KrohnkiteTileLayout", [], "set"),
    (K, "KrohnkiteSetMaster", [], "set"),
    (K, "KrohnkiteDecrease", [], "set"),
]
for n in range(1, 9):
    BINDINGS += [
        (K, f"Switch to Desktop {n}", keys(f"Meta+{n}"), "set"),
        (K, f"Window to Desktop {n}", keys(f"Meta+Ctrl+{n}"), "set"),
        (f"hyprkeys-move-follow-{n}.desktop", "_launch", keys(f"Meta+Shift+{n}"), "set"),
    ]

# ---- D-Bus helpers ---------------------------------------------------------------

bus = dbus.SessionBus()
ka = dbus.Interface(bus.get_object("org.kde.kglobalaccel", "/kglobalaccel"), "org.kde.KGlobalAccel")


def to_dbus(key_ints):
    return dbus.Array(
        [dbus.Struct((dbus.Array([k, 0, 0, 0], signature="i"),), signature=None) for k in key_ints],
        signature="(ai)",
    )


def actions_of(comp):
    try:
        return {str(a[1]): [str(x) for x in a] for a in ka.allActionsForComponent([comp])}
    except dbus.DBusException:
        return {}


def current(action_id):
    return [int(s[0][0]) for s in ka.shortcutKeys(action_id) if int(s[0][0])]


def set_keys(action_id, key_ints):
    ka.setForeignShortcutKeys(action_id, to_dbus(key_ints))


def action_id(comp, action):
    known = actions_of(comp).get(action)
    if known:
        return known
    # not registered yet (our own .desktop launchers, or Krohnkite before it loads)
    aid = [comp, action, comp.removesuffix(".desktop"), action]
    ka.doRegister(aid)
    return aid


def all_actions():
    for comp in ka.allMainComponents():
        for aid in actions_of(str(comp[0])).values():
            yield aid


# ---- main ---------------------------------------------------------------------------


def apply():
    own = {(c, a): ks for c, a, ks, _ in BINDINGS}
    wanted = {k for ks in own.values() for k in ks}

    # 1. strip our keys from every action that holds one it isn't meant to have
    cleared = set()
    for aid in all_actions():
        mine = own.get((aid[0], aid[1]), [])
        have = current(aid)
        keep = [k for k in have if k not in wanted or k in mine]
        if keep != have:
            set_keys(aid, keep)
            if (aid[0], aid[1]) not in own:
                cleared.add((aid[0], aid[1]))
            print(f"  freed keys from {aid[0]} / {aid[1]}")

    # remember what we freed so --reset can put it back
    os.makedirs(os.path.dirname(STATE_FILE), exist_ok=True)
    prev = set()
    if os.path.exists(STATE_FILE):
        prev = {tuple(x) for x in json.load(open(STATE_FILE))}
    json.dump(sorted(prev | cleared), open(STATE_FILE, "w"))

    # 2. assign
    failed = []
    for comp, action, ks, mode in BINDINGS:
        aid = action_id(comp, action)
        new = ks
        if mode == "add":
            new = [k for k in current(aid) if k not in ks] + ks
        set_keys(aid, new)
        got = current(aid)
        if any(k not in got for k in ks):
            failed.append(f"{comp} / {action}")
    if failed:
        print("  WARNING: some keys were not accepted:\n    " + "\n    ".join(failed))
    print(f"  {len(BINDINGS)} shortcuts applied")


def reset():
    entries = [(c, a) for c, a, _, _ in BINDINGS]
    if os.path.exists(STATE_FILE):
        entries += [tuple(x) for x in json.load(open(STATE_FILE))]
    # Krohnkite and our own launchers go away entirely; clear them first so the
    # KDE defaults below don't collide with them.
    for comp, action in entries:
        if action.startswith("Krohnkite") or comp.startswith("hyprkeys-"):
            aid = actions_of(comp).get(action)
            if aid:
                set_keys(aid, [])
            if comp.startswith("hyprkeys-"):
                ka.unregister(comp, action)
    for comp, action in entries:
        if action.startswith("Krohnkite") or comp.startswith("hyprkeys-"):
            continue
        aid = actions_of(comp).get(action)
        if aid:
            set_keys(aid, [int(s[0][0]) for s in ka.defaultShortcutKeys(aid) if int(s[0][0])])
    if os.path.exists(STATE_FILE):
        os.remove(STATE_FILE)
    print("  shortcuts reset to KDE defaults")


if __name__ == "__main__":
    reset() if "--reset" in sys.argv else apply()
