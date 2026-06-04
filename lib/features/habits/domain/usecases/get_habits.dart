import '../entities/habit.dart';
import '../repositories/habit_repository.dart';

/// Returns the current list of habits.
class GetHabits {
  const GetHabits(this._repo);
  final HabitRepository _repo;

  List<Habit> call() => _repo.getHabits();
}
