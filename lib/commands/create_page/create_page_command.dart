import 'package:sg_cli/commands/create_bottom_sheet/add_route_info.dart';
import 'package:sg_cli/data/global_vars.dart';
import 'package:sg_cli/templates/bloc_template.dart';
import 'package:sg_cli/templates/view_template.dart';
import 'package:sg_cli/utils/file_helper.dart';
import 'package:sg_cli/utils/prepare_page_imports.dart';
import 'package:sg_cli/utils/prepare_route_data.dart';
import 'package:sg_cli/utils/pubspec_helper.dart';

void createPageStructure() {
  moduleName = getModuleName();

  toBeCreated = 'page';
  pagePathType = 'pages';

  contentPath = 'lib/$pagePathType/$pageName';
  blocPath = '$contentPath/bloc';
  viewPath = '$contentPath/view';
  componentsPath = '$viewPath/components';

  // Create directories
  createDirectory(contentPath);
  createDirectory(blocPath);
  createDirectory(viewPath);
  createDirectory(componentsPath);

  // Create BLoC, Event and State files
  createFile('$blocPath/${pageName}_bloc.dart', generateBlocContent(pageName));
  createFile('$blocPath/${pageName}_event.dart', generateEventContent(pageName));
  createFile('$blocPath/${pageName}_state.dart', generateStateContent(pageName));

  // Create View file
  createFile('$viewPath/${pageName}_$toBeCreated.dart', generateViewContent(pageName));

  print('✅  $pagePathType structure for "$pageName" created successfully!');

  // Prepare route data
  final prepared = prepareRouteData();

  if (!prepared) return;

  // import lines of view and bloc for appRoutes and route names
  preparePageImports();
  // adding contents in appRoutes
  addRouteData();
  // adding contents in route names
  addRouteName();
}
