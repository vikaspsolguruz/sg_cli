import 'package:sg_cli/constants/constants.dart';
import 'package:sg_cli/data/global_vars.dart';
import 'package:sg_cli/utils/config_helper.dart';
import 'package:sg_cli/versions/amber/amber.dart';
import 'package:sg_cli/versions/bronze/bronze.dart';
import 'package:sg_cli/versions/cyan/cyan.dart';

void runCLI(List<String> args) {
  arguments = args;
  final config = getConfig();
  if (config == null) return;
  sgConfig = config;

  final cliVersions = {
    kAmber: Amber.runCommand,
    kBronze: Bronze.runCommand,
    kCyan: Cyan.runCommand,
  };

  final command = cliVersions[config.version];

  command?.call();
  if (command == null) print("❌ Error: Invalid config file sg_cli.yaml");
}
