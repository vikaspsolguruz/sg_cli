import 'package:sg_cli/constants/console_symbols.dart';

/// Simplified console printing utility for consistent formatting
/// 
/// This class provides a unified way to handle console output in the SG CLI,
/// focusing on the essential message types: success, error, warning, info, and loading.
class ConsoleLogger {
  // Prevent instantiation
  ConsoleLogger._();

  // Core message types with consistent formatting
  static void success(String message) => _print(ConsoleSymbols.success, message);
  static void error(String message) => _print(ConsoleSymbols.error, message);
  static void warning(String message) => _print(ConsoleSymbols.warning, message);
  static void info(String message) => _print(ConsoleSymbols.info, message);
  static void loading(String message) => _print(ConsoleSymbols.loading, message);
  static void package(String message) => _print(ConsoleSymbols.package, message);
  
  // Special formatting for decorative content
  static void divider({String title = ''}) {
    if (title.isNotEmpty) {
      print('╔════════════════════════════════════════════════════════════════════════════════╗');
      print('║${title.padLeft(77)}║');
      print('╚════════════════════════════════════════════════════════════════════════════════╝');
    } else {
      print('────────────────────────────────────────────────────────────────────────────────');
    }
  }
  
  static void banner(String title, {String? subtitle}) {
    print('************************************************************');
    print('*                                                          *');
    print('*${title.padLeft(57)}*');
    if (subtitle != null) {
      print('*${subtitle.padLeft(57)}*');
    }
    print('*                                                          *');
    print('************************************************************');
  }
  
  static void list(List<String> items, {String bullet = '•'}) {
    for (final item in items) {
      print('   $bullet $item');
    }
  }
  
  static void blank() => print('');
  static void raw(String message) => print(message);
  
  // Private helper for consistent formatting
  static void _print(String symbol, String message) {
    print('$symbol$message');
  }
}
