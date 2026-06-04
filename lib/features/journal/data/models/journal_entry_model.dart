import '../../domain/entities/journal_entry.dart';

/// Data-layer [JournalEntry] with JSON (de)serialization.
class JournalEntryModel extends JournalEntry {
  const JournalEntryModel({
    required super.id,
    required super.date,
    required super.mood,
    required super.text,
    required super.habits,
  });

  factory JournalEntryModel.fromEntity(JournalEntry e) => JournalEntryModel(
    id: e.id,
    date: e.date,
    mood: e.mood,
    text: e.text,
    habits: e.habits,
  );

  factory JournalEntryModel.fromJson(Map<String, dynamic> json) =>
      JournalEntryModel(
        id: json['id'] as String,
        date: json['date'] as String,
        mood: json['mood'] as String,
        text: json['text'] as String,
        habits:
            (json['habits'] as List?)?.map((e) => e as String).toList() ??
            const [],
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date,
    'mood': mood,
    'text': text,
    'habits': habits,
  };
}
