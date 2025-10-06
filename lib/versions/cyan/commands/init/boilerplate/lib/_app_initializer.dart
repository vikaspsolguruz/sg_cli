import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newarch/app/app_state.dart';
import 'package:newarch/core/data/country.dart';
import 'package:newarch/core/data/current_user.dart';
import 'package:newarch/core/services/notification/notification_service.dart';
import 'package:newarch/core/local_storage/local_storage.dart';
import 'package:newarch/core/utils/bloc/bloc_observer.dart';
import 'package:newarch/core/utils/console_print.dart';
import 'package:newarch/core/utils/device_info.dart';

Future<void> initializeApp() async {
  final sw = Stopwatch()..start();
  try {
    WidgetsFlutterBinding.ensureInitialized();
    deviceCountry = await getDeviceCountry();
    await LocalStorage.initialize();
    currentUser = LocalStorage.getCurrentUser();
    // Todo: Fix this when profile setup actual logic is defined
    // if (currentUser != null && currentUser?.onboardingStatus != OnBoardingStatus.finished) {
    //   await logOutUser();
    // }
    Bloc.observer = MyBlocObserver();
    AppState.initializeRoutes();
    await NotificationService.instance.initialize();
  } catch (e, s) {
    xErrorPrint("App Initialization failed : $e", stackTrace: s);
  }
  await Future.delayed(Duration(milliseconds: 2000 - sw.elapsedMilliseconds));
  sw.stop();
}
