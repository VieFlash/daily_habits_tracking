import '../../domain/entities/journal_entry.dart';
import '../../domain/repositories/journal_repository.dart';
import '../datasources/journal_local_data_source.dart';
import '../models/journal_entry_model.dart';

class JournalRepositoryImpl implements JournalRepository {
  JournalRepositoryImpl(this._local);

  final JournalLocalDataSource _local;

  @override
  List<JournalEntry> getEntries() => _local.read();

  @override
  Future<void> saveEntries(List<JournalEntry> entries) =>
      _local.write(entries.map(JournalEntryModel.fromEntity).toList());
}
