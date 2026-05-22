import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_cure_ui/config/app_theme.dart';
import 'package:my_cure_ui/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:my_cure_ui/shared/widgets/app_animations.dart';

/// Register a new utility — 3 simple steps:
///   1. Pick type
///   2. Enter account/consumer number
///   3. Verify with OTP
///
/// Visual language matches the rest of Cure One: gradient hero, tinted
/// cards with colored shadows, animated entry.
class RegisterUtilityScreen extends StatefulWidget {
  const RegisterUtilityScreen({super.key});

  @override
  State<RegisterUtilityScreen> createState() => _RegisterUtilityScreenState();
}

class _RegisterUtilityScreenState extends State<RegisterUtilityScreen> {
  int _step = 0;
  UtilityCategory? _category;
  final _canController = TextEditingController();
  final _otp = List.generate(4, (_) => TextEditingController());
  final _otpFocus = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    _canController.dispose();
    for (final c in _otp) {
      c.dispose();
    }
    for (final f in _otpFocus) {
      f.dispose();
    }
    super.dispose();
  }

  void _next() => setState(() => _step = (_step + 1).clamp(0, 2));
  void _back() {
    if (_step == 0) {
      Navigator.pop(context);
    } else {
      setState(() => _step--);
    }
  }

  bool get _canProceed {
    if (_step == 0) return _category != null;
    if (_step == 1) return _canController.text.trim().length >= 6;
    return _otp.every((c) => c.text.isNotEmpty);
  }

  void _finish() {
    final bloc = context.read<DashboardBloc>();
    bloc.add(AddUtilityBill(
      id: _canController.text.trim().toUpperCase(),
      name: '${_category!.label} Connection',
      amount: 0.00,
      category: _category!.key,
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_category!.label} registered successfully'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
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
                  padding:
                      const EdgeInsets.fromLTRB(20, 22, 20, 20),
                  child: _buildStep(),
                ),
              ),
            ),
          ),
          _BottomBar(
            primaryLabel: _step == 2 ? 'Verify & Save' : 'Continue',
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
          onSelect: (c) => setState(() => _category = c),
        );
      case 1:
        return _StepCan(
          category: _category!,
          controller: _canController,
          onChanged: (_) => setState(() {}),
        );
      default:
        return _StepOtp(
          mobile: '+91 98765 43210',
          controllers: _otp,
          focusNodes: _otpFocus,
          tint: _category!.color,
          onChanged: () => setState(() {}),
        );
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero header (gradient + back button + step dots)
// ─────────────────────────────────────────────────────────────────────────────

class _Hero extends StatelessWidget {
  const _Hero({required this.step, required this.onBack});
  final int step;
  final VoidCallback onBack;

  static final _titles = [
    'Pick a utility',
    'Enter your details',
    'Verify with OTP',
  ];

  static final _subtitles = [
    'Choose the service you want to add',
    'We\'ll fetch your dues automatically',
    'Confirm it\'s really you',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppGradients.brand,
        borderRadius: const BorderRadius.only(
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

class _StepPickType extends StatelessWidget {
  const _StepPickType({required this.selected, required this.onSelect});
  final UtilityCategory? selected;
  final ValueChanged<UtilityCategory> onSelect;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: UtilityCategory.all.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.35,
      ),
      itemBuilder: (context, i) {
        final cat = UtilityCategory.all[i];
        final isSelected = cat.key == selected?.key;
        return FadeSlideIn(
          delay: Duration(milliseconds: 60 * i),
          child: PressableScale(
            onTap: () => onSelect(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(AppRadii.lg),
                border: Border.all(
                  color: isSelected
                      ? cat.color
                      : cat.color.withOpacity(0.18),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: cat.color.withOpacity(isSelected ? 0.32 : 0.16),
                    blurRadius: isSelected ? 22 : 14,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: cat.color.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(cat.icon, color: cat.color, size: 22),
                      ),
                      AnimatedScale(
                        scale: isSelected ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(Icons.check_circle_rounded,
                            color: cat.color, size: 22),
                      ),
                    ],
                  ),
                  Text(
                    cat.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color:
                          isSelected ? cat.color : AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
    required this.onChanged,
  });

  final UtilityCategory category;
  final TextEditingController controller;
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
            color: AppColors.surfaceAlt,
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
                  style: TextStyle(
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
          style: TextStyle(
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
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryDark,
            letterSpacing: 0.5,
          ),
          decoration: InputDecoration(
            hintText: _placeholder(),
            hintStyle: TextStyle(
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
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: category.color.withOpacity(0.06),
            borderRadius: BorderRadius.circular(AppRadii.md),
            border: Border.all(color: category.color.withOpacity(0.12)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  color: category.color, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Find this on any previous ${category.label.toLowerCase()} bill.',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
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
// Step 3 — OTP
// ─────────────────────────────────────────────────────────────────────────────

class _StepOtp extends StatefulWidget {
  const _StepOtp({
    required this.mobile,
    required this.controllers,
    required this.focusNodes,
    required this.tint,
    required this.onChanged,
  });

  final String mobile;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final Color tint;
  final VoidCallback onChanged;

  @override
  State<_StepOtp> createState() => _StepOtpState();
}

class _StepOtpState extends State<_StepOtp> {
  Timer? _timer;
  int _seconds = 30;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _seconds = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds == 0) {
        t.cancel();
        if (mounted) setState(() {});
      } else {
        setState(() => _seconds--);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceAlt,
            borderRadius: BorderRadius.circular(AppRadii.lg),
            border: Border.all(color: widget.tint.withOpacity(0.18)),
            boxShadow: [
              BoxShadow(
                color: widget.tint.withOpacity(0.20),
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
                  color: widget.tint.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.sms_rounded,
                    color: widget.tint, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OTP sent to',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted,
                      ),
                    ),
                    Text(
                      widget.mobile,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(4, (i) {
            return SizedBox(
              width: 64,
              height: 64,
              child: TextField(
                controller: widget.controllers[i],
                focusNode: widget.focusNodes[i],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                autofocus: i == 0,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: widget.tint,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadii.md),
                    borderSide:
                        BorderSide(color: widget.tint.withOpacity(0.22)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadii.md),
                    borderSide:
                        BorderSide(color: widget.tint, width: 1.8),
                  ),
                ),
                onChanged: (v) {
                  if (v.isNotEmpty && i < 3) {
                    widget.focusNodes[i + 1].requestFocus();
                  } else if (v.isEmpty && i > 0) {
                    widget.focusNodes[i - 1].requestFocus();
                  }
                  widget.onChanged();
                },
              ),
            );
          }),
        ),
        const SizedBox(height: 20),
        Center(
          child: _seconds > 0
              ? Text(
                  'Resend in 0:${_seconds.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                )
              : TextButton.icon(
                  onPressed: _startTimer,
                  icon: Icon(Icons.refresh_rounded,
                      size: 16, color: widget.tint),
                  label: Text(
                    'Resend OTP',
                    style: TextStyle(
                      color: widget.tint,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
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
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
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
