part of '../cyan.dart';

/// Console symbols and emojis with proper spacing for clean output
/// Each symbol has 2 spaces on the left and right for better readability
class ConsoleSymbols {
  // Success and Status
  static const String success = ' ✅  ';
  static const String error = ' ❌  ';
  static const String warning = ' ⚠️   ';
  static const String info = ' ℹ️   ';
  static const String checkmark = ' ✓  ';
  static const String cross = ' ✗  ';

  // Actions and Tools
  static const String rocket = ' 🚀  ';
  static const String wrench = ' 🔧  ';
  static const String gear = ' ⚙️   ';
  static const String hammer = ' 🔨  ';
  static const String fire = '  🔥 ';
  static const String sparkles = ' ✨  ';

  // Information and Help
  static const String bulb = ' 💡  ';
  static const String question = ' ❓  ';
  static const String exclamation = ' ❗  ';
  static const String note = ' 📝  ';
  static const String clipboard = ' 📋  ';
  static const String books = ' 📚  ';
  static const String document = ' 📄  ';

  // Search and Navigation
  static const String search = ' 🔍  ';
  static const String target = ' 🎯  ';
  static const String pin = ' 📌  ';
  static const String link = ' 🔗  ';

  // Package and Files
  static const String package = ' 📦  ';
  static const String folder = ' 📁  ';
  static const String file = ' 📄  ';
  static const String box = ' 📦  ';

  // Progress and Loading
  static const String hourglass = ' ⏳  ';
  static const String loading = ' 🔄  ';
  static const String refresh = ' 🔄  ';

  // Identification
  static const String id = ' 🆔  ';
  static const String tag = ' 🏷️   ';
  static const String key = ' 🔑  ';

  // Steps and Numbers
  static const String one = ' 1️⃣   ';
  static const String two = ' 2️⃣   ';
  static const String three = ' 3️⃣   ';
  static const String four = ' 4️⃣   ';
  static const String five = ' 5️⃣   ';

  // Arrows
  static const String arrowRight = ' →  ';
  static const String arrowLeft = ' ←  ';
  static const String arrowUp = ' ↑  ';
  static const String arrowDown = ' ↓  ';

  // Code and Development
  static const String code = ' 💻  ';
  static const String terminal = ' ⌨️   ';
  static const String bug = ' 🐛  ';
  static const String robot = ' 🤖  ';

  // Mobile and Devices
  static const String mobile = ' 📱  ';
  static const String android = ' 🤖  ';
  static const String apple = ' 🍎  ';

  // Network and Cloud
  static const String cloud = ' ☁️   ';
  static const String globe = ' 🌐  ';
  static const String satellite = ' 📡  ';

  // Others
  static const String party = ' 🎉  ';
  static const String star = '  ⭐ ';
  static const String trophy = ' 🏆  ';
  static const String medal = ' 🥇  ';

  /// Helper method to create custom symbol with proper spacing
  static String custom(String emoji) {
    return '  $emoji  ';
  }

  /// Create a formatted message with symbol
  static String message(String symbol, String text) {
    return '$symbol$text';
  }
}
