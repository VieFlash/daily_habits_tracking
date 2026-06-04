import 'package:flutter/foundation.dart';

/// A journal entry (JOURNAL in data.jsx).
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
}
