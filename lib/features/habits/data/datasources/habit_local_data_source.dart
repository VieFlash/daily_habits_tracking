import 'dart:convert';

import 'package:daily_habits_tracking/core/storage/key_value_store.dart';

import '../models/habit_model.dart';

/// Persists habit definitions and their completion history in the
/// [KeyValueStore]. Both start empty — there is no seed data.
class HabitLocalDataSource {
  HabitLocalDataSource(this._store);

  final KeyValueStore _store;
  static const _habitsKey = 'habits';
  static const _completionsKey = 'habit_completions';

  /// The stored habit definitions (empty on first launch).
  List<HabitModel> readHabits() {
    final raw = _store.getString(_habitsKey);
    if (raw == null) return const [];
    final list = jsonDecode(raw) as List;
    return list
        .map((e) => HabitModel.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<void> writeHabits(List<HabitModel> habits) {
    return _store.setString(
      _habitsKey,
      jsonEncode(habits.map((h) => h.toJson()).toList()),
    );
  }

  /// Completion history: `habitId -> { 'yyyy-MM-dd': count }`.
  Map<String, Map<String, int>> readCompletions() {
    final raw = _store.getString(_completionsKey);
    if (raw == null) return {};
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map(
      (habitId, days) => MapEntry(
        habitId,
        (days as Map<String, dynamic>).map(
          (date, count) => MapEntry(date, (count as num).toInt()),
        ),
      ),
    );
  }

  Future<void> writeCompletions(Map<String, Map<String, int>> completions) {
    return _store.setString(_completionsKey, jsonEncode(completions));
  }
}
