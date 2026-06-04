import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/app_icons.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/habit_palette.dart';
import '../data/models/user_profile.dart';
import '../data/seed_data.dart';
import '../providers/habits_provider.dart';
import '../widgets/app_card.dart';
import '../widgets/habit_tile.dart';
import '../widgets/misc.dart';
import '../widgets/progress_ring.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final dark = c.isDark;
    final habits = ref.watch(habitsProvider);
    final user = SeedData.user;
    final totalRate = habits.isEmpty
        ? 0
        : (habits.fold<int>(0, (a, h) => a + h.rate) / habits.length).round();
    final best = [...habits]..sort((a, b) => b.streak.compareTo(a.streak));
    final top3 = best.take(3).toList();

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const TopBar(
            title: 'Tiến độ',
            subtitle: 'Bạn đang làm rất tốt 🌱',
            large: true,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: AppCard(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 8,
                        ),
                        child: Column(
                          children: [
                            ProgressRing(
                              value: totalRate.toDouble(),
                              max: 100,
                              size: 64,
                              stroke: 7,
                              child: Text(
                                '$totalRate%',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: c.text,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tỉ lệ chung',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: c.textDim,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        children: [
                          _MiniStat(
                            icon: 'check',
                            color: c.primary,
                            value: _format(user.totalDone),
                            label: 'lần hoàn thành',
                          ),
                          const SizedBox(height: 12),
                          _MiniStat(
                            icon: 'fire',
                            color: c.coral,
                            value: '${user.longestStreak}',
                            label: 'chuỗi dài nhất',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Hoàn thành theo ngày',
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                              color: c.text,
                            ),
                          ),
                          Text(
                            'Tuần này',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: c.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _BarChart(
                        data: SeedData.weeklyCompletion,
                        labels: SeedData.weekLabels,
                        color: c.primary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Xu hướng 12 tuần',
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                              color: c.text,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                AppIcons.resolve('chevU'),
                                size: 15,
                                color: c.primary,
                              ),
                              Text(
                                '+18%',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: c.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 96,
                        child: _LineChart(
                          data: SeedData.monthTrend,
                          color: c.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _LevelCard(
                  user: user,
                  onTap: () => context.push('/gamification'),
                ),
                SectionLabel(
                  'Chuỗi dài nhất',
                  trailing: Text(
                    'Xem tất cả',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: c.primary,
                    ),
                  ),
                ),
                for (var i = 0; i < top3.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Builder(
                      builder: (context) {
                        final h = top3[i];
                        final hc = HabitPalette.of(h.color, dark);
                        return AppCard(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 18,
                                child: Text(
                                  '${i + 1}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                    color: c.textFaint,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              HabitTile(
                                icon: h.icon,
                                color: h.color,
                                dark: dark,
                                size: 42,
                              ),
                              const SizedBox(width: 13),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      h.name,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: c.text,
                                      ),
                                    ),
                                    Text(
                                      '${h.rate}% hoàn thành',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: c.textDim,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(AppIcons.resolve('fire'), size: 17, color: hc.base),
                              const SizedBox(width: 4),
                              Text(
                                '${h.streak}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: hc.base,
                                ),
                              ),
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

  static String _format(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  final String icon;
  final Color color;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Icon(AppIcons.resolve(icon), size: 22, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    color: c.text,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: c.textDim,
                    fontWeight: FontWeight.w700,
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

class _LevelCard extends StatelessWidget {
  const _LevelCard({required this.user, required this.onTap});

  final UserProfile user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(18),
      border: const Border.fromBorderSide(BorderSide.none),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [c.violet, Color.lerp(c.violet, Colors.black, 0.18)!],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(18),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.bolt_rounded, size: 28, color: Colors.white),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cấp độ ${user.level}',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Người gieo mầm chăm chỉ',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, size: 22, color: Colors.white),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: user.xp / user.xpMax,
              minHeight: 9,
              backgroundColor: Colors.white.withValues(alpha: 0.25),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${user.xp} / ${user.xpMax} XP · còn ${user.xpMax - user.xp} XP lên cấp ${user.level + 1}',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  const _BarChart({
    required this.data,
    required this.labels,
    required this.color,
  });

  final List<int> data;
  final List<String> labels;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final max = data.reduce(math.max).clamp(1, 1 << 30);
    return SizedBox(
      height: 130,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < data.length; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${data[i]}%',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: c.textDim,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: data[i] / max),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                      builder: (context, v, _) => Container(
                        constraints: const BoxConstraints(maxWidth: 24),
                        height: math.max(6, v * 96),
                        decoration: BoxDecoration(
                          color: data[i] >= 80
                              ? color
                              : Color.lerp(c.surface, color, 0.55),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      labels[i],
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: c.textFaint,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _LineChart extends StatelessWidget {
  const _LineChart({required this.data, required this.color});

  final List<int> data;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _LinePainter(data: data, color: color),
    );
  }
}

class _LinePainter extends CustomPainter {
  _LinePainter({required this.data, required this.color});

  final List<int> data;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;
    final max = data.reduce(math.max).toDouble();
    final min = data.reduce(math.min).toDouble();
    final range = (max - min) == 0 ? 1 : (max - min);
    final w = size.width;
    final h = size.height;
    final pts = <Offset>[
      for (var i = 0; i < data.length; i++)
        Offset(
          i / (data.length - 1) * w,
          h - ((data[i] - min) / range) * (h - 16) - 8,
        ),
    ];

    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (var i = 1; i < pts.length; i++) {
      path.lineTo(pts[i].dx, pts[i].dy);
    }

    final area = Path.from(path)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(
      area,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: 0.25), color.withValues(alpha: 0)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = color,
    );

    canvas.drawCircle(pts.last, 5, Paint()..color = color);
    canvas.drawCircle(
      pts.last,
      5,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(_LinePainter old) =>
      old.data != data || old.color != color;
}
