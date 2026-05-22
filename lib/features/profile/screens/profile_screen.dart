import 'package:flutter/material.dart';
import 'package:my_cure_ui/config/app_theme.dart';
import 'package:my_cure_ui/config/routes.dart';
import 'package:my_cure_ui/shared/widgets/app_animations.dart';
import 'package:my_cure_ui/shared/widgets/app_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_cure_ui/config/theme_cubit.dart';

/// Lightweight Profile tab. Real-data fields are stubs — kept minimal so the
/// bottom-nav shell has four working tabs without scope-creeping.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
          children: [
            FadeSlideIn(
              child: Text('Profile', style: AppText.h1),
            ),
            const SizedBox(height: 16),
            FadeSlideIn(
              delay: const Duration(milliseconds: 80),
              child: AppCard(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryDark],
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person_rounded,
                            size: 32, color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ramesh Kumar',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryDark,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text('+91 98765 43210', style: AppText.bodyMuted),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            FadeSlideIn(
              delay: const Duration(milliseconds: 160),
              child: _section(context, 'Account', [
                _Tile(
                  icon: Icons.person_outline_rounded,
                  label: 'Edit Profile',
                  onTap: () => _toast(context, 'Edit profile — coming soon'),
                ),
                _Tile(
                  icon: Icons.lock_outline_rounded,
                  label: 'Change MPIN',
                  onTap: () => _toast(context, 'Change MPIN — coming soon'),
                ),
                _Tile(
                  icon: Icons.history_rounded,
                  label: 'Payment History',
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.paymentHistory),
                ),
              ]),
            ),
            const SizedBox(height: 16),
            FadeSlideIn(
              delay: const Duration(milliseconds: 240),
              child: _section(context, 'Preferences', [
                _Tile(
                  icon: Icons.notifications_none_rounded,
                  label: 'Notifications',
                  onTap: () => _toast(context, 'Notifications — coming soon'),
                ),
                _Tile(
                  icon: Icons.dark_mode_outlined,
                  label: 'Dark Theme',
                  trailingWidget: Switch(
                    value: context.watch<ThemeCubit>().state == ThemeMode.dark,
                    onChanged: (val) => context.read<ThemeCubit>().toggleTheme(val),
                    activeColor: AppColors.primary,
                  ),
                ),
                _Tile(
                  icon: Icons.language_rounded,
                  label: 'Language',
                  trailing: 'English',
                  onTap: () => _toast(context, 'Language — coming soon'),
                ),
              ]),
            ),
            const SizedBox(height: 16),
            FadeSlideIn(
              delay: const Duration(milliseconds: 320),
              child: _section(context, 'Support', [
                _Tile(
                  icon: Icons.help_outline_rounded,
                  label: 'Help & Support',
                  onTap: () => _toast(context, 'Support — coming soon'),
                ),
                _Tile(
                  icon: Icons.policy_outlined,
                  label: 'Privacy Policy',
                  onTap: () => _toast(context, 'Privacy — coming soon'),
                ),
              ]),
            ),
            const SizedBox(height: 22),
            FadeSlideIn(
              delay: const Duration(milliseconds: 400),
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (_) => false,
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.danger,
                  side: BorderSide(color: AppColors.danger),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.logout_rounded, size: 18),
                label: const Text(
                  'Log Out',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text('Version 1.0.0', style: AppText.caption),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(BuildContext context, String title, List<_Tile> tiles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title, style: AppText.h3),
        ),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: List.generate(tiles.length * 2 - 1, (i) {
              if (i.isOdd) {
                return Divider(
                    height: 1, indent: 56, color: AppColors.border);
              }
              return tiles[i ~/ 2];
            }),
          ),
        ),
      ],
    );
  }

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.primary),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.label,
    this.onTap,
    this.trailing,
    this.trailingWidget,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final String? trailing;
  final Widget? trailingWidget;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primary, size: 17),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
              if (trailing != null) ...[
                Text(trailing!, style: AppText.bodyMuted),
                const SizedBox(width: 6),
              ],
              if (trailingWidget != null)
                trailingWidget!
              else
                Icon(Icons.chevron_right_rounded,
                    color: AppColors.textMuted, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
