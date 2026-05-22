import 'package:flutter/material.dart';

/// Centralized design tokens for Cure One.
/// Keep all colors, text styles, radii, and spacing here so screens stay consistent.
class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF0956CB);
  static const Color primaryDark = Color(0xFF0653C7);
  static const Color primarySoft = Color(0x140956CB); // primary @ 8%

  // Surfaces
  static const Color surface = Color(0xFFFEFEFE);
  static const Color surfaceAlt = Color(0xFFF4F6F9);
  static const Color border = Color(0xFFE5E9F2);

  // Text
  static const Color textPrimary = Color(0xFF0653C7);
  static const Color textBody = Color(0xFF1F2937);
  static const Color textMuted = Color(0xFF8A9A9A);

  // Status
  static const Color success = Color(0xFF30D158);
  static const Color warning = Color(0xFFFF9F0A);
  static const Color danger = Color(0xFFFF453A);
  static const Color info = Color(0xFF0A84FF);

  // Utility category accents (kept in one place so dashboard, lists, receipts agree)
  static const Color catElectricity = Color(0xFFFF9F0A);
  static const Color catWater = Color(0xFF0A84FF);
  static const Color catPropertyTax = Color(0xFF30D158);
  static const Color catTrade = Color(0xFFBF5AF2);
  static const Color catEChallan = Color(0xFFFF453A);
  static const Color catBroadband = Color(0xFF5E5CE6);
}

class AppText {
  AppText._();

  static const TextStyle h1 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
    letterSpacing: 0.5,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: AppColors.primaryDark,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryDark,
  );

  static const TextStyle body = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textBody,
  );

  static const TextStyle bodyMuted = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
  );

  static const TextStyle button = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: 0.3,
  );

  static const TextStyle amount = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
  );
}

class AppRadii {
  AppRadii._();
  static const double sm = 10;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double pill = 999;
}

class AppSpacing {
  AppSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 28;
}

/// Reusable gradients used by hero headers and primary action cards.
class AppGradients {
  AppGradients._();

  static const LinearGradient brand = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0F6BFF),
      Color(0xFF0956CB),
      Color(0xFF0640A2),
    ],
    stops: [0.0, 0.55, 1.0],
  );

  static const LinearGradient brandSoft = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0956CB), Color(0xFF0653C7)],
  );

  static LinearGradient tint(Color color) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color.withOpacity(0.18),
          color.withOpacity(0.06),
        ],
      );
}

/// Pre-tuned shadow stacks for the overlay/floating look.
class AppShadows {
  AppShadows._();

  static List<BoxShadow> soft = [
    BoxShadow(
      color: const Color(0xFF0956CB).withOpacity(0.06),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> medium = [
    BoxShadow(
      color: const Color(0xFF0956CB).withOpacity(0.12),
      blurRadius: 28,
      offset: const Offset(0, 14),
    ),
  ];

  static List<BoxShadow> floating = [
    BoxShadow(
      color: const Color(0xFF0956CB).withOpacity(0.28),
      blurRadius: 30,
      offset: const Offset(0, 12),
    ),
  ];

  static List<BoxShadow> tile(Color tint) => [
        BoxShadow(
          color: tint.withOpacity(0.18),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ];
}

/// Maps a utility category key to a stable (icon, color, label) bundle.
/// Used by dashboard grid, My Utilities, receipts, and history.
class UtilityCategory {
  final String key;
  final String label;
  final IconData icon;
  final Color color;

  const UtilityCategory({
    required this.key,
    required this.label,
    required this.icon,
    required this.color,
  });

  static const electricity = UtilityCategory(
    key: 'electricity',
    label: 'Electricity',
    icon: Icons.bolt_rounded,
    color: AppColors.catElectricity,
  );
  static const water = UtilityCategory(
    key: 'hmwssb',
    label: 'Water (HMWSSB)',
    icon: Icons.water_drop_rounded,
    color: AppColors.catWater,
  );
  static const propertyTax = UtilityCategory(
    key: 'property_tax',
    label: 'Property Tax',
    icon: Icons.home_work_rounded,
    color: AppColors.catPropertyTax,
  );
  static const trade = UtilityCategory(
    key: 'trade',
    label: 'Trade License',
    icon: Icons.storefront_rounded,
    color: AppColors.catTrade,
  );
  static const echallan = UtilityCategory(
    key: 'echallan',
    label: 'eChallan',
    icon: Icons.receipt_long_rounded,
    color: AppColors.catEChallan,
  );
  static const broadband = UtilityCategory(
    key: 'broadband',
    label: 'Broadband',
    icon: Icons.wifi_rounded,
    color: AppColors.catBroadband,
  );

  static const List<UtilityCategory> all = [
    electricity,
    water,
    propertyTax,
    trade,
    echallan,
    broadband,
  ];

  static UtilityCategory fromKey(String key) {
    return all.firstWhere(
      (c) => c.key == key,
      orElse: () => electricity,
    );
  }
}

/// App-wide ThemeData used by MaterialApp.
ThemeData buildAppTheme() {
  return ThemeData(
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: AppColors.surface,
    primaryColor: AppColors.primary,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      surface: AppColors.surface,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.primaryDark,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: AppText.h2,
      iconTheme: IconThemeData(color: AppColors.primaryDark),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
        ),
        textStyle: AppText.button,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryDark,
        side: const BorderSide(color: AppColors.border, width: 1),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
    ),
  );
}
