import 'package:flutter_bloc/flutter_bloc.dart';
part 'otp_event.dart';
part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  OtpBloc() : super(OtpInitial()) {
    on<OtpSubmitted>((event, emit) async {
      if (event.code.length < 6) {
        emit(OtpFailure("Please enter the complete 6-digit code"));
        return;
      }

      emit(OtpLoading());
      
      // Simulate backend API OTP confirmation
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock validation logic (e.g., if code is 123456)
      if (event.code == "123456") {
        emit(OtpSuccess());
      } else {
        emit(OtpFailure("Invalid verification code. Try 123456"));
      }
    });

    on<ResendOtpRequested>((event, emit) async {
      // Logic to trigger another SMS trigger payload
    });
  }
}