import 'package:daily_habits_tracking/core/di/core_providers.dart';
import 'package:daily_habits_tracking/features/habits/domain/habit_activity.dart';
import 'package:daily_habits_tracking/features/habits/presentation/providers/habit_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/profile_local_data_source.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/badge.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/profile_calculator.dart';
import '../../domain/repositories/profile_repository.dart';

final profileLocalDataSourceProvider = Provider<ProfileLocalDataSource>(
  (ref) => ProfileLocalDataSource(ref.watch(keyValueStoreProvider)),
);

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepositoryImpl(ref.watch(profileLocalDataSourceProvider)),
);

/// The current user's profile, derived from real habit activity.
final userProfileProvider = Provider<UserProfile>((ref) {
  final repo = ref.watch(profileRepositoryProvider);
  final habits = ref.watch(habitsProvider);
  final completions = ref.watch(habitCompletionsProvider);
  return computeUserProfile(
    name: repo.getName(),
    handle: repo.getHandle(),
    habits: habits,
    completions: completions,
    now: DateTime.now(),
    installedAt: repo.getInstalledAt(),
  );
});

/// Achievement badges with their unlocked state computed from activity.
final badgesProvider = Provider<List<Badge>>((ref) {
  final habits = ref.watch(habitsProvider);
  final completions = ref.watch(habitCompletionsProvider);
  final agg = aggregateActivity(habits, completions);
  return computeBadges(
    totalDone: agg.totalDone,
    longestStreak: agg.longestStreak,
    level: levelForXp(agg.totalDone * 10),
    habitCount: habits.length,
  );
});
