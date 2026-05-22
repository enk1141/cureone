import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_cure_ui/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:my_cure_ui/config/routes.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentBannerIndex = 0;

  // Define service themes (icon, color, glow color)
  Map<String, dynamic> _getServiceTheme(String type) {
    switch (type) {
      case 'electricity':
        return {
          'icon': Icons.bolt_rounded,
          'color': const Color(0xFFFF9F0A), // Warm orange/amber
          'shadowColor': const Color(0xFFFF9F0A).withOpacity(0.25),
        };
      case 'hmwssb':
        return {
          'icon': Icons.water_drop_rounded,
          'color': const Color(0xFF0A84FF), // Radiant blue
          'shadowColor': const Color(0xFF0A84FF).withOpacity(0.25),
        };
      case 'property_tax':
        return {
          'icon': Icons.home_work_rounded,
          'color': const Color(0xFF30D158), // Green
          'shadowColor': const Color(0xFF30D158).withOpacity(0.25),
        };
      case 'trade':
        return {
          'icon': Icons.storefront_rounded,
          'color': const Color(0xFFBF5AF2), // Purple
          'shadowColor': const Color(0xFFBF5AF2).withOpacity(0.25),
        };
      case 'echallan':
        return {
          'icon': Icons.receipt_long_rounded,
          'color': const Color(0xFFFF453A), // Red
          'shadowColor': const Color(0xFFFF453A).withOpacity(0.25),
        };
      case 'broadband':
      default:
        return {
          'icon': Icons.wifi_rounded,
          'color': const Color(0xFF5E5CE6), // Indigo
          'shadowColor': const Color(0xFF5E5CE6).withOpacity(0.25),
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc()..add(LoadBills()),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0A2540), // Deep navy blue
                Color(0xFF1A3A52), // Teal-blue
                Color(0xFF0F2F45), // Ocean blue
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildHeader(context),
                  const SizedBox(height: 12),
                  _buildGreetingCard(),
                  const SizedBox(height: 12),
                  _buildBannerCarousel(),
                  const SizedBox(height: 18),
                  _buildPayAllAtOnceCard(),
                  const SizedBox(height: 14),
                  _buildAllServicesHeader(),
                  _buildServicesGrid(),
                  const SizedBox(height: 5),
                  _buildFooter(),
                  //const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingCard() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome",
            style: TextStyle(
              color: Color(0xFF00D9FF),
              fontSize: 20,
              fontWeight: FontWeight.w900,
              fontFamily: 'Inter',
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          // Profile Avatar with gradient border
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF00D9FF), Color(0xFF00F5FF)],
              ),
            ),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF0F2F45),
              child: ClipOval(
                child: Image.asset(
                  "assets/logo.png",
                  fit: BoxFit.contain,
                  height: 22,
                  width: 22,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // User location / app branding info
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      "CURE ONE",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF00D9FF),
                      size: 16,
                    ),
                  ],
                ),
                Text(
                  "Core Urban Region - CGG",
                  style: TextStyle(
                    color: Color(0xFF8A9A9A),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
<<<<<<< Updated upstream
          ),
          // Action Buttons: QR Scan, Settings, Notifications
          Row(
=======
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
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 56),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
>>>>>>> Stashed changes
            children: [
              _buildHeaderButton(
                icon: Icons.settings_outlined,
                onPressed: () {},
              ),
<<<<<<< Updated upstream
              const SizedBox(width: 8),
              _buildHeaderButton(
                icon: Icons.notifications_none_rounded,
                hasBadge: true,
                onPressed: () {},
=======
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
                  //   duration: Duration(milliseconds: 1100),
                  //   style: TextStyle(
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
                      child: const Text(
                        'Pay Your Bills',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
>>>>>>> Stashed changes
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton({
    required IconData icon,
    required VoidCallback onPressed,
    bool hasBadge = false,
  }) {
    return Stack(
      children: [
        Container(
          height: 38,
          width: 38,
          decoration: BoxDecoration(
            color: const Color(0xFF1A3A52),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF2D5A7B),
              width: 1,
            ),
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white, size: 18),
            onPressed: onPressed,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            splashRadius: 20,
          ),
        ),
        if (hasBadge)
          Positioned(
            right: 2,
            top: 2,
            child: Container(
<<<<<<< Updated upstream
              height: 7,
              width: 7,
              decoration: const BoxDecoration(
                color: Color(0xFFFF453A),
=======
              height: 8,
              width: 8,
              decoration: BoxDecoration(
                color: AppColors.danger,
>>>>>>> Stashed changes
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

<<<<<<< Updated upstream
  Widget _buildBannerCarousel() {
    final List<Widget> banners = [
      _buildBannerCard(
        line1: "PAY ELECTRICITY BILL",
        line2: "THE EASY WAY",
        tagline: "Pay your Electricity Bill on MYCURE",
        badgeHighlight: "SECURE & FAST",
        badgeRest: "on ELECTRICITY",
        photoAsset: "assets/electricity_photo.png",
      ),
      _buildBannerCard(
        line1: "PAY WATER BILLS",
        line2: "THE EASY WAY",
        tagline: "Pay your HMWSSB Water Bills on MYCURE",
        badgeHighlight: "24/7 ONLINE",
        badgeRest: "on WATER BILLS",
        photoAsset: "assets/water_bill_photo.png",
=======
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
          color: AppColors.surface,
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
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ),
        ],
>>>>>>> Stashed changes
      ),
      _buildBannerCard(
        line1: "PAY PROPERTY TAX",
        line2: "THE EASY WAY",
        tagline: "Pay your Property Tax on MYCURE",
        badgeHighlight: "5% REBATE*",
        badgeRest: "on PROPERTY TAX",
        photoAsset: "assets/property_tax_photo.png",
      ),
      _buildBannerCard(
        line1: "RENEW TRADE LICENSE",
        line2: "THE EASY WAY",
        tagline: "Renew your Trade License on MYCURE",
        badgeHighlight: "FAST RENEWAL",
        badgeRest: "on TRADE LICENSE",
        photoAsset: "assets/trade_license_photo.png",
      ),
      _buildBannerCard(
        line1: "CLEAR E-CHALLANS",
        line2: "THE EASY WAY",
        tagline: "Pay your Traffic Challans on MYCURE",
        badgeHighlight: "ZERO FEES",
        badgeRest: "on TRAFFIC CHALLANS",
        photoAsset: "assets/echallan_photo.png",
      ),
    ];

<<<<<<< Updated upstream
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          CarouselSlider(
            items: banners.map((banner) {
              return Padding(
                padding: const EdgeInsets.only(right: 8, left: 8),
                child: banner,
              );
            }).toList(),
            options: CarouselOptions(
              height: 140,
              viewportFraction: 0.92,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentBannerIndex = index;
                });
=======
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
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: action.color.withOpacity(0.18)),
                boxShadow: AppShadows.tile(action.color),
              ),
              child: Icon(action.icon, color: action.color, size: 24),
            ),
            const SizedBox(height: 6),
            Text(
              action.label,
              style: TextStyle(
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
          color: AppColors.surface,
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
                        AppColors.surface,
                        AppColors.surface.withOpacity(0.92),
                        AppColors.surface.withOpacity(0.0),
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
                            style: TextStyle(
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
              Text(
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
                child: Row(
                  children: [
                    Text(
                      'View all',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(Icons.arrow_forward_rounded,
                        size: 14, color: AppColors.primary),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (bills.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
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
                          color: AppColors.surfaceAlt,
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
                        style: TextStyle(
                          color: AppColors.primaryDark,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                );
>>>>>>> Stashed changes
              },
            ),
          ),
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: banners.asMap().entries.map((entry) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: _currentBannerIndex == entry.key ? 18.0 : 6.0,
                  height: 6.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: _currentBannerIndex == entry.key
                        ? const Color(0xFF00D9FF)
                        : const Color(0xFF00D9FF).withOpacity(0.3),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

<<<<<<< Updated upstream
  Widget _buildBannerCard({
    required String line1,
    required String line2,
    required String tagline,
    required String badgeHighlight,
    required String badgeRest,
    required String photoAsset,
  }) {
    return Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF1A3A52),
            Color(0xFF234B63),
            Color(0xFF1A3A52),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF2D5A7B),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 175,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      photoAsset,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [
                            Color(0x001A3A52),
                            Color(0x801A3A52),
                            Color(0xFF1A3A52),
                          ],
                          stops: [0.0, 0.5, 0.95],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 120, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          line1,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.15,
                            letterSpacing: 0.1,
                          ),
=======
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
              Text(
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
                child: Row(
                  children: [
                    Text(
                      'See all',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 2),
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
                  return Divider(
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
>>>>>>> Stashed changes
                        ),
                        Text(
                          line2,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.15,
                            letterSpacing: 0.1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tagline,
                          style: const TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF30D158),
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          "Quick > simple > secure.",
                          style: TextStyle(
                            fontSize: 7.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    CustomPaint(
                      painter: RibbonPainter(),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 4, 16, 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
<<<<<<< Updated upstream
                              badgeHighlight,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
=======
                              isMulti
                                  ? '${r.bills.length} bills paid'
                                  : r.bills.first['name'] as String,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryDark,
>>>>>>> Stashed changes
                              ),
                            ),
                            const SizedBox(width: 3),
                            Text(
<<<<<<< Updated upstream
                              badgeRest,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 7,
=======
                              '${_fmt(r.date)} · ${r.method}',
                              style: TextStyle(
                                fontSize: 11,
>>>>>>> Stashed changes
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
<<<<<<< Updated upstream
                    ),
                  ],
                ),
              ),
=======
                      Text(
                        '₹${r.amount.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                );
              }),
>>>>>>> Stashed changes
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllServicesHeader() {
    return const Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 4, bottom: 6),
      child: Text(
        "Utility Services",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildServicesGrid() {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state.bills.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(
                color: Color(0xFF00D9FF),
              ),
            ),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 4, bottom: 8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.88,
          ),
          itemCount: state.bills.length,
          itemBuilder: (context, index) {
            final bill = state.bills[index];
            final title = bill['title'] as String;
            final type = bill['type'] as String;
            final theme = _getServiceTheme(type);

            final IconData iconData = theme['icon'] as IconData;
            final Color accentColor = theme['color'] as Color;

            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1A3A52),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF2D5A7B),
                  width: 1,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.utilityDetails,
                      arguments: {
                        'category': type,
                        'bloc': BlocProvider.of<DashboardBloc>(context),
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon circle with subtle glow background
                        Container(
                          height: 38,
                          width: 38,
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            iconData,
                            color: accentColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Service Title
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPayAllAtOnceCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A3A52),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFF2D5A7B),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.payAllAtOnce,
                arguments: BlocProvider.of<DashboardBloc>(context),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    height: 46,
                    width: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00D9FF).withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.payments_rounded,
                      color: Color(0xFF00D9FF),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pay all at once",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Settle all pending bills in a single click",
                          style: TextStyle(
                            color: Color(0xFF8A9A9A),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00D9FF),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00D9FF).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          const Text(
            "Designed & Developed By",
            style: TextStyle(
              color: Color(0xFF8A9A9A),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/logo.png",
                height: 28,
                width: 28,
              ),
              const SizedBox(width: 8),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "CENTRE FOR GOOD GOVERNANCE",
                    style: TextStyle(
                      color: Color(0xFF00D9FF),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Knowledge • Technology • People",
                    style: TextStyle(
                      color: Color(0xFF8A9A9A),
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

<<<<<<< Updated upstream
class RibbonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0C4DA2)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width - 12, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Draw dashed inner border
    final dashPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final dashPath = Path();
    dashPath.moveTo(2, 2);
    dashPath.lineTo(size.width - 13, 2);
    dashPath.lineTo(size.width - 3, size.height - 2);
    dashPath.lineTo(2, size.height - 2);
    dashPath.close();

    _drawDashedPath(canvas, dashPath, dashPaint);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const dashWidth = 3.0;
    const dashSpace = 2.0;
    double distance = 0.0;
    for (final pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        canvas.drawPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
      distance = 0.0;
    }
=======
  String _fmt(DateTime d) {
    final m = [
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
>>>>>>> Stashed changes
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
