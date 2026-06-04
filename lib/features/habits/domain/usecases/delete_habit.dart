import '../entities/habit.dart';
import '../repositories/habit_repository.dart';

/// Removes a habit by id and persists the list.
class DeleteHabit {
  const DeleteHabit(this._repo);
  final HabitRepository _repo;

  Future<List<Habit>> call(String id) async {
    final updated = _repo.getHabits().where((h) => h.id != id).toList();
    await _repo.saveHabits(updated);
    return updated;
  }
}
