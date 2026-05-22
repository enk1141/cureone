import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_cure_ui/config/app_theme.dart';
import 'package:my_cure_ui/config/routes.dart';
import 'package:my_cure_ui/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:my_cure_ui/shared/widgets/app_animations.dart';
import 'package:my_cure_ui/shared/widgets/app_card.dart';

/// Bills list for a single utility category. Light theme matching the rest
/// of Cure One — gradient hero, tinted tiles with category-colored shadows,
/// staggered entry animations, pay-bar at bottom.
class UtilityDetailsScreen extends StatelessWidget {
  final String category;

  const UtilityDetailsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final cat = UtilityCategory.fromKey(category);

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        final catBills = state.utilityBills
            .where((b) => b['category'] == category)
            .toList();
        final selected =
            catBills.where((b) => b['isSelected'] as bool).toList();
        final totalAmount = selected.fold<double>(
            0.0, (s, b) => s + (b['amount'] as num).toDouble());
        final totalDueAll = catBills
            .where((b) => !((b['isPaid'] as bool?) ?? false))
            .fold<double>(
                0.0, (s, b) => s + (b['amount'] as num).toDouble());
        final allSelected = catBills.isNotEmpty &&
            catBills.every((b) => b['isSelected'] as bool);

        return Scaffold(
          backgroundColor: AppColors.surface,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: FadeSlideIn(
                  offset: const Offset(0, -18),
                  child: _Hero(
                    category: cat,
                    billCount: catBills.length,
                    totalDue: totalDueAll,
                    onBack: () => Navigator.pop(context),
                  ),
                ),
              ),
              if (catBills.isNotEmpty)
                SliverToBoxAdapter(
                  child: FadeSlideIn(
                    delay: const Duration(milliseconds: 120),
                    child: _SelectAllBar(
                      allSelected: allSelected,
                      selectedCount: selected.length,
                      totalCount: catBills.length,
                      tint: cat.color,
                      onToggle: () {
                        context.read<DashboardBloc>().add(
                              ToggleCategoryBillsSelection(
                                category: category,
                                isSelected: !allSelected,
                              ),
                            );
                      },
                    ),
                  ),
                ),
              if (catBills.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyState(category: cat),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  sliver: SliverList.builder(
                    itemCount: catBills.length,
                    itemBuilder: (context, i) {
                      return FadeSlideIn(
                        delay:
                            Duration(milliseconds: 200 + i * 60),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _BillTile(
                            bill: catBills[i],
                            category: cat,
                            onToggle: () {
                              context.read<DashboardBloc>().add(
                                    ToggleBillSelection(
                                        id: catBills[i]['id'] as String),
                                  );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
          bottomNavigationBar: selected.isEmpty
              ? null
              : _PayBar(
                  count: selected.length,
                  total: totalAmount,
                  tint: cat.color,
                  onPay: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.paymentGateway,
                      arguments: {
                        'selectedBills': selected,
                        'bloc': context.read<DashboardBloc>(),
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero header
// ─────────────────────────────────────────────────────────────────────────────

class _Hero extends StatelessWidget {
  const _Hero({
    required this.category,
    required this.billCount,
    required this.totalDue,
    required this.onBack,
  });

  final UtilityCategory category;
  final int billCount;
  final double totalDue;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppGradients.brand,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _CircleButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: onBack,
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: category.color.withOpacity(0.40),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child:
                        Icon(category.icon, color: category.color, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$billCount ${billCount == 1 ? 'bill' : 'bills'} registered',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.78),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                'Total due',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.78),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedCounter(
                value: totalDue,
                prefix: '₹',
                format: _format,
                duration: const Duration(milliseconds: 1000),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
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

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadii.pill),
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.16),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.32)),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Select-all bar
// ─────────────────────────────────────────────────────────────────────────────

class _SelectAllBar extends StatelessWidget {
  const _SelectAllBar({
    required this.allSelected,
    required this.selectedCount,
    required this.totalCount,
    required this.tint,
    required this.onToggle,
  });

  final bool allSelected;
  final int selectedCount;
  final int totalCount;
  final Color tint;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$selectedCount of $totalCount selected',
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textMuted,
              ),
            ),
          ),
          PressableScale(
            onTap: onToggle,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadii.pill),
                border: Border.all(color: tint.withOpacity(0.22)),
                boxShadow: [
                  BoxShadow(
                    color: tint.withOpacity(0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    allSelected
                        ? Icons.remove_done_rounded
                        : Icons.done_all_rounded,
                    size: 14,
                    color: tint,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    allSelected ? 'Clear all' : 'Select all',
                    style: TextStyle(
                      color: tint,
                      fontWeight: FontWeight.w800,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bill tile
// ─────────────────────────────────────────────────────────────────────────────

class _BillTile extends StatelessWidget {
  const _BillTile({
    required this.bill,
    required this.category,
    required this.onToggle,
  });

  final Map<String, dynamic> bill;
  final UtilityCategory category;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final selected = bill['isSelected'] as bool;
    final amount = (bill['amount'] as num).toDouble();
    final due = bill['dueDate'] as String? ?? '';
    final isExpired = due.toLowerCase().contains('expired');
    final isUrgent =
        due.contains('2 days') || due.contains('5 days');
    final isPaid = (bill['isPaid'] as bool?) ?? false;

    return PressableScale(
      onTap: isPaid ? () {} : onToggle,
      child: TintedCard(
        tint: category.color,
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            _Check(selected: selected, color: category.color, paid: isPaid),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          bill['name'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                      if (isPaid)
                        const StatusChip(
                            label: 'PAID', color: AppColors.success),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'ID: ${bill['id']}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        isExpired
                            ? Icons.error_outline_rounded
                            : Icons.schedule_rounded,
                        size: 12,
                        color: isExpired
                            ? AppColors.danger
                            : isUrgent
                                ? AppColors.warning
                                : AppColors.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        due,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isExpired
                              ? AppColors.danger
                              : isUrgent
                                  ? AppColors.warning
                                  : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '₹${amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: selected ? category.color : AppColors.primaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Check extends StatelessWidget {
  const _Check({
    required this.selected,
    required this.color,
    required this.paid,
  });
  final bool selected;
  final Color color;
  final bool paid;

  @override
  Widget build(BuildContext context) {
    if (paid) {
      return Container(
        height: 22,
        width: 22,
        decoration: BoxDecoration(
          color: AppColors.success,
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Icon(Icons.check_rounded, size: 14, color: Colors.white),
      );
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      height: 22,
      width: 22,
      decoration: BoxDecoration(
        color: selected ? color : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: selected ? color : AppColors.border,
          width: 1.5,
        ),
      ),
      child: selected
          ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
          : null,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom pay bar
// ─────────────────────────────────────────────────────────────────────────────

class _PayBar extends StatelessWidget {
  const _PayBar({
    required this.count,
    required this.total,
    required this.tint,
    required this.onPay,
  });

  final int count;
  final double total;
  final Color tint;
  final VoidCallback onPay;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 12, 20, 12 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: tint.withOpacity(0.10),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$count selected',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '₹${total.toStringAsFixed(2)}',
                style: TextStyle(
                  color: tint,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: onPay,
              style: ElevatedButton.styleFrom(
                backgroundColor: tint,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 22),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
              ),
              icon:
                  const Icon(Icons.lock_outline_rounded, size: 16),
              label: const Text(
                'Pay Now',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.category});
  final UtilityCategory category;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 92,
              width: 92,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: category.color.withOpacity(0.30),
                    blurRadius: 22,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(category.icon, color: category.color, size: 46),
            ),
            const SizedBox(height: 18),
            Text(
              'No ${category.label.toLowerCase()} yet',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tap "+ Add Utility" to register your first bill.',
              textAlign: TextAlign.center,
              style: AppText.bodyMuted,
            ),
          ],
        ),
      ),
    );
  }
}
