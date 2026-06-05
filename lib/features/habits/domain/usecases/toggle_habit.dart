import '../entities/habit.dart';
import '../habit_activity.dart';
import '../repositories/habit_repository.dart';

/// Result of toggling a habit: the new list plus whether the habit became done
/// (used to decide if the +XP toast should be shown).
class ToggleResult {
  const ToggleResult(this.habits, this.becameDone);
  final List<Habit> habits;
  final bool becameDone;
}

/// Toggles completion for a habit on a given day (defaults to today) and
/// persists it. Completing logs the full daily target; un-completing clears
/// that day's entry. Used both for today's check-in and for back-filling
/// missed days from the week strip.
class ToggleHabit {
  const ToggleHabit(this._repo);
  final HabitRepository _repo;

  Future<ToggleResult> call(String id, {DateTime? date}) async {
    final day = date ?? DateTime.now();
    final habits = _repo.getHabits();
    final match = habits.where((h) => h.id == id);
    if (match.isEmpty) return ToggleResult(habits, false);
    final habit = match.first;

    // Deep-copy the completion history before mutating.
    final completions = {
      for (final entry in _repo.getCompletions().entries)
        entry.key: Map<String, int>.of(entry.value),
    };
    final key = habitDateKey(day);
    final dayMap = completions.putIfAbsent(id, () => <String, int>{});

    final becameDone = !isHabitDoneOn(habit.target, dayMap, day);
    if (becameDone) {
      dayMap[key] = habit.target <= 1 ? 1 : habit.target;
    } else {
      dayMap.remove(key);
      if (dayMap.isEmpty) completions.remove(id);
    }

    await _repo.saveCompletions(completions);
    return ToggleResult(_repo.getHabits(), becameDone);
  }
}
