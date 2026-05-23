import 'package:flutter/material.dart';
import 'package:my_cure_ui/config/app_theme.dart';
import 'package:my_cure_ui/config/routes.dart';
import 'package:my_cure_ui/shared/widgets/app_animations.dart';
import 'package:my_cure_ui/shared/widgets/app_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            const FadeSlideIn(
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
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryDark],
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person_rounded,
                            size: 32, color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
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
                          SizedBox(height: 3),
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
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HelpSupportScreen(),
                    ),
                  ),
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
                 onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.login,
                      (_) => false,
                    );
                  }
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.danger,
                  side: const BorderSide(color: AppColors.danger),
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
            const Center(
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
                return const Divider(
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
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? trailing;

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
                  style: const TextStyle(
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
              const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textMuted, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Help & Support Screen Components
// ─────────────────────────────────────────────────────────────────────────────

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: const AppHeaderBar(title: 'Help & Support'),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          children: [
            const _HelpSupportHeader(),
            const SizedBox(height: 16),
            _HelpTile(
              icon: Icons.help_outline_rounded,
              title: 'FAQs',
              onTap: () {},
            ),
            _HelpTile(
              icon: Icons.report_problem_outlined,
              title: 'Raise a Complaint',
              onTap: () {},
            ),
            _HelpTile(
              icon: Icons.chat_bubble_outline_rounded,
              title: 'Chat with Support',
              info: 'Online',
              onTap: () {},
            ),
            _HelpTile(
              icon: Icons.phone_outlined,
              title: 'Call Us',
              info: '1800-123-4567',
              onTap: () {},
            ),
            _HelpTile(
              icon: Icons.mail_outline_rounded,
              title: 'Email Us',
              info: 'support@cureone.telangana.gov.in',
              onTap: () {},
            ),
            _HelpTile(
              icon: Icons.rate_review_outlined,
              title: 'Feedback',
              onTap: () {},
            ),
            const SizedBox(height: 18),
            const _SupportBanner(),
          ],
        ),
      ),
    );
  }
}

class _HelpSupportHeader extends StatelessWidget {
  const _HelpSupportHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Text(
            'How can we help you?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.primaryDark,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Container(
          height: 72,
          width: 72,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.support_agent_rounded,
            size: 40,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _HelpTile extends StatelessWidget {
  const _HelpTile({
    required this.icon,
    required this.title,
    this.info,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? info;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 16),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
                if (info != null) ...[
                  Text(
                    info!,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: info!.toLowerCase() == 'online'
                          ? const Color(0xFF2E7D32)
                          : AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textMuted,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SupportBanner extends StatelessWidget {
  const _SupportBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.12),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.headset_mic_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'We are here to help!',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryDark,
                ),
              ),
              SizedBox(height: 2),
              Text(
                '24x7 Support',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
