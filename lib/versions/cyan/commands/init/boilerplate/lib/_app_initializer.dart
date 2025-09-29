import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newarch/app/app_state.dart';
import 'package:newarch/core/shared_pref/shared_pref.dart';
import 'package:newarch/core/utils/bloc/bloc_observer.dart';
import 'package:newarch/core/utils/console_print.dart';

Future<void> initializeApp() async {
  final sw = Stopwatch()..start();
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Prefs.initialize();
    Bloc.observer = MyBlocObserver();
    AppState.initializeRoutes();
  } catch (e, s) {
    xErrorPrint("App Initialization failed : $e", stackTrace: s);
  }
  await Future.delayed(Duration(milliseconds: 2000 - sw.elapsedMilliseconds));
  sw.stop();
}