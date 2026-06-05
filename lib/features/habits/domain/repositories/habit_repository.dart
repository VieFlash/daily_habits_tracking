import '../entities/habit.dart';

/// Source of truth for habits. Reads are synchronous (cached local store);
/// writes are awaited.
abstract interface class HabitRepository {
  /// Habit definitions with today's derived stats computed from history.
  List<Habit> getHabits();

  /// Raw completion history: `habitId -> { 'yyyy-MM-dd': count }`.
  Map<String, Map<String, int>> getCompletions();

  /// Persists the habit definitions (derived fields are ignored).
  Future<void> saveDefinitions(List<Habit> definitions);

  /// Persists the completion history.
  Future<void> saveCompletions(Map<String, Map<String, int>> completions);
}
