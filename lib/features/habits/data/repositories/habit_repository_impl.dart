import '../../domain/entities/habit.dart';
import '../../domain/habit_activity.dart';
import '../../domain/repositories/habit_repository.dart';
import '../datasources/habit_local_data_source.dart';
import '../models/habit_model.dart';

class HabitRepositoryImpl implements HabitRepository {
  HabitRepositoryImpl(this._local);

  final HabitLocalDataSource _local;

  @override
  List<Habit> getHabits() {
    final definitions = _local.readHabits();
    final completions = _local.readCompletions();
    final now = DateTime.now();
    return [
      for (final def in definitions)
        deriveHabit(def, completions[def.id], now),
    ];
  }

  @override
  Map<String, Map<String, int>> getCompletions() => _local.readCompletions();

  @override
  Future<void> saveDefinitions(List<Habit> definitions) =>
      _local.writeHabits(definitions.map(HabitModel.fromEntity).toList());

  @override
  Future<void> saveCompletions(Map<String, Map<String, int>> completions) =>
      _local.writeCompletions(completions);
}
