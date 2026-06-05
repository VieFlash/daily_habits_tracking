import '../entities/habit.dart';
import '../repositories/habit_repository.dart';

/// Appends a new habit definition and persists it.
class AddHabit {
  const AddHabit(this._repo);
  final HabitRepository _repo;

  Future<List<Habit>> call(Habit habit) async {
    await _repo.saveDefinitions([..._repo.getHabits(), habit]);
    return _repo.getHabits();
  }
}
