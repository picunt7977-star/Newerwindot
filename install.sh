#!/usr/bin/env bash
# Установщик дотфайлов Newerwindot: Hyprland (конфиг caelestia на Lua) + DankMaterialShell.
# Для чистой CachyOS/Arch. Запуск:
#   bash <(curl -fsSL https://raw.githubusercontent.com/picun7977-cell/Newerwindot/main/install.sh)
set -euo pipefail

REPO_URL="https://github.com/picun7977-cell/Newerwindot"
DMS_VERSION="v1.6.2"
DGOP_VERSION="v1.6.2"
MATUGEN_VERSION="v4.2.0"
INTER_VERSION="v4.1"

# Пакеты из официальных репозиториев / CachyOS
PACMAN_PKGS=(
    hyprland xdg-desktop-portal-hyprland xdg-desktop-portal-gtk hyprpicker
    foot fish starship fastfetch cava btop fuzzel eza zoxide
    grim slurp swappy wl-clipboard cliphist playerctl brightnessctl
    gpu-screen-recorder ffmpeg pipewire wireplumber bluez-utils
    polkit-gnome gnome-keyring trash-cli libnotify
    papirus-icon-theme adw-gtk-theme ttf-jetbrains-mono-nerd
    qt6-multimedia qt6-imageformats accountsservice power-profiles-daemon networkmanager
    git curl unzip rsync python jq
)
# Пакеты из AUR: оболочка caelestia нужна для скриншотов (её AreaPicker) и CLI (буфер, эмодзи, спецстолы),
# она же тянет quickshell-git, на котором работает DMS
AUR_PKGS=(caelestia-shell caelestia-cli qtengine darkly-bin)
AUR_OPTIONAL=(sweet-cursors-hyprcursor-git)

c_blue=$'\e[1;34m'; c_green=$'\e[1;32m'; c_yellow=$'\e[1;33m'; c_red=$'\e[1;31m'; c_off=$'\e[0m'
step() { printf '\n%s==>%s %s\n' "$c_blue" "$c_off" "$*"; }
ok()   { printf '%s  ✓%s %s\n' "$c_green" "$c_off" "$*"; }
warn() { printf '%s  !%s %s\n' "$c_yellow" "$c_off" "$*"; }
die()  { printf '%s  ✗ %s%s\n' "$c_red" "$*" "$c_off" >&2; exit 1; }
ask()  { # ask "вопрос" -> 0 если да (по умолчанию да)
    local a
    read -r -p "  $1 [Y/n] " a </dev/tty || a=""
    [[ -z "$a" || "$a" =~ ^[YyДд] ]]
}

[[ $EUID -eq 0 ]] && die "Запускай от обычного пользователя, не от root (sudo спросится сам)."
command -v pacman >/dev/null || die "Нужен Arch/CachyOS (pacman не найден)."

cat <<EOF
${c_blue}
  ╔══════════════════════════════════════════╗
  ║        Newerwindot — установка           ║
  ║   Hyprland + DankMaterialShell + caelestia ║
  ╚══════════════════════════════════════════╝${c_off}
  Будут установлены пакеты, а твои текущие конфиги
  сохранены в ~/.config/newerwindot-backup-<дата>.
EOF
ask "Продолжить?" || exit 0

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# ---------------------------------------------------------------------------
step "Скачиваю дотфайлы"
if [[ -f "$(dirname "${BASH_SOURCE[0]}")/dotfiles/config/hypr/hyprland.lua" ]]; then
    SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    ok "использую локальную копию: $SRC"
else
    command -v git >/dev/null || sudo pacman -S --needed --noconfirm git
    git clone --depth 1 "$REPO_URL" "$WORK/repo"
    SRC="$WORK/repo"
fi
DOT="$SRC/dotfiles"

# ---------------------------------------------------------------------------
step "Устанавливаю пакеты (pacman)"
sudo pacman -Syu --needed --noconfirm "${PACMAN_PKGS[@]}"
ok "пакеты из репозиториев"

step "Устанавливаю пакеты из AUR"
AUR=""
for h in paru yay; do command -v "$h" >/dev/null && { AUR="$h"; break; }; done
if [[ -z "$AUR" ]]; then
    warn "нет paru/yay — ставлю paru"
    sudo pacman -S --needed --noconfirm base-devel
    git clone --depth 1 https://aur.archlinux.org/paru-bin.git "$WORK/paru"
    (cd "$WORK/paru" && makepkg -si --noconfirm)
    AUR=paru
fi
"$AUR" -S --needed --noconfirm "${AUR_PKGS[@]}"
ok "AUR: ${AUR_PKGS[*]}"
if ask "Поставить курсоры Sweet (AUR, собираются из исходников)?"; then
    "$AUR" -S --needed --noconfirm "${AUR_OPTIONAL[@]}" || warn "курсоры не поставились — не страшно"
fi

# ---------------------------------------------------------------------------
step "Сохраняю текущие конфиги"
BACKUP="$HOME/.config/newerwindot-backup-$(date +%Y-%m-%d_%H-%M-%S)"
mkdir -p "$BACKUP"
for p in hypr caelestia DankMaterialShell quickshell foot fuzzel fastfetch cava btop fish starship.toml; do
    [[ -e "$HOME/.config/$p" ]] && cp -a "$HOME/.config/$p" "$BACKUP/"
done
[[ -e "$HOME/.local/state/DankMaterialShell" ]] && cp -a "$HOME/.local/state/DankMaterialShell" "$BACKUP/state-DankMaterialShell"
ok "бэкап: $BACKUP"

# ---------------------------------------------------------------------------
step "Скачиваю DankMaterialShell $DMS_VERSION, dgop, matugen"
mkdir -p "$HOME/.local/bin"
gh_dl() { curl -fSL --retry 3 -o "$2" "$1"; }
verify() { # verify <файл> <файл.sha256>
    local want got
    want="$(awk '{print $1}' "$2")"; got="$(sha256sum "$1" | awk '{print $1}')"
    [[ "$want" == "$got" ]] || die "контрольная сумма не сошлась: $1"
}
DMS_URL="https://github.com/AvengeMedia/DankMaterialShell/releases/download/$DMS_VERSION"
DGOP_URL="https://github.com/AvengeMedia/dgop/releases/download/$DGOP_VERSION"
cd "$WORK"
for f in dms-cli-amd64.gz dms-qml.tar.gz; do gh_dl "$DMS_URL/$f" "$f"; gh_dl "$DMS_URL/$f.sha256" "$f.sha256"; verify "$f" "$f.sha256"; done
gh_dl "$DGOP_URL/dgop-linux-amd64.gz" dgop.gz; gh_dl "$DGOP_URL/dgop-linux-amd64.gz.sha256" dgop.gz.sha256; verify dgop.gz dgop.gz.sha256
gh_dl "https://github.com/InioX/matugen/releases/download/$MATUGEN_VERSION/matugen-${MATUGEN_VERSION#v}-x86_64.tar.gz" matugen.tar.gz
gunzip -f dms-cli-amd64.gz dgop.gz
mkdir -p mg && tar -xzf matugen.tar.gz -C mg
install -m755 dms-cli-amd64 "$HOME/.local/bin/dms"
install -m755 dgop "$HOME/.local/bin/dgop"
install -m755 mg/matugen "$HOME/.local/bin/matugen"
ok "dms $("$HOME/.local/bin/dms" version 2>/dev/null | head -1), dgop, matugen"

# Интерфейс DMS из папки + наши правки (календарь, подсветка карточек, выравнивание)
rm -rf "$HOME/.local/share/dms-ui"
mkdir -p "$HOME/.local/share/dms-ui"
tar -xzf dms-qml.tar.gz -C "$HOME/.local/share/dms-ui"
[[ "$(cat "$HOME/.local/share/dms-ui/VERSION")" == "$(cat "$DOT/dms-ui-overlay/VERSION")" ]] \
    || die "версия dms-qml не совпадает с правками — обнови dms-ui-overlay"
cp -a "$DOT/dms-ui-overlay/Modules/." "$HOME/.local/share/dms-ui/Modules/"
ok "интерфейс DMS с правками: ~/.local/share/dms-ui"

step "Шрифт Inter"
gh_dl "https://github.com/rsms/inter/releases/download/$INTER_VERSION/Inter-${INTER_VERSION#v}.zip" inter.zip
mkdir -p inter "$HOME/.local/share/fonts/Inter"
unzip -qo inter.zip -d inter
cp inter/InterVariable.ttf inter/InterVariable-Italic.ttf "$HOME/.local/share/fonts/Inter/"
fc-cache -f "$HOME/.local/share/fonts" >/dev/null
ok "Inter Variable"
cd - >/dev/null

# ---------------------------------------------------------------------------
step "Раскладываю конфиги"
mkdir -p "$HOME/.config" "$HOME/.local/state" "$HOME/.local/share/icons"
for p in hypr caelestia DankMaterialShell quickshell foot fuzzel fastfetch cava btop fish; do
    [[ -e "$DOT/config/$p" ]] || continue
    mkdir -p "$HOME/.config/$p"
    rsync -a "$DOT/config/$p/" "$HOME/.config/$p/"
done
cp -a "$DOT/config/starship.toml" "$HOME/.config/starship.toml"
mkdir -p "$HOME/.local/state/DankMaterialShell"
cp -a "$DOT/state/DankMaterialShell/session.json" "$HOME/.local/state/DankMaterialShell/session.json"
sed -i "s|__HOME__|$HOME|g" "$HOME/.config/DankMaterialShell/settings.json"
install -m755 "$DOT/bin/"* "$HOME/.local/bin/"
cp -a "$DOT/icons/arch-logo.svg" "$HOME/.local/share/icons/"

# Файлы, которые конфиг caelestia ожидает, но генерирует сам
[[ -e "$HOME/.config/caelestia/hypr-local.lua" ]] || cat > "$HOME/.config/caelestia/hypr-local.lua" <<'EOF'
-- Настройки мониторов этого компьютера, например:
-- hl.monitor({ output = "DP-1", mode = "2560x1440@165", position = "auto", scale = 1 })
EOF
[[ -e "$HOME/.config/caelestia/user-config.fish" ]] || : > "$HOME/.config/caelestia/user-config.fish"

# Скриншоты как в caelestia: отдельный quickshell только с её AreaPicker
SHOT="$HOME/.config/quickshell/caelestia-shot"
for d in components services utils assets modules; do
    ln -sfn "/etc/xdg/quickshell/caelestia/$d" "$SHOT/$d"
done
ok "конфиги на месте"

# ---------------------------------------------------------------------------
if [[ "$(basename "${SHELL:-}")" != "fish" ]] && ask "Сделать fish оболочкой по умолчанию?"; then
    chsh -s /usr/bin/fish && ok "fish — оболочка по умолчанию"
fi

cat <<EOF

${c_green}Готово!${c_off}
  • Выйди из сеанса и выбери ${c_blue}Hyprland${c_off} на экране входа.
  • Super — поиск приложений, Super+I — настройки, Super+Shift+S — скриншот,
    Super+Alt+R — запись экрана, Super+L — блокировка.
  • Мониторы настраиваются в ~/.config/caelestia/hypr-local.lua
  • Старые конфиги: $BACKUP
EOF
