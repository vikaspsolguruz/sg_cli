import 'dart:io';

import '../../templates/event_template.dart';
import '../../utils/name_helper.dart';

void createEvent(final String eventName, final String pageName) {
  String mainFolderPath = '';
  if (Directory('lib/pages/$pageName').existsSync()) {
    mainFolderPath = 'lib/pages/$pageName';
  } else if (Directory('lib/pages/common/$pageName').existsSync()) {
    mainFolderPath = 'lib/pages/common/$pageName';
  } else if (Directory('lib/pages/customer/$pageName').existsSync()) {
    mainFolderPath = 'lib/pages/customer/$pageName';
  } else if (Directory('lib/pages/pub/$pageName').existsSync()) {
    mainFolderPath = 'lib/pages/pub/$pageName';
  } else if (Directory('lib/bottom_sheets/$pageName').existsSync()) {
    mainFolderPath = 'lib/bottom_sheets/$pageName';
  } else {
    print('❌  Error: Page folder not found: for $pageName');
    return;
  }
  final String eventFilePath = '$mainFolderPath/bloc/${pageName}_event.dart';

  File eventFile = File(eventFilePath);
  if (!eventFile.existsSync()) {
    eventFile = File(eventFilePath);
    if (!eventFile.existsSync()) {
      print('❌  Error: Event file not found: $eventFilePath');
      return;
    }
    return;
  }

  final String content = eventFile.readAsStringSync();
  final String eventClassName = toPascalCase(eventName);
  final String newEventClass = generateEventContent(eventName, pageName);

  if (content.contains('class $eventClassName')) {
    print('⚠️ Event "$eventClassName" already exists in $eventFilePath.');
    return;
  }

  final String updatedContent = content.trim() + newEventClass;

  eventFile.writeAsStringSync(updatedContent);
  print('✅  Event "$eventClassName" added to $eventFilePath');

  final blocFilePath = '$mainFolderPath/bloc/${pageName}_bloc.dart';
  final blocFile = File(blocFilePath);
  if (blocFile.existsSync()) {
    final blocContent = blocFile.readAsStringSync();
    final startIndex = blocContent.indexOf('_setupEventListener() {');
    if (startIndex == -1) {
      print('❌  Error: Unable to find "_setupEventListener() {" in $blocFilePath');
      return;
    }

    final toBeReplaced = "_setupEventListener() {";
    final replacer = "_setupEventListener() {\n    on<$eventClassName>(_on$eventClassName);";

    String blocContentWithListener = blocContent.replaceAll(toBeReplaced, replacer);

    int endIndex = blocContentWithListener.indexOf('}', startIndex);
    if (endIndex == -1) {
      print('❌  Error: Unable to find "}" after "_setupEventListener() {" in $blocFilePath');
      return;
    }
    endIndex++;

    final newBlocContent =
        "${blocContentWithListener.substring(0, endIndex)}\n\n  void _on$eventClassName($eventClassName event, Emitter emit) {}${blocContentWithListener.substring(endIndex)}";

    blocFile.writeAsStringSync(newBlocContent);
  } else {
    print('❌  Error: Bloc file not found: $blocFilePath');
  }
}
