part of '../bronze.dart';

void _preparePageImports() {
  String roleType = '';
  if (_role.isNotEmpty) {
    roleType = '$_role/';
  }
  _viewImport = "import 'package:$_moduleName/$_pagePathType/$roleType$_pageName/view/${_pageName}_$_toBeCreated.dart';";
  _blocImport = "import 'package:$_moduleName/$_pagePathType/$roleType$_pageName/bloc/${_pageName}_bloc.dart';";
}
