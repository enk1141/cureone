import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_cure_ui/config/app_theme.dart';
import 'package:my_cure_ui/config/routes.dart';
import 'package:my_cure_ui/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:my_cure_ui/shared/widgets/app_card.dart';

/// Pay-All-At-Once: pick bills across categories, see live total, pay in one go.
/// Replaces the older dark-themed version with the Cure One light palette.
class PayAllAtOnceScreen extends StatelessWidget {
  const PayAllAtOnceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: const AppHeaderBar(title: 'Pay All Bills'),
      body: SafeArea(
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            // Only show unpaid bills here.
            final unpaid = state.utilityBills
                .where((b) => !((b['isPaid'] as bool?) ?? false))
                .toList();

            final grouped = <String, List<Map<String, dynamic>>>{};
            for (final b in unpaid) {
              grouped.putIfAbsent(b['category'] as String, () => []).add(b);
            }

            final selected =
                unpaid.where((b) => b['isSelected'] as bool).toList();
            final totalAmount = selected.fold<double>(
                0.0, (s, b) => s + (b['amount'] as num).toDouble());

            return Column(
              children: [
                _SummaryStrip(
                  selectedCount: selected.length,
                  totalCount: unpaid.length,
                  totalAmount: totalAmount,
                  onSelectAll: () {
                    final shouldSelectAll =
                        selected.length != unpaid.length;
                    // Toggle every category to the same state.
                    for (final cat in grouped.keys) {
                      context.read<DashboardBloc>().add(
                            ToggleCategoryBillsSelection(
                              category: cat,
                              isSelected: shouldSelectAll,
                            ),
                          );
                    }
                  },
                  allSelected:
                      unpaid.isNotEmpty && selected.length == unpaid.length,
                ),
                Expanded(
                  child: unpaid.isEmpty
                      ? const _AllPaidState()
                      : ListView(
                          physics: const BouncingScrollPhysics(),
                          padding:
                              const EdgeInsets.fromLTRB(16, 12, 16, 24),
                          children: grouped.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _CategoryGroup(
                                category:
                                    UtilityCategory.fromKey(entry.key),
                                bills: entry.value,
                              ),
                            );
                          }).toList(),
                        ),
                ),
                if (unpaid.isNotEmpty)
                  _PayBar(
                    selectedCount: selected.length,
                    totalAmount: totalAmount,
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
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SummaryStrip extends StatelessWidget {
  const _SummaryStrip({
    required this.selectedCount,
    required this.totalCount,
    required this.totalAmount,
    required this.onSelectAll,
    required this.allSelected,
  });

  final int selectedCount;
  final int totalCount;
  final double totalAmount;
  final VoidCallback onSelectAll;
  final bool allSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.10),
            AppColors.primary.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.primary.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$selectedCount of $totalCount selected',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '₹${totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
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
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadii.pill),
                side: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${bills.length} bill${bills.length == 1 ? '' : 's'}'
                          '${categoryTotal > 0 ? ' · ₹${categoryTotal.toStringAsFixed(0)} selected' : ''}',
                          style: const TextStyle(
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
                : const Border(
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
                      style: const TextStyle(
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
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 3,
                          height: 3,
                          decoration: const BoxDecoration(
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
        color: checked ? color : Colors.white,
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
        color: filled ? color : Colors.white,
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
      decoration: const BoxDecoration(
        color: Colors.white,
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
              child: const Icon(Icons.check_rounded,
                  size: 42, color: AppColors.success),
            ),
            const SizedBox(height: 16),
            const Text(
              'All caught up!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
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
