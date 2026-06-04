import 'package:daily_habits_tracking/core/icons/app_icons.dart';
import 'package:daily_habits_tracking/core/theme/habit_palette.dart';
import 'package:flutter/material.dart';

/// Rounded colored icon tile for a habit (HabitTile in components.jsx).
class HabitTile extends StatelessWidget {
  const HabitTile({
    super.key,
    required this.icon,
    required this.color,
    required this.dark,
    this.size = 48,
    this.radius = 16,
  });

  final String icon;
  final String color;
  final bool dark;
  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final c = HabitPalette.of(color, dark);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: c.soft,
        borderRadius: BorderRadius.circular(radius),
      ),
      alignment: Alignment.center,
      child: Icon(AppIcons.resolve(icon), size: size * 0.5, color: c.base),
    );
  }
}
