import 'package:newarch/app/app_state.dart';
import 'package:newarch/app/navigation/navigator.dart';
import 'package:newarch/core/data/current_user.dart';
import 'package:newarch/core/network/api/api_client.dart';
import 'package:newarch/core/services/social_auth_service/social_auth_service.dart';
import 'package:newarch/core/local_storage/local_storage.dart';
import 'package:newarch/core/utils/console_print.dart';

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
