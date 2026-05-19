import 'package:flutter_bloc/flutter_bloc.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      final phone = event.mobileNumber;

      if (phone.length != 10) {
        emit(LoginFailure("Mobile number must be exactly 10 digits"));
        return;
      }

      final firstDigit = int.tryParse(phone[0]);
      if (firstDigit != null && firstDigit >= 0 && firstDigit <= 5) {
        emit(LoginFailure("Invalid mobile number format"));
        return;
      }

      emit(LoginLoading());

      await Future.delayed(const Duration(seconds: 2));

      // Emit OTP sent state
      emit(LoginOtpSent(phone));
    });
  }
}
