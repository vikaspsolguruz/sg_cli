part of 'sign_in_bloc.dart';

class SignInState extends Equatable {
  const SignInState();
  
  const SignInState.initial();
  
  SignInState copyWith() => SignInState();

  @override
  List<Object?> get props => [];

  @override
  String toString() => '$runtimeType';
  
  @visibleForTesting
  const SignInState.test();
}
