import 'package:sg_cli/data/global_vars.dart';

void preparePageImports() {
  viewImport = "import 'package:$viewPath/${pageName}_$toBeCreated.dart';";
  blocImport = "import 'package:$blocPath/${pageName}_bloc.dart';";
}
