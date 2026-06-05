import 'package:flutter/foundation.dart';

/// A trackable habit.
///
/// The *definition* fields (name, icon, target, …) are what the user enters and
/// what gets persisted. The *derived* fields (progress, streak, best, done,
/// weekDone, rate) are NOT stored — they are computed for "today" from the
/// completion history by the data layer (see `habit_activity.dart`). On a fresh
/// definition they default to zero/empty.
@immutable
class Habit {
  const Habit({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.cat,
    required this.goalText,
    required this.freq,
    required this.time,
    required this.unit,
    required this.target,
    required this.reminder,
    required this.createdAt,
    this.progress = 0,
    this.streak = 0,
    this.best = 0,
    this.done = false,
    this.weekDone = const [0, 0, 0, 0, 0, 0, 0],
    this.rate = 0,
  });

  // ---- Definition (persisted) ----
  final String id;
  final String name;
  final String icon;
  final String color;
  final String cat;
  final String goalText;
  final String freq;
  final String time;
  final String unit;
  final int target;
  final bool reminder;
  final DateTime createdAt;

  // ---- Derived for today (computed, not persisted) ----
  final int progress;
  final int streak;
  final int best;
  final bool done;
  final List<int> weekDone; // 7 entries (Mon..Sun), 1 = done
  final int rate;

  /// Daily progress fraction used by progress bars / rings.
  double get progressFraction =>
      target > 1 ? progress / target : (done ? 1 : 0);

  Habit copyWith({
    String? name,
    String? icon,
    String? color,
    String? cat,
    String? goalText,
    String? freq,
    String? time,
    String? unit,
    int? target,
    bool? reminder,
    DateTime? createdAt,
    int? progress,
    int? streak,
    int? best,
    bool? done,
    List<int>? weekDone,
    int? rate,
  }) {
    return Habit(
      id: id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      cat: cat ?? this.cat,
      goalText: goalText ?? this.goalText,
      freq: freq ?? this.freq,
      time: time ?? this.time,
      unit: unit ?? this.unit,
      target: target ?? this.target,
      reminder: reminder ?? this.reminder,
      createdAt: createdAt ?? this.createdAt,
      progress: progress ?? this.progress,
      streak: streak ?? this.streak,
      best: best ?? this.best,
      done: done ?? this.done,
      weekDone: weekDone ?? this.weekDone,
      rate: rate ?? this.rate,
    );
  }
}
