import 'package:daily_habits_tracking/core/di/core_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/habit_local_data_source.dart';
import '../../data/repositories/habit_repository_impl.dart';
import '../../domain/entities/habit.dart';
import '../../domain/repositories/habit_repository.dart';
import '../../domain/usecases/add_habit.dart';
import '../../domain/usecases/delete_habit.dart';
import '../../domain/usecases/get_habits.dart';
import '../../domain/usecases/toggle_habit.dart';
import '../../domain/usecases/update_habit.dart';

// ---- DI graph: data source -> repository -> use cases ----
final habitLocalDataSourceProvider = Provider<HabitLocalDataSource>(
  (ref) => HabitLocalDataSource(ref.watch(keyValueStoreProvider)),
);

final habitRepositoryProvider = Provider<HabitRepository>(
  (ref) => HabitRepositoryImpl(ref.watch(habitLocalDataSourceProvider)),
);

final _getHabitsProvider = Provider(
  (ref) => GetHabits(ref.watch(habitRepositoryProvider)),
);
final _toggleHabitProvider = Provider(
  (ref) => ToggleHabit(ref.watch(habitRepositoryProvider)),
);
final _addHabitProvider = Provider(
  (ref) => AddHabit(ref.watch(habitRepositoryProvider)),
);
final _updateHabitProvider = Provider(
  (ref) => UpdateHabit(ref.watch(habitRepositoryProvider)),
);
final _deleteHabitProvider = Provider(
  (ref) => DeleteHabit(ref.watch(habitRepositoryProvider)),
);

/// Presentation state: the in-memory habit list, kept in sync with storage via
/// the use cases.
class HabitsNotifier extends StateNotifier<List<Habit>> {
  HabitsNotifier(this._ref) : super(_ref.read(_getHabitsProvider)());

  final Ref _ref;

  Habit? byId(String id) {
    for (final h in state) {
      if (h.id == id) return h;
    }
    return null;
  }

  /// Returns whether the habit became completed (for the +XP toast).
  Future<bool> toggle(String id) async {
    final result = await _ref.read(_toggleHabitProvider)(id);
    state = result.habits;
    return result.becameDone;
  }

  Future<void> add(Habit habit) async {
    state = await _ref.read(_addHabitProvider)(habit);
  }

  Future<void> update(Habit habit) async {
    state = await _ref.read(_updateHabitProvider)(habit);
  }

  Future<void> remove(String id) async {
    state = await _ref.read(_deleteHabitProvider)(id);
  }
}

final habitsProvider = StateNotifierProvider<HabitsNotifier, List<Habit>>(
  (ref) => HabitsNotifier(ref),
);
