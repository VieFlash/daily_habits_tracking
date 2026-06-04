import '../entities/journal_entry.dart';

abstract interface class JournalRepository {
  List<JournalEntry> getEntries();
  Future<void> saveEntries(List<JournalEntry> entries);
}
