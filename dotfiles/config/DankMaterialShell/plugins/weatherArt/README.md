# Weather Art Widget

A responsive ASCII weather art widget for DankMaterialShell with dynamic scenes, customizable stats, and theme support.

## Features

- **Responsive ASCII Art**: Scales to widget size with detailed weather scenes (sunny, rainy, snowy, cloudy, thunderstorm, hot, night)
- **4 Background Styles**: OneShot gradient, DMS theme, glass/frosted, or transparent
- **Customizable Stats**: Per-widget instance control over displayed stats:
  - Temperature (Fahrenheit)
  - Feels like temperature
  - Humidity
  - Wind speed + direction arrow
  - Barometric pressure
  - Sunrise/sunset times
  - Location/city name
- **Personality Messages**: Context-aware quips ("it's rainy out today", "IM MELTING WHY IS IT SO HOT", etc.)
- **Theme Integration**: Text colors adapt to selected background style and DMS theme
- **Global Controls** (Plugin Settings):
  - Font scale: 100-250%
  - Update interval: 10-600 seconds
  - Background opacity: 0-100%

## Installation

1. Copy the `deskweather` folder to `~/.config/DankMaterialShell/plugins/weatherArt/`
2. Restart DMS: `systemctl --user restart dms`
3. Add the widget to your desktop and configure

## Usage

### Per-Widget Configuration

Access via desktop widget settings:
- **Show Quip**: Toggle personality messages
- **Show Stats**: Individual toggles for each stat (temp, humidity, wind, pressure, sunrise, sunset, city)

### Plugin Settings

Access via DMS plugins menu:
- **Background Style**: Choose between OneShot gradient, DMS theme, glass/frosted, or transparent
- **Background Opacity**: 0-100%
- **Font Scale**: 100-250% (responsive scaling)
- **Update Interval**: How often to refresh (10-600 seconds)

## Color Schemes

| Style | Art | Quip | Stats |
|-------|-----|------|-------|
| OneShot | Gold (#ffd700) | White | Purple (#c792ea) |
| DMS Theme | Theme.onSurface | Theme.onSurfaceVariant | Theme.primary |
| Glass/Transparent | Theme.onSurface | Theme.onSurfaceVariant | Theme.primary |

## Weather Types

- **Sunny/Hot**: Sun with directional rays
- **Rainy**: Cloud with rain drops
- **Snowy**: Scattered snowflakes
- **Cloudy/Foggy**: Layered mist formations
- **Thunderstorm**: Lightning + rain
- **Night**: Stars and crescent moon

## Wind Direction Arrows

Arrows point in the direction the wind is blowing:
- ↓ North | ↙ Northeast | ← East | ↖ Southeast
- ↑ South | ↗ Southwest | → West | ↘ Northwest
- ↔ No direction data

## Files

- `WeatherArtWidget.qml` - Main widget component
- `WeatherArtGenerator.js` - ASCII art scene generation
- `WeatherArtSettings.qml` - Plugin settings
- `plugin.json` - Plugin manifest
- `README.md` - This file

## Requirements

- DankMaterialShell >= 1.2.0
- WeatherService (DMS built-in)

## Author

viewerofall
