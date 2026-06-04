import '../entities/habit.dart';
import '../repositories/habit_repository.dart';

/// Appends a new habit and persists the list.
class AddHabit {
  const AddHabit(this._repo);
  final HabitRepository _repo;

  Future<List<Habit>> call(Habit habit) async {
    final updated = [..._repo.getHabits(), habit];
    await _repo.saveHabits(updated);
    return updated;
  }
}
