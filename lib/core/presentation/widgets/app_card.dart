import 'package:daily_habits_tracking/core/theme/app_colors.dart';
import 'package:daily_habits_tracking/core/theme/app_radii.dart';
import 'package:flutter/material.dart';

/// Surface card with the soft shadow + border used throughout the design.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.color,
    this.border,
    this.gradient,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final BoxBorder? border;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = BorderRadius.circular(context.radii.card);
    final decoration = BoxDecoration(
      color: gradient == null ? (color ?? c.surface) : null,
      gradient: gradient,
      borderRadius: radius,
      border: border ?? Border.all(color: c.border),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: c.isDark ? 0.30 : 0.05),
          blurRadius: 20,
          offset: const Offset(0, 6),
        ),
      ],
    );
    final content = Padding(padding: padding, child: child);
    if (onTap == null) {
      return DecoratedBox(decoration: decoration, child: content);
    }
    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: Ink(
        decoration: decoration,
        child: InkWell(borderRadius: radius, onTap: onTap, child: content),
      ),
    );
  }
}
