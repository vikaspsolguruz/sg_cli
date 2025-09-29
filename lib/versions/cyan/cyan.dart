import 'dart:io';

import 'package:sg_cli/data/global_vars.dart';
import 'package:sg_cli/utils/file_helper.dart';
import 'package:sg_cli/utils/name_helper.dart';
import 'package:sg_cli/utils/pubspec_helper.dart';
import 'package:sg_cli/utils/validate_command.dart';

part 'commands/create_bottom_sheet/create_bottom_sheet_command.dart';
part 'commands/create_dialog/create_dialog_command.dart';
part 'commands/create_event/create_event_command.dart';
part 'commands/create_screen/create_screen_command.dart';
part 'commands/create_sub_screen/create_sub_screen_command.dart';
part 'commands/init/init_command.dart';
part 'data/cyan_vars.dart';
part 'templates/bloc_template.dart';
part 'templates/event_template.dart';
part 'templates/route_name_template.dart';
part 'templates/route_template.dart';
part 'templates/view_template.dart';
part 'utils/add_route_data.dart';
part 'utils/add_route_info.dart';
part 'utils/check_existing_route.dart';
part 'utils/prepare_page_imports.dart';
part 'utils/prepare_route_data.dart';

class Cyan {
  Cyan._();

  static void runCommand() {
    bool isHelpCommand = arguments.length == 1 && (arguments[0] == 'help' || arguments[0] == '--help' || arguments[0] == '-h');
    bool isInitCommand = arguments.length == 1 && arguments[0] == 'init';
    bool isCreateScreenCommand = arguments.length == 3 && arguments[0] == 'create' && arguments[1] == 'screen';
    bool isCreateSubScreenCommand = arguments.length == 5 && arguments[0] == 'create' && arguments[1] == 'sub_screen' && arguments[3] == 'in';
    bool isCreateBottomSheetCommand = arguments.length == 3 && arguments[0] == 'create' && arguments[1] == 'bs';
    bool isCreateDialogCommand = arguments.length == 3 && arguments[0] == 'create' && arguments[1] == 'dialog';
    bool isCreateEventCommand = arguments.length == 5 && arguments[0] == 'create' && arguments[1] == 'event' && arguments[3] == 'in';

    if (arguments.isEmpty) {
      print('❌  Error: No command provided.');
      return;
    }

    if (arguments.any((element) => isInValidArgument(element))) {
      print("❌  Error: Invalid command format\n  • Should be in lowercase only\n  • Start with alphabet\n  • No special characters allowed other then underscore (_)");
      return;
    }
    if (isHelpCommand) {
      // Show Help
      _showHelp();
      return;
    }
    if (isInitCommand) {
      // Initialize Project
      _initProject();
      return;
    }
    if (isCreateScreenCommand) {
      // Create Screen
      _pageName = arguments[2];
      _createScreenStructure();
      return;
    }
    if (isCreateSubScreenCommand) {
      // Create Sub Screen
      _pageName = arguments[2];
      _parentPageName = arguments[4];
      _createSubScreenStructure();
      return;
    }
    if (isCreateBottomSheetCommand) {
      // Create Bottom Sheet
      _pageName = arguments[2];
      _createBottomSheetStructure();
      return;
    }
    if (isCreateDialogCommand) {
      // Create Dialog
      _pageName = arguments[2];
      _createDialogStructure();
      return;
    }
    if (isCreateEventCommand) {
      // Create Bloc'sEvent
      final String eventName = arguments[2];
      final String pageName = arguments[4];
      _createEvent(eventName, pageName);
      return;
    }
    print('❌  Error: Unknown command.');
  }
}
