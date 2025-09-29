import 'dart:io';

import 'package:sg_cli/models/sg_config.dart';
import 'package:sg_cli/utils/get_value_in_line.dart';

SgConfig? getConfig() {
  final pubspec = File('sg_cli.yaml');
  try {
    if (pubspec.existsSync()) {
      final lines = pubspec.readAsLinesSync();
      final version = getSingleLineValueFromLines(lines: lines, key: 'version');
      final routePaths = getMultilineValueFromLines(lines: lines, key: 'route_paths') ?? <String>[];

      if (version != null && routePaths.isNotEmpty) {
        final sgConfig = SgConfig(
          version: version,
          routePaths: routePaths,
        );
        return sgConfig;
      }
    }
  } catch (e) {
    return null;
  }
  return null;
}
