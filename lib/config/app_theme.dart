import 'package:flutter/material.dart';

class AppThemeManager {
  static bool isDark = false;

  static void setTheme(ThemeMode mode) {
    isDark = mode == ThemeMode.dark;
  }
}

class AppColors {
  AppColors._();

  static Color get primary => const Color(0xFF0956CB);
  static Color get primaryDark => AppThemeManager.isDark ? Colors.white : const Color(0xFF0653C7);
  static Color get primarySoft => AppThemeManager.isDark ? const Color(0x260956CB) : const Color(0x140956CB);

  static Color get surface => AppThemeManager.isDark ? const Color(0xFF121418) : const Color(0xFFFEFEFE);
  static Color get surfaceAlt => AppThemeManager.isDark ? const Color(0xFF1C1F26) : const Color(0xFFF4F6F9);
  static Color get border => AppThemeManager.isDark ? const Color(0xFF2A2D35) : const Color(0xFFE5E9F2);

  static Color get textPrimary => AppThemeManager.isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0653C7);
  static Color get textBody => AppThemeManager.isDark ? const Color(0xFFCBD5E1) : const Color(0xFF1F2937);
  static Color get textMuted => AppThemeManager.isDark ? const Color(0xFF94A3B8) : const Color(0xFF8A9A9A);

  static Color get success => const Color(0xFF30D158);
  static Color get warning => const Color(0xFFFF9F0A);
  static Color get danger => const Color(0xFFFF453A);
  static Color get info => const Color(0xFF0A84FF);

  static Color get catElectricity => const Color(0xFFFF9F0A);
  static Color get catWater => const Color(0xFF0A84FF);
  static Color get catPropertyTax => const Color(0xFF30D158);
  static Color get catTrade => const Color(0xFFBF5AF2);
  static Color get catEChallan => const Color(0xFFFF453A);
  static Color get catBroadband => const Color(0xFF5E5CE6);
}

class AppText {
  AppText._();

  static TextStyle get h1 => TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: AppColors.primary,
        letterSpacing: 0.5,
      );

  static TextStyle get h2 => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: AppColors.primaryDark,
      );

  static TextStyle get h3 => TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryDark,
      );

  static TextStyle get body => TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.textBody,
      );

  static TextStyle get bodyMuted => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textMuted,
      );

  static TextStyle get caption => TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.textMuted,
      );

  static TextStyle get button => const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        letterSpacing: 0.3,
      );

  static TextStyle get amount => TextStyle(
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

class AppGradients {
  AppGradients._();

  static LinearGradient get brand => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF0F6BFF),
          Color(0xFF0956CB),
          Color(0xFF0640A2),
        ],
        stops: [0.0, 0.55, 1.0],
      );

  static LinearGradient get brandSoft => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.primary, AppColors.primaryDark],
      );

  static LinearGradient tint(Color color) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color.withValues(alpha: 0.18),
          color.withValues(alpha: 0.06),
        ],
      );
}

class AppShadows {
  AppShadows._();

  static List<BoxShadow> get soft => [
        BoxShadow(
          color: AppThemeManager.isDark ? Colors.black.withValues(alpha: 0.2) : const Color(0xFF0956CB).withValues(alpha: 0.06),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get medium => [
        BoxShadow(
          color: AppThemeManager.isDark ? Colors.black.withValues(alpha: 0.3) : const Color(0xFF0956CB).withValues(alpha: 0.12),
          blurRadius: 28,
          offset: const Offset(0, 14),
        ),
      ];

  static List<BoxShadow> get floating => [
        BoxShadow(
          color: AppThemeManager.isDark ? Colors.black.withValues(alpha: 0.4) : const Color(0xFF0956CB).withValues(alpha: 0.28),
          blurRadius: 30,
          offset: const Offset(0, 12),
        ),
      ];

  static List<BoxShadow> tile(Color tint) => [
        BoxShadow(
          color: tint.withValues(alpha: AppThemeManager.isDark ? 0.08 : 0.18),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ];
}

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

  static UtilityCategory get electricity => UtilityCategory(
        key: 'electricity',
        label: 'Electricity',
        icon: Icons.bolt_rounded,
        color: AppColors.catElectricity,
      );
  static UtilityCategory get water => UtilityCategory(
        key: 'hmwssb',
        label: 'Water (HMWSSB)',
        icon: Icons.water_drop_rounded,
        color: AppColors.catWater,
      );
  static UtilityCategory get propertyTax => UtilityCategory(
        key: 'property_tax',
        label: 'Property Tax',
        icon: Icons.home_work_rounded,
        color: AppColors.catPropertyTax,
      );
  static UtilityCategory get trade => UtilityCategory(
        key: 'trade',
        label: 'Trade License',
        icon: Icons.storefront_rounded,
        color: AppColors.catTrade,
      );
  static UtilityCategory get echallan => UtilityCategory(
        key: 'echallan',
        label: 'eChallan',
        icon: Icons.receipt_long_rounded,
        color: AppColors.catEChallan,
      );
  static UtilityCategory get broadband => UtilityCategory(
        key: 'broadband',
        label: 'Broadband',
        icon: Icons.wifi_rounded,
        color: AppColors.catBroadband,
      );

  static List<UtilityCategory> get all => [
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
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.primaryDark,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: AppText.h2,
      iconTheme: IconThemeData(color: AppColors.primaryDark),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppThemeManager.isDark ? AppColors.primary : AppColors.primaryDark,
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
        side: BorderSide(color: AppColors.border, width: 1),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppThemeManager.isDark ? AppColors.surfaceAlt : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
      ),
      hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14),
    ),
  );
}

ThemeData buildDarkTheme() {
  return buildAppTheme(); // Both share the same function since AppColors responds to AppThemeManager
}
