import 'package:flutter_bloc/flutter_bloc.dart';
part 'mpin_event.dart';
part 'mpin_state.dart';

class MpinBloc extends Bloc<MpinEvent, MpinState> {
  // 🟢 1. Create a runtime static variable to act as memory cache across different screens
  static String _savedMpin = "1234"; 

  MpinBloc() : super(MpinInitial()) {
    
    // --- 1. CREATE MPIN HANDLER ---
    on<SetMpinSubmitted>((event, emit) async {
      if (event.mpin.length < 4 || event.confirmMpin.length < 4) {
        emit(MpinMismatch("Please complete both 4-digit fields"));
        return;
      }

      if (event.mpin != event.confirmMpin) {
        emit(MpinMismatch("MPINs do not match. Please re-enter."));
        return;
      }

      emit(MpinLoading());
      await Future.delayed(const Duration(seconds: 2));

      // 🟢 2. Capture and save the user's customized pin to our runtime cache memory
      _savedMpin = event.mpin;

      emit(MpinSuccess());
    });

    // --- 2. EXISTING USER LOGIN HANDLER ---
    on<LoginMpinSubmitted>((event, emit) async {
      emit(MpinLoading());

      await Future.delayed(const Duration(milliseconds: 600));

      // 🟢 3. Compare the typed pin directly to our updated memory variable instead of "1234"
      if (event.pin == _savedMpin) { 
        emit(LoginMpinSuccess());
      } else {
        emit(LoginMpinFailure("Incorrect MPIN. Please try again."));
      }
    });
  }
}