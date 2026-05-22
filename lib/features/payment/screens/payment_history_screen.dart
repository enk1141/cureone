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
  String _filterKey = 'all';
  DateTimeRange? _dateRange;

  List<PaymentRecord> get _filtered {
    var records = PaymentHistoryRegistry.instance.all;
    if (_filterKey != 'all') {
      records = records
          .where((r) => r.bills.any((b) => b['category'] == _filterKey))
          .toList();
    }
    if (_dateRange != null) {
      records = records.where((r) {
        return !r.date.isBefore(_dateRange!.start) &&
            !r.date.isAfter(_dateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }
    return records;
  }

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
      initialDateRange: _dateRange,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            surface: AppColors.surface,
            onSurface: AppColors.primaryDark,
          ),
        ),
        child: child!,
      ),
    );
    if (result != null) setState(() => _dateRange = result);
  }

  @override
  Widget build(BuildContext context) {
    final records = _filtered;
    final totalPaid = records.fold<double>(0.0, (s, r) => s + r.amount);
    final thisMonth = records
        .where((r) =>
            r.date.month == DateTime.now().month &&
            r.date.year == DateTime.now().year)
        .toList();
    final monthTotal =
        thisMonth.fold<double>(0.0, (s, r) => s + r.amount);

    final grouped = _groupByBucket(records);

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
                  child: _StatsRow(
                    monthTotal: monthTotal,
                    monthCount: thisMonth.length,
                    lifetimeTotal: PaymentHistoryRegistry.instance.all
                        .fold<double>(0.0, (s, r) => s + r.amount),
                  ),
                ),
                const SizedBox(height: 18),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 200),
                  child: _FilterBar(
                    filterKey: _filterKey,
                    dateRange: _dateRange,
                    onUtilityChange: (k) =>
                        setState(() => _filterKey = k),
                    onDateTap: _pickRange,
                    onClearDates: () => setState(() => _dateRange = null),
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
          if (records.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyHistory(),
            )
          else
            ..._buildGroupedSlivers(grouped),
          const SliverToBoxAdapter(
            child: SizedBox(height: 110),
          ),
        ],
      ),
    );
  }

  /// Buckets records into Today / Yesterday / This week / Earlier.
  Map<String, List<PaymentRecord>> _groupByBucket(
      List<PaymentRecord> records) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final weekAgo = today.subtract(const Duration(days: 7));

    final map = <String, List<PaymentRecord>>{
      'Today': [],
      'Yesterday': [],
      'This week': [],
      'Earlier': [],
    };
    for (final r in records) {
      final d = DateTime(r.date.year, r.date.month, r.date.day);
      if (d == today) {
        map['Today']!.add(r);
      } else if (d == yesterday) {
        map['Yesterday']!.add(r);
      } else if (d.isAfter(weekAgo)) {
        map['This week']!.add(r);
      } else {
        map['Earlier']!.add(r);
      }
    }
    // Drop empty buckets.
    map.removeWhere((_, v) => v.isEmpty);
    return map;
  }

  List<Widget> _buildGroupedSlivers(
      Map<String, List<PaymentRecord>> grouped) {
    final slivers = <Widget>[];
    var staggerIdx = 0;
    grouped.forEach((bucket, items) {
      slivers.add(SliverToBoxAdapter(
        child: FadeSlideIn(
          delay: Duration(milliseconds: 280 + staggerIdx * 60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Row(
              children: [
                Text(
                  bucket,
                  style: TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(AppRadii.pill),
                  ),
                  child: Text(
                    '${items.length}',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
      staggerIdx++;
      slivers.add(SliverList.builder(
        itemCount: items.length,
        itemBuilder: (context, i) {
          return FadeSlideIn(
            delay:
                Duration(milliseconds: 320 + staggerIdx * 60 + i * 50),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: _HistoryTile(record: items[i]),
            ),
          );
        },
      ));
      staggerIdx++;
    });
    return slivers;
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
      decoration: BoxDecoration(
        gradient: AppGradients.brand,
        borderRadius: const BorderRadius.only(
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

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.monthTotal,
    required this.monthCount,
    required this.lifetimeTotal,
  });

  final double monthTotal;
  final int monthCount;
  final double lifetimeTotal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              tint: AppColors.success,
              icon: Icons.calendar_month_rounded,
              label: 'This month',
              value: '₹${_short(monthTotal)}',
              sub: '$monthCount paid',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              tint: AppColors.primary,
              icon: Icons.account_balance_wallet_rounded,
              label: 'Lifetime',
              value: '₹${_short(lifetimeTotal)}',
              sub: 'All time',
            ),
          ),
        ],
      ),
    );
  }

  String _short(double v) {
    if (v >= 10000000) return '${(v / 10000000).toStringAsFixed(1)}Cr';
    if (v >= 100000) return '${(v / 100000).toStringAsFixed(1)}L';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
    return v.toStringAsFixed(0);
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.tint,
    required this.icon,
    required this.label,
    required this.value,
    required this.sub,
  });

  final Color tint;
  final IconData icon;
  final String label;
  final String value;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return TintedCard(
      tint: tint,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              color: tint.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 17, color: tint),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: tint,
              ),
            ),
          ),
          const SizedBox(height: 1),
          Text(
            sub,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Filter bar
// ─────────────────────────────────────────────────────────────────────────────

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.filterKey,
    required this.dateRange,
    required this.onUtilityChange,
    required this.onDateTap,
    required this.onClearDates,
  });

  final String filterKey;
  final DateTimeRange? dateRange;
  final ValueChanged<String> onUtilityChange;
  final VoidCallback onDateTap;
  final VoidCallback onClearDates;

  @override
  Widget build(BuildContext context) {
    final chips = <_FilterChipItem>[
      _FilterChipItem('All', 'all', null),
      ...UtilityCategory.all.map((c) => _FilterChipItem(c.label, c.key, c)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: chips.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final c = chips[i];
              final selected = c.key == filterKey;
              final color = c.category?.color ?? AppColors.primary;
              return InkWell(
                borderRadius: BorderRadius.circular(AppRadii.pill),
                onTap: () => onUtilityChange(c.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: selected ? color : AppColors.surfaceAlt,
                    borderRadius: BorderRadius.circular(AppRadii.pill),
                    border: Border.all(
                      color: selected ? color : AppColors.border,
                    ),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: color.withOpacity(0.30),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (c.category != null) ...[
                        Icon(
                          c.category!.icon,
                          size: 13,
                          color: selected ? Colors.white : color,
                        ),
                        const SizedBox(width: 5),
                      ],
                      Text(
                        c.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: selected ? Colors.white : color,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadii.md),
            onTap: onDateTap,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(AppRadii.md),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    height: 26,
                    width: 26,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.10),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.date_range_rounded,
                        color: AppColors.primary, size: 14),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      dateRange == null
                          ? 'All dates'
                          : '${_short(dateRange!.start)} – ${_short(dateRange!.end)}',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                  if (dateRange != null)
                    InkWell(
                      onTap: onClearDates,
                      child: Icon(Icons.close_rounded,
                          size: 16, color: AppColors.textMuted),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _short(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }
}

class _FilterChipItem {
  final String label;
  final String key;
  final UtilityCategory? category;
  _FilterChipItem(this.label, this.key, this.category);
}

// ─────────────────────────────────────────────────────────────────────────────
// History tile (colored shadow card)
// ─────────────────────────────────────────────────────────────────────────────

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.record});
  final PaymentRecord record;

  @override
  Widget build(BuildContext context) {
    final primaryCat =
        UtilityCategory.fromKey(record.bills.first['category'] as String);
    final isMulti = record.bills.length > 1;
    final ok = record.status == 'Success';

    return PressableScale(
      onTap: () => _showReceiptSheet(context),
      child: TintedCard(
        tint: primaryCat.color,
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: primaryCat.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child:
                  Icon(primaryCat.icon, color: primaryCat.color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          isMulti
                              ? '${record.bills.length} bills paid'
                              : record.bills.first['name'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      StatusChip(
                        label: ok ? 'PAID' : 'FAILED',
                        color: ok ? AppColors.success : AppColors.danger,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded,
                          size: 11,
                          color: AppColors.textMuted.withOpacity(0.9)),
                      const SizedBox(width: 3),
                      Text(
                        _time(record.date),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: BoxDecoration(
                          color: AppColors.textMuted,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(_methodIcon(record.method),
                          size: 11, color: AppColors.textMuted),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          record.method,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '#${record.transactionId.substring(record.transactionId.length - 8)}',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textMuted.withOpacity(0.8),
                          letterSpacing: 0.3,
                        ),
                      ),
                      Text(
                        '₹${record.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: primaryCat.color,
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
    );
  }

  IconData _methodIcon(String method) {
    final m = method.toLowerCase();
    if (m.contains('upi')) return Icons.account_balance_wallet_rounded;
    if (m.contains('net')) return Icons.account_balance_rounded;
    if (m.contains('card')) return Icons.credit_card_rounded;
    if (m.contains('wallet')) return Icons.wallet_rounded;
    return Icons.payments_rounded;
  }

  String _time(DateTime d) {
    final h = d.hour > 12 ? d.hour - 12 : (d.hour == 0 ? 12 : d.hour);
    final m = d.minute.toString().padLeft(2, '0');
    final ap = d.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ap';
  }

  void _showReceiptSheet(BuildContext context) {
    final cat =
        UtilityCategory.fromKey(record.bills.first['category'] as String);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
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
                Expanded(
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
                  Divider(height: 18, color: AppColors.border),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Amount',
                          style: TextStyle(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          )),
                      Text(
                        '₹${record.amount.toStringAsFixed(2)}',
                        style: TextStyle(
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
            Text('Bills',
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
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                    Text(
                      '₹${(b['amount'] as num).toStringAsFixed(2)}',
                      style: TextStyle(
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
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryDark,
          ),
        ),
      ],
    );
  }

  String _fullDate(DateTime d) {
    final m = [
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
              child: Icon(Icons.history_rounded,
                  size: 42, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              'No payments yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
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
