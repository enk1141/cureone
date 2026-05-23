import 'package:flutter/material.dart';
import 'package:my_cure_ui/config/app_theme.dart';
import 'package:my_cure_ui/features/payment/bloc/payment_history_bloc.dart';
import 'package:my_cure_ui/shared/widgets/app_animations.dart';
import 'package:my_cure_ui/shared/widgets/app_card.dart';

/// History tab — gradient hero + overlay stats + grouped beautiful tiles.
class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  String _filterKey = 'All';

  List<PaymentRecord> get _filtered {
    var records = PaymentHistoryRegistry.instance.all;
    if (_filterKey != 'All') {
      records = records
          .where((r) => r.status.toLowerCase() == _filterKey.toLowerCase())
          .toList();
    }
    return records;
  }

  @override
  Widget build(BuildContext context) {
    final records = _filtered;
    final totalPaid = records.fold<double>(0.0, (s, r) => s + r.amount);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: FadeSlideIn(
              offset: const Offset(0, -18),
              child: _HeroHeader(
                txnCount: records.length,
                total: totalPaid,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 18),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 120),
                  child: _StatusFilterChips(
                    selectedFilter: _filterKey,
                    onSelect: (val) => setState(() => _filterKey = val),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          if (records.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyHistory(),
            )
          else
            SliverList.builder(
              itemCount: records.length,
              itemBuilder: (context, index) {
                return FadeSlideIn(
                  delay: Duration(milliseconds: 160 + index * 50),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    child: _PaymentHistoryTile(record: records[index]),
                  ),
                );
              },
            ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 110),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero header
// ─────────────────────────────────────────────────────────────────────────────

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.txnCount, required this.total});
  final int txnCount;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppGradients.brand,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: Colors.white.withOpacity(0.35)),
                    ),
                    child: const Icon(Icons.history_rounded,
                        color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Payment History',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Text(
                'Total paid · $txnCount transaction${txnCount == 1 ? '' : 's'}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.78),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedCounter(
                value: total,
                prefix: '₹',
                format: _format,
                duration: const Duration(milliseconds: 1100),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _format(double v) {
    final s = v.toStringAsFixed(2);
    final parts = s.split('.');
    final whole = parts[0];
    final buf = StringBuffer();
    if (whole.length <= 3) {
      buf.write(whole);
    } else {
      final last3 = whole.substring(whole.length - 3);
      var rest = whole.substring(0, whole.length - 3);
      final chunks = <String>[];
      while (rest.length > 2) {
        chunks.insert(0, rest.substring(rest.length - 2));
        rest = rest.substring(0, rest.length - 2);
      }
      if (rest.isNotEmpty) chunks.insert(0, rest);
      buf.write(chunks.join(','));
      buf.write(',');
      buf.write(last3);
    }
    buf.write('.');
    buf.write(parts[1]);
    return buf.toString();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stats overlay row
// ─────────────────────────────────────────────────────────────────────────────

// ─────────────────────────────────────────────────────────────────────────────
// Status filter chips
// ─────────────────────────────────────────────────────────────────────────────

class _StatusFilterChips extends StatelessWidget {
  const _StatusFilterChips({
    required this.selectedFilter,
    required this.onSelect,
  });

  final String selectedFilter;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final filters = const ['All', 'Success', 'Failed', 'Refund'];

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = filter.toLowerCase() == selectedFilter.toLowerCase();
          
          return InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: () => onSelect(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : const Color(0xFFEFF3FA),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
                  width: 1,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                filter,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? Colors.white : AppColors.textMuted,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Payment History Tile
// ─────────────────────────────────────────────────────────────────────────────

class _PaymentHistoryTile extends StatelessWidget {
  const _PaymentHistoryTile({required this.record});
  final PaymentRecord record;

  @override
  Widget build(BuildContext context) {
    final statusColor = record.status.toLowerCase() == 'success'
        ? const Color(0xFF2E7D32)
        : record.status.toLowerCase() == 'failed'
            ? AppColors.danger
            : const Color(0xFFE65100); // orange/amber for refund

    return PressableScale(
      onTap: () => _showReceiptSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.border,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.015),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left column: Date & Service
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatDate(record.date),
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getServiceName(record),
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            // Right column: Amount & Status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatAmount(record.amount),
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  record.status,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final day = date.day.toString().padLeft(2, '0');
    final month = months[date.month - 1];
    final year = date.year;
    return '$day $month $year';
  }

  String _getServiceName(PaymentRecord record) {
    if (record.bills.length > 1) {
      return 'Multiple Services';
    }
    if (record.bills.isEmpty) {
      return 'Unknown Service';
    }
    final catKey = record.bills.first['category'] as String?;
    if (catKey == 'electricity') return 'Electricity';
    if (catKey == 'hmwssb' || catKey == 'water') return 'Water Bill';
    if (catKey == 'property_tax') return 'Property Tax';
    if (catKey == 'trade') return 'Trade License';
    if (catKey == 'echallan') return 'Traffic Challan';
    return record.bills.first['name'] as String? ?? 'Utility Bill';
  }

  String _formatAmount(double v) {
    final s = v.toStringAsFixed(2);
    final parts = s.split('.');
    final whole = parts[0];
    final buf = StringBuffer();
    if (whole.length <= 3) {
      buf.write(whole);
    } else {
      final last3 = whole.substring(whole.length - 3);
      var rest = whole.substring(0, whole.length - 3);
      final chunks = <String>[];
      while (rest.length > 2) {
        chunks.insert(0, rest.substring(rest.length - 2));
        rest = rest.substring(0, rest.length - 2);
      }
      if (rest.isNotEmpty) chunks.insert(0, rest);
      buf.write(chunks.join(','));
      buf.write(',');
      buf.write(last3);
    }
    buf.write('.');
    buf.write(parts[1]);
    return '₹ ${buf.toString()}';
  }

  void _showReceiptSheet(BuildContext context) {
    final cat =
        UtilityCategory.fromKey(record.bills.first['category'] as String);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadii.xl),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 4,
                width: 42,
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    color: cat.color.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(cat.icon, color: cat.color, size: 22),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text('Receipt', style: AppText.h2),
                ),
                StatusChip(
                  label: record.status == 'Success' ? 'PAID' : 'FAILED',
                  color: record.status == 'Success'
                      ? AppColors.success
                      : AppColors.danger,
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(AppRadii.lg),
              ),
              child: Column(
                children: [
                  _row('Transaction ID', record.transactionId),
                  const SizedBox(height: 8),
                  _row('Date', _fullDate(record.date)),
                  const SizedBox(height: 8),
                  _row('Method', record.method),
                  const Divider(height: 18, color: AppColors.border),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Amount',
                          style: TextStyle(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          )),
                      Text(
                        '₹${record.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('Bills',
                style: TextStyle(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                )),
            const SizedBox(height: 8),
            ...record.bills.map((b) {
              final c = UtilityCategory.fromKey(b['category'] as String);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Container(
                      height: 28,
                      width: 28,
                      decoration: BoxDecoration(
                        color: c.color.withOpacity(0.14),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(c.icon, color: c.color, size: 14),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        b['name'] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                    Text(
                      '₹${(b['amount'] as num).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _row(String k, String v) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(k, style: AppText.bodyMuted),
        Text(
          v,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryDark,
          ),
        ),
      ],
    );
  }

  String _fullDate(DateTime d) {
    const m = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final h = d.hour > 12 ? d.hour - 12 : (d.hour == 0 ? 12 : d.hour);
    final mm = d.minute.toString().padLeft(2, '0');
    final ap = d.hour >= 12 ? 'PM' : 'AM';
    return '${d.day} ${m[d.month - 1]} ${d.year}, $h:$mm $ap';
  }
}


class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

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
                color: AppColors.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.history_rounded,
                  size: 42, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            const Text(
              'No payments yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Past transactions will show up here.',
              textAlign: TextAlign.center,
              style: AppText.bodyMuted,
            ),
          ],
        ),
      ),
    );
  }
}
