import '../entities/journal_entry.dart';
import '../repositories/journal_repository.dart';

class GetJournal {
  const GetJournal(this._repo);
  final JournalRepository _repo;

  List<JournalEntry> call() => _repo.getEntries();
}
