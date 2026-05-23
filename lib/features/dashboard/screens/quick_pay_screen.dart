import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_cure_ui/config/app_theme.dart';
import 'package:my_cure_ui/config/routes.dart';
import 'package:my_cure_ui/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:my_cure_ui/shared/widgets/app_animations.dart';

/// Quick Pay Screen — 3 simple steps:
///   1. Pick type
///   2. Enter account/consumer number
///   3. Review Bill Details and Pay
///
class QuickPayScreen extends StatefulWidget {
  const QuickPayScreen({super.key});

  @override
  State<QuickPayScreen> createState() => _QuickPayScreenState();
}

class _QuickPayScreenState extends State<QuickPayScreen> {
  int _step = 0;
  UtilityCategory? _category;
  final _canController = TextEditingController();
  final _mobileController = TextEditingController();

  @override
  void dispose() {
    _canController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  void _next() {
    FocusScope.of(context).unfocus();
    setState(() => _step = (_step + 1).clamp(0, 2));
  }
  void _back() {
    if (_step == 0) {
      Navigator.pop(context);
    } else {
      setState(() => _step--);
    }
  }

  bool get _canProceed {
    if (_step == 0) return _category != null;
    if (_step == 1) {
      return _canController.text.trim().length >= 6 && 
             _mobileController.text.trim().length >= 10;
    }
    return true; // Step 2 (Review) is always valid
  }

  void _finish() {
    final bloc = context.read<DashboardBloc>();
    final billData = {
      'id': _canController.text.trim().toUpperCase(),
      'name': '${_category!.label} Connection',
      'amount': 1250.00,
      'category': _category!.key,
      'status': 'unpaid',
      'date': '28 May 2026',
    };

    Navigator.pushNamed(
      context,
      AppRoutes.paymentGateway,
      arguments: {
        'selectedBills': [billData],
        'bloc': bloc,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          FadeSlideIn(
            offset: const Offset(0, -18),
            child: _Hero(step: _step, onBack: _back),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.12, 0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    )),
                    child: child,
                  ),
                );
              },
              child: KeyedSubtree(
                key: ValueKey(_step),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                  child: _buildStep(),
                ),
              ),
            ),
          ),
          if (_step > 0)
            _BottomBar(
              primaryLabel: _step == 2 ? 'Proceed to Pay' : 'Continue',
              tint: _category?.color ?? AppColors.primary,
              enabled: _canProceed,
              onPrimary: () {
                if (_step < 2) {
                  _next();
                } else {
                  _finish();
                }
              },
            ),
        ],
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _StepPickType(
          selected: _category,
          onSelect: (c) {
            setState(() {
              _category = c;
            });
            _next();
          },
        );
      case 1:
        return _StepCan(
          category: _category!,
          controller: _canController,
          mobileController: _mobileController,
          onChanged: (_) => setState(() {}),
        );
      default:
        return _StepBillDetails(
          category: _category!,
          consumerNumber: _canController.text.trim().toUpperCase(),
        );
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero header
// ─────────────────────────────────────────────────────────────────────────────

class _Hero extends StatelessWidget {
  const _Hero({required this.step, required this.onBack});
  final int step;
  final VoidCallback onBack;

  static const _titles = [
    'Quick Pay',
    'Enter your details',
    'Bill Details',
  ];

  static const _subtitles = [
    'Choose the service to pay',
    'We\'ll fetch your current bill',
    'Review and proceed to pay',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppGradients.brand,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _CircleButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: onBack,
                  ),
                  const Spacer(),
                  _StepDots(current: step),
                ],
              ),
              const SizedBox(height: 22),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 240),
                child: Text(
                  _titles[step],
                  key: ValueKey('title-$step'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 240),
                child: Text(
                  _subtitles[step],
                  key: ValueKey('sub-$step'),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.80),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadii.pill),
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.16),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.32)),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}

class _StepDots extends StatelessWidget {
  const _StepDots({required this.current});
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (i) {
        final active = i == current;
        final done = i < current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          height: 6,
          width: active ? 20 : 6,
          decoration: BoxDecoration(
            color: active
                ? Colors.white
                : done
                    ? Colors.white.withOpacity(0.70)
                    : Colors.white.withOpacity(0.30),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 1 — Pick category
// ─────────────────────────────────────────────────────────────────────────────

class _ServiceItem {
  final UtilityCategory category;
  final String title;
  final IconData icon;
  final Color color;

  const _ServiceItem({
    required this.category,
    required this.title,
    required this.icon,
    required this.color,
  });
}

class _StepPickType extends StatelessWidget {
  const _StepPickType({required this.selected, required this.onSelect});
  final UtilityCategory? selected;
  final ValueChanged<UtilityCategory> onSelect;

  @override
  Widget build(BuildContext context) {
    final services = [
      const _ServiceItem(
        category: UtilityCategory.electricity,
        title: 'Electricity',
        icon: Icons.bolt_rounded,
        color: AppColors.catElectricity,
      ),
      const _ServiceItem(
        category: UtilityCategory.water,
        title: 'Water Bill',
        icon: Icons.water_drop_rounded,
        color: AppColors.catWater,
      ),
      const _ServiceItem(
        category: UtilityCategory.propertyTax,
        title: 'Property Tax',
        icon: Icons.home_work_rounded,
        color: AppColors.catPropertyTax,
      ),
      const _ServiceItem(
        category: UtilityCategory.trade,
        title: 'Trade License',
        icon: Icons.badge_outlined,
        color: AppColors.catTrade,
      ),
      const _ServiceItem(
        category: UtilityCategory.echallan,
        title: 'Traffic Challans',
        icon: Icons.local_police_outlined,
        color: AppColors.catEChallan,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select a Service',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textBody,
          ),
        ),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: services.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = services[index];
            return InkWell(
              onTap: () => onSelect(item.category),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
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
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: item.color.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item.icon,
                        color: item.color,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textBody,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textMuted,
                      size: 22,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 2 — Enter CAN
// ─────────────────────────────────────────────────────────────────────────────

class _StepCan extends StatelessWidget {
  const _StepCan({
    required this.category,
    required this.controller,
    required this.mobileController,
    required this.onChanged,
  });

  final UtilityCategory category;
  final TextEditingController controller;
  final TextEditingController mobileController;
  final ValueChanged<String> onChanged;

  String get _label {
    switch (category.key) {
      case 'hmwssb':
        return 'CAN Number';
      case 'electricity':
        return 'USCNo / Service Number';
      case 'property_tax':
        return 'PTIN';
      case 'echallan':
        return 'Vehicle / Challan Number';
      case 'trade':
        return 'Trade License Number';
      default:
        return 'Connection Number';
    }
  }

  String _placeholder() {
    switch (category.key) {
      case 'hmwssb':
        return 'CAN987654321';
      case 'electricity':
        return 'USC1234567';
      case 'property_tax':
        return 'PTIN12345678';
      case 'echallan':
        return 'TS09AB1234';
      case 'trade':
        return 'TRD2024001';
      default:
        return 'ABC123456';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selected-category indicator
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadii.lg),
            border:
                Border.all(color: category.color.withOpacity(0.18)),
            boxShadow: [
              BoxShadow(
                color: category.color.withOpacity(0.20),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: category.color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(category.icon, color: category.color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  category.label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
              Icon(Icons.check_circle_rounded,
                  color: category.color, size: 20),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Text(
          _label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          textCapitalization: TextCapitalization.characters,
          autofocus: true,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
          ],
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryDark,
            letterSpacing: 0.5,
          ),
          decoration: InputDecoration(
            hintText: _placeholder(),
            hintStyle: const TextStyle(
              color: AppColors.textMuted,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: Icon(Icons.tag_rounded,
                color: category.color, size: 20),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.md),
              borderSide:
                  BorderSide(color: category.color.withOpacity(0.20)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.md),
              borderSide: BorderSide(color: category.color, width: 1.6),
            ),
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          'Mobile Number',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: mobileController,
          onChanged: onChanged,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryDark,
            letterSpacing: 0.5,
          ),
          decoration: InputDecoration(
            hintText: 'Enter 10 digit number',
            hintStyle: const TextStyle(
              color: AppColors.textMuted,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: Icon(Icons.phone_iphone_rounded,
                color: category.color, size: 20),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.md),
              borderSide:
                  BorderSide(color: category.color.withOpacity(0.20)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.md),
              borderSide: BorderSide(color: category.color, width: 1.6),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 3 — Bill Details
// ─────────────────────────────────────────────────────────────────────────────

class _StepBillDetails extends StatelessWidget {
  const _StepBillDetails({
    required this.category,
    required this.consumerNumber,
  });

  final UtilityCategory category;
  final String consumerNumber;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadii.lg),
            border: Border.all(color: category.color.withOpacity(0.18)),
            boxShadow: [
              BoxShadow(
                color: category.color.withOpacity(0.10),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: category.color.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(category.icon, color: category.color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Biller',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textMuted,
                          ),
                        ),
                        Text(
                          category.label,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(color: AppColors.border, height: 1),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Consumer Name',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Naveen Kumar',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textBody,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Due Date',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          '28 May 2026',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.danger,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Consumer Number',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          consumerNumber,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textBody,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(color: AppColors.border, height: 1),
              ),
              const Text(
                'Bill Amount',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '₹1,250.00',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: category.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom bar
// ─────────────────────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.primaryLabel,
    required this.tint,
    required this.enabled,
    required this.onPrimary,
  });

  final String primaryLabel;
  final Color tint;
  final bool enabled;
  final VoidCallback onPrimary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 12, 20, 12 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: tint.withOpacity(0.10),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: enabled ? onPrimary : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: enabled ? tint : AppColors.border,
            disabledBackgroundColor: AppColors.border,
            disabledForegroundColor: AppColors.textMuted,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            elevation: enabled ? 6 : 0,
            shadowColor: tint.withOpacity(0.45),
          ),
          child: Text(
            primaryLabel,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}
