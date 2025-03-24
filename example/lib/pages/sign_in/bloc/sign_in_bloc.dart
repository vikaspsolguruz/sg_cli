import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:example/logger/app_logging.dart';
import 'package:example/utils/analytics_helper.dart';
import 'package:example/analytics/main_event.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> with Loggable {
  SignInBloc() : super(const SignInState.initial()) {
    _setupEventListener();
  }
  
  @override
  void onEvent(SignInEvent event) {
    super.onEvent(event);
    AnalyticsHelper().logCustomEvent(
      event.eventName,
      parameters: event.getAnalyticParameters(),
    );
  }
  
  @override
  String get className => '$runtimeType';
  
  void _setupEventListener() {}
}

extension SignInExtension on BuildContext {
  SignInBloc get signInBloc => BlocProvider.of<SignInBloc>(this);
}
