import '../../domain/entities/habit.dart';

/// Data-layer representation of a habit *definition* with JSON
/// (de)serialization. Only the definition is persisted; the derived stats
/// (progress/streak/best/done/weekDone/rate) are recomputed from the completion
/// history on read.
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
    required super.reminder,
    required super.createdAt,
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
    reminder: h.reminder,
    createdAt: h.createdAt,
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
    reminder: json['reminder'] as bool? ?? false,
    createdAt:
        DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
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
    'reminder': reminder,
    'createdAt': createdAt.toIso8601String(),
  };
}
