import QtQuick
import Quickshell
import qs.Common
import qs.Services
import qs.Modules.Plugins
import "WeatherArtGenerator.js" as WeatherGen

DesktopPluginComponent {
    id: root

    minWidth: 300
    minHeight: 240

    property string backgroundStyle: pluginData.backgroundStyle ?? "oneshot"
    property real backgroundOpacity: (pluginData.backgroundOpacity ?? 70) / 100
    property real pictureScale: (pluginData.pictureScale ?? 165) / 100
    property real textScale: (pluginData.textScale ?? 100) / 100
    property int updateInterval: pluginData.updateInterval ?? 60
    property bool showQuip: pluginData.showQuip ?? true
    property bool showTemp: pluginData.showTemp ?? true
    property bool showFeelsLike: pluginData.showFeelsLike ?? true
    property bool showHumidity: pluginData.showHumidity ?? true
    property bool showPressure: pluginData.showPressure ?? false
    property bool showSunrise: pluginData.showSunrise ?? true
    property bool showSunset: pluginData.showSunset ?? true

    readonly property bool weatherAvailable: WeatherService.weather.available
    readonly property var weather: WeatherService.weather

    readonly property color bgSkyTop: backgroundStyle === "oneshot" ? "#0c0a30" : (backgroundStyle === "dms" ? Qt.darker(Theme.surface, 1.5) : "transparent")
    readonly property color bgSkyMid: backgroundStyle === "oneshot" ? "#3a1a5c" : (backgroundStyle === "dms" ? Theme.surfaceContainer : "transparent")
    readonly property color bgSkyBot: backgroundStyle === "oneshot" ? "#a02670" : (backgroundStyle === "dms" ? Qt.darker(Theme.primary, 0.7) : "transparent")
    readonly property color glassColor: Qt.rgba(0, 0, 0, 0.15)

    readonly property bool isDarkBackground: {
        if (backgroundStyle === "transparent" || backgroundStyle === "glass") return true
        const rgb = Qt.darker(bgSkyMid, 1.0)
        const r = rgb.r * 255
        const g = rgb.g * 255
        const b = rgb.b * 255
        const brightness = (r * 299 + g * 587 + b * 114) / 1000
        return brightness < 128
    }

    readonly property color artColor: {
        if (backgroundStyle === "oneshot") return "#ffd700"
        if (backgroundStyle === "dms") return Theme.onSurface
        if (backgroundStyle === "glass" || backgroundStyle === "transparent") return Theme.onSurface
        return "#ffd700"
    }
    readonly property color quipColor: {
        if (backgroundStyle === "oneshot") return "#ffffff"
        if (backgroundStyle === "dms") return Theme.onSurfaceVariant
        if (backgroundStyle === "glass" || backgroundStyle === "transparent") return Theme.onSurfaceVariant
        return "#ffffff"
    }
    readonly property color statColor: {
        if (backgroundStyle === "oneshot") return "#c792ea"
        if (backgroundStyle === "dms") return Theme.primary
        if (backgroundStyle === "glass" || backgroundStyle === "transparent") return Theme.primary
        return "#c792ea"
    }

    Ref {
        service: WeatherService
    }

    function getWeatherType() {
        if (!weatherAvailable) return "sunny"
        const wCode = weather.wCode ?? 1
        const temp = weather.temp ?? 20
        if (wCode >= 95 && wCode <= 99) return "thunderstorm"
        if (wCode >= 85 && wCode <= 86) return "snow"
        if (wCode >= 80 && wCode <= 82) return "rainy"
        if (wCode >= 71 && wCode <= 77) return "snow"
        if (wCode >= 51 && wCode <= 67) return "rainy"
        if (wCode >= 45 && wCode <= 48) return "cloudy"
        if (wCode === 0 || wCode === 1) return "sunny"
        if (wCode === 2 || wCode === 3) return "cloudy"
        const tempF = weather.tempF ?? (temp * 9 / 5 + 32)
        if (tempF >= 90) return "hot"
        return "sunny"
    }

    function isNight() {
        const hour = new Date().getHours()
        return hour < 6 || hour >= 20
    }

    function getScene() {
        const weatherType = isNight() ? "night" : getWeatherType()
        return WeatherGen.WeatherArtGenerator.generateArt(
            weatherType,
            Math.round(root.width),
            Math.round(root.height),
            "simple",
            {}
        )
    }

    function getQuip() {
        if (!weatherAvailable) return "no weather data..."
        const type = isNight() ? "night" : getWeatherType()
        switch (type) {
            case "thunderstorm": return "⚡ stay inside. seriously."
            case "rainy":        return "it's rainy out today..."
            case "snow":         return "❄ it's snowing!! go look outside"
            case "cloudy":       return "kinda grey out there"
            case "hot":          return "IM MELTING WHY IS IT SO HOT"
            case "night":        return "quiet night out there"
            case "sunny":        return (weather.feelsLikeF && weather.feelsLikeF >= 90) ? "IM MELTING WHY IS IT SO HOT" : "nice day actually"
            default:             return "just vibing"
        }
    }

    function getStats() {
        if (!weatherAvailable) return ""
        const parts = []
        if (showTemp) parts.push(WeatherService.formatTemp(weather.temp, true, false))
        if (showFeelsLike && weather.feelsLike != null) parts.push("feels " + WeatherService.formatTemp(weather.feelsLike))
        if (showHumidity && weather.humidity) parts.push(WeatherService.formatPercent(weather.humidity) + " humid")
        if (showPressure && weather.pressure) parts.push(WeatherService.formatPressure(weather.pressure))
        if (showSunrise && weather.sunrise) parts.push("▲" + weather.sunrise)
        if (showSunset && weather.sunset) parts.push("▼" + weather.sunset)
        if (weather.city) parts.push(weather.city)
        return parts.join("  •  ")
    }

    Rectangle {
        anchors.fill: parent
        radius: Theme.cornerRadius
        opacity: root.backgroundOpacity
        visible: backgroundStyle === "oneshot"
        color: "#1a1a1a"

        gradient: Gradient {
            GradientStop { position: 0.0; color: bgSkyTop }
            GradientStop { position: 0.45; color: bgSkyMid }
            GradientStop { position: 1.0; color: bgSkyBot }
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: Theme.cornerRadius
        opacity: root.backgroundOpacity
        visible: backgroundStyle === "dms"
        gradient: Gradient {
            GradientStop { position: 0.0; color: bgSkyTop }
            GradientStop { position: 0.45; color: bgSkyMid }
            GradientStop { position: 1.0; color: bgSkyBot }
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: Theme.cornerRadius
        visible: backgroundStyle === "glass"
        color: root.glassColor
        border.color: Qt.rgba(255, 255, 255, 0.1)
        border.width: 1
    }

    Column {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 0

        Text {
            width: parent.width
            height: parent.height * 0.55
            font.family: "monospace"
            font.bold: true
            font.pixelSize: {
                const lines = root.getScene().art.length
                const availHeight = height
                const baseDiv = 1.65
                const scaled = baseDiv / root.pictureScale
                return Math.max(10, Math.floor(availHeight / (lines * scaled)))
            }
            color: root.artColor
            text: root.getScene().art.join("\n")
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignTop
            lineHeight: 0.85
            wrapMode: Text.NoWrap
            clip: true
        }

        Item {
            width: parent.width
            height: parent.height * 0.20
        }

        Text {
            visible: root.showQuip
            width: parent.width
            height: root.showQuip ? parent.height * 0.10 : 0
            font.family: "monospace"
            font.pixelSize: Math.max(8, Math.floor(parent.height / 24 * root.textScale))
            font.italic: true
            color: root.quipColor
            text: root.getQuip()
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            visible: root.weatherAvailable && root.getStats() !== ""
            width: parent.width
            height: root.weatherAvailable && root.getStats() !== "" ? parent.height * 0.10 : 0
            font.family: "monospace"
            font.pixelSize: Math.max(8, Math.floor(parent.height / 24 * root.textScale))
            font.bold: true
            color: root.statColor
            text: root.getStats()
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }
    }

    Timer {
        interval: root.updateInterval * 1000
        running: true
        repeat: true
        onTriggered: root.update()
    }
}
