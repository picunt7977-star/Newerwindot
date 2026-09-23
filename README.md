# Newerwindot

Мои дотфайлы: **Hyprland** (Lua-конфиг на основе caelestia) + **DankMaterialShell** — плавающая
закруглённая панель сверху, стеклянные попапы, плавные анимации, виджеты рабочего стола,
запись экрана и скриншоты как в caelestia.

## Установка (чистая CachyOS / Arch)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/picun7977-cell/Newerwindot/main/install.sh)
```

Установщик:
1. ставит пакеты из репозиториев и AUR (через paru/yay, если нет — поставит paru);
2. сохраняет твои текущие конфиги в `~/.config/newerwindot-backup-<дата>`;
3. скачивает DankMaterialShell, dgop и matugen нужных версий (с проверкой контрольных сумм);
4. раскладывает конфиги и наши правки интерфейса DMS.

После установки выйди из сеанса и выбери **Hyprland** на экране входа.

## Горячие клавиши

| Клавиши | Действие |
|---|---|
| `Super` | поиск приложений (Spotlight) |
| `Super + I` | настройки панели и всего остального |
| `Super + T / W / E` | терминал / браузер / файлы |
| `Super + C` | закрыть окно |
| `Super + 1…0` | рабочие столы |
| `Super + Shift + S` | скриншот области (как в caelestia) |
| `Print` | скриншот всего экрана |
| `Super + Alt + R` | начать/остановить запись экрана |
| `Ctrl + Alt + R` | пауза записи |
| `Super + L` | блокировка |
| `Ctrl + Alt + Delete` | меню выключения |
| `Super + B` | центр управления |
| `Super + K` | дашборд (календарь, погода, музыка) |

## Что внутри

- `dotfiles/config/hypr` — конфиг Hyprland (caelestia, Lua)
- `dotfiles/config/caelestia/hypr-user.lua`, `hypr-vars.lua` — наши правки: отступы под панель,
  градиентные рамки в цветах обоев, плавные анимации, постоянные рабочие столы 1–5
- `dotfiles/config/DankMaterialShell` — настройки панели, виджеты и плагины
- `dotfiles/dms-ui-overlay` — правки интерфейса DMS: плавная смена месяца и новый вид календаря,
  логотип без подложки, исправленная подсветка карточек и выравнивание ручек перетаскивания
- `dotfiles/config/quickshell/caelestia-shot` — скриншотер caelestia отдельно от её панели

Мониторы — в `~/.config/caelestia/hypr-local.lua` (у каждого свои, в репозиторий не попадают).
Обои выбираются в `Super + I → Обои`, цвета всей системы подстроятся под них.

## Обновить репозиторий из своей системы

```bash
./sync.sh && git add -A && git commit -m "обновление" && git push
```

## Благодарности

[caelestia-dots](https://github.com/caelestia-dots) · [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell) ·
плагины DMS: Screen Recorder (arqueon), Dank Desktop Weather (AvengeMedia), Dank Audio Visualizer (odtgit),
Media Player (arrifat346afs), Process List (Mithgroth), Weather Art (viewerofall).
