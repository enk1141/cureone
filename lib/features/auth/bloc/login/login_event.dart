part of 'login_bloc.dart';

abstract class LoginEvent {}

class MobileNumberChanged extends LoginEvent {
  final String mobileNumber;

  MobileNumberChanged(this.mobileNumber);
}

class LoginSubmitted extends LoginEvent {
  final String mobileNumber;

  LoginSubmitted(this.mobileNumber);
}