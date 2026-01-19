import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:max_arch/core/utils/analytics/analytics_helper.dart';
import 'package:max_arch/core/utils/bloc/base_event.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    if (event is BaseEvent) {
      AnalyticsHelper.logCustomEvent(
        event.runtimeType.toString(),
        blocName: bloc.runtimeType.toString(),
        parameters: event.getAnalyticParameters(),
      );
    }
    super.onEvent(bloc, event);
  }
}
