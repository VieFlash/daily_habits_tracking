import 'package:daily_habits_tracking/core/icons/app_icons.dart';
import 'package:daily_habits_tracking/core/presentation/widgets/app_card.dart';
import 'package:daily_habits_tracking/core/presentation/widgets/buttons.dart';
import 'package:daily_habits_tracking/core/presentation/widgets/misc.dart';
import 'package:daily_habits_tracking/core/theme/app_colors.dart';
import 'package:daily_habits_tracking/core/theme/habit_palette.dart';
import 'package:daily_habits_tracking/features/journal/domain/entities/mood.dart';
import 'package:daily_habits_tracking/features/journal/presentation/providers/journal_providers.dart';
import 'package:daily_habits_tracking/features/journal/presentation/widgets/add_journal_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final dark = c.isDark;
    final entries = ref.watch(journalProvider);

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          TopBar(
            title: 'Nhật ký',
            subtitle: 'Ghi lại cảm xúc mỗi ngày',
            large: true,
            trailing: SoftIconButton(
              icon: 'plus',
              active: true,
              onTap: () => showAddJournalSheet(context, ref),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
            child: Column(
              children: [
                AppCard(
                  onTap: () => showAddJournalSheet(context, ref),
                  color: c.primarySoft,
                  border: const Border.fromBorderSide(BorderSide.none),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: c.surface,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          AppIcons.resolve('pencil'),
                          size: 20,
                          color: c.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hôm nay bạn thế nào?',
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w800,
                                color: c.text,
                              ),
                            ),
                            Text(
                              'Viết vài dòng nhé',
                              style: TextStyle(
                                fontSize: 12,
                                color: c.textDim,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(AppIcons.resolve('chevR'), size: 20, color: c.primary),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    for (final m in Mood.all)
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            final hc = HabitPalette.of(m.color, dark);
                            return Column(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: hc.soft,
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    AppIcons.resolve(m.icon),
                                    size: 26,
                                    color: hc.base,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  m.label,
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    color: c.textDim,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                  ],
                ),
                const SectionLabel('Gần đây'),
                for (final j in entries)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Builder(
                      builder: (context) {
                        final m = Mood.byKey(j.mood);
                        final hc = HabitPalette.of(m.color, dark);
                        return AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: hc.soft,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      AppIcons.resolve(m.icon),
                                      size: 20,
                                      color: hc.base,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          m.label,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800,
                                            color: c.text,
                                          ),
                                        ),
                                        Text(
                                          j.date,
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            color: c.textFaint,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                j.text,
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  fontWeight: FontWeight.w500,
                                  color: c.text,
                                ),
                              ),
                              if (j.habits.isNotEmpty) ...[
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: [
                                    for (final hb in j.habits)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: c.surface2,
                                          borderRadius:
                                              BorderRadius.circular(99),
                                        ),
                                        child: Text(
                                          '#$hb',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: c.textDim,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
