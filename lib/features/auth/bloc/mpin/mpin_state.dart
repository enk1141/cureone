part of 'mpin_bloc.dart';

abstract class MpinState {} //

class MpinInitial extends MpinState {} //
class MpinLoading extends MpinState {} //
class MpinSuccess extends MpinState {} //

class MpinMismatch extends MpinState { //
  final String error; //
  MpinMismatch(this.error); //
}

class LoginMpinSuccess extends MpinState {} //
class LoginMpinFailure extends MpinState { //
  final String error; //
  LoginMpinFailure(this.error); //
}