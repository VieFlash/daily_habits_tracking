import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/app_icons.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/habit_palette.dart';
import '../data/seed_data.dart';
import '../providers/habits_provider.dart';
import '../widgets/app_card.dart';
import '../widgets/buttons.dart';
import '../widgets/check_circle.dart';
import '../widgets/habit_tile.dart';
import '../widgets/misc.dart';

class HabitDetailScreen extends ConsumerStatefulWidget {
  const HabitDetailScreen({super.key, required this.id});

  final String id;

  @override
  ConsumerState<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends ConsumerState<HabitDetailScreen> {
  String _tab = 'overview';

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final dark = c.isDark;
    final habits = ref.watch(habitsProvider);
    final matches = habits.where((x) => x.id == widget.id);
    final h = matches.isEmpty ? null : matches.first;
    if (h == null) {
      return Scaffold(
        backgroundColor: c.bg,
        body: SafeArea(
          child: Column(
            children: [
              TopBar(title: 'Thói quen', onBack: () => context.pop()),
              const Expanded(child: Center(child: Text('Không tìm thấy'))),
            ],
          ),
        ),
      );
    }
    final hc = HabitPalette.of(h.color, dark);

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: Column(
          children: [
            TopBar(
              title: h.name,
              onBack: () => context.pop(),
              trailing: SoftIconButton(
                icon: 'edit',
                onTap: () => context.push('/create?editId=${h.id}'),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                children: [
                  Row(
                    children: [
                      HabitTile(
                        icon: h.icon,
                        color: h.color,
                        dark: dark,
                        size: 58,
                        radius: 20,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              h.cat,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: hc.base,
                              ),
                            ),
                            Text(
                              h.goalText,
                              style: TextStyle(
                                fontSize: 13.5,
                                color: c.textDim,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CheckCircle(
                        done: h.done,
                        color: h.color,
                        dark: dark,
                        size: 40,
                        onTap: () =>
                            ref.read(habitsProvider.notifier).toggle(h.id),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        _StatPill(
                          icon: 'fire',
                          value: '${h.streak}',
                          label: 'chuỗi hiện tại',
                          color: c.coral,
                        ),
                        _divider(c),
                        _StatPill(
                          icon: 'trophy',
                          value: '${h.best}',
                          label: 'chuỗi dài nhất',
                          color: c.amber,
                        ),
                        _divider(c),
                        _StatPill(
                          icon: 'target',
                          value: '${h.rate}%',
                          label: 'tỉ lệ hoàn thành',
                          color: hc.base,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Segmented(
                    value: _tab,
                    onChanged: (v) => setState(() => _tab = v),
                    options: const [
                      SegmentOption('overview', 'Lịch sử'),
                      SegmentOption('calendar', 'Lịch'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_tab == 'overview')
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Heatmap 18 tuần qua',
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                              color: c.text,
                            ),
                          ),
                          const SizedBox(height: 14),
                          _Heatmap(colorKey: h.color, dark: dark),
                        ],
                      ),
                    )
                  else
                    AppCard(child: _MiniCalendar(colorKey: h.color, dark: dark)),
                  const SectionLabel('Tuần này'),
                  AppCard(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (var i = 0; i < SeedData.weekLabels.length; i++)
                          Column(
                            children: [
                              Text(
                                SeedData.weekLabels[i],
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: c.textFaint,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: (i < h.weekDone.length &&
                                          h.weekDone[i] == 1)
                                      ? hc.base
                                      : c.surface3,
                                ),
                                alignment: Alignment.center,
                                child: (i < h.weekDone.length &&
                                        h.weekDone[i] == 1)
                                    ? const Icon(
                                        Icons.check_rounded,
                                        size: 16,
                                        color: Colors.white,
                                      )
                                    : Container(
                                        width: 5,
                                        height: 5,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: c.textFaint,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SectionLabel('Ghi chú'),
                  AppCard(
                    child: Row(
                      children: [
                        Icon(AppIcons.resolve('pen'), size: 18, color: c.textDim),
                        const SizedBox(width: 10),
                        Text(
                          'Thêm cảm nghĩ về thói quen này...',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: c.textDim,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider(AppColors c) =>
      Container(width: 1, height: 44, color: c.border);
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final String icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        child: Column(
          children: [
            Icon(AppIcons.resolve(icon), size: 22, color: color),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: c.text,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.5,
                color: c.textDim,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Heatmap extends StatelessWidget {
  const _Heatmap({required this.colorKey, required this.dark});

  final String colorKey;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final hc = HabitPalette.of(colorKey, dark);
    final data = SeedData.heatmap();
    final levels = [
      c.surface3,
      Color.lerp(c.surface, hc.base, 0.30)!,
      Color.lerp(c.surface, hc.base, 0.55)!,
      Color.lerp(c.surface, hc.base, 0.80)!,
      hc.base,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var w = 0; w < SeedData.heatmapWeeks; w++) ...[
                if (w > 0) const SizedBox(width: 4),
                Column(
                  children: [
                    for (var d = 0; d < 7; d++) ...[
                      if (d > 0) const SizedBox(height: 4),
                      Container(
                        width: 13,
                        height: 13,
                        decoration: BoxDecoration(
                          color: levels[data[w * 7 + d]],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Ít',
              style: TextStyle(
                fontSize: 11,
                color: c.textDim,
                fontWeight: FontWeight.w600,
              ),
            ),
            for (final l in levels) ...[
              const SizedBox(width: 5),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: l,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
            const SizedBox(width: 5),
            Text(
              'Nhiều',
              style: TextStyle(
                fontSize: 11,
                color: c.textDim,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MiniCalendar extends StatelessWidget {
  const _MiniCalendar({required this.colorKey, required this.dark});

  final String colorKey;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final hc = HabitPalette.of(colorKey, dark);
    final today = DateTime.now();
    final first = DateTime(today.year, today.month, 1);
    final startDow = (first.weekday - 1) % 7;
    final daysInMonth = DateTime(today.year, today.month + 1, 0).day;
    const months = [
      'Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6',
      'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12',
    ];
    final cells = <int?>[
      for (var i = 0; i < startDow; i++) null,
      for (var d = 1; d <= daysInMonth; d++) d,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${months[today.month - 1]} ${today.year}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: c.text,
              ),
            ),
            Row(
              children: [
                SoftIconButton(icon: 'chevL', size: 32),
                const SizedBox(width: 6),
                SoftIconButton(icon: 'chevR', size: 32),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: [
            for (final l in SeedData.weekLabels)
              Center(
                child: Text(
                  l,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: c.textFaint,
                  ),
                ),
              ),
            for (final d in cells)
              if (d == null)
                const SizedBox()
              else
                _calendarCell(c, hc, d, today),
          ],
        ),
      ],
    );
  }

  Widget _calendarCell(AppColors c, HabitColor hc, int d, DateTime today) {
    final isToday = d == today.day;
    final done = d <= today.day && SeedData.seeded(d * 1.7 + 3) > 0.32;
    final miss = d <= today.day && !done && !isToday;
    return Container(
      decoration: BoxDecoration(
        color: done ? hc.soft : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isToday ? Border.all(color: c.primary, width: 2) : null,
      ),
      alignment: Alignment.center,
      child: Text(
        '$d',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: done
              ? hc.base
              : isToday
              ? c.primary
              : miss
              ? c.textFaint
              : c.text,
        ),
      ),
    );
  }
}
