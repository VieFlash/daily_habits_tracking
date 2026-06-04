import 'package:flutter/foundation.dart';

/// Aggregated chart data for the progress screen (WEEKLY_COMPLETION /
/// MONTH_TREND in data.jsx).
@immutable
class StatsOverview {
  const StatsOverview({
    required this.weeklyCompletion,
    required this.monthTrend,
  });

  /// % completion per weekday (Mon..Sun).
  final List<int> weeklyCompletion;

  /// % completion for the last 12 periods.
  final List<int> monthTrend;
}
