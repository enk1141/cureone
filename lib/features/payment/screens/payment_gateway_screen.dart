import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_cure_ui/config/app_theme.dart';
import 'package:my_cure_ui/config/routes.dart';
import 'package:my_cure_ui/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:my_cure_ui/features/payment/bloc/payment_history_bloc.dart';
import 'package:my_cure_ui/shared/widgets/app_card.dart';

/// Unified Payment Platform screen. Shows the transaction summary and lets the
/// user pick a payment method, then routes to the Success / Receipt screen.
class PaymentGatewayScreen extends StatefulWidget {
  const PaymentGatewayScreen({super.key, required this.selectedBills});

  final List<Map<String, dynamic>> selectedBills;

  @override
  State<PaymentGatewayScreen> createState() => _PaymentGatewayScreenState();
}

class _PaymentGatewayScreenState extends State<PaymentGatewayScreen> {
  int _methodIndex = 0;
  bool _processing = false;

  static final _methods = [
    _PayMethod('UPI', Icons.account_balance_wallet_rounded, AppColors.success),
    _PayMethod('Net Banking', Icons.account_balance_rounded, AppColors.info),
    _PayMethod('Debit/Credit Card', Icons.credit_card_rounded,
        AppColors.catTrade),
    _PayMethod('Wallets', Icons.wallet_rounded, AppColors.warning),
  ];

  double get _subtotal =>
      widget.selectedBills.fold(0.0, (s, b) => s + (b['amount'] as num));

  double get _grandTotal => _subtotal; // convenience fee is 0 for now

  Future<void> _pay() async {
    setState(() => _processing = true);
    // Simulate gateway round-trip
    await Future.delayed(const Duration(milliseconds: 1100));

    final txnId = 'TXN${DateTime.now().millisecondsSinceEpoch}';
    final method = _methods[_methodIndex].label;

    // Mark bills paid in dashboard state + record into history
    final bloc = context.read<DashboardBloc>();
    for (final b in widget.selectedBills) {
      bloc.add(MarkBillPaid(id: b['id'] as String));
    }
    PaymentHistoryRegistry.instance.record(
      bills: widget.selectedBills,
      transactionId: txnId,
      method: method,
    );

    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.paymentSuccess,
      arguments: {
        'paidBills': widget.selectedBills,
        'paymentMethod': method,
        'transactionId': txnId,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: const AppHeaderBar(title: 'Payment Gateway'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                children: [
                  _TxnDetailsCard(
                    transactionId:
                        'TXN${DateTime.now().millisecondsSinceEpoch.toString().substring(4, 12)}',
                    amount: _grandTotal,
                    billCount: widget.selectedBills.length,
                  ),
                  const SizedBox(height: 16),
                  Text('Select Payment Method', style: AppText.h3),
                  const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _methods.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.45,
                    ),
                    itemBuilder: (context, i) {
                      final m = _methods[i];
                      final selected = _methodIndex == i;
                      return AppCard(
                        borderColor:
                            selected ? m.color : AppColors.border,
                        padding: const EdgeInsets.all(14),
                        onTap: () => setState(() => _methodIndex = i),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 38,
                              width: 38,
                              decoration: BoxDecoration(
                                color: m.color.withOpacity(0.14),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(m.icon, color: m.color, size: 20),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    m.label,
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w800,
                                      color: selected
                                          ? m.color
                                          : AppColors.primaryDark,
                                    ),
                                  ),
                                ),
                                if (selected)
                                  Icon(Icons.check_circle_rounded,
                                      color: m.color, size: 18),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  AppCard(
                    child: Row(
                      children: [
                        Icon(Icons.lock_outline_rounded,
                            color: AppColors.success, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Your transaction is encrypted end-to-end.',
                            style: AppText.bodyMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _PayBar(
              total: _grandTotal,
              processing: _processing,
              onPay: _pay,
            ),
          ],
        ),
      ),
    );
  }
}

class _PayMethod {
  final String label;
  final IconData icon;
  final Color color;
  _PayMethod(this.label, this.icon, this.color);
}

class _TxnDetailsCard extends StatelessWidget {
  const _TxnDetailsCard({
    required this.transactionId,
    required this.amount,
    required this.billCount,
  });

  final String transactionId;
  final double amount;
  final int billCount;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Transaction Details', style: AppText.h3),
          const SizedBox(height: 12),
          _kv('Transaction ID', transactionId),
          const SizedBox(height: 8),
          _kv('Bills', '$billCount selected'),
          const SizedBox(height: 8),
          _kv('Phone Number', '+91 98765 43210'),
          Divider(height: 24, color: AppColors.border),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Amount',
                  style: TextStyle(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  )),
              Text(
                '₹${amount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(k, style: AppText.bodyMuted),
        Text(
          v,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryDark,
          ),
        ),
      ],
    );
  }
}

class _PayBar extends StatelessWidget {
  const _PayBar({
    required this.total,
    required this.processing,
    required this.onPay,
  });

  final double total;
  final bool processing;
  final VoidCallback onPay;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 12, 20, 12 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Payable', style: AppText.caption),
              Text(
                '₹${total.toStringAsFixed(2)}',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: processing ? null : onPay,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: processing
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock_outline_rounded,
                              color: Colors.white, size: 16),
                          SizedBox(width: 6),
                          Text('Pay Now'),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
