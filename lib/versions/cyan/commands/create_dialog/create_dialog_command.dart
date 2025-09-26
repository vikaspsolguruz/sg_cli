part of '../../cyan.dart';

void _createDialogStructure() {
  // Prepare route data
  final prepared = _prepareRouteData(isDialog: true);
  if (!prepared) return;

  final isAlreadyExists = _checkExistingRoute();
  if (isAlreadyExists) {
    print('❌ Error: Route already exists');
    return;
  }
  _moduleName = getModuleName();
  _role = '';

  _toBeCreated = 'dialog';
  _pagePathType = 'dialogs';

  _contentPath = 'lib/presentation/$_pagePathType/$_pageName';
  _logicPath = '$_contentPath/logic';
  _viewPath = '$_contentPath/view';
  _widgetsPath = '$_viewPath/widgets';

  // Create directories
  createDirectory(_contentPath);
  createDirectory(_logicPath);
  createDirectory(_viewPath);
  createDirectory(_widgetsPath);

  // import lines of view and bloc for appRoutes and route names
  _preparePageImports();
  // adding contents in appRoutes
  _addRouteData(isBottomSheet: false, isDialog: true);
  // adding contents in route names
  _addRouteName();

  // Create BLoC, Event and State files
  createFile('$_logicPath/${_pageName}_bloc.dart', _generateBlocContent(_pageName));
  createFile('$_logicPath/${_pageName}_event.dart', _generateEventContent(_pageName));
  createFile('$_logicPath/${_pageName}_state.dart', _generateStateContent(_pageName));

  // Create View file
  createFile('$_viewPath/${_pageName}_$_toBeCreated.dart', _generateDialogContent(_pageName));

  print('✅  $_pagePathType structure for "$_pageName" created successfully!');
}
