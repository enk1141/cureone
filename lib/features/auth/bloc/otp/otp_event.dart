part of 'otp_block.dart';

abstract class OtpEvent {}

class OtpCodeChanged extends OtpEvent {
  final String code;
  OtpCodeChanged(this.code);
}

class OtpSubmitted extends OtpEvent {
  final String code;
  OtpSubmitted(this.code);
}

class ResendOtpRequested extends OtpEvent {}