import '../../domain/entities/habit.dart';

/// Data-layer representation of [Habit] with JSON (de)serialization.
class HabitModel extends Habit {
  const HabitModel({
    required super.id,
    required super.name,
    required super.icon,
    required super.color,
    required super.cat,
    required super.goalText,
    required super.freq,
    required super.time,
    required super.unit,
    required super.target,
    required super.progress,
    required super.streak,
    required super.best,
    required super.done,
    required super.reminder,
    required super.weekDone,
    required super.rate,
  });

  factory HabitModel.fromEntity(Habit h) => HabitModel(
    id: h.id,
    name: h.name,
    icon: h.icon,
    color: h.color,
    cat: h.cat,
    goalText: h.goalText,
    freq: h.freq,
    time: h.time,
    unit: h.unit,
    target: h.target,
    progress: h.progress,
    streak: h.streak,
    best: h.best,
    done: h.done,
    reminder: h.reminder,
    weekDone: h.weekDone,
    rate: h.rate,
  );

  factory HabitModel.fromJson(Map<String, dynamic> json) => HabitModel(
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
}
