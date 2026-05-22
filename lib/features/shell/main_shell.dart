import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_cure_ui/config/app_theme.dart';
import 'package:my_cure_ui/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:my_cure_ui/features/dashboard/screens/dashboard.dart';
import 'package:my_cure_ui/features/utilities/screens/my_utilities_screen.dart';
import 'package:my_cure_ui/features/payment/screens/payment_history_screen.dart';
import 'package:my_cure_ui/features/profile/screens/profile_screen.dart';

/// Persistent shell with a FLOATING bottom nav (blue pill, rounded corners,
/// detached from the screen edges with shadow). DashboardBloc is provided
/// at the route level so all tabs share state.
class MainShell extends StatefulWidget {
  const MainShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  static const _tabs = <_TabSpec>[
    _TabSpec(label: 'Home', icon: Icons.home_rounded),
    _TabSpec(label: 'Bills', icon: Icons.receipt_long_rounded),
    _TabSpec(label: 'History', icon: Icons.history_rounded),
    _TabSpec(label: 'Profile', icon: Icons.person_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Lets the body paint underneath the floating nav — needed so the
      // nav appears to hover over scrollable content.
      extendBody: true,
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          IndexedStack(
            index: _index,
            children: const [
              DashboardScreen(),
              MyUtilitiesScreen(),
              PaymentHistoryScreen(),
              ProfileScreen(),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                child: _FloatingBottomNav(
                  tabs: _tabs,
                  index: _index,
                  onTap: (i) => setState(() => _index = i),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _index == 1
          ? Padding(
              padding: const EdgeInsets.only(bottom: 76),
              child: FloatingActionButton.extended(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 6,
                icon: const Icon(Icons.add_rounded),
                label: const Text(
                  'Add Utility',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/register-utility',
                    arguments: context.read<DashboardBloc>(),
                  );
                },
              ),
            )
          : null,
    );
  }
}

class _TabSpec {
  final String label;
  final IconData icon;
  const _TabSpec({required this.label, required this.icon});
}

class _FloatingBottomNav extends StatelessWidget {
  const _FloatingBottomNav({
    required this.tabs,
    required this.index,
    required this.onTap,
  });

  final List<_TabSpec> tabs;
  final int index;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppGradients.brand,
        borderRadius: BorderRadius.circular(28),
        boxShadow: AppShadows.floating,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(tabs.length, (i) {
          final selected = index == i;
          final tab = tabs[i];
          return Expanded(
            child: _NavItem(
              icon: tab.icon,
              label: tab.label,
              selected: selected,
              onTap: () => onTap(i),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? Colors.white.withOpacity(0.18)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: selected
                  ? Colors.white
                  : Colors.white.withOpacity(0.55),
            ),
            // Label only visible on the selected tab — keeps the pill compact.
            // Flexible must be a direct child of Row, so it wraps AnimatedSize.
            Flexible(
              child: AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                child: selected
                    ? Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
