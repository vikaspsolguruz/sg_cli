part of '../../amber.dart';

void _createPageStructure() {
  _moduleName = getModuleName();

  _toBeCreated = 'page';
  _pagePathType = 'pages';

  _contentPath = 'lib/$_pagePathType/$_role/$_pageName';
  _blocPath = '$_contentPath/bloc';
  _viewPath = '$_contentPath/view';
  _componentsPath = '$_viewPath/components';

  // Create directories
  createDirectory(_contentPath);
  createDirectory(_blocPath);
  createDirectory(_viewPath);
  createDirectory(_componentsPath);

  // Prepare route data
  final prepared = _prepareRouteData();

  if (!prepared) return;

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
  createFile('$_viewPath/${_pageName}_$_toBeCreated.dart', _generateViewContent(_pageName));

  ConsoleLogger.success('$_pagePathType structure for "$_pageName" created successfully!');
}
