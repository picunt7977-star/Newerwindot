/**
 * Weather Art Generator - Responsive Weather Scenes
 * Scales based on available widget width
 */

var WeatherArtGenerator = {
  generateArt: function(weatherType, width, height, mode, colors) {
    var scale = "small"
    if (width > 350) scale = "medium"
    if (width > 500) scale = "large"
    return this.scene(weatherType, scale)
  },

  scene: function(weather, scale) {
    if (scale === "small") return this.smallScene(weather)
    if (scale === "large") return this.largeScene(weather)
    return this.mediumScene(weather)
  },

  // ─────────────────────────────────────────
  // SMALL: Narrow, 25-30 chars
  smallScene: function(weather) {
    switch (weather) {
      case "rainy":
        return {
          art: [
            "  ░░░░░░░░░░░░░░░  ",
            " ║ ║ ║ ║ ║ ║ ║ ║  ",
            "  ║ ║ ║ ║ ║ ║ ║   "
          ]
        }
      case "sunny":
        return {
          art: [
            "   \\  |  /   ",
            "────────◉────────",
            "   /  |  \\   "
          ]
        }
      case "cloudy":
        return {
          art: [
            " ░░░░  ░░░░░░░  ",
            " ░░ ░░░░░  ░░░░ ",
            "  ░░░  ░░░░░░   "
          ]
        }
      case "snow":
        return {
          art: [
            " ❄  ❆  ❄  ❆  ",
            "❆  ❄  ❅  ❄  ❆",
            " ❄  ❆  ❄  ❅  "
          ]
        }
      case "thunderstorm":
        return {
          art: [
            " ░⚡░  ░░⚡░░░ ",
            "  ⚡ ║ ║ ⚡   ",
            "   ║ ║ ║ ║    "
          ]
        }
      case "hot":
        return {
          art: [
            "  \\\\  ◉◉◉  //  ",
            " ──  ◉  ──   ",
            "  ∼ ∼ ∼ ∼ ∼  "
          ]
        }
      case "night":
        return {
          art: [
            " ✦  ◐  ★  ✧ ",
            "   ★    ✦    ",
            " ✧  ★   ★   "
          ]
        }
      default:
        return { art: ["", "", ""] }
    }
  },

  // ─────────────────────────────────────────
  // MEDIUM: Standard, 40-45 chars
  mediumScene: function(weather) {
    switch (weather) {
      case "rainy":
        return {
          art: [
            "     ░░░░░░░░░░░░░░░░░░     ",
            "   ░░░░░░░░░░░░░░░░░░░░░░   ",
            "      ║   ║   ║   ║   ║    ",
            "    ║   ║   ║   ║   ║   ║  ",
            "      ║   ║   ║   ║   ║    "
          ]
        }
      case "sunny":
        return {
          art: [
            "        \\   |   /        ",
            "      \\\\   |   //       ",
            "   ──────────◉──────────  ",
            "      //   |   \\\\       ",
            "        /   |   \\        "
          ]
        }
      case "cloudy":
        return {
          art: [
            "   ░░░░░   ░░░░░░░   ░░░  ",
            "  ░░░░░░░░░░░░░░░░░░░░░░  ",
            "  ░░░░   ░░░░░░░░░░░   ░░ ",
            "  ░░░░░░░░░░░░░░░░░░░░░░  ",
            "    ░░░   ░░░░░░░░░░ ░░░  "
          ]
        }
      case "snow":
        return {
          art: [
            "   ❄    ❆    ❄    ❆   ",
            " ❆   ❄   ❅   ❄   ❆ ",
            "   ❄    ❆    ❄    ❅   ",
            " ❅   ❆   ❄   ❅   ❆ ",
            "   ❆    ❄    ❅    ❄   "
          ]
        }
      case "thunderstorm":
        return {
          art: [
            "  ░░⚡░░  ░░░⚡░░░  ░⚡░  ",
            " ░░░░░░░░░░░░░░░░░░░░░░ ",
            "   ⚡  ║  ║  ⚡  ║  ║   ",
            "       ║  ║  ║  ║  ║    ",
            "   ⚡  ║  ║  ⚡  ║      "
          ]
        }
      case "hot":
        return {
          art: [
            "       \\\\\\  ◉  ///      ",
            "    ─────  ◉◉◉  ─────   ",
            "        ∼ ∼ ∼ ∼ ∼ ∼    ",
            "      ∼ ∼ ∼ ∼ ∼ ∼ ∼ ∼  ",
            "        ∼ ∼ ∼ ∼ ∼ ∼    "
          ]
        }
      case "night":
        return {
          art: [
            "   ✦       ◐       ✧   ",
            "       ★           ✦    ",
            " ★      ✧           ★  ",
            "     ✧       ★      ✦  ",
            "   ✦       ✧       ★   "
          ]
        }
      default:
        return { art: ["", "", "", "", ""] }
    }
  },

  // ─────────────────────────────────────────
  // LARGE: Full width, 55+ chars
  largeScene: function(weather) {
    switch (weather) {
      case "rainy":
        return {
          art: [
            "        ░░░░░░░░░░░░░░░░░░░░░░░░░░░░         ",
            "      ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░       ",
            "         ║     ║     ║     ║     ║     ║      ",
            "       ║     ║     ║     ║     ║     ║     ║ ",
            "         ║     ║     ║     ║     ║     ║      "
          ]
        }
      case "sunny":
        return {
          art: [
            "             \\    |    /             ",
            "           \\\\    |    //            ",
            "         \\\\\\    |    ///          ",
            "    ─────────────◉─────────────     ",
            "         ///    |    \\\\\\          ",
            "           //    |    \\\\            ",
            "             /    |    \\             "
          ]
        }
      case "cloudy":
        return {
          art: [
            "    ░░░░░░   ░░░░░░░░░░   ░░░░░░░   ",
            "  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ ",
            "   ░░░░░   ░░░░░░░░░░░░░░░░░░   ░░░ ",
            "  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ ",
            "     ░░░░   ░░░░░░░░░░░░░░░░   ░░░ "
          ]
        }
      case "snow":
        return {
          art: [
            "     ❄      ❆      ❄      ❆      ❅   ",
            "  ❆      ❄      ❅      ❄      ❆     ",
            "     ❄      ❆      ❄      ❅      ❄   ",
            "  ❅      ❆      ❄      ❅      ❆     ",
            "     ❆      ❄      ❅      ❄      ❆   "
          ]
        }
      case "thunderstorm":
        return {
          art: [
            "    ░░⚡░░  ░░░░⚡░░░░  ░⚡░░      ",
            "   ░░░░░░░░░░░░░░░░░░░░░░░░░░░░    ",
            "     ⚡   ║   ║   ⚡   ║   ║  ⚡   ",
            "         ║   ║   ║   ║   ║   ║      ",
            "     ⚡   ║   ║   ⚡   ║   ║        "
          ]
        }
      case "hot":
        return {
          art: [
            "            \\\\\\\\  ◉  ////           ",
            "         ────────  ◉◉◉  ────────    ",
            "            ////  ◉  \\\\\\\\           ",
            "        ∼ ∼ ∼ ∼ ∼ ∼ ∼ ∼ ∼ ∼ ∼ ∼  ",
            "      ∼ ∼ ∼ ∼ ∼ ∼ ∼ ∼ ∼ ∼ ∼ ∼ ∼ ∼ "
          ]
        }
      case "night":
        return {
          art: [
            "     ✦           ◐           ✧      ",
            "            ★           ✦           ",
            "  ★          ✧              ★      ",
            "         ✧          ★          ✦  ",
            "     ✦           ✧           ★     "
          ]
        }
      default:
        return { art: ["", "", "", "", ""] }
    }
  }
}
