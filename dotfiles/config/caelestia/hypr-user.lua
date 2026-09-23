-- Свои мониторы — в ~/.config/caelestia/hypr-local.lua (создаётся установщиком, в репозиторий не попадает)
pcall(require, "hypr-local")

-- Рабочие столы 1–5 существуют всегда, чтобы пустые тоже были видны на панели
for i = 1, 5 do
    hl.workspace_rule({ workspace = tostring(i), persistent = true })
end

-- Цвета рамок окон из палитры DMS (обновляются вместе с обоями: DMS сам делает hyprctl reload)
local function dms_palette()
    local f = io.open(os.getenv("HOME") .. "/.cache/DankMaterialShell/dms-colors.json")
    if not f then return nil end
    local text = f:read("*a")
    f:close()

    local dark = text:match('"dark"%s*:%s*(%b{})')
    if not dark then return nil end
    return {
        primary  = dark:match('"primary"%s*:%s*"#(%x+)"'),
        tertiary = dark:match('"tertiary"%s*:%s*"#(%x+)"'),
        outline  = dark:match('"outline_variant"%s*:%s*"#(%x+)"'),
    }
end

local c = dms_palette()
if c and c.primary and c.tertiary and c.outline then
    hl.config({
        general = {
            col = {
                active_border   = {
                    colors = { "rgba(" .. c.primary .. "ee)", "rgba(" .. c.tertiary .. "ee)" },
                    angle  = 45,
                },
                inactive_border = "rgba(" .. c.outline .. "66)",
            },
        },
    })
end

-- Плавные анимации почти везде
hl.curve("overshot", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("smoothOut", { type = "bezier", points = { { 0.36, 0 }, { 0.66, -0.56 } } })
hl.curve("smoothIn", { type = "bezier", points = { { 0.25, 1 }, { 0.5, 1 } } })
hl.curve("fluent", { type = "bezier", points = { { 0.0, 0.0 }, { 0.2, 1.0 } } })

-- Окна: всплывают с лёгким перелётом, закрываются сжатием, плавно переезжают при раскладке
hl.animation({ leaf = "windowsIn", enabled = true, speed = 5, bezier = "overshot", style = "popin 80%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, bezier = "smoothOut", style = "popin 80%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 5, bezier = "smoothIn", style = "slide" })

-- Затухания: появление/скрытие, смена фокуса, затемнение неактивных
hl.animation({ leaf = "fadeIn", enabled = true, speed = 4, bezier = "smoothIn" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 4, bezier = "smoothIn" })
hl.animation({ leaf = "fadeSwitch", enabled = true, speed = 6, bezier = "smoothIn" })
hl.animation({ leaf = "fadeDim", enabled = true, speed = 6, bezier = "smoothIn" })
hl.animation({ leaf = "border", enabled = true, speed = 8, bezier = "smoothIn" })

-- Рабочие столы: скольжение с затуханием; спецстол — выезд по вертикали
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "fluent", style = "slidefade 20%" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 5, bezier = "fluent", style = "slidefadevert 20%" })

-- Изменение размера окна с клавиатуры тоже анимируется (перетаскивание мышью — нет, иначе окно «плывёт» за курсором)
hl.config({ misc = { animate_manual_resizes = true } })

-- У DMS свои анимации панели/попапов/виджетов — анимации Hyprland поверх дают рывки
hl.layer_rule({ match = { namespace = "^dms:" }, no_anim = true })
hl.layer_rule({ match = { namespace = "^quickshell$" }, no_anim = true })
