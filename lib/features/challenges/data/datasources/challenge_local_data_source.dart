import 'dart:convert';

import 'package:daily_habits_tracking/core/storage/key_value_store.dart';

/// Persists which challenges the user has joined and their progress, as a map
/// of `challengeId -> currentDay`.
class ChallengeLocalDataSource {
  ChallengeLocalDataSource(this._store);

  final KeyValueStore _store;
  static const _key = 'challenge_joins';

  Map<String, int> readJoins() {
    final raw = _store.getString(_key);
    if (raw == null) return {};
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map((id, day) => MapEntry(id, (day as num).toInt()));
  }

  Future<void> writeJoins(Map<String, int> joins) {
    return _store.setString(_key, jsonEncode(joins));
  }
}
