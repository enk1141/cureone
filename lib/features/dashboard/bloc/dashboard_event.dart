part of 'dashboard_bloc.dart';

abstract class DashboardEvent {}

class LoadBills extends DashboardEvent {}

class AddUtilityBill extends DashboardEvent {
  final String id;
  final String name;
  final double amount;
  final String category;

  AddUtilityBill({
    required this.id,
    required this.name,
    required this.amount,
    required this.category,
  });
}

class ToggleBillSelection extends DashboardEvent {
  final String id;

  ToggleBillSelection({required this.id});
}

class ToggleCategoryBillsSelection extends DashboardEvent {
  final String category;
  final bool isSelected;

  ToggleCategoryBillsSelection({
    required this.category,
    required this.isSelected,
  });
}

class ClearSelection extends DashboardEvent {}