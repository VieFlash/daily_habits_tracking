import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/app_icons.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/habit_palette.dart';
import '../data/models/habit.dart';
import '../data/seed_data.dart';
import '../providers/habits_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/app_card.dart';
import '../widgets/buttons.dart';
import '../widgets/check_circle.dart';
import '../widgets/flash.dart';
import '../widgets/habit_tile.dart';
import '../widgets/misc.dart';
import '../widgets/progress_ring.dart';
import '../widgets/sheets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _filter = 'all';

  void _toggle(Habit h) {
    final becameDone = ref.read(habitsProvider.notifier).toggle(h.id);
    if (becameDone) {
      showFlash(context, '+10 XP · ${h.name} ✓', icon: 'sparkle');
    }
  }

  void _cycleLayout() {
    final next = ref.read(settingsProvider.notifier).cycleLayout();
    final label = next == 'card'
        ? 'Thẻ lớn'
        : next == 'list'
        ? 'Danh sách'
        : 'Lưới';
    showFlash(context, 'Bố cục: $label', icon: 'grid');
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final habits = ref.watch(habitsProvider);
    final layout = ref.watch(settingsProvider.select((s) => s.layout));
    final dark = c.isDark;

    final cats = {for (final h in habits) h.cat}.toList();
    List<Habit> list = habits;
    if (_filter == 'todo') {
      list = habits.where((h) => !h.done).toList();
    } else if (_filter == 'done') {
      list = habits.where((h) => h.done).toList();
    } else if (_filter != 'all') {
      list = habits.where((h) => h.cat == _filter).toList();
    }

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _Greeting(
            name: SeedData.user.name,
            layout: layout,
            onCycleLayout: _cycleLayout,
            onBell: () => showNotificationsSheet(context),
            onProfile: () => context.push('/profile'),
          ),
          const _WeekStrip(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: _SummaryCard(habits: habits),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Row(
              children: [
                AppChip(
                  label: 'Tất cả',
                  active: _filter == 'all',
                  onTap: () => setState(() => _filter = 'all'),
                ),
                const SizedBox(width: 8),
                AppChip(
                  label: 'Chưa xong',
                  active: _filter == 'todo',
                  onTap: () => setState(() => _filter = 'todo'),
                ),
                const SizedBox(width: 8),
                AppChip(
                  label: 'Đã xong',
                  active: _filter == 'done',
                  onTap: () => setState(() => _filter = 'done'),
                ),
                for (final cat in cats) ...[
                  const SizedBox(width: 8),
                  AppChip(
                    label: cat,
                    active: _filter == cat,
                    onTap: () => setState(() => _filter = cat),
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 110),
            child: list.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        Icon(
                          AppIcons.resolve('check'),
                          size: 40,
                          color: c.primary,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Không có gì ở đây cả',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: c.textDim,
                          ),
                        ),
                      ],
                    ),
                  )
                : layout == 'grid'
                ? GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.92,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      for (final h in list)
                        _HabitGridTile(
                          h: h,
                          dark: dark,
                          onToggle: () => _toggle(h),
                          onOpen: () => context.push('/detail/${h.id}'),
                        ),
                    ],
                  )
                : Column(
                    children: [
                      for (final h in list)
                        layout == 'card'
                            ? _HabitCardBig(
                                h: h,
                                dark: dark,
                                onToggle: () => _toggle(h),
                                onOpen: () => context.push('/detail/${h.id}'),
                              )
                            : _HabitRow(
                                h: h,
                                dark: dark,
                                onToggle: () => _toggle(h),
                                onOpen: () => context.push('/detail/${h.id}'),
                              ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

}

class _Greeting extends StatelessWidget {
  const _Greeting({
    required this.name,
    required this.layout,
    required this.onCycleLayout,
    required this.onBell,
    required this.onProfile,
  });

  final String name;
  final String layout;
  final VoidCallback onCycleLayout;
  final VoidCallback onBell;
  final VoidCallback onProfile;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final hr = DateTime.now().hour;
    final g = hr < 11
        ? 'Chào buổi sáng'
        : hr < 18
        ? 'Buổi chiều tốt lành'
        : 'Buổi tối an lành';
    final layoutIcon = layout == 'list' ? 'grid' : layout == 'grid' ? 'list' : 'grid';
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 2),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$g 👋',
                  style: TextStyle(
                    fontSize: 13.5,
                    color: c.textDim,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                    color: c.text,
                  ),
                ),
              ],
            ),
          ),
          SoftIconButton(icon: layoutIcon, onTap: onCycleLayout),
          const SizedBox(width: 8),
          SoftIconButton(icon: 'bell', badge: true, onTap: onBell),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onProfile,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: c.primarySoft, width: 2),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [c.primary, c.primarySoft2],
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                SeedData.user.initials,
                style: TextStyle(
                  color: c.onPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekStrip extends StatelessWidget {
  const _WeekStrip();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final today = DateTime.now();
    final days = <_WeekDay>[];
    for (var i = -3; i <= 3; i++) {
      final d = today.add(Duration(days: i));
      days.add(
        _WeekDay(
          SeedData.weekLabels[(d.weekday - 1) % 7],
          d.day,
          i == 0,
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      child: Row(
        children: [
          for (var i = 0; i < days.length; i++) ...[
            if (i > 0) const SizedBox(width: 6),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: days[i].today ? c.primary : c.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: days[i].today ? null : Border.all(color: c.border),
                ),
                child: Column(
                  children: [
                    Text(
                      days[i].dow,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: days[i].today
                            ? c.onPrimary.withValues(alpha: 0.9)
                            : c.text.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${days[i].num}',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: days[i].today ? c.onPrimary : c.text,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (!days[i].today)
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: c.primary.withValues(alpha: 0.5),
                        ),
                      )
                    else
                      const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _WeekDay {
  const _WeekDay(this.dow, this.num, this.today);
  final String dow;
  final int num;
  final bool today;
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.habits});

  final List<Habit> habits;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final done = habits.where((h) => h.done).length;
    final total = habits.length;
    final pct = total == 0 ? 0.0 : done / total;
    final msg = pct == 1
        ? 'Hoàn hảo! Bạn đã xong tất cả 🎉'
        : pct >= 0.5
        ? 'Tiến độ tốt, cố lên!'
        : 'Bắt đầu ngày mới nào!';
    return AppCard(
      padding: const EdgeInsets.all(18),
      border: const Border.fromBorderSide(BorderSide.none),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [c.primary, c.primaryPress],
      ),
      child: Row(
        children: [
          ProgressRing(
            value: done.toDouble(),
            max: total.toDouble(),
            size: 68,
            stroke: 7,
            color: Colors.white,
            track: Colors.white.withValues(alpha: 0.28),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${(pct * 100).round()}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const TextSpan(
                    text: '%',
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$done/$total thói quen',
                  style: const TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  msg,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.92),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(Icons.local_fire_department_rounded,
                    size: 20, color: Colors.white),
                const SizedBox(height: 2),
                const Text(
                  '31',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'chuỗi dài',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.9),
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

class _HabitRow extends StatelessWidget {
  const _HabitRow({
    required this.h,
    required this.dark,
    required this.onToggle,
    required this.onOpen,
  });

  final Habit h;
  final bool dark;
  final VoidCallback onToggle;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final hc = HabitPalette.of(h.color, dark);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Opacity(
        opacity: h.done ? 0.7 : 1,
        child: AppCard(
          padding: const EdgeInsets.all(12),
          onTap: onOpen,
          child: Row(
            children: [
              HabitTile(icon: h.icon, color: h.color, dark: dark, size: 46),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      h.name,
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: c.text,
                        decoration:
                            h.done ? TextDecoration.lineThrough : null,
                        decorationColor: c.textFaint,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(AppIcons.resolve('clock'), size: 13, color: c.textDim),
                        const SizedBox(width: 3),
                        Text(
                          h.time,
                          style: TextStyle(
                            fontSize: 12,
                            color: c.textDim,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(AppIcons.resolve('fire'), size: 13, color: hc.base),
                        const SizedBox(width: 3),
                        Text(
                          '${h.streak}',
                          style: TextStyle(
                            fontSize: 12,
                            color: hc.base,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (h.target > 1 && !h.done)
                Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: Text(
                    '${h.progress}/${h.target}',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: c.textDim,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              CheckCircle(
                done: h.done,
                color: h.color,
                dark: dark,
                onTap: onToggle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HabitCardBig extends StatelessWidget {
  const _HabitCardBig({
    required this.h,
    required this.dark,
    required this.onToggle,
    required this.onOpen,
  });

  final Habit h;
  final bool dark;
  final VoidCallback onToggle;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final hc = HabitPalette.of(h.color, dark);
    final pct = h.progressFraction;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        onTap: onOpen,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HabitTile(
                  icon: h.icon,
                  color: h.color,
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
                        h.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: c.text,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        h.goalText,
                        style: TextStyle(
                          fontSize: 12.5,
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
                  size: 36,
                  onTap: onToggle,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: pct.clamp(0, 1),
                      minHeight: 8,
                      backgroundColor: c.surface3,
                      valueColor: AlwaysStoppedAnimation(hc.base),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Icon(AppIcons.resolve('fire'), size: 14, color: hc.base),
                const SizedBox(width: 3),
                Text(
                  '${h.streak} ngày',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: hc.base,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HabitGridTile extends StatelessWidget {
  const _HabitGridTile({
    required this.h,
    required this.dark,
    required this.onToggle,
    required this.onOpen,
  });

  final Habit h;
  final bool dark;
  final VoidCallback onToggle;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final hc = HabitPalette.of(h.color, dark);
    return AppCard(
      padding: const EdgeInsets.all(14),
      onTap: onOpen,
      color: h.done ? hc.soft : c.surface,
      border: Border.all(
        color: h.done ? hc.base.withValues(alpha: 0.2) : c.border,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HabitTile(
                icon: h.icon,
                color: h.color,
                dark: dark,
                size: 44,
                radius: 15,
              ),
              CheckCircle(
                done: h.done,
                color: h.color,
                dark: dark,
                size: 30,
                onTap: onToggle,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            h.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              color: c.text,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            h.target > 1 ? '${h.progress}/${h.target} ${h.unit}' : h.freq,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.5,
              color: c.textDim,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(AppIcons.resolve('fire'), size: 13, color: hc.base),
              const SizedBox(width: 4),
              Text(
                '${h.streak}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: hc.base,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
