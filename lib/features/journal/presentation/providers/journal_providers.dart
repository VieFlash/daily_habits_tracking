import 'package:daily_habits_tracking/core/di/core_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/journal_local_data_source.dart';
import '../../data/repositories/journal_repository_impl.dart';
import '../../domain/entities/journal_entry.dart';
import '../../domain/repositories/journal_repository.dart';
import '../../domain/usecases/add_journal_entry.dart';
import '../../domain/usecases/get_journal.dart';

final journalLocalDataSourceProvider = Provider<JournalLocalDataSource>(
  (ref) => JournalLocalDataSource(ref.watch(keyValueStoreProvider)),
);

final journalRepositoryProvider = Provider<JournalRepository>(
  (ref) => JournalRepositoryImpl(ref.watch(journalLocalDataSourceProvider)),
);

final _getJournalProvider = Provider(
  (ref) => GetJournal(ref.watch(journalRepositoryProvider)),
);
final _addJournalEntryProvider = Provider(
  (ref) => AddJournalEntry(ref.watch(journalRepositoryProvider)),
);

class JournalNotifier extends StateNotifier<List<JournalEntry>> {
  JournalNotifier(this._ref) : super(_ref.read(_getJournalProvider)());

  final Ref _ref;

  Future<void> add(JournalEntry entry) async {
    state = await _ref.read(_addJournalEntryProvider)(entry);
  }
}

final journalProvider =
    StateNotifierProvider<JournalNotifier, List<JournalEntry>>(
      (ref) => JournalNotifier(ref),
    );
