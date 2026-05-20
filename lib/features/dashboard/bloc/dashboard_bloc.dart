import 'package:flutter_bloc/flutter_bloc.dart';
part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardState(bills: [])) {
    on<LoadBills>((event, emit) {
      emit(DashboardState(bills: [
        {"title": "Electricity", "type": "electricity"},
        {"title": "HMWSSB", "type": "hmwssb"},
        {"title": "Property Tax", "type": "property_tax"},
        {"title": "Trade License", "type": "trade"},
        {"title": "eChallan", "type": "echallan"},
        {"title": "Broadband", "type": "broadband"},
      ]));
    });
  }
}