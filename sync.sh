#!/usr/bin/env bash
# Собирает репозиторий из текущей системы: копирует конфиги, вычищает личное
# (пути /home/<user>, погоду, историю) и приводит позиции виджетов к долям экрана.
# Запуск: ./sync.sh  (потом git add/commit/push)
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
C="$HOME/.config"
D="$REPO/dotfiles"

rm -rf "$D"
mkdir -p "$D"

copy() { # copy <откуда> <куда относительно dotfiles>
    mkdir -p "$(dirname "$D/$2")"
    cp -a "$1" "$D/$2"
}

# --- Hyprland (конфиг caelestia на Lua + наши правки) ---
mkdir -p "$D/config/hypr/hyprland" "$D/config/hypr/scheme"
cp -a "$C/hypr/hyprland.lua" "$C/hypr/variables.lua" "$D/config/hypr/"
cp -a "$C/hypr/hyprland/"*.lua "$D/config/hypr/hyprland/"
cp -a "$C/hypr/scheme/default.lua" "$D/config/hypr/scheme/"

mkdir -p "$D/config/caelestia"
cp -a "$C/caelestia/hypr-vars.lua" "$D/config/caelestia/"
# Мониторы у каждого свои: строки hl.monitor из hypr-user.lua не публикуем
python3 - "$C/caelestia/hypr-user.lua" "$D/config/caelestia/hypr-user.lua" <<'EOF'
import re, sys
src = open(sys.argv[1]).read()
src = re.sub(r'hl\.monitor\(\{.*?\}\)\n*', '', src, flags=re.S)
src = src.replace(', monitor = "HDMI-A-1"', '')
header = ('-- Свои мониторы — в ~/.config/caelestia/hypr-local.lua (создаётся установщиком, в репозиторий не попадает)\n'
          'pcall(require, "hypr-local")\n\n')
open(sys.argv[2], "w").write(header + src.lstrip())
EOF

# --- DankMaterialShell ---
mkdir -p "$D/config/DankMaterialShell" "$D/state/DankMaterialShell"
python3 - "$C/DankMaterialShell" "$HOME/.local/state/DankMaterialShell/session.json" "$D" "$HOME" <<'EOF'
import json, os, sys
cfg, session, out, home = sys.argv[1:5]
s = json.load(open(os.path.join(cfg, "settings.json")))
ps = json.load(open(os.path.join(cfg, "plugin_settings.json")))
ss = json.load(open(session))

# Позиции виджетов: пиксели конкретного монитора -> доли экрана (работает на любом мониторе)
SW, SH = 1920, 1080
pos_out = {}
for inst in s.get("desktopWidgetInstances", []):
    p = ss.get("desktopWidgetInstancePositions", {}).get(inst["id"], {})
    src = p.get("_synced") or next(iter(p.values()), None)
    if not src:
        continue
    synced = "_synced" in p
    inst["config"]["syncPositionAcrossScreens"] = True
    pos_out[inst["id"]] = {"_synced": {
        "x": src["x"] if synced else src["x"] / SW,
        "y": src["y"] if synced else src["y"] / SH,
        "width": src["width"], "height": src["height"]}}

text = json.dumps(s, ensure_ascii=False, indent=2).replace(home, "__HOME__")
open(os.path.join(out, "config/DankMaterialShell/settings.json"), "w").write(text)
json.dump(ps, open(os.path.join(out, "config/DankMaterialShell/plugin_settings.json"), "w"), ensure_ascii=False, indent=2)
# Из session.json берём только раскладку виджетов и переход обоев — без погоды/истории/обоев
json.dump({"desktopWidgetInstancePositions": pos_out,
           "wallpaperTransition": ss.get("wallpaperTransition", "disc")},
          open(os.path.join(out, "state/DankMaterialShell/session.json"), "w"), ensure_ascii=False, indent=2)
EOF

# Плагины DMS (включая наш патч mediaPlayer) — без .git
mkdir -p "$D/config/DankMaterialShell/plugins"
for p in "$C/DankMaterialShell/plugins/"*/; do
    name="$(basename "$p")"
    rsync -a --exclude .git --exclude 'dist' "$p" "$D/config/DankMaterialShell/plugins/$name/"
done

# Правки интерфейса DMS поверх dms-qml той же версии
OVERLAY_FILES=(
    Modules/Settings/Widgets/SettingsToggleCard.qml
    Modules/Settings/Widgets/SettingsCard.qml
    Modules/Settings/DesktopWidgetGroupSection.qml
    Modules/DankDash/Overview/CalendarOverviewCard.qml
    Modules/Plugins/BasePill.qml
    Modules/DankBar/Widgets/LauncherButton.qml
)
for f in "${OVERLAY_FILES[@]}"; do
    copy "$HOME/.local/share/dms-ui/$f" "dms-ui-overlay/$f"
done
cp -a "$HOME/.local/share/dms-ui/VERSION" "$D/dms-ui-overlay/VERSION"

# --- Скриншоты как в caelestia ---
copy "$C/quickshell/caelestia-shot/shell.qml" "config/quickshell/caelestia-shot/shell.qml"

# --- Терминал, оболочка, мелочи ---
for x in foot/foot.ini fuzzel fastfetch cava btop starship.toml; do
    copy "$C/$x" "config/$x"
done
mkdir -p "$D/config/fish/functions"
sed -e "s|$HOME/.lmstudio/bin|\$HOME/.lmstudio/bin|; s|$HOME|\$HOME|g" "$C/fish/config.fish" > "$D/config/fish/config.fish"
sed -i '/\.lmstudio\/bin/d' "$D/config/fish/config.fish"
cp -a "$C/fish/functions/fish_greeting.fish" "$D/config/fish/functions/"

copy "$HOME/.local/bin/gpu-screen-recorder" "bin/gpu-screen-recorder"
copy "$HOME/.local/bin/ff-anim" "bin/ff-anim"
copy "$HOME/.local/bin/ff-anim-row" "bin/ff-anim-row"
copy "$HOME/.local/share/icons/arch-logo.svg" "icons/arch-logo.svg"

# Страховка: в репозиторий не должно попасть ни одного абсолютного пути домашней папки
if grep -rIl "$HOME" "$D" >/dev/null; then
    echo "ВНИМАНИЕ: остались пути $HOME:" >&2
    grep -rIl "$HOME" "$D" >&2
    exit 1
fi
echo "Готово: $D"
