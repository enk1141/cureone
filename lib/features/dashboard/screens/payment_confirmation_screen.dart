import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_cure_ui/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:my_cure_ui/config/routes.dart';

class PaymentConfirmationScreen extends StatelessWidget {
  final List<Map<String, dynamic>> selectedBills;

  const PaymentConfirmationScreen({
    super.key,
    required this.selectedBills,
  });

  // Lookup themes helper
  Map<String, dynamic> _getCategoryDetails(String category) {
    switch (category) {
      case 'electricity':
        return {
          'title': 'Electricity',
          'icon': Icons.bolt_rounded,
          'color': const Color(0xFFFF9F0A),
        };
      case 'hmwssb':
        return {
          'title': 'Water (HMWSSB)',
          'icon': Icons.water_drop_rounded,
          'color': const Color(0xFF0A84FF),
        };
      case 'property_tax':
        return {
          'title': 'Property Tax',
          'icon': Icons.home_work_rounded,
          'color': const Color(0xFF30D158),
        };
      case 'trade':
        return {
          'title': 'Trade License',
          'icon': Icons.storefront_rounded,
          'color': const Color(0xFFBF5AF2),
        };
      case 'echallan':
        return {
          'title': 'eChallan',
          'icon': Icons.receipt_long_rounded,
          'color': const Color(0xFFFF453A),
        };
      default:
        return {
          'title': 'Utility',
          'icon': Icons.receipt_rounded,
          'color': const Color(0xFF19B9B9),
        };
    }
  }

  void _showSuccessDialog(BuildContext context, double totalAmount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: const Color(0xFF1E1435),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: const BorderSide(color: Color(0xFF2D1F49), width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success Checkmark with glowing border
                Container(
                  height: 72,
                  width: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFF30D158).withOpacity(0.12),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF30D158), width: 2),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Color(0xFF30D158),
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Payment Successful!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Successfully paid ${selectedBills.length} utility bills",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF8A9A9A),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F0720),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF2D1F49)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Paid",
                        style: TextStyle(
                          color: Color(0xFF8A9A9A),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "₹${totalAmount.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Color(0xFF19B9B9),
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF19B9B9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      // Clear selection in Bloc
                      BlocProvider.of<DashboardBloc>(context).add(ClearSelection());

                      // Navigate back to Dashboard
                      Navigator.pop(dialogContext); // pop dialog
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.dashboard,
                        (route) => false,
                      );
                    },
                    child: const Text(
                      "DONE",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double subtotal = selectedBills.fold(0.0, (sum, item) => sum + (item['amount'] as double));
    const double convenienceFee = 0.00;
    final double grandTotal = subtotal + convenienceFee;

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
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Receipt Items Card
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1435),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFF2D1F49), width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
                            child: Text(
                              "PAYMENT SUMMARY",
                              style: TextStyle(
                                color: Color(0xFF8A9A9A),
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const Divider(color: Color(0xFF2D1F49), height: 1, thickness: 1),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: selectedBills.length,
                            itemBuilder: (context, index) {
                              final bill = selectedBills[index];
                              final String category = bill['category'] as String;
                              final catDetails = _getCategoryDetails(category);
                              final Color catColor = catDetails['color'] as Color;
                              final IconData catIcon = catDetails['icon'] as IconData;

                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                decoration: BoxDecoration(
                                  border: index < selectedBills.length - 1
                                      ? const Border(bottom: BorderSide(color: Color(0xFF2D1F49), width: 0.8))
                                      : null,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 34,
                                      width: 34,
                                      decoration: BoxDecoration(
                                        color: catColor.withOpacity(0.12),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(catIcon, color: catColor, size: 18),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            bill['name'] as String,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            "ID: ${bill['id']}",
                                            style: const TextStyle(
                                              color: Color(0xFF8A9A9A),
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      "₹${(bill['amount'] as double).toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Bill Breakdowns Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1435),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFF2D1F49), width: 1),
                      ),
                      child: Column(
                        children: [
                          _buildSummaryRow("Subtotal", "₹${subtotal.toStringAsFixed(2)}"),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Convenience Fee",
                                style: TextStyle(
                                  color: Color(0xFF8A9A9A),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF30D158).withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      "FREE",
                                      style: TextStyle(
                                        color: Color(0xFF30D158),
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    "₹0.00",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(color: Color(0xFF2D1F49), height: 1, thickness: 1),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Grand Total",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                "₹${grandTotal.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: Color(0xFF19B9B9),
                                  fontSize: 19,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _buildBottomButton(context, grandTotal),
            ],
          ),
        ),
      ),
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
            "Review Payment",
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

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF8A9A9A),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton(BuildContext context, double grandTotal) {
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
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF19B9B9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            elevation: 8,
            shadowColor: const Color(0xFF19B9B9).withOpacity(0.3),
          ),
          onPressed: () => _showSuccessDialog(context, grandTotal),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline_rounded, color: Colors.white, size: 16),
              SizedBox(width: 8),
              Text(
                "Confirm & Pay",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
