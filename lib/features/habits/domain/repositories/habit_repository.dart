import '../entities/habit.dart';

/// Source of truth for habits. Reads are synchronous (cached local store);
/// writes are awaited.
abstract interface class HabitRepository {
  List<Habit> getHabits();
  Future<void> saveHabits(List<Habit> habits);
}
