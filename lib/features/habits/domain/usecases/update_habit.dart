import '../entities/habit.dart';
import '../repositories/habit_repository.dart';

/// Replaces an existing habit definition (matched by id) and persists the list.
class UpdateHabit {
  const UpdateHabit(this._repo);
  final HabitRepository _repo;

  Future<List<Habit>> call(Habit habit) async {
    final updated = [
      for (final h in _repo.getHabits())
        if (h.id == habit.id) habit else h,
    ];
    await _repo.saveDefinitions(updated);
    return _repo.getHabits();
  }
}
