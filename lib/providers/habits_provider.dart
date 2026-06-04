import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/habit.dart';
import 'app_providers.dart';

/// Holds the list of habits and persists every mutation to local storage.
class HabitsNotifier extends StateNotifier<List<Habit>> {
  HabitsNotifier(this._ref) : super(_ref.read(localStoreProvider).loadHabits());

  final Ref _ref;

  void _persist() => _ref.read(localStoreProvider).saveHabits(state);

  Habit? byId(String id) {
    for (final h in state) {
      if (h.id == id) return h;
    }
    return null;
  }

  /// Toggles today's completion for [id]. Mirrors `toggle()` in app.jsx and
  /// returns whether the habit became completed (for the +XP toast).
  bool toggle(String id) {
    var becameDone = false;
    state = [
      for (final h in state)
        if (h.id != id)
          h
        else
          () {
            final done = !h.done;
            becameDone = done;
            return h.copyWith(
              done: done,
              progress: done
                  ? h.target
                  : (h.progress == h.target
                        ? (h.target - 1).clamp(0, h.target)
                        : h.progress),
              streak: done ? h.streak + 1 : (h.streak - 1).clamp(0, 1 << 30),
            );
          }(),
    ];
    _persist();
    return becameDone;
  }

  void add(Habit habit) {
    state = [...state, habit];
    _persist();
  }

  void update(Habit habit) {
    state = [
      for (final h in state)
        if (h.id == habit.id) habit else h,
    ];
    _persist();
  }

  void remove(String id) {
    state = state.where((h) => h.id != id).toList();
    _persist();
  }
}

final habitsProvider = StateNotifierProvider<HabitsNotifier, List<Habit>>(
  (ref) => HabitsNotifier(ref),
);
