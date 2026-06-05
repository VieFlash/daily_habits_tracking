import 'package:daily_habits_tracking/core/icons/app_icons.dart';
import 'package:daily_habits_tracking/core/presentation/widgets/app_card.dart';
import 'package:daily_habits_tracking/core/presentation/widgets/misc.dart';
import 'package:daily_habits_tracking/core/theme/app_colors.dart';
import 'package:daily_habits_tracking/core/theme/habit_palette.dart';
import 'package:daily_habits_tracking/features/profile/presentation/providers/profile_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GamificationScreen extends ConsumerWidget {
  const GamificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final dark = c.isDark;
    final user = ref.watch(userProfileProvider);
    final badges = ref.watch(badgesProvider);
    final got = badges.where((b) => b.got).length;

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: Column(
          children: [
            TopBar(title: 'Thành tựu', onBack: () => context.pop()),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                children: [
                  AppCard(
                    padding: const EdgeInsets.all(22),
                    border: const Border.fromBorderSide(BorderSide.none),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [c.amber, c.coral],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(26),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.emoji_events_outlined,
                            size: 42,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Cấp độ ${user.level}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$got/${badges.length} huy hiệu · ${user.xp} XP',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white.withValues(alpha: 0.92),
                          ),
                        ),
                        const SizedBox(height: 14),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 240),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(99),
                            child: LinearProgressIndicator(
                              value: user.xp / user.xpMax,
                              minHeight: 10,
                              backgroundColor:
                                  Colors.white.withValues(alpha: 0.28),
                              valueColor:
                                  const AlwaysStoppedAnimation(Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SectionLabel('Huy hiệu'),
                  GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.95,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      for (final b in badges)
                        Builder(
                          builder: (context) {
                            final hc = HabitPalette.of(b.color, dark);
                            return Opacity(
                              opacity: b.got ? 1 : 0.55,
                              child: AppCard(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 18,
                                ),
                                child: Stack(
                                  children: [
                                    if (!b.got)
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Icon(
                                          AppIcons.resolve('lock'),
                                          size: 15,
                                          color: c.textFaint,
                                        ),
                                      ),
                                    Column(
                                      children: [
                                        Container(
                                          width: 58,
                                          height: 58,
                                          decoration: BoxDecoration(
                                            color: b.got ? hc.soft : c.surface3,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          alignment: Alignment.center,
                                          child: Icon(
                                            AppIcons.resolve(b.icon),
                                            size: 30,
                                            color:
                                                b.got ? hc.base : c.textFaint,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          b.name,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w800,
                                            color: c.text,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          b.desc,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 11,
                                            height: 1.35,
                                            color: c.textDim,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
