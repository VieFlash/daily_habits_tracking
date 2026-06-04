import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/habit_palette.dart';

/// The animated check-in control (CheckCircle in components.jsx).
class CheckCircle extends StatelessWidget {
  const CheckCircle({
    super.key,
    required this.done,
    required this.color,
    required this.dark,
    this.size = 34,
    this.onTap,
  });

  final bool done;
  final String color;
  final bool dark;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = HabitPalette.of(color, dark);
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutBack,
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: done ? c.base : Colors.transparent,
          border: done
              ? null
              : Border.all(color: colors.borderStrong, width: 2.5),
        ),
        alignment: Alignment.center,
        child: AnimatedScale(
          scale: done ? 1 : 0.4,
          duration: const Duration(milliseconds: 250),
          child: AnimatedOpacity(
            opacity: done ? 1 : 0,
            duration: const Duration(milliseconds: 250),
            child: Icon(
              Icons.check_rounded,
              size: size * 0.6,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
