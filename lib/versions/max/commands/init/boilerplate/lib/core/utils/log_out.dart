import 'package:max_arch/app/app_state.dart';
import 'package:max_arch/app/navigation/navigator.dart';
import 'package:max_arch/core/data/current_user.dart';
import 'package:max_arch/core/network/api/api_client.dart';
import 'package:max_arch/core/services/social_auth_service/social_auth_service.dart';
import 'package:max_arch/core/local_storage/local_storage.dart';
import 'package:max_arch/core/utils/console_print.dart';

Future<bool> logOutUser() async {
  try {
    await LocalStorage.clear();
    currentUser = null;
    ApiClient.instance.removeBaseToken();
    // Todo: Fix this when initialization route is defined
    // if (AppState.rootNavigatorKey.currentState != null) Go.replaceAllToNamed(Routes.onboarding);
    // await SocialAuthService().logout();
    return true;
  } catch (e, s) {
    xErrorPrint(e, stackTrace: s);
    return false;
  }
}
