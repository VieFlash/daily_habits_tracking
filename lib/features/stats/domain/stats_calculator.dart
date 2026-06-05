import 'package:daily_habits_tracking/features/habits/domain/entities/habit.dart';
import 'package:daily_habits_tracking/features/habits/domain/habit_activity.dart';

import 'entities/stats_overview.dart';

/// Computes the progress-screen charts from the real habit definitions and
/// their completion history.
StatsOverview computeStatsOverview(
  List<Habit> habits,
  Map<String, Map<String, int>> completions,
  DateTime now,
) {
  final today = DateTime(now.year, now.month, now.day);
  final monday = today.subtract(Duration(days: today.weekday - 1));

  // This week's per-day completion (Mon..Sun).
  final weekly = [
    for (var i = 0; i < 7; i++)
      dayCompletionPercent(
        habits,
        completions,
        monday.add(Duration(days: i)),
        today,
      ),
  ];

  // Average daily completion for each of the last 12 weeks (oldest first).
  final trend = <int>[];
  for (var w = 11; w >= 0; w--) {
    final weekMonday = monday.subtract(Duration(days: 7 * w));
    var sum = 0;
    var count = 0;
    for (var i = 0; i < 7; i++) {
      final day = weekMonday.add(Duration(days: i));
      if (day.isAfter(today)) continue;
      sum += dayCompletionPercent(habits, completions, day, today);
      count++;
    }
    trend.add(count == 0 ? 0 : (sum / count).round());
  }

  return StatsOverview(weeklyCompletion: weekly, monthTrend: trend);
}
