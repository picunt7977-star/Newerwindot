//@ pragma DefaultEnv QS_NO_RELOAD_POPUP=1
//@ pragma DefaultEnv QSG_RENDER_LOOP=threaded

// Только выделение области/скриншот из caelestia (1:1), без панели и остального —
// основной оболочкой остаётся DankMaterialShell.
import "modules/areapicker"
import Quickshell

ShellRoot {
    settings.watchFiles: false

    AreaPicker {}
}
