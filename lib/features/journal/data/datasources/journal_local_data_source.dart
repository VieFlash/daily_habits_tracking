import 'dart:convert';

import 'package:daily_habits_tracking/core/storage/key_value_store.dart';

import '../models/journal_entry_model.dart';
import 'journal_seed.dart';

class JournalLocalDataSource {
  JournalLocalDataSource(this._store);

  final KeyValueStore _store;
  static const _key = 'journal';

  List<JournalEntryModel> read() {
    final raw = _store.getString(_key);
    if (raw == null) return List.of(kJournalSeed);
    final list = jsonDecode(raw) as List;
    return list
        .map((e) => JournalEntryModel.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<void> write(List<JournalEntryModel> entries) {
    return _store.setString(
      _key,
      jsonEncode(entries.map((e) => e.toJson()).toList()),
    );
  }
}
