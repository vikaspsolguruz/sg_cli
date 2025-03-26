// import lines for view and bloc

import 'package:sg_cli/data/global_vars.dart';

void preparePageImports() {
  String roleType = '';
  if(role.isNotEmpty) {
    roleType = '$role/';
  }
  viewImport = "import 'package:$moduleName/$pagePathType/$roleType$pageName/view/${pageName}_$toBeCreated.dart';";
  blocImport = "import 'package:$moduleName/$pagePathType/$roleType$pageName/bloc/${pageName}_bloc.dart';";
}