part of 'login_bloc.dart';

abstract class LoginState {}
class LoginInitial extends LoginState {}
class LoginLoading extends LoginState {}
class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}

// 1. Emitted if the number is new -> Goes to OTP Screen
class LoginOtpSent extends LoginState {} 

// 2. Emitted if the number is already registered -> Goes straight to Enter MPIN Screen
class LoginExistingUserSuccess extends LoginState {}