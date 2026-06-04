import 'package:daily_habits_tracking/core/presentation/widgets/misc.dart';
import 'package:daily_habits_tracking/core/theme/app_colors.dart';
import 'package:daily_habits_tracking/core/theme/habit_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_providers.dart';

/// Appearance tweaks (the TweaksPanel from app.jsx): accent color, corners,
/// home layout.
void showAppearanceSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: context.colors.surface,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) => const _AppearanceSheet(),
  );
}

class _AppearanceSheet extends ConsumerWidget {
  const _AppearanceSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 5,
                decoration: BoxDecoration(
                  color: c.borderStrong,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Tùy chỉnh giao diện',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: c.text,
              ),
            ),
            const SectionLabel('Màu chủ đạo'),
            Row(
              children: [
                for (var i = 0; i < HabitPalette.accents.length; i++)
                  GestureDetector(
                    onTap: () => notifier.setAccentIndex(i),
                    child: Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: settings.accentIndex == i
                              ? c.text
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: HabitPalette.accents[i],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SectionLabel('Bo góc'),
            Segmented(
              value: settings.corner,
              onChanged: notifier.setCorner,
              options: const [
                SegmentOption('rounded', 'Tròn'),
                SegmentOption('soft', 'Vừa'),
                SegmentOption('sharp', 'Sắc'),
              ],
            ),
            const SectionLabel('Bố cục thói quen'),
            Segmented(
              value: settings.layout,
              onChanged: notifier.setLayout,
              options: const [
                SegmentOption('card', 'Thẻ'),
                SegmentOption('list', 'Danh sách'),
                SegmentOption('grid', 'Lưới'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
