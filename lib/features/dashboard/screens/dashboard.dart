import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_cure_ui/config/app_theme.dart';
import 'package:my_cure_ui/config/routes.dart';
import 'package:my_cure_ui/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:my_cure_ui/features/payment/bloc/payment_history_bloc.dart';
import 'package:my_cure_ui/shared/widgets/app_animations.dart';
import 'package:my_cure_ui/shared/widgets/app_card.dart';

/// Cure One dashboard — modern overlay layout:
/// 1. Hero header with brand gradient (greeting + total due)
/// 2. Overlay summary card that sits ON TOP of the hero edge (-34px translate)
/// 3. Quick-action chips
/// 4. Promotional banner carousel
/// 5. 3-col colored utility tiles
/// 6. Recent activity from PaymentHistoryRegistry
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _banner = 0;

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(LoadBills());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          final pending = state.utilityBills
              .where((b) => !((b['isPaid'] as bool?) ?? false))
              .toList();
          final paid = state.utilityBills
              .where((b) => (b['isPaid'] as bool?) ?? false)
              .toList();
          final totalDue = pending.fold<double>(
              0.0, (s, b) => s + (b['amount'] as num).toDouble());
          final electricityCount = state.utilityBills
              .where((b) =>
                  !((b['isPaid'] as bool?) ?? false) &&
                  b['category'] == 'electricity')
              .length;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                FadeSlideIn(
                  offset: const Offset(0, -18),
                  child: _HeroHeader(
                      totalDue: totalDue, pendingCount: pending.length),
                ),
                Transform.translate(
                  offset: const Offset(0, -34),
                  child: Column(
                    children: [
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 120),
                        child: _OverlaySummary(
                          electricityDue: state.utilityBills
                              .where((b) =>
                                  !((b['isPaid'] as bool?) ?? false) &&
                                  b['category'] == 'electricity')
                              .fold<double>(
                                  0.0,
                                  (s, b) =>
                                      s + (b['amount'] as num).toDouble()),
                          tradeDue: state.utilityBills
                              .where((b) =>
                                  !((b['isPaid'] as bool?) ?? false) &&
                                  b['category'] == 'trade')
                              .fold<double>(
                                  0.0,
                                  (s, b) =>
                                      s + (b['amount'] as num).toDouble()),
                          taxDue: state.utilityBills
                              .where((b) =>
                                  !((b['isPaid'] as bool?) ?? false) &&
                                  b['category'] == 'property_tax')
                              .fold<double>(
                                  0.0,
                                  (s, b) =>
                                      s + (b['amount'] as num).toDouble()),
                          echallanDue: state.utilityBills
                              .where((b) =>
                                  !((b['isPaid'] as bool?) ?? false) &&
                                  b['category'] == 'echallan')
                              .fold<double>(
                                  0.0,
                                  (s, b) =>
                                      s + (b['amount'] as num).toDouble()),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const FadeSlideIn(
                        delay: Duration(milliseconds: 200),
                        child: _QuickActions(),
                      ),
                      const SizedBox(height: 16),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 280),
                        child: _BannerCarousel(
                          current: _banner,
                          onChange: (i) => setState(() => _banner = i),
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 360),
                        child: _ServicesSection(bills: state.bills),
                      ),
                      const SizedBox(height: 8),
                      const FadeSlideIn(
                        delay: Duration(milliseconds: 440),
                        child: _RecentActivity(),
                      ),
                      // Clearance for the floating bottom nav.
                      const SizedBox(height: 110),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero header
// ─────────────────────────────────────────────────────────────────────────────

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.totalDue, required this.pendingCount});

  final double totalDue;
  final int pendingCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 56),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.16),
                      border: Border.all(color: Colors.white.withOpacity(0.35)),
                    ),
                    child: const Icon(Icons.person_rounded,
                        color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Text(
                          'Ramesh Kumar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _CircleIconButton(
                    icon: Icons.notifications_none_rounded,
                    hasBadge: true,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 26),
              // Text(
              //   'Total due this month',
              //   style: TextStyle(
              //     color: Colors.white.withOpacity(0.78),
              //     fontSize: 12.5,
              //     fontWeight: FontWeight.w600,
              //     letterSpacing: 0.4,
              //   ),
              // ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // AnimatedCounter(
                  //   value: totalDue,
                  //   prefix: '₹',
                  //   format: _format,
                  //   duration: const Duration(milliseconds: 1100),
                  //   style: const TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 34,
                  //     fontWeight: FontWeight.w900,
                  //     letterSpacing: -0.5,
                  //   ),
                  // ),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(AppRadii.pill),
                      ),
                      child: Text(
                        'Pay Your Bills',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
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
    // Indian number grouping: 1,23,456.78
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

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.hasBadge = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool hasBadge;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadii.pill),
          child: Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.16),
              border: Border.all(color: Colors.white.withOpacity(0.35)),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
        if (hasBadge)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              height: 8,
              width: 8,
              decoration: const BoxDecoration(
                color: AppColors.danger,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Overlay summary card — sits on top of the hero edge.
// ─────────────────────────────────────────────────────────────────────────────

class _OverlaySummary extends StatelessWidget {
  const _OverlaySummary({
    required this.electricityDue,
    required this.tradeDue,
    required this.taxDue,
    required this.echallanDue,
  });

  final double electricityDue;
  final double tradeDue;
  final double taxDue;
  final double echallanDue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 14),
        decoration: BoxDecoration(
          // Clean off-white shade — no aggressive gradient.
          color: const Color(0xFFFBFCFE),
          borderRadius: BorderRadius.circular(AppRadii.xl),
          border: Border.all(color: AppColors.border),
          boxShadow: AppShadows.soft,
        ),
        child: Row(
          children: [
            _stat(
              icon: Icons.bolt_rounded,
              label: 'Electricity',
              value: '3',
              color: AppColors.catElectricity,
            ),
            _divider(),
            _stat(
              icon: Icons.storefront_rounded,
              label: 'Trade',
              value: '2',
              color: AppColors.catTrade,
            ),
            _divider(),
            _stat(
              icon: Icons.account_balance_rounded,
              label: 'Tax',
              value: '1',
              color: AppColors.catPropertyTax,
            ),
            _divider(),
            _stat(
              icon: Icons.receipt_long_rounded,
              label: 'eChallan',
              value: '1',
              color: AppColors.catEChallan,
            ),
          ],
        ),
      ),
    );
  }

  /// Compact rupee display: 12500 → 12.5K, 1250000 → 12.5L.
  String _compact(double v) {
    if (v >= 10000000) {
      return '${(v / 10000000).toStringAsFixed(1)}Cr';
    }
    if (v >= 100000) {
      return '${(v / 100000).toStringAsFixed(1)}L';
    }
    if (v >= 1000) {
      return '${(v / 1000).toStringAsFixed(1)}K';
    }
    return v.toStringAsFixed(0);
  }

  Widget _stat({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 15, color: color),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 1),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 32,
      width: 1,
      color: AppColors.border,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Quick actions
// ─────────────────────────────────────────────────────────────────────────────

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    final items = [
      _QuickAction(
        icon: Icons.payments_rounded,
        label: 'Pay All',
        color: AppColors.primary,
        onTap: () => Navigator.pushNamed(
          context,
          AppRoutes.payAllAtOnce,
          arguments: context.read<DashboardBloc>(),
        ),
      ),
      _QuickAction(
        icon: Icons.add_card_rounded,
        label: 'Register',
        color: AppColors.success,
        onTap: () => Navigator.pushNamed(
          context,
          AppRoutes.registerUtility,
          arguments: context.read<DashboardBloc>(),
        ),
      ),
      _QuickAction(
        icon: Icons.history_rounded,
        label: 'History',
        color: AppColors.catTrade,
        onTap: () => Navigator.pushNamed(context, AppRoutes.paymentHistory),
      ),
      _QuickAction(
        icon: Icons.support_agent_rounded,
        label: 'Help',
        color: AppColors.warning,
        onTap: () {},
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: items
            .map((a) => Expanded(child: _QuickActionTile(action: a)))
            .toList(),
      ),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({required this.action});
  final _QuickAction action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        onTap: action.onTap,
        child: Column(
          children: [
            Container(
              height: 54,
              width: 54,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: action.color.withOpacity(0.18)),
                boxShadow: AppShadows.tile(action.color),
              ),
              child: Icon(action.icon, color: action.color, size: 24),
            ),
            const SizedBox(height: 6),
            Text(
              action.label,
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Banner carousel
// ─────────────────────────────────────────────────────────────────────────────

class _BannerCarousel extends StatelessWidget {
  const _BannerCarousel({required this.current, required this.onChange});

  final int current;
  final ValueChanged<int> onChange;

  @override
  Widget build(BuildContext context) {
    final banners = <_Banner>[
      _Banner(
        title: 'Pay Property Tax',
        subtitle: 'Save up to 5% rebate on early payment',
        badge: '5% REBATE',
        color: AppColors.catPropertyTax,
        icon: Icons.home_work_rounded,
        asset: 'assets/property_tax_photo.png',
      ),
      _Banner(
        title: 'Pay Electricity',
        subtitle: 'Quick, secure, zero processing fee',
        badge: 'ZERO FEE',
        color: AppColors.catElectricity,
        icon: Icons.bolt_rounded,
        asset: 'assets/electricity_photo.png',
      ),
      _Banner(
        title: 'Water Bill',
        subtitle: '24/7 HMWSSB online payments',
        badge: '24/7',
        color: AppColors.catWater,
        icon: Icons.water_drop_rounded,
        asset: 'assets/water_bill_photo.png',
      ),
      _Banner(
        title: 'eChallan',
        subtitle: 'Clear traffic challans in seconds',
        badge: 'NEW',
        color: AppColors.catEChallan,
        icon: Icons.receipt_long_rounded,
        asset: 'assets/echallan_photo.png',
      ),
    ];

    return Column(
      children: [
        CarouselSlider(
          // Pad each card vertically so the colored shadow has room to render
          // inside the viewport (was being clipped at 130px).
          items: banners
              .map((b) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: _BannerCard(banner: b),
                  ))
              .toList(),
          options: CarouselOptions(
            height: 156,
            viewportFraction: 0.88,
            enlargeCenterPage: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            onPageChanged: (i, _) => onChange(i),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: banners.asMap().entries.map((e) {
            final active = e.key == current;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 6,
              width: active ? 20 : 6,
              decoration: BoxDecoration(
                color: active
                    ? AppColors.primary
                    : AppColors.primary.withOpacity(0.25),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _Banner {
  final String title;
  final String subtitle;
  final String badge;
  final Color color;
  final IconData icon;
  final String asset;
  _Banner({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.color,
    required this.icon,
    required this.asset,
  });
}

class _BannerCard extends StatelessWidget {
  const _BannerCard({required this.banner});
  final _Banner banner;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadii.lg),
          border: Border.all(color: banner.color.withOpacity(0.18)),
          boxShadow: AppShadows.tile(banner.color),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          child: Stack(
            children: [
              // Right-side asset image with a gradient fade into the card.
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: 170,
                child: ShaderMask(
                  blendMode: BlendMode.dstIn,
                  shaderCallback: (bounds) => const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.transparent, Colors.black, Colors.black],
                    stops: [0.0, 0.35, 1.0],
                  ).createShader(bounds),
                  child: Image.asset(
                    banner.asset,
                    fit: BoxFit.cover,
                    alignment: Alignment.centerRight,
                    errorBuilder: (_, __, ___) => Container(
                      color: banner.color.withOpacity(0.10),
                      alignment: Alignment.center,
                      child: Icon(banner.icon, color: banner.color, size: 48),
                    ),
                  ),
                ),
              ),
              // Soft color wash overlay so text on the left stays legible.
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.white,
                        Colors.white.withOpacity(0.92),
                        Colors.white.withOpacity(0.0),
                      ],
                      stops: const [0.0, 0.45, 0.75],
                    ),
                  ),
                ),
              ),
              // Content on the left.
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: banner.color,
                              borderRadius:
                                  BorderRadius.circular(AppRadii.pill),
                              boxShadow: [
                                BoxShadow(
                                  color: banner.color.withOpacity(0.35),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Text(
                              banner.badge,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            banner.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.primaryDark,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            banner.subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.primaryDark.withOpacity(0.62),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 130),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Services — 3-col colored tiles
// ─────────────────────────────────────────────────────────────────────────────

class _ServicesSection extends StatelessWidget {
  const _ServicesSection({required this.bills});
  final List<Map<String, dynamic>> bills;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Utility Services',
                style: TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.myUtilities,
                  arguments: context.read<DashboardBloc>(),
                ),
                child: const Row(
                  children: [
                    Text(
                      'View all',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(Icons.arrow_forward_rounded,
                        size: 14, color: AppColors.primary),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (bills.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(28),
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: bills.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.92,
              ),
              itemBuilder: (context, i) {
                final bill = bills[i];
                final cat = UtilityCategory.fromKey(bill['type'] as String);
                return TintedCard(
                  tint: cat.color,
                  elevated: true,
                  padding: const EdgeInsets.all(10),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.utilityDetails,
                      arguments: {
                        'category': cat.key,
                        'bloc': context.read<DashboardBloc>(),
                      },
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: AppShadows.tile(cat.color),
                        ),
                        child: Icon(cat.icon, color: cat.color, size: 22),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        bill['title'] as String,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.primaryDark,
                          fontSize: 11.5,
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
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Recent activity from PaymentHistoryRegistry
// ─────────────────────────────────────────────────────────────────────────────

class _RecentActivity extends StatelessWidget {
  const _RecentActivity();

  @override
  Widget build(BuildContext context) {
    final recent = PaymentHistoryRegistry.instance.all.take(3).toList();
    if (recent.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Activity',
                style: TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.paymentHistory),
                child: const Row(
                  children: [
                    Text(
                      'See all',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(Icons.arrow_forward_rounded,
                        size: 14, color: AppColors.primary),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: List.generate(recent.length * 2 - 1, (i) {
                if (i.isOdd) {
                  return const Divider(
                    height: 1,
                    indent: 14,
                    endIndent: 14,
                    color: AppColors.border,
                  );
                }
                final r = recent[i ~/ 2];
                final cat = UtilityCategory.fromKey(
                    r.bills.first['category'] as String);
                final isMulti = r.bills.length > 1;
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        height: 38,
                        width: 38,
                        decoration: BoxDecoration(
                          color: cat.color.withOpacity(0.14),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(cat.icon, color: cat.color, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isMulti
                                  ? '${r.bills.length} bills paid'
                                  : r.bills.first['name'] as String,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${_fmt(r.date)} · ${r.method}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '₹${r.amount.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime d) {
    const m = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${d.day.toString().padLeft(2, '0')} ${m[d.month - 1]}';
  }
}
