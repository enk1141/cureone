import 'package:flutter/material.dart';

/// Fades + slides a child in from below. Use `delay` to stagger lists.
///
///   FadeSlideIn(delay: Duration(milliseconds: 120), child: SomeCard())
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 520),
    this.offset = const Offset(0, 24),
    this.curve = Curves.easeOutCubic,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset offset;
  final Curve curve;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: widget.duration);

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = CurvedAnimation(parent: _c, curve: widget.curve);
    return AnimatedBuilder(
      animation: t,
      builder: (_, child) {
        return Opacity(
          opacity: t.value,
          child: Transform.translate(
            offset: Offset(
              widget.offset.dx * (1 - t.value),
              widget.offset.dy * (1 - t.value),
            ),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// Animated rupee counter that counts up to [value] on the first build and
/// re-animates between changes. Uses the same formatter as the caller via
/// the [format] callback.
class AnimatedCounter extends StatelessWidget {
  const AnimatedCounter({
    super.key,
    required this.value,
    required this.style,
    this.duration = const Duration(milliseconds: 900),
    this.format,
    this.prefix = '',
  });

  final double value;
  final TextStyle style;
  final Duration duration;
  final String Function(double)? format;
  final String prefix;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (_, v, __) {
        final formatted = format?.call(v) ?? v.toStringAsFixed(2);
        return Text('$prefix$formatted', style: style);
      },
    );
  }
}

/// Wraps a child with a subtle scale-down on press for tactile feedback.
class PressableScale extends StatefulWidget {
  const PressableScale({
    super.key,
    required this.child,
    required this.onTap,
    this.scale = 0.96,
  });

  final Widget child;
  final VoidCallback onTap;
  final double scale;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? widget.scale : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// Convenience: takes a list of children and wraps each in FadeSlideIn with a
/// stagger delay. The first child starts after [initialDelay].
class StaggeredColumn extends StatelessWidget {
  const StaggeredColumn({
    super.key,
    required this.children,
    this.initialDelay = Duration.zero,
    this.stagger = const Duration(milliseconds: 80),
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  final List<Widget> children;
  final Duration initialDelay;
  final Duration stagger;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: List.generate(children.length, (i) {
        return FadeSlideIn(
          delay: initialDelay + stagger * i,
          child: children[i],
        );
      }),
    );
  }
}
