import 'dart:io';
late List<String> arguments; // command line arguments

late String moduleName;
late String role;
late String pageName; // name of the page/bottom sheet

late String toBeCreated;
late String pagePathType;
late String contentPath;
late String blocPath;
late String viewPath;
late String componentsPath;

late String routesFilePath;
late String routeNamesFilePath;

late File routesFile;
late File routeNamesFile;

// import lines for view and bloc
late String viewImport;
late String blocImport;
