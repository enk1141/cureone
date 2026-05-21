import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_cure_ui/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:my_cure_ui/config/routes.dart';

class UtilityDetailsScreen extends StatefulWidget {
  final String category;

  const UtilityDetailsScreen({
    super.key,
    required this.category,
  });

  @override
  State<UtilityDetailsScreen> createState() => _UtilityDetailsScreenState();
}

class _UtilityDetailsScreenState extends State<UtilityDetailsScreen> {
  final Map<String, dynamic> _categoryDetails = {
    'electricity': {
      'title': 'Electricity Bills',
      'icon': Icons.bolt_rounded,
      'color': const Color(0xFFFF9F0A),
    },
    'hmwssb': {
      'title': 'Water Bills (HMWSSB)',
      'icon': Icons.water_drop_rounded,
      'color': const Color(0xFF0A84FF),
    },
    'property_tax': {
      'title': 'Property Tax',
      'icon': Icons.home_work_rounded,
      'color': const Color(0xFF30D158),
    },
    'trade': {
      'title': 'Trade Licenses',
      'icon': Icons.storefront_rounded,
      'color': const Color(0xFFBF5AF2),
    },
    'echallan': {
      'title': 'Traffic eChallans',
      'icon': Icons.receipt_long_rounded,
      'color': const Color(0xFFFF453A),
    },
  };

  void _showAddUtilityDialog(
      BuildContext context, Color accentColor, String title) {
    final formKey = GlobalKey<FormState>();
    final idController = TextEditingController();
    final nameController = TextEditingController();
    final amountController = TextEditingController();

    // Generate a default prefix for ID to make it quick
    String prefix = "UTL-";
    if (widget.category == 'electricity') prefix = "ELE-";
    if (widget.category == 'hmwssb') prefix = "CAN-";
    if (widget.category == 'property_tax') prefix = "PTX-";
    if (widget.category == 'trade') prefix = "TRD-";
    if (widget.category == 'echallan') prefix = "TS09-";

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1435),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: Color(0xFF2D1F49), width: 1.5),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                    _categoryDetails[widget.category]['icon'] as IconData,
                    color: accentColor,
                    size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Add New Bill",
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
                      labelText: "Consumer / Connection ID",
                      labelStyle: const TextStyle(
                          color: Color(0xFF8A9A9A), fontSize: 13),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF2D1F49)),
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
                      labelStyle: const TextStyle(
                          color: Color(0xFF8A9A9A), fontSize: 13),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF2D1F49)),
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
                      labelStyle: const TextStyle(
                          color: Color(0xFF8A9A9A), fontSize: 13),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF2D1F49)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: accentColor),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) return "Required";
                      if (double.tryParse(val) == null)
                        return "Enter valid number";
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("CANCEL",
                  style: TextStyle(color: Color(0xFF8A9A9A))),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final parsedAmount = double.parse(amountController.text);
                  BlocProvider.of<DashboardBloc>(context).add(
                    AddUtilityBill(
                      id: idController.text.trim(),
                      name: nameController.text.trim(),
                      amount: parsedAmount,
                      category: widget.category,
                    ),
                  );
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text("ADD",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final catData = _categoryDetails[widget.category] ??
        {
          'title': 'Utility Bills',
          'icon': Icons.receipt_rounded,
          'color': const Color(0xFF19B9B9),
        };
    final String catTitle = catData['title'] as String;
    final IconData catIcon = catData['icon'] as IconData;
    final Color catColor = catData['color'] as Color;

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        // Filter bills of this category
        final catBills = state.utilityBills
            .where((b) => b['category'] == widget.category)
            .toList();
        final selectedBills =
            catBills.where((b) => b['isSelected'] as bool).toList();
        final int totalCount = selectedBills.length;
        final double totalAmount = selectedBills.fold(
            0.0, (sum, item) => sum + (item['amount'] as double));

        // Check if all bills are selected
        final bool allSelected = catBills.isNotEmpty &&
            catBills.every((b) => b['isSelected'] as bool);

        return Scaffold(
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: FloatingActionButton(
              backgroundColor: catColor,
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              onPressed: () =>
                  _showAddUtilityDialog(context, catColor, catTitle),
              child:
                  const Icon(Icons.add_rounded, color: Colors.white, size: 28),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
                  _buildHeader(context, catTitle, catColor, catIcon,
                      allSelected, catBills.isNotEmpty),
                  Expanded(
                    child: catBills.isEmpty
                        ? _buildEmptyState(catColor)
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                            physics: const BouncingScrollPhysics(),
                            itemCount: catBills.length,
                            itemBuilder: (context, index) {
                              final bill = catBills[index];
                              final isSelected = bill['isSelected'] as bool;
                              final billAmount = bill['amount'] as double;
                              final billName = bill['name'] as String;
                              final billId = bill['id'] as String;
                              final dueDate = bill['dueDate'] as String;
                              final isExpired =
                                  dueDate.toLowerCase() == 'expired';

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E1435),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: isSelected
                                        ? catColor.withOpacity(0.5)
                                        : const Color(0xFF2D1F49),
                                    width: 1.2,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: catColor.withOpacity(0.08),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          )
                                        ]
                                      : null,
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(18),
                                  onTap: () {
                                    BlocProvider.of<DashboardBloc>(context).add(
                                      ToggleBillSelection(id: billId),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        // Custom Checkbox
                                        Transform.scale(
                                          scale: 0.9,
                                          child: Checkbox(
                                            value: isSelected,
                                            activeColor: catColor,
                                            checkColor: Colors.black,
                                            side: BorderSide(
                                              color: isSelected
                                                  ? catColor
                                                  : const Color(0xFF4C3E6D),
                                              width: 1.5,
                                            ),
                                            onChanged: (val) {
                                              BlocProvider.of<DashboardBloc>(
                                                      context)
                                                  .add(
                                                ToggleBillSelection(id: billId),
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                billName,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "Account ID: $billId",
                                                style: const TextStyle(
                                                  color: Color(0xFF8A9A9A),
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                dueDate,
                                                style: TextStyle(
                                                  color: isExpired
                                                      ? const Color(0xFFFF453A)
                                                      : (dueDate.contains(
                                                                  '5 days') ||
                                                              dueDate.contains(
                                                                  '2 days')
                                                          ? const Color(
                                                              0xFFFF9F0A)
                                                          : const Color(
                                                              0xFF30D158)),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "₹${billAmount.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  _buildBottomNavBar(
                      context, totalCount, totalAmount, selectedBills),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    String title,
    Color catColor,
    IconData icon,
    bool allSelected,
    bool hasBills,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 18),
            onPressed: () => Navigator.pop(context),
            splashRadius: 20,
          ),
          const SizedBox(width: 4),
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color: catColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: catColor, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
          if (hasBills)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Select All",
                  style: TextStyle(
                    color: Color(0xFF8A9A9A),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Transform.scale(
                  scale: 0.8,
                  child: Checkbox(
                    value: allSelected,
                    activeColor: catColor,
                    checkColor: Colors.black,
                    side:
                        const BorderSide(color: Color(0xFF4C3E6D), width: 1.5),
                    onChanged: (val) {
                      BlocProvider.of<DashboardBloc>(context).add(
                        ToggleCategoryBillsSelection(
                          category: widget.category,
                          isSelected: val ?? false,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(Color catColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              color: catColor.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.receipt_rounded,
                color: catColor.withOpacity(0.6), size: 36),
          ),
          const SizedBox(height: 16),
          const Text(
            "No active bills found",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Tap the '+' button below to add your details",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF8A9A9A),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context, int totalCount,
      double totalAmount, List<Map<String, dynamic>> selectedBills) {
    final bool hasSelection = totalCount > 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF1E1435),
        border: Border(
          top: BorderSide(color: Color(0xFF2D1F49), width: 1.5),
        ),
        borderRadius: BorderRadius.only(
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
                  "$totalCount selected",
                  style: const TextStyle(
                    color: Color(0xFF8A9A9A),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "₹${totalAmount.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Color(0xFF19B9B9),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF19B9B9),
              disabledBackgroundColor: const Color(0xFF19B9B9).withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
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
                    color: hasSelection
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: hasSelection
                      ? Colors.white
                      : Colors.white.withOpacity(0.4),
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
