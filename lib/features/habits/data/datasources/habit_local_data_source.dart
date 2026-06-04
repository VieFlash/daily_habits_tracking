import 'dart:convert';

import 'package:daily_habits_tracking/core/storage/key_value_store.dart';

import '../models/habit_model.dart';
import 'habit_seed.dart';

/// Persists habits as a JSON array in the [KeyValueStore]. Falls back to the
/// seed list when nothing has been stored yet (first launch).
class HabitLocalDataSource {
  HabitLocalDataSource(this._store);

  final KeyValueStore _store;
  static const _key = 'habits';

  List<HabitModel> read() {
    final raw = _store.getString(_key);
    if (raw == null) return List.of(kHabitSeed);
    final list = jsonDecode(raw) as List;
    return list
        .map((e) => HabitModel.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<void> write(List<HabitModel> habits) {
    return _store.setString(
      _key,
      jsonEncode(habits.map((h) => h.toJson()).toList()),
    );
  }
}
