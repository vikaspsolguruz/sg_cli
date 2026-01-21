part of '../max.dart';

/// Runs flutter pub get to install dependencies
void _runPubGet() {
  ConsoleLogger.package('Installing dependencies...');

  try {
    final result = Process.runSync('flutter', ['pub', 'get']);

    if (result.exitCode == 0) {
      ConsoleLogger.success('Dependencies installed successfully');
    } else {
      ConsoleLogger.warning('Failed to install dependencies automatically');
      ConsoleLogger.info('Please run: flutter pub get');
    }
  } catch (e) {
    ConsoleLogger.warning('Failed to install dependencies automatically');
    ConsoleLogger.info('Please run: flutter pub get');
  }
}
