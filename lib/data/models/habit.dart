import 'package:flutter/foundation.dart';

/// A trackable habit. Mirrors the habit objects in data.jsx and is persisted to
/// local storage as JSON.
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'icon': icon,
    'color': color,
    'cat': cat,
    'goalText': goalText,
    'freq': freq,
    'time': time,
    'unit': unit,
    'target': target,
    'progress': progress,
    'streak': streak,
    'best': best,
    'done': done,
    'reminder': reminder,
    'weekDone': weekDone,
    'rate': rate,
  };

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
    id: json['id'] as String,
    name: json['name'] as String,
    icon: json['icon'] as String,
    color: json['color'] as String,
    cat: json['cat'] as String? ?? 'Khác',
    goalText: json['goalText'] as String? ?? '',
    freq: json['freq'] as String? ?? 'Hằng ngày',
    time: json['time'] as String? ?? '—',
    unit: json['unit'] as String? ?? '',
    target: (json['target'] as num?)?.toInt() ?? 1,
    progress: (json['progress'] as num?)?.toInt() ?? 0,
    streak: (json['streak'] as num?)?.toInt() ?? 0,
    best: (json['best'] as num?)?.toInt() ?? 0,
    done: json['done'] as bool? ?? false,
    reminder: json['reminder'] as bool? ?? false,
    weekDone:
        (json['weekDone'] as List?)?.map((e) => (e as num).toInt()).toList() ??
        const [0, 0, 0, 0, 0, 0, 0],
    rate: (json['rate'] as num?)?.toInt() ?? 0,
  );

  /// Daily progress fraction used by progress bars / rings.
  double get progressFraction =>
      target > 1 ? progress / target : (done ? 1 : 0);
}
