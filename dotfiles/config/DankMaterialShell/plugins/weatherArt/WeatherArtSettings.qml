import QtQuick
import qs.Common
import qs.Modules.Plugins

PluginSettings {
    id: root
    pluginId: "weatherArt"

    SelectionSetting {
        settingKey: "backgroundStyle"
        label: I18n.tr("Background Style")
        options: [
            { label: I18n.tr("OneShot Gradient"), value: "oneshot" },
            { label: I18n.tr("DMS Theme"), value: "dms" },
            { label: I18n.tr("Glass/Frosted"), value: "glass" },
            { label: I18n.tr("Transparent"), value: "transparent" }
        ]
        defaultValue: "oneshot"
    }

    SliderSetting {
        settingKey: "backgroundOpacity"
        label: I18n.tr("Background Opacity")
        defaultValue: 70
        minimum: 0
        maximum: 100
        unit: "%"
    }

    SliderSetting {
        settingKey: "pictureScale"
        label: I18n.tr("Picture Scale")
        defaultValue: 165
        minimum: 100
        maximum: 250
        unit: "%"
    }

    SliderSetting {
        settingKey: "textScale"
        label: I18n.tr("Text Size")
        defaultValue: 100
        minimum: 50
        maximum: 250
        unit: "%"
    }

    SliderSetting {
        settingKey: "updateInterval"
        label: I18n.tr("Update Interval")
        defaultValue: 60
        minimum: 10
        maximum: 600
        unit: "s"
    }
}
