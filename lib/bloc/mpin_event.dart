abstract class MpinEvent {} //

class SetMpinSubmitted extends MpinEvent { //
  final String mpin; //
  final String confirmMpin; //

  SetMpinSubmitted({required this.mpin, required this.confirmMpin}); //
}

class LoginMpinSubmitted extends MpinEvent { //
  final String pin; //
  LoginMpinSubmitted(this.pin); //
}