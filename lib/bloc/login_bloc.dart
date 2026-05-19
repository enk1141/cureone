import 'package:flutter_bloc/flutter_bloc.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {

    on<LoginSubmitted>((event, emit) async {

      if (event.mobileNumber.length != 10) {
        emit(LoginFailure("Enter valid mobile number"));
        return;
      }

      emit(LoginLoading());

      await Future.delayed(const Duration(seconds: 2));

      emit(LoginOtpSent(event.mobileNumber));
    });
  }
}