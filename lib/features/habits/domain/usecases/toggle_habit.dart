import '../entities/habit.dart';
import '../repositories/habit_repository.dart';

/// Result of toggling a habit: the new list plus whether the habit became done
/// (used to decide if the +XP toast should be shown).
class ToggleResult {
  const ToggleResult(this.habits, this.becameDone);
  final List<Habit> habits;
  final bool becameDone;
}

/// Toggles a habit's daily completion and persists the change.
class ToggleHabit {
  const ToggleHabit(this._repo);
  final HabitRepository _repo;

  Future<ToggleResult> call(String id) async {
    var becameDone = false;
    final updated = [
      for (final h in _repo.getHabits())
        if (h.id != id)
          h
        else
          () {
            final t = h.toggled();
            becameDone = t.done;
            return t;
          }(),
    ];
    await _repo.saveHabits(updated);
    return ToggleResult(updated, becameDone);
  }
}
