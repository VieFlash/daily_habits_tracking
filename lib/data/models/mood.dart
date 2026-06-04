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
}
