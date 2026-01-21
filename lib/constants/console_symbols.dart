/// Essential console symbols with consistent spacing for clean CLI output
class ConsoleSymbols {
  static const String success = ' ✅  ';
  static const String error = ' ❌  ';
  static const String warning = ' ⚠️  ';
  static const String info = ' ℹ️  ';
  static const String loading = ' 🔄  ';
  static const String package = ' 📦  ';
  static const String rocket = ' 🚀  ';
  static const String bulb = ' 💡  ';
  static const String books = ' 📚  ';
  static const String clipboard = ' 📋  ';
  static const String question = ' ❓  ';
  
  /// Helper method for creating custom symbol messages
  static String message(String symbol, String text) {
    return '$symbol$text';
  }
}
