import 'package:flutter_bloc/flutter_bloc.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<MobileNumberChanged>((event, emit) {});
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());

      try {
        // Simulated network delay (reduced from 15s to 1s for better testing response)
        await Future.delayed(const Duration(seconds: 1));

        // 🟢 DYNAMIC CHECKING FOR TESTING:
        // If you type '9999999999', it treats it as an existing user.
        // If you type any other number, it acts as a new user and goes to OTP.
        bool isExistingUser = (event.mobileNumber == "9999999999");

        if (isExistingUser) {
          emit(
              LoginExistingUserSuccess()); // Bypasses OTP flow -> Enter MPIN Screen
        } else {
          emit(LoginOtpSent()); // Standard registration pipeline -> OTP Screen
        }
      } catch (e) {
        emit(LoginFailure("Connection failed. Please try again."));
      }
    });
  }
}
