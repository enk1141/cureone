part of 'login_bloc.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginOtpSent extends LoginState {
  final String mobileNumber;

  LoginOtpSent(this.mobileNumber);
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure(this.error);
}