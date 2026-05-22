import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_cure_ui/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:my_cure_ui/config/routes.dart';

class PayAllAtOnceScreen extends StatefulWidget {
  const PayAllAtOnceScreen({super.key});

  @override
  State<PayAllAtOnceScreen> createState() => _PayAllAtOnceScreenState();
}

class _PayAllAtOnceScreenState extends State<PayAllAtOnceScreen> {
  final Map<String, dynamic> _categories = {
    'electricity': {
      'title': 'Electricity',
      'icon': Icons.bolt_rounded,
      'color': const Color(0xFFFF9F0A),
    },
    'hmwssb': {
      'title': 'Water (HMWSSB)',
      'icon': Icons.water_drop_rounded,
      'color': const Color(0xFF0A84FF),
    },
    'property_tax': {
      'title': 'Property Tax',
      'icon': Icons.home_work_rounded,
      'color': const Color(0xFF30D158),
    },
    'trade': {
      'title': 'Trade License',
      'icon': Icons.storefront_rounded,
      'color': const Color(0xFFBF5AF2),
    },
    'echallan': {
      'title': 'eChallan',
      'icon': Icons.receipt_long_rounded,
      'color': const Color(0xFFFF453A),
    },
  };

  void _showAddUtilityDialog(BuildContext context, String category, String categoryTitle, Color accentColor) {
    final formKey = GlobalKey<FormState>();
    final idController = TextEditingController();
    final nameController = TextEditingController();
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1435),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: const Color(0xFF2D1F49), width: 1.5),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(_categories[category]['icon'] as IconData, color: accentColor, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Add $categoryTitle",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: idController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Utility Account/Consumer ID",
                      labelStyle: const TextStyle(color: Color(0xFF8A9A9A), fontSize: 13),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: const Color(0xFF2D1F49)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: accentColor),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) return "Required";
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Consumer Name",
                      labelStyle: const TextStyle(color: Color(0xFF8A9A9A), fontSize: 13),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: const Color(0xFF2D1F49)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: accentColor),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) return "Required";
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Due Amount (₹)",
                      labelStyle: const TextStyle(color: Color(0xFF8A9A9A), fontSize: 13),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: const Color(0xFF2D1F49)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: accentColor),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) return "Required";
                      if (double.tryParse(val) == null) return "Enter valid number";
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("CANCEL", style: TextStyle(color: Color(0xFF8A9A9A))),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final parsedAmount = double.parse(amountController.text);
                  BlocProvider.of<DashboardBloc>(context).add(
                    AddUtilityBill(
                      id: idController.text.trim(),
                      name: nameController.text.trim(),
                      amount: parsedAmount,
                      category: category,
                    ),
                  );
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text("ADD", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        // Calculate totals
        final selectedBills = state.utilityBills.where((b) => b['isSelected'] as bool).toList();
        final int totalCount = selectedBills.length;
        final double totalAmount = selectedBills.fold(0.0, (sum, item) => sum + (item['amount'] as double));

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0F0720),
                  Color(0xFF160E2A),
                  Color(0xFF0F0720),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(context),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      physics: const BouncingScrollPhysics(),
                      itemCount: _categories.keys.length,
                      itemBuilder: (context, index) {
                        final catKey = _categories.keys.elementAt(index);
                        final catData = _categories[catKey];
                        final catTitle = catData['title'] as String;
                        final catIcon = catData['icon'] as IconData;
                        final catColor = catData['color'] as Color;

                        // Filter bills of this category
                        final catBills = state.utilityBills.where((b) => b['category'] == catKey).toList();

                        // Check if all bills in this category are selected
                        final bool allSelected = catBills.isNotEmpty && catBills.every((b) => b['isSelected'] as bool);
                        final bool someSelected = catBills.isNotEmpty && catBills.any((b) => b['isSelected'] as bool) && !allSelected;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1435),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF2D1F49),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Category Header
                              Padding(
                                padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 32,
                                      width: 32,
                                      decoration: BoxDecoration(
                                        color: catColor.withOpacity(0.12),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(catIcon, color: catColor, size: 18),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Text(
                                            catTitle,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          IconButton(
                                            icon: Icon(Icons.add_circle_outline_rounded, color: catColor, size: 18),
                                            onPressed: () => _showAddUtilityDialog(context, catKey, catTitle, catColor),
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            splashRadius: 16,
                                            tooltip: 'Add utility connection',
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Custom checkbox for Category
                                    Transform.scale(
                                      scale: 0.85,
                                      child: Checkbox(
                                        value: allSelected ? true : (someSelected ? null : false),
                                        activeColor: catColor,
                                        tristate: true,
                                        side: const BorderSide(color: Color(0xFF4C3E6D), width: 1.5),
                                        onChanged: (val) {
                                          final nextVal = val ?? true;
                                          BlocProvider.of<DashboardBloc>(context).add(
                                            ToggleCategoryBillsSelection(
                                              category: catKey,
                                              isSelected: nextVal,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(color: Color(0xFF2D1F49), height: 1, thickness: 1),
                              // Bills List
                              if (catBills.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                                  child: Center(
                                    child: Text(
                                      "No active bills. Click '+' to add one.",
                                      style: const TextStyle(
                                        color: Color(0xFF8A9A9A),
                                        fontSize: 11,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: catBills.length,
                                  itemBuilder: (context, bIndex) {
                                    final bill = catBills[bIndex];
                                    final isSelected = bill['isSelected'] as bool;
                                    final billAmount = bill['amount'] as double;
                                    final billName = bill['name'] as String;
                                    final billId = bill['id'] as String;
                                    final dueDate = bill['dueDate'] as String;
                                    final isExpired = dueDate.toLowerCase() == 'expired';

                                    return InkWell(
                                      onTap: () {
                                        BlocProvider.of<DashboardBloc>(context).add(
                                          ToggleBillSelection(id: billId),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? catColor.withOpacity(0.04)
                                              : Colors.transparent,
                                          border: bIndex < catBills.length - 1
                                              ? const Border(bottom: BorderSide(color: Color(0xFF23183F), width: 0.8))
                                              : null,
                                        ),
                                        child: Row(
                                          children: [
                                            // Checkbox
                                            Transform.scale(
                                              scale: 0.85,
                                              child: Checkbox(
                                                value: isSelected,
                                                activeColor: catColor,
                                                checkColor: Colors.black,
                                                side: BorderSide(
                                                  color: isSelected ? catColor : const Color(0xFF4C3E6D),
                                                  width: 1.5,
                                                ),
                                                onChanged: (val) {
                                                  BlocProvider.of<DashboardBloc>(context).add(
                                                    ToggleBillSelection(id: billId),
                                                  );
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            // Bill Details
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    billName,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.5,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    "ID: $billId",
                                                    style: const TextStyle(
                                                      color: Color(0xFF8A9A9A),
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Amount & Due Date
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "₹${billAmount.toStringAsFixed(2)}",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.5,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  dueDate,
                                                  style: TextStyle(
                                                    color: isExpired
                                                        ? const Color(0xFFFF453A)
                                                        : (dueDate.contains('5 days') || dueDate.contains('2 days')
                                                            ? const Color(0xFFFF9F0A)
                                                            : const Color(0xFF30D158)),
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  _buildBottomNavBar(context, totalCount, totalAmount, selectedBills),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
            onPressed: () => Navigator.pop(context),
            splashRadius: 20,
          ),
          const SizedBox(width: 8),
          const Text(
            "Pay All At Once",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context, int totalCount, double totalAmount, List<Map<String, dynamic>> selectedBills) {
    final bool hasSelection = totalCount > 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1435),
        border: const Border(
          top: BorderSide(color: Color(0xFF2D1F49), width: 1.5),
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
<<<<<<< Updated upstream
                  "$totalCount items selected",
                  style: const TextStyle(
                    color: Color(0xFF8A9A9A),
=======
                  '$selectedCount of $totalCount selected',
                  style: TextStyle(
>>>>>>> Stashed changes
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
<<<<<<< Updated upstream
                  "₹${totalAmount.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Color(0xFF19B9B9),
                    fontSize: 18,
=======
                  '₹${totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 20,
>>>>>>> Stashed changes
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
<<<<<<< Updated upstream
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF19B9B9),
              disabledBackgroundColor: const Color(0xFF19B9B9).withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
=======
          TextButton.icon(
            onPressed: totalCount == 0 ? null : onSelectAll,
            icon: Icon(
              allSelected
                  ? Icons.remove_done_rounded
                  : Icons.done_all_rounded,
              size: 16,
              color: AppColors.primary,
            ),
            label: Text(
              allSelected ? 'Clear all' : 'Select all',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: AppColors.surface,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadii.pill),
                side: BorderSide(color: AppColors.border),
>>>>>>> Stashed changes
              ),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              elevation: hasSelection ? 8 : 0,
              shadowColor: const Color(0xFF19B9B9).withOpacity(0.3),
            ),
            onPressed: hasSelection
                ? () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.paymentConfirmation,
                      arguments: {
                        'selectedBills': selectedBills,
                        'bloc': BlocProvider.of<DashboardBloc>(context),
                      },
                    );
                  }
                : null,
            child: Row(
              children: [
                Text(
                  "Pay Now",
                  style: TextStyle(
                    color: hasSelection ? Colors.white : Colors.white.withOpacity(0.4),
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: hasSelection ? Colors.white : Colors.white.withOpacity(0.4),
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
<<<<<<< Updated upstream
=======

class _CategoryGroup extends StatelessWidget {
  const _CategoryGroup({required this.category, required this.bills});

  final UtilityCategory category;
  final List<Map<String, dynamic>> bills;

  @override
  Widget build(BuildContext context) {
    final allSelected = bills.every((b) => b['isSelected'] as bool);
    final someSelected =
        bills.any((b) => b['isSelected'] as bool) && !allSelected;
    final categoryTotal = bills
        .where((b) => b['isSelected'] as bool)
        .fold<double>(0.0, (s, b) => s + (b['amount'] as num).toDouble());

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category header with select-all toggle
          InkWell(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadii.lg),
            ),
            onTap: () {
              context.read<DashboardBloc>().add(
                    ToggleCategoryBillsSelection(
                      category: category.key,
                      isSelected: !allSelected,
                    ),
                  );
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
              child: Row(
                children: [
                  Container(
                    height: 34,
                    width: 34,
                    decoration: BoxDecoration(
                      color: category.color.withOpacity(0.14),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(category.icon,
                        color: category.color, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.label,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${bills.length} bill${bills.length == 1 ? '' : 's'}'
                          '${categoryTotal > 0 ? ' · ₹${categoryTotal.toStringAsFixed(0)} selected' : ''}',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _TriCheckbox(
                    allSelected: allSelected,
                    someSelected: someSelected,
                    color: category.color,
                  ),
                ],
              ),
            ),
          ),
          // Divider
          Container(height: 1, color: AppColors.border),
          // Bills under this category
          ...bills.asMap().entries.map((entry) {
            final i = entry.key;
            final bill = entry.value;
            return _BillRow(
              bill: bill,
              category: category,
              isLast: i == bills.length - 1,
            );
          }),
        ],
      ),
    );
  }
}

class _BillRow extends StatelessWidget {
  const _BillRow({
    required this.bill,
    required this.category,
    required this.isLast,
  });

  final Map<String, dynamic> bill;
  final UtilityCategory category;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final selected = bill['isSelected'] as bool;
    final amount = (bill['amount'] as num).toDouble();
    final due = bill['dueDate'] as String? ?? '';
    final isExpired = due.toLowerCase().contains('expired');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: isLast
            ? const BorderRadius.vertical(
                bottom: Radius.circular(AppRadii.lg),
              )
            : BorderRadius.zero,
        onTap: () {
          context.read<DashboardBloc>().add(
                ToggleBillSelection(id: bill['id'] as String),
              );
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          decoration: BoxDecoration(
            border: isLast
                ? null
                : Border(
                    bottom:
                        BorderSide(color: AppColors.border, width: 0.8),
                  ),
          ),
          child: Row(
            children: [
              _Check(checked: selected, color: category.color),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bill['name'] as String,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          'ID: ${bill['id']}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 3,
                          height: 3,
                          decoration: BoxDecoration(
                            color: AppColors.textMuted,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          isExpired
                              ? Icons.error_outline_rounded
                              : Icons.schedule_rounded,
                          size: 11,
                          color: isExpired
                              ? AppColors.danger
                              : AppColors.textMuted,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          due,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isExpired
                                ? AppColors.danger
                                : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '₹${amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: selected ? category.color : AppColors.primaryDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Check extends StatelessWidget {
  const _Check({required this.checked, required this.color});
  final bool checked;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      width: 22,
      decoration: BoxDecoration(
        color: checked ? color : AppColors.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: checked ? color : AppColors.border,
          width: 1.5,
        ),
      ),
      child: checked
          ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
          : null,
    );
  }
}

class _TriCheckbox extends StatelessWidget {
  const _TriCheckbox({
    required this.allSelected,
    required this.someSelected,
    required this.color,
  });

  final bool allSelected;
  final bool someSelected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final filled = allSelected || someSelected;
    return Container(
      height: 22,
      width: 22,
      decoration: BoxDecoration(
        color: filled ? color : AppColors.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: filled ? color : AppColors.border,
          width: 1.5,
        ),
      ),
      child: allSelected
          ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
          : someSelected
              ? const Icon(Icons.remove_rounded, size: 14, color: Colors.white)
              : null,
    );
  }
}

class _PayBar extends StatelessWidget {
  const _PayBar({
    required this.selectedCount,
    required this.totalAmount,
    required this.onPay,
  });

  final int selectedCount;
  final double totalAmount;
  final VoidCallback onPay;

  @override
  Widget build(BuildContext context) {
    final enabled = selectedCount > 0;
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 12, 20, 12 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: enabled ? onPay : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            disabledBackgroundColor: AppColors.border,
            disabledForegroundColor: AppColors.textMuted,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline_rounded, size: 16),
              const SizedBox(width: 6),
              Text(
                enabled
                    ? 'Pay ₹${totalAmount.toStringAsFixed(2)} ($selectedCount)'
                    : 'Select bills to pay',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AllPaidState extends StatelessWidget {
  const _AllPaidState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 84,
              width: 84,
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_rounded,
                  size: 42, color: AppColors.success),
            ),
            const SizedBox(height: 16),
            Text(
              'All caught up!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'You have no pending bills.',
              textAlign: TextAlign.center,
              style: AppText.bodyMuted,
            ),
          ],
        ),
      ),
    );
  }
}
>>>>>>> Stashed changes
