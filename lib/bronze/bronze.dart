import 'dart:io';

import 'package:sg_cli/data/global_vars.dart';
import 'package:sg_cli/utils/file_helper.dart';
import 'package:sg_cli/utils/name_helper.dart';
import 'package:sg_cli/utils/pubspec_helper.dart';
import 'package:sg_cli/utils/validate_command.dart';

part 'commands/create_bottom_sheet/add_route_info.dart';
part 'commands/create_bottom_sheet/create_bottom_sheet_command.dart';
part 'commands/create_page/create_page_command.dart';
part 'commands/create_event/create_event_command.dart';
part 'data/bronze_vars.dart';
part 'templates/bloc_template.dart';
part 'templates/event_template.dart';
part 'templates/route_name_template.dart';
part 'templates/route_template.dart';
part 'templates/view_template.dart';
part 'utils/check_existing_route.dart';
part 'utils/prepare_page_imports.dart';
part 'utils/prepare_route_data.dart';

class Bronze {
  Bronze._();

  static void runCommand() {
    bool isCreatePageCommand = arguments.length == 3 && arguments[0] == 'create' && arguments[1] == 'screen';
    bool isCreateBottomSheetCommand = arguments.length == 3 && arguments[0] == 'create' && arguments[1] == 'bs';
    bool isCreateEventCommand = arguments.length == 5 && arguments[0] == 'create' && arguments[1] == 'event' && arguments[3] == 'in';

    if (arguments.isEmpty) {
      print('❌  Error: No command provided.');
      return;
    }

    if (arguments.any((element) => isInValidArgument(element))) {
      print("❌  Error: Invalid command format\n  • Should be in lowercase only\n  • Start with alphabet\n  • No special characters allowed other then underscore (_)");
      return;
    }

    if (isCreatePageCommand) {
      _pageName = arguments[2];
      _createPageStructure();
    } else if (isCreateBottomSheetCommand) {
      _pageName = arguments[2];
      _createBottomSheetStructure();
    } else if (isCreateEventCommand) {
      // Create Event
      final String eventName = arguments[2];
      final String pageName = arguments[4];
      _createEvent(eventName, pageName);
    } else {
      print('❌  Error: Unknown command.');
    }
  }
}
