import 'package:flutter_bloc/flutter_bloc.dart';
import 'mpin_event.dart';
import 'mpin_state.dart';

class MpinBloc extends Bloc<MpinEvent, MpinState> {
  MpinBloc() : super(MpinInitial()) {
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

      // Simulate backend API payload transmission to save the MPIN
      await Future.delayed(const Duration(seconds: 2));

      emit(MpinSuccess());
    });
  }
}