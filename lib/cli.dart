import 'package:sg_cli/commands/create_bottom_sheet/create_bottom_sheet_command.dart';
import 'package:sg_cli/commands/create_event/create_event_command.dart';
import 'package:sg_cli/commands/create_page/create_page_command.dart';
import 'package:sg_cli/data/global_vars.dart';
import 'package:sg_cli/utils/config_helper.dart';
import 'package:sg_cli/utils/validate_command.dart';

void runCLI(List<String> args) {
  arguments = args;
  final sgConfig = getConfig();
  if (sgConfig == null) return;

  bool isCreatePageCommand() => arguments.length == 3 && arguments[0] == 'create' && arguments[1] == 'page';
  bool isCreateBottomSheetCommand() => arguments.length == 3 && arguments[0] == 'create' && arguments[1] == 'bs';
  bool isCreateEventCommand() => arguments.length == 5 && arguments[0] == 'create' && arguments[1] == 'event' && arguments[3] == 'in';

  if (arguments.isEmpty) {
    print('❌  Error: No command provided.');
    return;
  }

  if (arguments.any((element) => isInValidArgument(element))) {
    print("❌  Error: Invalid command format\n  • Should be in lowercase only\n  • Start with alphabet\n  • No special characters allowed other then underscore (_)");
    return;
  }

  if (isCreatePageCommand()) {
    // Create Page
    pageName = arguments[2];
    createPageStructure();
  } else if (isCreateBottomSheetCommand()) {
    // Create Bottom Sheet
    pageName = arguments[2];
    createBottomSheetStructure();
  } else if (isCreateEventCommand()) {
    // Create Event
    final String eventName = arguments[2];
    final String pageName = arguments[4];
    createEvent(eventName, pageName);
  } else {
    print('❌  Error: Unknown command.');
  }
}
