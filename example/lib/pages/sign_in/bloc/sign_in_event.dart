part of 'sign_in_bloc.dart';

abstract class SignInEvent with EquatableMixin implements AnalyticsEvent {
  const SignInEvent();

  @override
  bool shouldLogEvent() => true;
}
