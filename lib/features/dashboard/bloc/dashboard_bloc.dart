import 'package:flutter_bloc/flutter_bloc.dart';
part 'dashboard_event.dart';
part 'dashboard_state.dart';

const List<Map<String, dynamic>> _initialBills = [
  {"title": "Electricity", "type": "electricity"},
  {"title": "HMWSSB", "type": "hmwssb"},
  {"title": "Property Tax", "type": "property_tax"},
  {"title": "Trade License", "type": "trade"},
  {"title": "eChallan", "type": "echallan"},
];

const List<Map<String, dynamic>> _initialUtilityBills = [
  // Electricity
  {"id": "ELE-98723", "name": "Main Residence", "amount": 2450.00, "category": "electricity", "dueDate": "Due in 5 days", "isSelected": true},
  {"id": "ELE-10283", "name": "Commercial Shop", "amount": 5120.50, "category": "electricity", "dueDate": "Due in 10 days", "isSelected": false},
  // HMWSSB
  {"id": "CAN-88294", "name": "Home Water Connection", "amount": 620.00, "category": "hmwssb", "dueDate": "Due in 8 days", "isSelected": true},
  // Property Tax
  {"id": "PTX-99821", "name": "Plot A - Jubilee Hills", "amount": 12500.00, "category": "property_tax", "dueDate": "Due in 15 days", "isSelected": false},
  {"id": "PTX-55310", "name": "Office Building - Madhapur", "amount": 8750.00, "category": "property_tax", "dueDate": "Due in 5 days", "isSelected": true},
  // Trade License
  {"id": "TRD-44120", "name": "Retail Store License", "amount": 3500.00, "category": "trade", "dueDate": "Due in 20 days", "isSelected": true},
  // eChallan
  {"id": "TS09EA1234", "name": "Activa Speeding Fine", "amount": 1035.00, "category": "echallan", "dueDate": "Expired", "isSelected": false},
  {"id": "TS09EB5678", "name": "Car No-Parking Fine", "amount": 235.00, "category": "echallan", "dueDate": "Due in 2 days", "isSelected": true},
];

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc()
      : super(DashboardState(
          bills: _initialBills,
          utilityBills: _initialUtilityBills
              .map((b) => Map<String, dynamic>.from(b))
              .toList(),
        )) {
    on<LoadBills>((event, emit) {
      // Bills are already pre-loaded in the initial state.
      // Re-emit bills so BlocBuilder on the dashboard rebuilds the grid.
      emit(state.copyWith(bills: _initialBills));
    });

    on<AddUtilityBill>((event, emit) {
      final updatedList = List<Map<String, dynamic>>.from(state.utilityBills);
      updatedList.add({
        "id": event.id,
        "name": event.name,
        "amount": event.amount,
        "category": event.category,
        "dueDate": "Due in 30 days",
        "isSelected": true,
      });
      emit(state.copyWith(utilityBills: updatedList));
    });

    on<ToggleBillSelection>((event, emit) {
      final updatedList = state.utilityBills.map((bill) {
        if (bill['id'] == event.id) {
          return Map<String, dynamic>.from(bill)..['isSelected'] = !(bill['isSelected'] as bool);
        }
        return bill;
      }).toList();
      emit(state.copyWith(utilityBills: updatedList));
    });

    on<ToggleCategoryBillsSelection>((event, emit) {
      final updatedList = state.utilityBills.map((bill) {
        if (bill['category'] == event.category) {
          return Map<String, dynamic>.from(bill)..['isSelected'] = event.isSelected;
        }
        return bill;
      }).toList();
      emit(state.copyWith(utilityBills: updatedList));
    });

    on<ClearSelection>((event, emit) {
      final updatedList = state.utilityBills.map((bill) {
        return Map<String, dynamic>.from(bill)..['isSelected'] = false;
      }).toList();
      emit(state.copyWith(utilityBills: updatedList));
    });

    on<MarkBillPaid>((event, emit) {
      final updatedList = state.utilityBills.map((bill) {
        if (bill['id'] == event.id) {
          return Map<String, dynamic>.from(bill)
            ..['isPaid'] = true
            ..['isSelected'] = false;
        }
        return bill;
      }).toList();
      emit(state.copyWith(utilityBills: updatedList));
    });
  }
}