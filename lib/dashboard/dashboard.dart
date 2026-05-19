import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_cure_ui/login_screen.dart';
import 'dashboard_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

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
                Color(0xFFE8F7F7), // Soft teal/cyan tint
                Color(0xFFF4F9F9), // Light background
                Colors.white,
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
                  const SizedBox(height: 24),
                  _buildBannerCarousel(),
                  const SizedBox(height: 24),
                  _buildAllServicesHeader(),
                  _buildServicesGrid(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Logo container matching design
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFE2F0F0),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                "assets/logo.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // App Title
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "MY CURE",
                  style: TextStyle(
                    color: Color(0xFF19B9B9),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  "Core Urban Region.",
                  style: TextStyle(
                    color: Color(0xFF769B9B),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Action Buttons
          Row(
            children: [
              _buildHeaderButton(
                icon: Icons.logout_rounded,
                onPressed: () {
                  // Navigate back to Login Screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
              ),
              const SizedBox(width: 10),
              _buildHeaderButton(
                icon: Icons.settings_outlined,
                onPressed: () {},
              ),
              const SizedBox(width: 10),
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
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(icon, color: const Color(0xFF0B0B22), size: 20),
            onPressed: onPressed,
            splashRadius: 22,
          ),
        ),
        if (hasBadge)
          Positioned(
            right: 12,
            top: 12,
            child: Container(
              height: 8,
              width: 8,
              decoration: const BoxDecoration(
                color: Color(0xFFFF453A), // Red badge dot
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBannerCarousel() {
    final List<Widget> banners = [
      _buildPropertyTaxBanner(),
      _buildWaterBillBanner(),
    ];

    return Column(
      children: [
        CarouselSlider(
          items: banners,
          options: CarouselOptions(
            height: 160,
            viewportFraction: 0.92,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
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
        const SizedBox(height: 12),
        // Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: banners.asMap().entries.map((entry) {
            return Container(
              width: _currentBannerIndex == entry.key ? 18.0 : 6.0,
              height: 6.0,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: _currentBannerIndex == entry.key
                    ? const Color(0xFF19B9B9)
                    : const Color(0xFFD0E7E7),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPropertyTaxBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE6F5F6),
            Color(0xFFCEECEE),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFBBE5E5),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Right Side Image Background
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 140,
              child: Opacity(
                opacity: 0.95,
                child: Image.asset(
                  "assets/property_tax_banner.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Gradient Overlay to blend text
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFFE6F5F6),
                      Color(0xFFE6F5F6),
                      Color(0xDFE6F5F6),
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.4, 0.6, 1.0],
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "PAY PROPERTY TAX\nTHE EASY WAY",
                        style: TextStyle(
                          color: Color(0xFF0F5A5A),
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Pay your Property Tax on MY CURE\nQuick • simple • secure.",
                        style: TextStyle(
                          color: Color(0xFF3F7F7F),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F5A5A),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "5% REBATE* ON PROPERTY TAX",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterBillBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE3F2FD),
            Color(0xFFBBDEFB),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF90CAF9),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Right Side Image Background
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 140,
              child: Image.asset(
                "assets/water_bill_banner.png",
                fit: BoxFit.cover,
              ),
            ),
            // Gradient Overlay to blend text
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFFE3F2FD),
                      Color(0xFFE3F2FD),
                      Color(0xDFE3F2FD),
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.4, 0.6, 1.0],
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "PAY WATER BILLS\nINSTANTLY",
                        style: TextStyle(
                          color: Color(0xFF0D47A1),
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Settle your HMWSSB water bills in seconds.\nSafe • fast • hassle-free.",
                        style: TextStyle(
                          color: Color(0xFF1565C0),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D47A1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "NO LATE FEES* ON FIRST PAY",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllServicesHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        "All services",
        style: TextStyle(
          color: Color(0xFF0B0B22),
          fontSize: 20,
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 18,
            mainAxisSpacing: 18,
            childAspectRatio: 0.95,
          ),
          itemCount: state.bills.length,
          itemBuilder: (context, index) {
            final bill = state.bills[index];
            final title = bill['title'] as String;
            final type = bill['type'] as String;
            final theme = _getServiceTheme(type);

            final IconData iconData = theme['icon'] as IconData;
            final Color accentColor = theme['color'] as Color;
            final Color shadowColor = theme['shadowColor'] as Color;

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 20,
                    spreadRadius: 0,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.01),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(28),
                  onTap: () {
                    // Navigate or perform action
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Icon circle
                        Container(
                          height: 42,
                          width: 42,
                          decoration: BoxDecoration(
                            color: accentColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: accentColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            iconData,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        // Service Title
                        Text(
                          title,
                          style: const TextStyle(
                            color: Color(0xFF0B0B22),
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        // Bottom row: "Open ->" and mini arrow button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Open",
                                  style: TextStyle(
                                    color: accentColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward,
                                  color: accentColor,
                                  size: 13,
                                ),
                              ],
                            ),
                            Container(
                              height: 28,
                              width: 28,
                              decoration: BoxDecoration(
                                color: accentColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.chevron_right_rounded,
                                color: accentColor,
                                size: 16,
                              ),
                            ),
                          ],
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
}
