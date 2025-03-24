import 'dart:developer';
import 'dart:io';

import 'package:sg_cli/models/sg_config.dart';
import 'package:sg_cli/utils/get_value_in_line.dart';

SgConfig? getConfig() {
  final pubspec = File('sg_cli.yaml');
  try {
    if (pubspec.existsSync()) {
      final lines = pubspec.readAsLinesSync();
      final version = getValueFromLines(lines: lines, key: 'version');
      final stateManagement = getValueFromLines(lines: lines, key: 'state_management');
      final type = getValueFromLines(lines: lines, key: 'type');
      if (version != null && stateManagement != null && type != null) {
        final sgConfig = SgConfig(
          version: double.parse(version),
          type: type,
          stateManagement: stateManagement,
        );
        return sgConfig;
      }
    } else {
      print("❌  Error: This project doesn't have config file sg_cli.yaml");
    }
  } catch (e) {
    print("❌  Error: Invalid config file sg_cli.yaml");
    return null;
  }
  return null;
}
