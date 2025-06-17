import 'package:sg_cli/data/global_vars.dart';
import 'package:sg_cli/utils/validate_command.dart';

class Bronze {
  Bronze._();

  static runCommand() {
    bool isCreatePageCommand = arguments.length == 5 && arguments[3] == 'in' && arguments[0] == 'create' && arguments[1] == 'page';
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
  }
}
