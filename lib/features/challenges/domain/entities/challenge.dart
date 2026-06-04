import 'package:flutter/foundation.dart';

/// A community challenge (CHALLENGES in data.jsx).
@immutable
class Challenge {
  const Challenge({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.joined,
    required this.total,
    required this.current,
    required this.people,
    required this.days,
  });

  final String id;
  final String name;
  final String icon;
  final String color;
  final bool joined;
  final int total;
  final int current;
  final int people;
  final String days;

  double get progress => total == 0 ? 0 : current / total;

  Challenge copyWith({bool? joined, int? current}) => Challenge(
    id: id,
    name: name,
    icon: icon,
    color: color,
    joined: joined ?? this.joined,
    total: total,
    current: current ?? this.current,
    people: people,
    days: days,
  );
}
