import 'package:daily_habits_tracking/features/habits/presentation/providers/habit_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/stats_overview.dart';
import '../domain/stats_calculator.dart';

/// Progress-screen charts derived from real habit activity.
final statsOverviewProvider = Provider<StatsOverview>((ref) {
  final habits = ref.watch(habitsProvider);
  final completions = ref.watch(habitCompletionsProvider);
  return computeStatsOverview(habits, completions, DateTime.now());
});
