import 'entities/habit.dart';

/// A ready-made habit preset offered to the user (app content, not user data).
/// Picking one creates a real [Habit] in the tracker.
class HabitTemplate {
  const HabitTemplate({
    required this.name,
    required this.icon,
    required this.color,
    required this.cat,
    required this.goalText,
    required this.unit,
    required this.target,
    required this.time,
  });

  final String name;
  final String icon;
  final String color;
  final String cat;
  final String goalText;
  final String unit;
  final int target;
  final String time; // 'HH:mm' or '—' when no reminder

  /// Builds a concrete, persistable habit from this preset.
  Habit toHabit() => Habit(
    id: 'h${DateTime.now().microsecondsSinceEpoch}',
    name: name,
    icon: icon,
    color: color,
    cat: cat,
    goalText: goalText,
    freq: 'Hằng ngày',
    time: time,
    unit: unit,
    target: target,
    reminder: time != '—',
    createdAt: DateTime.now(),
  );
}

/// Trending starter habits shown on the empty home state and in the create
/// screen so new users aren't faced with a blank tracker.
const kHabitTemplates = <HabitTemplate>[
  HabitTemplate(
    name: 'Uống nước',
    icon: 'water',
    color: 'sky',
    cat: 'Sức khỏe',
    goalText: '8 ly mỗi ngày',
    unit: 'ly',
    target: 8,
    time: '08:00',
  ),
  HabitTemplate(
    name: 'Thiền',
    icon: 'meditate',
    color: 'violet',
    cat: 'Tinh thần',
    goalText: '10 phút mỗi sáng',
    unit: 'phút',
    target: 10,
    time: '06:30',
  ),
  HabitTemplate(
    name: 'Đọc sách',
    icon: 'book',
    color: 'amber',
    cat: 'Học tập',
    goalText: '20 trang mỗi tối',
    unit: 'trang',
    target: 20,
    time: '21:00',
  ),
  HabitTemplate(
    name: 'Tập thể dục',
    icon: 'dumbbell',
    color: 'coral',
    cat: 'Thể thao',
    goalText: '30 phút vận động',
    unit: 'phút',
    target: 30,
    time: '17:30',
  ),
  HabitTemplate(
    name: 'Chạy bộ',
    icon: 'run',
    color: 'green',
    cat: 'Thể thao',
    goalText: '3 km mỗi ngày',
    unit: 'km',
    target: 3,
    time: '06:00',
  ),
  HabitTemplate(
    name: 'Ngủ sớm',
    icon: 'bed',
    color: 'pink',
    cat: 'Sức khỏe',
    goalText: 'Trước 23:00',
    unit: '',
    target: 1,
    time: '22:30',
  ),
  HabitTemplate(
    name: 'Ăn lành mạnh',
    icon: 'apple',
    color: 'green',
    cat: 'Ăn uống',
    goalText: 'Cả ngày',
    unit: '',
    target: 1,
    time: '—',
  ),
  HabitTemplate(
    name: 'Viết nhật ký',
    icon: 'pen',
    color: 'amber',
    cat: 'Tinh thần',
    goalText: 'Vài dòng mỗi ngày',
    unit: '',
    target: 1,
    time: '21:30',
  ),
  HabitTemplate(
    name: 'Biết ơn',
    icon: 'heart',
    color: 'pink',
    cat: 'Tinh thần',
    goalText: '3 điều mỗi ngày',
    unit: 'điều',
    target: 3,
    time: '22:00',
  ),
];
