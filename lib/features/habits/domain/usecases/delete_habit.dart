import '../entities/habit.dart';
import '../repositories/habit_repository.dart';

/// Removes a habit by id (definition + its completion history) and persists.
class DeleteHabit {
  const DeleteHabit(this._repo);
  final HabitRepository _repo;

  Future<List<Habit>> call(String id) async {
    final definitions =
        _repo.getHabits().where((h) => h.id != id).toList();
    final completions = {
      for (final entry in _repo.getCompletions().entries)
        if (entry.key != id) entry.key: entry.value,
    };
    await _repo.saveDefinitions(definitions);
    await _repo.saveCompletions(completions);
    return _repo.getHabits();
  }
}
