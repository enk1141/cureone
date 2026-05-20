import 'package:flutter_bloc/flutter_bloc.dart';
part 'mpin_event.dart';
part 'mpin_state.dart';

class MpinBloc extends Bloc<MpinEvent, MpinState> {
  MpinBloc() : super(MpinInitial()) {
    
    // --- 1. YOUR EXISTING CREATE MPIN HANDLER ---
    on<SetMpinSubmitted>((event, emit) async {
      if (event.mpin.length < 4 || event.confirmMpin.length < 4) {
        emit(MpinMismatch("Please complete both 4-digit fields"));
        return;
      }

      if (event.mpin != event.confirmMpin) {
        emit(MpinMismatch("MPINs do not match. Please re-enter."));
        return;
      }

      emit(MpinLoading()); //
      await Future.delayed(const Duration(seconds: 2)); //
      emit(MpinSuccess()); //
    });

    // --- 2. EXISTING USER LOGIN HANDLER ---
    on<LoginMpinSubmitted>((event, emit) async {
      emit(MpinLoading());

      // Simulated latency delay
      await Future.delayed(const Duration(milliseconds: 600));

      const String defaultMpin = "1234";

      if (event.pin == defaultMpin) {
        emit(LoginMpinSuccess()); //
      } else {
        emit(LoginMpinFailure("Incorrect MPIN. Please try again.")); //
      }
    });
  }
}