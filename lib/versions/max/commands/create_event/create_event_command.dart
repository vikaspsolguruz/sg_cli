part of '../../max.dart';

void _createEvent(final String eventName, final String pageName) {
  String mainFolderPath = '';

  for (final path in sgConfig.routePaths) {
    if (Directory("$path/$pageName").existsSync()) {
      mainFolderPath = "$path/$pageName";
      break;
    }
  }
  if (mainFolderPath.isEmpty) {
    ConsoleLogger.error('Page folder not found: $pageName');
    return;
  }
  final String eventFilePath = '$mainFolderPath/logic/${pageName}_event.dart';

  File eventFile = File(eventFilePath);
  if (!eventFile.existsSync()) {
    eventFile = File(eventFilePath);
    if (!eventFile.existsSync()) {
      ConsoleLogger.error('Event file not found: $eventFilePath');
      return;
    }
    return;
  }

  final String content = eventFile.readAsStringSync();
  final String eventClassName = toPascalCase(eventName);
  final String newEventClass = generateEventContent(eventName, pageName);

  if (content.contains('class $eventClassName {')) {
    ConsoleLogger.warning('Event "$eventClassName" already exists in $eventFilePath');
    return;
  }

  final String updatedContent = content.trim() + newEventClass;

  eventFile.writeAsStringSync(updatedContent);
  ConsoleLogger.success('Event "$eventClassName" added to $eventFilePath');

  final blocFilePath = '$mainFolderPath/logic/${pageName}_bloc.dart';
  final blocFile = File(blocFilePath);
  if (blocFile.existsSync()) {
    final blocContent = blocFile.readAsStringSync();
    final startIndex = blocContent.indexOf('eventListeners() {');
    if (startIndex == -1) {
      ConsoleLogger.error('Unable to find "eventListeners() {" in $blocFilePath');
      return;
    }

    final toBeReplaced = "eventListeners() {";
    final replacer = "eventListeners() {\n    on<$eventClassName>(_on$eventClassName);";

    String blocContentWithListener = blocContent.replaceAll(toBeReplaced, replacer);

    int endIndex = blocContentWithListener.indexOf('}', startIndex);
    if (endIndex == -1) {
      ConsoleLogger.error('Unable to find "}" after "eventListeners() {" in $blocFilePath');
      return;
    }
    endIndex++;

    final blocClassName = toPascalCase(pageName);

    final newBlocContent =
        "${blocContentWithListener.substring(0, endIndex)}\n\n  void _on$eventClassName($eventClassName event, Emitter<${blocClassName}State> emit) {}${blocContentWithListener.substring(endIndex)}";

    blocFile.writeAsStringSync(newBlocContent);
  } else {
    ConsoleLogger.error('Bloc file not found: $blocFilePath');
  }
}
