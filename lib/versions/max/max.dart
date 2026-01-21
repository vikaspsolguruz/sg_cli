import 'dart:convert';
import 'dart:io';

import 'package:sg_cli/data/global_vars.dart';
import 'package:sg_cli/utils/console_logger.dart';
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
part 'commands/setup_deeplink/setup_deeplink_command.dart';
part 'commands/setup_firebase/setup_firebase_command.dart';
part 'commands/setup_firebase_manual/setup_firebase_manual_command.dart';
part 'commands/setup_flavors/setup_flavors_command.dart';
part 'commands/show_help/show_help_command.dart';
part 'constants/console_symbols.dart';
part 'data/max_vars.dart';
part 'templates/android_manifest_template.dart';
part 'templates/android_studio_run_config_template.dart';
part 'templates/bloc_template.dart';
part 'templates/deep_link_manager_template.dart';
part 'templates/event_template.dart';
part 'templates/firebase_android_template.dart';
part 'templates/firebase_init_code_template.dart';
part 'templates/firebase_ios_template.dart';
part 'templates/firebase_options_dart_template.dart';
part 'templates/gradle_with_flavors.dart';
part 'templates/ios_entitlements_template.dart';
part 'templates/ios_xcconfig_template.dart';
part 'templates/patrol_android_test_template.dart';
part 'templates/patrol_ios_test_template.dart';
part 'templates/patrol_podfile_template.dart';
part 'templates/route_name_template.dart';
part 'templates/route_template.dart';
part 'templates/view_template.dart';
part 'utils/add_dependency_to_pubspec.dart';
part 'utils/add_imports_to_file.dart';
part 'utils/add_route_data.dart';
part 'utils/add_route_info.dart';
part 'utils/check_existing_route.dart';
part 'utils/copy_directory.dart';
part 'utils/file_helpers.dart';
part 'utils/get_app_label.dart';
part 'utils/get_boilerplate_path.dart';
part 'utils/get_package_id.dart';
part 'utils/modify_app_for_deeplink.dart';
part 'utils/modify_app_initializer.dart';
part 'utils/prepare_page_imports.dart';
part 'utils/prepare_route_data.dart';
part 'utils/pubspec_helpers.dart';
part 'utils/run_pub_get.dart';
part 'utils/setup_patrol_native.dart';
part 'utils/update_android_build_gradle_for_patrol.dart';
part 'utils/update_ios_podfile_for_patrol.dart';

class Max {
  Max._();

  static void runCommand() {
    bool isHelpCommand = arguments.isEmpty || (arguments.length == 1 && (arguments[0] == 'help' || arguments[0] == '--help' || arguments[0] == '-h'));
    bool isInitCommand = arguments.length == 1 && arguments[0] == 'init';
    bool isSetupFlavorsCommand = arguments.length == 1 && arguments[0] == 'setup_flavors';
    bool isSetupDeeplinkCommand = arguments.length == 1 && arguments[0] == 'setup_deeplink';
    bool isSetupFirebaseManualCommand = arguments.length == 1 && arguments[0] == 'setup_firebase_manual';
    bool isSetupFirebaseAutoCommand = arguments.length == 1 && arguments[0] == 'setup_firebase';
    bool isCreateScreenCommand = arguments.length == 3 && arguments[0] == 'create' && arguments[1] == 'screen';
    bool isCreateSubScreenCommand = arguments.length == 5 && arguments[0] == 'create' && arguments[1] == 'sub_screen' && arguments[3] == 'in';
    bool isCreateBottomSheetCommand = arguments.length == 3 && arguments[0] == 'create' && arguments[1] == 'bs';
    bool isCreateDialogCommand = arguments.length == 3 && arguments[0] == 'create' && arguments[1] == 'dialog';
    bool isCreateEventCommand = arguments.length == 5 && arguments[0] == 'create' && arguments[1] == 'event' && arguments[3] == 'in';

    if (arguments.any((element) => isInValidArgument(element))) {
      print(
        "${ConsoleSymbols.error}  Error: Invalid command format\n  • Should be in lowercase only\n  • Start with alphabet\n  • No special characters allowed other then underscore (_)",
      );
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
    if (isSetupFlavorsCommand) {
      // Setup Product Flavors
      _setupFlavors();
      return;
    }
    if (isSetupDeeplinkCommand) {
      // Setup Deep-Linking
      _setupDeeplink();
      return;
    }
    if (isSetupFirebaseManualCommand) {
      // Setup Firebase Configs
      _setupFirebase();
      return;
    }
    if (isSetupFirebaseAutoCommand) {
      // Setup Firebase Configs Automatically using FlutterFire CLI
      setupFirebaseAuto();
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
    print('${ConsoleSymbols.error}  Error: Unknown command.');
  }
}
