part of '../../amber.dart';

void _createEvent(final String eventName, final String pageName) {
  String mainFolderPath = '';

  for (final path in sgConfig.routePaths) {
    if (Directory("$path/$pageName").existsSync()) {
      mainFolderPath = "$path/$pageName";
      break;
    }
  }
  if (mainFolderPath.isEmpty) {
    ConsoleLogger.error('Page folder not found: for $pageName');
    return;
  }
  final String eventFilePath = '$mainFolderPath/bloc/${pageName}_event.dart';

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
    ConsoleLogger.warning('Event "$eventClassName" already exists in $eventFilePath.');
    return;
  }

  final String updatedContent = content.trim() + newEventClass;

  eventFile.writeAsStringSync(updatedContent);
  ConsoleLogger.success('Event "$eventClassName" added to $eventFilePath');

  final blocFilePath = '$mainFolderPath/bloc/${pageName}_bloc.dart';
  final blocFile = File(blocFilePath);
  if (blocFile.existsSync()) {
    final blocContent = blocFile.readAsStringSync();
    final startIndex = blocContent.indexOf('_setupEventListener() {');
    if (startIndex == -1) {
      ConsoleLogger.error('Unable to find "_setupEventListener() {" in $blocFilePath');
      return;
    }

    final toBeReplaced = "_setupEventListener() {";
    final replacer = "_setupEventListener() {\n    on<$eventClassName>(_on$eventClassName);";

    String blocContentWithListener = blocContent.replaceAll(toBeReplaced, replacer);

    int endIndex = blocContentWithListener.indexOf('}', startIndex);
    if (endIndex == -1) {
      ConsoleLogger.error('Unable to find "}" after "_setupEventListener() {" in $blocFilePath');
      return;
    }
    endIndex++;

    final newBlocContent =
        "${blocContentWithListener.substring(0, endIndex)}\n\n  void _on$eventClassName($eventClassName event, Emitter emit) {}${blocContentWithListener.substring(endIndex)}";

    blocFile.writeAsStringSync(newBlocContent);
  } else {
    ConsoleLogger.error('Bloc file not found: $blocFilePath');
  }
}
