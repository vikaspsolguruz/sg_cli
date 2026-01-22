import 'package:sg_cli/constants/constants.dart';
import 'package:sg_cli/data/global_vars.dart';
import 'package:sg_cli/models/sg_config.dart';
import 'package:sg_cli/utils/config_helper.dart';
import 'package:sg_cli/utils/console_logger.dart';
import 'package:sg_cli/versions/amber/amber.dart';
import 'package:sg_cli/versions/bronze/bronze.dart';
import 'package:sg_cli/versions/max/max.dart';

void runCLI(List<String> args) {
  arguments = args;
  final config = getConfig();
  if (config == null) {
    if (args.length == 1 && args.first == 'init') {
      sgConfig = SgConfig(version: kMax, routePaths: []);
      Max.runCommand();
    } else if (args.length == 1 && (args.first == 'help' || args.first == '--help' || args.first == '-help' || args.first == '-h' || args.first == 'h')) {
      sgConfig = SgConfig(version: kMax, routePaths: []);
      Max.runCommand();
    } else if (args.isEmpty) {
      Max.runCommand();
    } else {
      ConsoleLogger.error('Invalid config file sg_cli.yaml');
    }
    return;
  } else if (args.isEmpty) {
    Max.runCommand();
    return;
  }
  sgConfig = config;

  final cliVersions = {
    kAmber: Amber.runCommand,
    kBronze: Bronze.runCommand,
    kMax: Max.runCommand,
  };

  final command = cliVersions[config.version];

  command?.call();
  if (command == null) ConsoleLogger.error('Invalid config file sg_cli.yaml');
}
