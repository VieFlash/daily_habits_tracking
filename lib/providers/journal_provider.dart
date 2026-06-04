import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/journal_entry.dart';
import 'app_providers.dart';

/// Holds journal entries and persists them to local storage.
class JournalNotifier extends StateNotifier<List<JournalEntry>> {
  JournalNotifier(this._ref)
    : super(_ref.read(localStoreProvider).loadJournal());

  final Ref _ref;

  void add(JournalEntry entry) {
    state = [entry, ...state];
    _ref.read(localStoreProvider).saveJournal(state);
  }
}

final journalProvider =
    StateNotifierProvider<JournalNotifier, List<JournalEntry>>(
      (ref) => JournalNotifier(ref),
    );
