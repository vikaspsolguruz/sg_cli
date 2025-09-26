part of '../../bronze.dart';

void _createScreenStructure() {
  // Prepare route data
  final prepared = _prepareRouteData();
  if (!prepared) return;

  final isAlreadyExists = _checkExistingRoute();
  if (isAlreadyExists) {
    print('❌ Error: Route already exists');
    return;
  }
  _moduleName = getModuleName();
  _role = '';

  _toBeCreated = 'screen';
  _pagePathType = 'screens';

  _contentPath = 'lib/$_pagePathType/$_pageName';
  _blocPath = '$_contentPath/bloc';
  _viewPath = '$_contentPath/view';
  _componentsPath = '$_viewPath/components';

  // Create directories
  createDirectory(_contentPath);
  createDirectory(_blocPath);
  createDirectory(_viewPath);
  createDirectory(_componentsPath);

  // import lines of view and bloc for appRoutes and route names
  _preparePageImports();
  // adding contents in appRoutes
  _addRouteData();
  // adding contents in route names
  _addRouteName();

  // Create BLoC, Event and State files
  createFile('$_blocPath/${_pageName}_bloc.dart', _generateBlocContent(_pageName));
  createFile('$_blocPath/${_pageName}_event.dart', _generateEventContent(_pageName));
  createFile('$_blocPath/${_pageName}_state.dart', _generateStateContent(_pageName));

  // Create View file
  createFile('$_viewPath/${_pageName}_$_toBeCreated.dart', _generateScreenContent(_pageName));

  print('✅  $_pagePathType structure for "$_pageName" created successfully!');
}
