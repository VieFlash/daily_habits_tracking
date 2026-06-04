import 'package:flutter/foundation.dart';

/// A mood option for the journal (MOODS in data.jsx).
@immutable
class Mood {
  const Mood({
    required this.key,
    required this.label,
    required this.icon,
    required this.color,
  });

  final String key;
  final String label;
  final String icon;
  final String color;

  /// The fixed set of selectable moods.
  static const all = [
    Mood(key: 'great', label: 'Tuyệt vời', icon: 'smile', color: 'green'),
    Mood(key: 'good', label: 'Ổn', icon: 'smile', color: 'sky'),
    Mood(key: 'meh', label: 'Bình thường', icon: 'meh', color: 'amber'),
    Mood(key: 'bad', label: 'Không vui', icon: 'frown', color: 'coral'),
  ];

  static Mood byKey(String key) =>
      all.firstWhere((m) => m.key == key, orElse: () => all.first);
}
