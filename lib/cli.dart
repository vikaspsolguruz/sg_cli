import 'package:sg_cli/amber/amber.dart';
import 'package:sg_cli/constants/constants.dart';
import 'package:sg_cli/utils/config_helper.dart';

import 'data/global_vars.dart';

void runCLI(List<String> args) {
  arguments = args;
  final config = getConfig();
  if (config == null) return;
  sgConfig = config;

  if (config.version == kAmber) {
    Amber.runCommand();
  } else {
    print("❌  Error: Invalid config file sg_cli.yaml");
  }
}
