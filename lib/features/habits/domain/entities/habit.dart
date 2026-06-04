import 'package:flutter/foundation.dart';

/// A trackable habit. Pure domain entity — holds the data plus the business
/// rules for checking a habit in/out for the day.
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
    required this.progress,
    required this.streak,
    required this.best,
    required this.done,
    required this.reminder,
    required this.weekDone,
    required this.rate,
  });

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
  final int progress;
  final int streak;
  final int best;
  final bool done;
  final bool reminder;
  final List<int> weekDone; // 7 entries, 1 = done
  final int rate;

  /// Daily progress fraction used by progress bars / rings.
  double get progressFraction =>
      target > 1 ? progress / target : (done ? 1 : 0);

  /// Toggles today's completion, recomputing progress + streak.
  /// Mirrors `toggle()` in app.jsx.
  Habit toggled() {
    final nextDone = !done;
    return copyWith(
      done: nextDone,
      progress: nextDone
          ? target
          : (progress == target ? (target - 1).clamp(0, target) : progress),
      streak: nextDone ? streak + 1 : (streak - 1).clamp(0, 1 << 30),
    );
  }

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
    int? progress,
    int? streak,
    int? best,
    bool? done,
    bool? reminder,
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
      progress: progress ?? this.progress,
      streak: streak ?? this.streak,
      best: best ?? this.best,
      done: done ?? this.done,
      reminder: reminder ?? this.reminder,
      weekDone: weekDone ?? this.weekDone,
      rate: rate ?? this.rate,
    );
  }
}
