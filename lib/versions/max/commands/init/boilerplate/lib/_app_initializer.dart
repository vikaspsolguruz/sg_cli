import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:max_arch/app/app_settings.dart';
import 'package:max_arch/app/app_state.dart';
import 'package:max_arch/core/data/country.dart';
import 'package:max_arch/core/data/current_user.dart';
import 'package:max_arch/core/local_storage/local_storage.dart';
import 'package:max_arch/core/utils/bloc/bloc_observer.dart';
import 'package:max_arch/core/utils/console_print.dart';
import 'package:max_arch/core/utils/device_info.dart';
import 'package:max_arch/core/utils/prepare_initial_route.dart';

Future<void> initializeApp() async {
  final sw = Stopwatch()..start();
  try {
    WidgetsFlutterBinding.ensureInitialized();

    await LocalStorage.initialize();
    AppSettings.init();
    deviceCountry = LocalStorage.getDeviceCountry() ?? await getDeviceCountry();
    currentUser = LocalStorage.getCurrentUser();

    // Todo: Fix this when profile setup actual logic is defined
    // if (currentUser != null && currentUser?.onboardingStatus != OnBoardingStatus.finished) {
    //   await logOutUser();
    // }

    Bloc.observer = MyBlocObserver();

    AppState.initializeRoutes();
    prepareInitialRoute();

    // Todo: uncomment this after firebase setup is completed
    // await NativeNotificationService.instance.initialize();
  } catch (e, s) {
    xErrorPrint("App Initialization failed : $e", stackTrace: s);
  }
  await Future.delayed(Duration(milliseconds: 1200 - sw.elapsedMilliseconds));
  sw.stop();
}
