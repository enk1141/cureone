import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_cure_ui/config/app_theme.dart';
import 'package:my_cure_ui/config/routes.dart';
import 'package:my_cure_ui/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:my_cure_ui/shared/widgets/app_animations.dart';
import 'package:my_cure_ui/shared/widgets/app_card.dart';

/// Bills tab — lists every utility the user has registered, grouped by type.
/// Tap a card → utility details. "+" → register flow (also reachable via FAB).
class MyUtilitiesScreen extends StatelessWidget {
  const MyUtilitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          final grouped = _groupByCategory(state.utilityBills);

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: FadeSlideIn(
                  offset: const Offset(0, -18),
                  child: _Header(count: state.utilityBills.length),
                ),
              ),
              if (grouped.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyState(),
                )
              else
                SliverList.builder(
                  itemCount: grouped.length,
                  itemBuilder: (context, i) {
                    final entry = grouped.entries.elementAt(i);
                    return FadeSlideIn(
                      delay:
                          Duration(milliseconds: 120 + i * 80),
                      child: _CategorySection(
                        category:
                            UtilityCategory.fromKey(entry.key),
                        bills: entry.value,
                      ),
                    );
                  },
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 110)),
            ],
          );
        },
      ),
    );
  }

  Map<String, List<Map<String, dynamic>>> _groupByCategory(
      List<Map<String, dynamic>> bills) {
    final map = <String, List<Map<String, dynamic>>>{};
    for (final b in bills) {
      final c = b['category'] as String;
      map.putIfAbsent(c, () => []).add(b);
    }
    return map;
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppGradients.brand,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My Utilities',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$count registered ${count == 1 ? 'utility' : 'utilities'}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.78),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({required this.category, required this.bills});

  final UtilityCategory category;
  final List<Map<String, dynamic>> bills;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 28,
                width: 28,
                decoration: BoxDecoration(
                  color: category.color.withOpacity(0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(category.icon, size: 16, color: category.color),
              ),
              const SizedBox(width: 10),
              Text(category.label, style: AppText.h3),
              const Spacer(),
              Text(
                '${bills.length}',
                style: AppText.bodyMuted.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...bills.map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _UtilityTile(bill: b, category: category),
              )),
        ],
      ),
    );
  }
}

class _UtilityTile extends StatelessWidget {
  const _UtilityTile({required this.bill, required this.category});

  final Map<String, dynamic> bill;
  final UtilityCategory category;

  @override
  Widget build(BuildContext context) {
    final amount = (bill['amount'] as num).toDouble();
    final due = bill['dueDate'] as String? ?? '';
    final isExpired = due.toLowerCase().contains('expired');

    return PressableScale(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.utilityDetails,
          arguments: {
            'category': category.key,
            'bloc': context.read<DashboardBloc>(),
          },
        );
      },
      child: TintedCard(
        tint: category.color,
        padding: const EdgeInsets.all(14),
        child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bill['name'] as String,
                  style: TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text('ID: ${bill['id']}', style: AppText.caption),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      isExpired
                          ? Icons.error_outline_rounded
                          : Icons.schedule_rounded,
                      size: 13,
                      color: isExpired ? AppColors.danger : AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
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
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${amount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: category.color,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              _PayButton(
                color: category.color,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.paymentGateway,
                    arguments: {
                      'selectedBills': <Map<String, dynamic>>[bill],
                      'bloc': context.read<DashboardBloc>(),
                    },
                  );
                },
              ),
            ],
          ),
        ],
        ),
      ),
    );
  }
}

class _PayButton extends StatelessWidget {
  const _PayButton({required this.color, required this.onTap});

  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(AppRadii.pill),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.pill),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          child: Text(
            'Pay Now',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

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
              child: Icon(
                Icons.receipt_long_rounded,
                size: 42,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No utilities yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Tap "+ Add Utility" to register your first bill',
              textAlign: TextAlign.center,
              style: AppText.bodyMuted,
            ),
          ],
        ),
      ),
    );
  }
}
