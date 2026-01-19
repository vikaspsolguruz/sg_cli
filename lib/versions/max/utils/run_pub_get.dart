part of '../max.dart';

/// Runs flutter pub get to install dependencies
void _runPubGet() {
  print('${ConsoleSymbols.package}Installing dependencies...');

  try {
    final result = Process.runSync('flutter', ['pub', 'get']);

    if (result.exitCode == 0) {
      print('${ConsoleSymbols.success}Dependencies installed successfully');
    } else {
      print('${ConsoleSymbols.warning}Warning: Failed to install dependencies automatically');
      print('   Please run: flutter pub get');
    }
  } catch (e) {
    print('${ConsoleSymbols.warning}Warning: Failed to install dependencies automatically');
    print('   Please run: flutter pub get');
  }
}
