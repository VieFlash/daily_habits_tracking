import 'package:daily_habits_tracking/core/constants/week.dart';
import 'package:daily_habits_tracking/core/icons/app_icons.dart';
import 'package:daily_habits_tracking/core/presentation/widgets/app_card.dart';
import 'package:daily_habits_tracking/core/presentation/widgets/check_circle.dart';
import 'package:daily_habits_tracking/core/presentation/widgets/flash.dart';
import 'package:daily_habits_tracking/core/presentation/widgets/habit_tile.dart';
import 'package:daily_habits_tracking/core/presentation/widgets/misc.dart';
import 'package:daily_habits_tracking/core/presentation/widgets/notifications_sheet.dart';
import 'package:daily_habits_tracking/core/presentation/widgets/progress_ring.dart';
import 'package:daily_habits_tracking/core/theme/app_colors.dart';
import 'package:daily_habits_tracking/core/theme/habit_palette.dart';
import 'package:daily_habits_tracking/features/habits/domain/entities/habit.dart';
import 'package:daily_habits_tracking/features/habits/domain/habit_activity.dart';
import 'package:daily_habits_tracking/features/habits/domain/habit_templates.dart';
import 'package:daily_habits_tracking/features/habits/presentation/providers/habit_providers.dart';
import 'package:daily_habits_tracking/features/habits/presentation/widgets/habit_suggestions.dart';
import 'package:daily_habits_tracking/features/profile/presentation/providers/profile_providers.dart';
import 'package:daily_habits_tracking/features/settings/presentation/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/widgets/buttons.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _filter = 'all';
  DateTime _selectedDay = _dateOnly(DateTime.now());

  bool get _isToday => _selectedDay == _dateOnly(DateTime.now());

  Future<void> _toggle(Habit h) async {
    final becameDone =
        await ref.read(habitsProvider.notifier).toggleOn(h.id, _selectedDay);
    if (becameDone && mounted) {
      final suffix = _isToday ? '' : ' (bù ngày)';
      showFlash(context, '+10 XP · ${h.name} ✓$suffix', icon: 'sparkle');
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

  void _addFromTemplate(HabitTemplate t) {
    ref.read(habitsProvider.notifier).add(t.toHabit());
    showFlash(context, 'Đã thêm ${t.name} 🌱', icon: 'check');
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final habits = ref.watch(habitsProvider);
    final completions = ref.watch(habitCompletionsProvider);
    final layout = ref.watch(settingsProvider.select((s) => s.layout));
    final suggestionsHidden =
        ref.watch(settingsProvider.select((s) => s.suggestionsHidden));
    final user = ref.watch(userProfileProvider);
    final dark = c.isDark;

    // Habits as of the selected day: only those that existed by then, with their
    // stats derived for that date (so the list/summary reflect that day).
    final habitsForDay = [
      for (final h in habits)
        if (!_dateOnly(h.createdAt).isAfter(_selectedDay))
          deriveHabit(h, completions[h.id], _selectedDay),
    ];

    // Trending presets the user hasn't added yet (matched by name).
    final addedNames = {for (final h in habits) h.name.trim().toLowerCase()};
    final remainingTemplates = [
      for (final t in kHabitTemplates)
        if (!addedNames.contains(t.name.toLowerCase())) t,
    ];
    final showInlineSuggestions = habits.isNotEmpty &&
        !suggestionsHidden &&
        remainingTemplates.isNotEmpty;

    final cats = {for (final h in habitsForDay) h.cat}.toList();
    List<Habit> list = habitsForDay;
    if (_filter == 'todo') {
      list = habitsForDay.where((h) => !h.done).toList();
    } else if (_filter == 'done') {
      list = habitsForDay.where((h) => h.done).toList();
    } else if (_filter != 'all') {
      list = habitsForDay.where((h) => h.cat == _filter).toList();
    }

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _Greeting(
            name: user.name,
            initials: user.initials,
            layout: layout,
            onCycleLayout: _cycleLayout,
            onBell: () => showNotificationsSheet(context),
            onProfile: () => context.push('/profile'),
          ),
          _WeekStrip(
            habits: habits,
            completions: completions,
            selectedDay: _selectedDay,
            onSelect: (d) => setState(() => _selectedDay = d),
          ),
          if (!_isToday)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: _ViewingDayBanner(
                day: _selectedDay,
                onToday: () =>
                    setState(() => _selectedDay = _dateOnly(DateTime.now())),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: _SummaryCard(habits: habitsForDay),
          ),
          if (habits.isNotEmpty)
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
            padding: EdgeInsets.fromLTRB(16, 6, 16, showInlineSuggestions ? 8 : 110),
            child: habits.isEmpty
                ? _StarterSuggestions(
                    onPick: _addFromTemplate,
                    templates: remainingTemplates,
                  )
                : list.isEmpty
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
          if (showInlineSuggestions)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 110),
              child: _InlineSuggestions(
                templates: remainingTemplates,
                onPick: _addFromTemplate,
                onHide: () =>
                    ref.read(settingsProvider.notifier).hideSuggestions(),
              ),
            ),
        ],
      ),
    );
  }
}

/// Empty-state shown when the user has no habits yet: a friendly intro plus a
/// gallery of trending presets they can add with one tap.
class _StarterSuggestions extends StatelessWidget {
  const _StarterSuggestions({required this.onPick, required this.templates});

  final void Function(HabitTemplate template) onPick;
  final List<HabitTemplate> templates;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: c.primarySoft,
              borderRadius: BorderRadius.circular(22),
            ),
            alignment: Alignment.center,
            child: Icon(AppIcons.resolve('leaf'), size: 32, color: c.primary),
          ),
          const SizedBox(height: 14),
          Text(
            'Bắt đầu từ một thói quen nhỏ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: c.text,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Chọn bao nhiêu gợi ý tùy thích bên dưới, hoặc bấm nút + để tự tạo.',
            style: TextStyle(
              fontSize: 13.5,
              height: 1.45,
              fontWeight: FontWeight.w600,
              color: c.textDim,
            ),
          ),
          const SizedBox(height: 16),
          HabitSuggestions(onPick: onPick, templates: templates),
        ],
      ),
    );
  }
}

/// Persistent "more suggestions" section shown once the user has at least one
/// habit, so they can keep adding presets. Dismissible (remembered).
class _InlineSuggestions extends StatelessWidget {
  const _InlineSuggestions({
    required this.templates,
    required this.onPick,
    required this.onHide,
  });

  final List<HabitTemplate> templates;
  final void Function(HabitTemplate template) onPick;
  final VoidCallback onHide;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Gợi ý cho bạn',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w900,
                  color: c.text,
                ),
              ),
            ),
            GestureDetector(
              onTap: onHide,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Text(
                  'Ẩn',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: c.textDim,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        HabitSuggestions(onPick: onPick, templates: templates),
      ],
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({
    required this.name,
    required this.initials,
    required this.layout,
    required this.onCycleLayout,
    required this.onBell,
    required this.onProfile,
  });

  final String name;
  final String initials;
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
    final layoutIcon = layout == 'list'
        ? 'grid'
        : layout == 'grid'
        ? 'list'
        : 'grid';
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
                initials,
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

/// The Mon→Sun week containing [selectedDay]. Tapping a day selects it (to view
/// / back-fill that day); ‹ › step between weeks. The dot under each date shows
/// how much of that day's habits were completed. Future days are disabled.
class _WeekStrip extends StatelessWidget {
  const _WeekStrip({
    required this.habits,
    required this.completions,
    required this.selectedDay,
    required this.onSelect,
  });

  final List<Habit> habits;
  final Map<String, Map<String, int>> completions;
  final DateTime selectedDay;
  final void Function(DateTime day) onSelect;

  static const _months = [
    'thg 1', 'thg 2', 'thg 3', 'thg 4', 'thg 5', 'thg 6',
    'thg 7', 'thg 8', 'thg 9', 'thg 10', 'thg 11', 'thg 12',
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final today = _dateOnly(DateTime.now());
    final monday = selectedDay.subtract(Duration(days: selectedDay.weekday - 1));
    final sunday = monday.add(const Duration(days: 6));
    final todayMonday = today.subtract(Duration(days: today.weekday - 1));
    final canGoNext = monday.isBefore(todayMonday);

    final label = monday.month == sunday.month
        ? '${monday.day} – ${sunday.day} ${_months[sunday.month - 1]}'
        : '${monday.day} ${_months[monday.month - 1]} – '
              '${sunday.day} ${_months[sunday.month - 1]}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: c.textDim,
                  ),
                ),
              ),
              SoftIconButton(
                icon: 'chevL',
                size: 30,
                onTap: () => onSelect(
                  _dateOnly(selectedDay.subtract(const Duration(days: 7))),
                ),
              ),
              const SizedBox(width: 6),
              SoftIconButton(
                icon: 'chevR',
                size: 30,
                onTap: canGoNext
                    ? () {
                        final next =
                            _dateOnly(selectedDay.add(const Duration(days: 7)));
                        onSelect(next.isAfter(today) ? today : next);
                      }
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              for (var i = 0; i < 7; i++) ...[
                if (i > 0) const SizedBox(width: 6),
                Expanded(
                  child: _DayCell(
                    date: monday.add(Duration(days: i)),
                    selected: monday.add(Duration(days: i)) == selectedDay,
                    isToday: monday.add(Duration(days: i)) == today,
                    disabled: monday.add(Duration(days: i)).isAfter(today),
                    percent: dayCompletionPercent(
                      habits,
                      completions,
                      monday.add(Duration(days: i)),
                      today,
                    ),
                    onSelect: onSelect,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.selected,
    required this.isToday,
    required this.disabled,
    required this.percent,
    required this.onSelect,
  });

  final DateTime date;
  final bool selected;
  final bool isToday;
  final bool disabled;
  final int percent;
  final void Function(DateTime day) onSelect;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final dow = kWeekLabels[(date.weekday - 1) % 7];
    return Opacity(
      opacity: disabled ? 0.4 : 1,
      child: GestureDetector(
        onTap: disabled ? null : () => onSelect(date),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: selected ? c.primary : c.surface,
            borderRadius: BorderRadius.circular(16),
            border: selected
                ? null
                : Border.all(
                    color: isToday ? c.primary : c.border,
                    width: isToday ? 1.5 : 1,
                  ),
          ),
          child: Column(
            children: [
              Text(
                dow,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: selected
                      ? c.onPrimary.withValues(alpha: 0.9)
                      : c.textDim,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${date.day}',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: selected ? c.onPrimary : c.text,
                ),
              ),
              const SizedBox(height: 5),
              _dot(c),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dot(AppColors c) {
    final base = selected ? c.onPrimary : c.primary;
    final Color color;
    if (percent >= 100) {
      color = base;
    } else if (percent > 0) {
      color = base.withValues(alpha: 0.45);
    } else {
      color = (selected ? c.onPrimary : c.textFaint).withValues(alpha: 0.3);
    }
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

/// Notice shown when viewing a day other than today, with a shortcut back.
class _ViewingDayBanner extends StatelessWidget {
  const _ViewingDayBanner({required this.day, required this.onToday});

  final DateTime day;
  final VoidCallback onToday;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final dow = kWeekLabels[(day.weekday - 1) % 7];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: c.primarySoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(AppIcons.resolve('calendar'), size: 16, color: c.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Đang xem $dow ${day.day}/${day.month}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: c.text,
              ),
            ),
          ),
          GestureDetector(
            onTap: onToday,
            child: Text(
              'Về hôm nay',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                color: c.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
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
    final longestStreak = habits.fold<int>(
      0,
      (m, h) => h.streak > m ? h.streak : m,
    );
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
                const Icon(
                  Icons.local_fire_department_rounded,
                  size: 20,
                  color: Colors.white,
                ),
                const SizedBox(height: 2),
                Text(
                  '$longestStreak',
                  style: const TextStyle(
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
                        decoration: h.done ? TextDecoration.lineThrough : null,
                        decorationColor: c.textFaint,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(
                          AppIcons.resolve('clock'),
                          size: 13,
                          color: c.textDim,
                        ),
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
