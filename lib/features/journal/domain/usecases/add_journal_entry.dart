import '../entities/journal_entry.dart';
import '../repositories/journal_repository.dart';

/// Prepends a new entry (most recent first) and persists the list.
class AddJournalEntry {
  const AddJournalEntry(this._repo);
  final JournalRepository _repo;

  Future<List<JournalEntry>> call(JournalEntry entry) async {
    final updated = [entry, ..._repo.getEntries()];
    await _repo.saveEntries(updated);
    return updated;
  }
}
