part of '../max.dart';

void _preparePageImports() {
  String roleType = '';
  if (_role.isNotEmpty) {
    roleType = '$_role/';
  }
  _viewImport = "import 'package:$_moduleName/presentation/$_pagePathType/$roleType$_pageName/view/${_pageName}_$_toBeCreated.dart';";
  _blocImport = "import 'package:$_moduleName/presentation/$_pagePathType/$roleType$_pageName/logic/${_pageName}_bloc.dart';";
}
