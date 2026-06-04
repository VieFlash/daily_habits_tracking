import 'package:flutter/foundation.dart';

/// A journal entry (JOURNAL in data.jsx). Persisted to local storage.
@immutable
class JournalEntry {
  const JournalEntry({
    required this.id,
    required this.date,
    required this.mood,
    required this.text,
    required this.habits,
  });

  final String id;
  final String date;
  final String mood;
  final String text;
  final List<String> habits;

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date,
    'mood': mood,
    'text': text,
    'habits': habits,
  };

  factory JournalEntry.fromJson(Map<String, dynamic> json) => JournalEntry(
    id: json['id'] as String,
    date: json['date'] as String,
    mood: json['mood'] as String,
    text: json['text'] as String,
    habits:
        (json['habits'] as List?)?.map((e) => e as String).toList() ??
        const [],
  );
}
