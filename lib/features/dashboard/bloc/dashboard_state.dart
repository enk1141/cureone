part of 'dashboard_bloc.dart';

class DashboardState {
  final List<Map<String, dynamic>> bills;
  final List<Map<String, dynamic>> utilityBills;

  DashboardState({
    required this.bills,
    required this.utilityBills,
  });

  DashboardState copyWith({
    List<Map<String, dynamic>>? bills,
    List<Map<String, dynamic>>? utilityBills,
  }) {
    return DashboardState(
      bills: bills ?? this.bills,
      utilityBills: utilityBills ?? this.utilityBills,
    );
  }
}