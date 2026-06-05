import 'package:daily_habits_tracking/core/icons/app_icons.dart';
import 'package:daily_habits_tracking/core/theme/app_colors.dart';
import 'package:daily_habits_tracking/core/theme/habit_palette.dart';
import 'package:daily_habits_tracking/features/habits/domain/habit_templates.dart';
import 'package:flutter/material.dart';

/// A wrap of tappable trending-habit presets. Tapping one calls [onPick].
/// Defaults to the full catalog, or pass [templates] to show a subset.
class HabitSuggestions extends StatelessWidget {
  const HabitSuggestions({super.key, required this.onPick, this.templates});

  final void Function(HabitTemplate template) onPick;
  final List<HabitTemplate>? templates;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final dark = c.isDark;
    final items = templates ?? kHabitTemplates;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final t in items)
          _SuggestionChip(
            template: t,
            color: HabitPalette.of(t.color, dark),
            onTap: () => onPick(t),
          ),
      ],
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({
    required this.template,
    required this.color,
    required this.onTap,
  });

  final HabitTemplate template;
  final HabitColor color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: c.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: color.soft,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Icon(
                AppIcons.resolve(template.icon),
                size: 17,
                color: color.base,
              ),
            ),
            const SizedBox(width: 9),
            Text(
              template.name,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                color: c.text,
              ),
            ),
            const SizedBox(width: 6),
            Icon(AppIcons.resolve('plus'), size: 15, color: c.textDim),
          ],
        ),
      ),
    );
  }
}
