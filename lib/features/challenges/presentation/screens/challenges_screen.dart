import 'package:daily_habits_tracking/core/icons/app_icons.dart';
import 'package:daily_habits_tracking/core/presentation/widgets/app_card.dart';
import 'package:daily_habits_tracking/core/presentation/widgets/buttons.dart';
import 'package:daily_habits_tracking/core/presentation/widgets/flash.dart';
import 'package:daily_habits_tracking/core/presentation/widgets/habit_tile.dart';
import 'package:daily_habits_tracking/core/presentation/widgets/misc.dart';
import 'package:daily_habits_tracking/core/theme/app_colors.dart';
import 'package:daily_habits_tracking/core/theme/habit_palette.dart';
import 'package:daily_habits_tracking/core/util/number_format.dart';
import 'package:daily_habits_tracking/features/challenges/presentation/providers/challenge_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChallengesScreen extends ConsumerStatefulWidget {
  const ChallengesScreen({super.key});

  @override
  ConsumerState<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends ConsumerState<ChallengesScreen> {
  String _tab = 'mine';

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final dark = c.isDark;
    final all = ref.watch(challengesProvider);
    final list = _tab == 'mine'
        ? all.where((ch) => ch.joined).toList()
        : all.where((ch) => !ch.joined).toList();

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const TopBar(
            title: 'Thử thách',
            subtitle: 'Cùng cộng đồng giữ vững phong độ',
            large: true,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Segmented(
              value: _tab,
              onChanged: (v) => setState(() => _tab = v),
              options: const [
                SegmentOption('mine', 'Đang tham gia'),
                SegmentOption('explore', 'Khám phá'),
              ],
            ),
          ),
          for (final ch in list)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Builder(
                builder: (context) {
                  final hc = HabitPalette.of(ch.color, dark);
                  return AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HabitTile(
                              icon: ch.icon,
                              color: ch.color,
                              dark: dark,
                              size: 50,
                              radius: 18,
                            ),
                            const SizedBox(width: 13),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ch.name,
                                    style: TextStyle(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w800,
                                      color: c.text,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    children: [
                                      Icon(AppIcons.resolve('user'),
                                          size: 13, color: c.textDim),
                                      const SizedBox(width: 3),
                                      Text(
                                        formatThousands(ch.people),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: c.textDim,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Icon(AppIcons.resolve('clock'),
                                          size: 13, color: c.textDim),
                                      const SizedBox(width: 3),
                                      Flexible(
                                        child: Text(
                                          ch.days,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: c.textDim,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        if (ch.joined)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Ngày ${ch.current}/${ch.total}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: hc.base,
                                    ),
                                  ),
                                  Text(
                                    '${(ch.progress * 100).round()}%',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: c.textDim,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(99),
                                child: LinearProgressIndicator(
                                  value: ch.progress,
                                  minHeight: 9,
                                  backgroundColor: c.surface3,
                                  valueColor: AlwaysStoppedAnimation(hc.base),
                                ),
                              ),
                            ],
                          )
                        else
                          AppButton(
                            label: 'Tham gia thử thách',
                            icon: 'plus',
                            variant: AppButtonVariant.soft,
                            size: AppButtonSize.sm,
                            full: true,
                            onPressed: () {
                              ref
                                  .read(challengesProvider.notifier)
                                  .join(ch.id);
                              showFlash(
                                context,
                                'Đã tham gia ${ch.name} 🎯',
                                icon: 'check',
                              );
                              setState(() {});
                            },
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 96),
        ],
      ),
    );
  }
}
