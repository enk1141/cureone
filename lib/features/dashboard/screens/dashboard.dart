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
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0F0720), // Deep violet-black
                Color(0xFF160E2A), // Dark purple
                Color(0xFF0F0720),
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
                  BlocBuilder<DashboardBloc, DashboardState>(
                    builder: (context, state) {
                      return _buildSummaryCard(state);
                    },
                  ),
                  const SizedBox(height: 14),
                  _buildPayAllAtOnceCard(),
                  const SizedBox(height: 14),
                  _buildAllServicesHeader(),
                  _buildServicesGrid(),
                  const SizedBox(height: 60),
                  _buildFooter(),
                  const SizedBox(height: 32),
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
              color: Color(0xFF19B9B9),
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
                colors: [Color(0xFF19B9B9), Color(0xFF24BDBD)],
              ),
            ),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF1E1435),
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
                      color: Color(0xFF19B9B9),
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
          ),
          // Action Buttons: QR Scan, Settings, Notifications
          Row(
            children: [
              _buildHeaderButton(
                icon: Icons.qr_code_scanner_rounded,
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              _buildHeaderButton(
                icon: Icons.settings_outlined,
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              _buildHeaderButton(
                icon: Icons.notifications_none_rounded,
                hasBadge: true,
                onPressed: () {},
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
            color: const Color(0xFF1E1435),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF2D1F49),
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
              height: 7,
              width: 7,
              decoration: const BoxDecoration(
                color: Color(0xFFFF453A),
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

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
                        ? const Color(0xFF19B9B9)
                        : const Color(0xFF19B9B9).withOpacity(0.3),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

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
            Color(0xFF1E1435),
            Color(0xFF251A43),
            Color(0xFF1E1435),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF2D1F49),
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
                            Color(0x001E1435),
                            Color(0x801E1435),
                            Color(0xFF1E1435),
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
                              badgeHighlight,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              badgeRest,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 7,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                color: Color(0xFF19B9B9),
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
                color: const Color(0xFF1E1435),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF2D1F49),
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
          color: const Color(0xFF1E1435),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFF2D1F49),
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
                      color: const Color(0xFF19B9B9).withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.payments_rounded,
                      color: Color(0xFF19B9B9),
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
                      color: const Color(0xFF19B9B9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF19B9B9).withOpacity(0.3),
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
                      color: Color(0xFF19B9B9),
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

  Widget _buildSummaryCard(DashboardState state) {
    final currentMonth = DateTime.now().month;

    final monthlyBills =
        state.utilityBills.where((b) => b['month'] == currentMonth).toList();

    final pendingBills =
        monthlyBills.where((b) => !(b['isPaid'] ?? false)).length;

    final paidBills = monthlyBills.where((b) => (b['isPaid'] ?? false)).length;

    final totalAmount = monthlyBills
        .where((b) => !(b['isPaid'] ?? false))
        .fold(0.0, (sum, item) => sum + (item['amount'] as double));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            // Top Row → Pending & Paid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Pending Bills (This Month)",
                        style:
                            TextStyle(color: Color(0xFF8A9A9A), fontSize: 11)),
                    Text("$pendingBills",
                        style: const TextStyle(
                            color: Color(0xFFFF9F0A), // orange
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text("Paid Bills (This Month)",
                        style:
                            TextStyle(color: Color(0xFF8A9A9A), fontSize: 11)),
                    Text("$paidBills",
                        style: const TextStyle(
                            color: Color(0xFF30D158), // green
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Divider
            Container(
              height: 1,
              color: Colors.white.withOpacity(0.08),
            ),

            const SizedBox(height: 12),

            // Bottom Row → Total Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Amount",
                    style: TextStyle(color: Color(0xFF8A9A9A), fontSize: 11)),
                Text("₹${totalAmount.toStringAsFixed(2)}",
                    style: const TextStyle(
                        color: Color(0xFF19B9B9),
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
