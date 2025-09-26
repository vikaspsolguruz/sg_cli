import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newarch/core/utils/analytics/analytics_helper.dart';
import 'package:newarch/core/utils/bloc/bloc_event.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    if (event is BlocEvent) {
      AnalyticsHelper.logCustomEvent(
        event.runtimeType.toString(),
        blocName: bloc.runtimeType.toString(),
        parameters: event.getAnalyticParameters(),
      );
    }
    super.onEvent(bloc, event);
  }
}
