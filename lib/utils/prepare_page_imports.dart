// import lines for view and bloc

import 'package:sg_cli/data/global_vars.dart';

void preparePageImports() {
  viewImport = "import 'package:$moduleName/$pagePathType/$pageName/view/${pageName}_$toBeCreated.dart';";
  blocImport = "import 'package:$moduleName/$pagePathType/$pageName/bloc/${pageName}_bloc.dart';";
}
