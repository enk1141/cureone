import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_cure_ui/config/app_theme.dart';
import 'package:my_cure_ui/config/routes.dart';
import 'package:my_cure_ui/shared/widgets/app_card.dart';

/// Confirmation screen after a successful payment. Shows a receipt summary
/// and a department-wise split. Actions: Download / Print / Share / Done.
class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({
    super.key,
    required this.paidBills,
    required this.paymentMethod,
    required this.transactionId,
  });

  final List<Map<String, dynamic>> paidBills;
  final String paymentMethod;
  final String transactionId;

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _total => widget.paidBills
      .fold(0.0, (s, b) => s + (b['amount'] as num).toDouble());

  Map<String, double> get _deptSplit {
    final map = <String, double>{};
    for (final b in widget.paidBills) {
      final cat = b['category'] as String;
      map[cat] = (map[cat] ?? 0) + (b['amount'] as num).toDouble();
    }
    return map;
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.primary),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = _formatDate(DateTime.now());

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar — no back button. Use the Done button.
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Row(
                children: [
                  Text('Receipt', style: AppText.h2),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.share_outlined,
                        color: AppColors.primaryDark),
                    onPressed: () => _toast('Share — coming soon'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  Center(
                    child: ScaleTransition(
                      scale: _scale,
                      child: Container(
                        height: 96,
                        width: 96,
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.12),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.success, width: 2.5),
                        ),
                        child: Icon(Icons.check_rounded,
                            color: AppColors.success, size: 54),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Center(
                    child: Text(
                      'Payment Successful!',
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Text(
                      '${widget.paidBills.length} ${widget.paidBills.length == 1 ? 'bill' : 'bills'} paid · ₹${_total.toStringAsFixed(2)}',
                      style: AppText.bodyMuted,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Summary card
                  AppCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _kv('Transaction ID', widget.transactionId, copyable: true),
                        const SizedBox(height: 10),
                        _kv('Amount Paid', '₹${_total.toStringAsFixed(2)}',
                            valueColor: AppColors.primary,
                            valueWeight: FontWeight.w900),
                        const SizedBox(height: 10),
                        _kv('Payment Date', dateStr),
                        const SizedBox(height: 10),
                        _kv('Payment Method', widget.paymentMethod),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Department-wise split
                  AppCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Department-wise Split',
                            style: AppText.h3),
                        const SizedBox(height: 10),
                        ..._deptSplit.entries.map((e) {
                          final cat = UtilityCategory.fromKey(e.key);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                Container(
                                  height: 28,
                                  width: 28,
                                  decoration: BoxDecoration(
                                    color: cat.color.withOpacity(0.14),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(cat.icon,
                                      color: cat.color, size: 14),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    cat.label,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                ),
                                Text(
                                  '₹${e.value.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: cat.color,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        Divider(height: 22, color: AppColors.border),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total',
                                style: TextStyle(
                                  color: AppColors.primaryDark,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                )),
                            Text(
                              '₹${_total.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _toast('Receipt saved as PDF'),
                          icon: const Icon(Icons.download_rounded, size: 18),
                          label: const Text('Download'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _toast('Sent to printer'),
                          icon: const Icon(Icons.print_rounded, size: 18),
                          label: const Text('Print'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _DoneBar(
              onDone: () {
                Navigator.popUntil(
                  context,
                  ModalRoute.withName(AppRoutes.home),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _kv(
    String k,
    String v, {
    bool copyable = false,
    Color? valueColor,
    FontWeight valueWeight = FontWeight.w700,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(k, style: AppText.bodyMuted),
        Row(
          children: [
            Text(
              v,
              style: TextStyle(
                fontSize: 13,
                fontWeight: valueWeight,
                color: valueColor ?? AppColors.primaryDark,
              ),
            ),
            if (copyable) ...[
              const SizedBox(width: 6),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: v));
                  _toast('Copied');
                },
                child: Icon(Icons.copy_rounded,
                    size: 14, color: AppColors.textMuted),
              ),
            ],
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime d) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final h = d.hour > 12 ? d.hour - 12 : (d.hour == 0 ? 12 : d.hour);
    final m = d.minute.toString().padLeft(2, '0');
    final ap = d.hour >= 12 ? 'PM' : 'AM';
    return '${d.day} ${months[d.month - 1]} ${d.year}, $h:$m $ap';
  }
}

class _DoneBar extends StatelessWidget {
  const _DoneBar({required this.onDone});
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
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
          onPressed: onDone,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: const Text('Back to Dashboard'),
        ),
      ),
    );
  }
}
