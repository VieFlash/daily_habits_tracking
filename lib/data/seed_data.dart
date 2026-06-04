import 'dart:math' as math;

import 'models/badge.dart';
import 'models/challenge.dart';
import 'models/habit.dart';
import 'models/journal_entry.dart';
import 'models/mood.dart';
import 'models/user_profile.dart';

/// Static seed content ported from data.jsx. Habits and journal entries are used
/// to populate local storage on first launch; the rest is reference data.
class SeedData {
  SeedData._();

  static const weekLabels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

  static const iconChoices = [
    'water',
    'meditate',
    'run',
    'book',
    'apple',
    'bed',
    'dumbbell',
    'coffee',
    'music',
    'pen',
    'leaf',
    'heart',
  ];

  static const weeklyCompletion = [80, 60, 100, 90, 70, 40, 85];
  static const monthTrend = [62, 70, 58, 81, 74, 88, 79, 92, 85, 90, 78, 95];
  static const heatmapWeeks = 18;

  static const user = UserProfile(
    name: 'Minh Anh',
    handle: '@minhanh',
    level: 12,
    xp: 740,
    xpMax: 1000,
    totalDone: 1284,
    longestStreak: 41,
    badges: 4,
    joinedDays: 184,
  );

  static List<Habit> habits() => const [
    Habit(
      id: 'h1',
      name: 'Uống nước',
      icon: 'water',
      color: 'sky',
      cat: 'Sức khỏe',
      goalText: '8 ly · mỗi ngày',
      freq: 'Hằng ngày',
      time: '08:00',
      unit: 'ly',
      target: 8,
      progress: 6,
      streak: 23,
      best: 41,
      done: false,
      reminder: true,
      weekDone: [1, 1, 1, 1, 0, 1, 0],
      rate: 86,
    ),
    Habit(
      id: 'h2',
      name: 'Thiền',
      icon: 'meditate',
      color: 'violet',
      cat: 'Tinh thần',
      goalText: '10 phút · sáng',
      freq: 'Hằng ngày',
      time: '06:30',
      unit: 'phút',
      target: 10,
      progress: 10,
      streak: 12,
      best: 30,
      done: true,
      reminder: true,
      weekDone: [1, 1, 1, 1, 1, 0, 0],
      rate: 71,
    ),
    Habit(
      id: 'h3',
      name: 'Chạy bộ',
      icon: 'run',
      color: 'coral',
      cat: 'Thể thao',
      goalText: '3 km · T2/T4/T6',
      freq: '3 lần / tuần',
      time: '17:30',
      unit: 'km',
      target: 3,
      progress: 0,
      streak: 5,
      best: 9,
      done: false,
      reminder: true,
      weekDone: [1, 0, 1, 0, 1, 0, 0],
      rate: 64,
    ),
    Habit(
      id: 'h4',
      name: 'Đọc sách',
      icon: 'book',
      color: 'amber',
      cat: 'Học tập',
      goalText: '20 trang · tối',
      freq: 'Hằng ngày',
      time: '21:00',
      unit: 'trang',
      target: 20,
      progress: 12,
      streak: 31,
      best: 31,
      done: false,
      reminder: false,
      weekDone: [1, 1, 1, 1, 1, 1, 0],
      rate: 92,
    ),
    Habit(
      id: 'h5',
      name: 'Không đường',
      icon: 'apple',
      color: 'green',
      cat: 'Ăn uống',
      goalText: 'Cả ngày',
      freq: 'Hằng ngày',
      time: '—',
      unit: '',
      target: 1,
      progress: 1,
      streak: 8,
      best: 14,
      done: true,
      reminder: false,
      weekDone: [1, 1, 0, 1, 1, 1, 0],
      rate: 78,
    ),
    Habit(
      id: 'h6',
      name: 'Ngủ trước 23h',
      icon: 'bed',
      color: 'pink',
      cat: 'Sức khỏe',
      goalText: 'Trước 23:00',
      freq: 'Hằng ngày',
      time: '22:45',
      unit: '',
      target: 1,
      progress: 0,
      streak: 3,
      best: 19,
      done: false,
      reminder: true,
      weekDone: [0, 1, 1, 0, 1, 0, 0],
      rate: 58,
    ),
  ];

  static const badges = [
    Badge(
      id: 'b1',
      name: 'Tia lửa đầu tiên',
      icon: 'zap',
      got: true,
      desc: 'Hoàn thành thói quen đầu tiên',
      color: 'amber',
    ),
    Badge(
      id: 'b2',
      name: 'Chuỗi 7 ngày',
      icon: 'fire',
      got: true,
      desc: 'Giữ streak 7 ngày liên tục',
      color: 'coral',
    ),
    Badge(
      id: 'b3',
      name: 'Chuỗi 30 ngày',
      icon: 'flag',
      got: true,
      desc: 'Giữ streak 30 ngày',
      color: 'green',
    ),
    Badge(
      id: 'b4',
      name: 'Người dậy sớm',
      icon: 'sun',
      got: true,
      desc: 'Check-in trước 7h sáng × 10',
      color: 'amber',
    ),
    Badge(
      id: 'b5',
      name: 'Tuần hoàn hảo',
      icon: 'star',
      got: false,
      desc: 'Hoàn thành 100% trong 1 tuần',
      color: 'violet',
    ),
    Badge(
      id: 'b6',
      name: 'Bậc thầy thiền',
      icon: 'leaf',
      got: false,
      desc: 'Thiền tổng 500 phút',
      color: 'green',
    ),
    Badge(
      id: 'b7',
      name: 'Mọt sách',
      icon: 'book',
      got: false,
      desc: 'Đọc 1000 trang',
      color: 'amber',
    ),
    Badge(
      id: 'b8',
      name: 'Huyền thoại',
      icon: 'trophy',
      got: false,
      desc: 'Đạt level 20',
      color: 'coral',
    ),
  ];

  static const challenges = [
    Challenge(
      id: 'c1',
      name: '21 ngày uống đủ nước',
      icon: 'water',
      color: 'sky',
      joined: true,
      total: 21,
      current: 14,
      people: 1284,
      days: '7 ngày còn lại',
    ),
    Challenge(
      id: 'c2',
      name: 'Tháng không đường',
      icon: 'apple',
      color: 'green',
      joined: true,
      total: 30,
      current: 8,
      people: 642,
      days: '22 ngày còn lại',
    ),
    Challenge(
      id: 'c3',
      name: 'Thử thách đọc 30 ngày',
      icon: 'book',
      color: 'amber',
      joined: false,
      total: 30,
      current: 0,
      people: 3120,
      days: 'Bắt đầu T2',
    ),
    Challenge(
      id: 'c4',
      name: '7 ngày dậy sớm',
      icon: 'sun',
      color: 'coral',
      joined: false,
      total: 7,
      current: 0,
      people: 890,
      days: 'Mở đăng ký',
    ),
    Challenge(
      id: 'c5',
      name: 'Chạy 50km / tháng',
      icon: 'run',
      color: 'violet',
      joined: false,
      total: 50,
      current: 0,
      people: 410,
      days: 'Bắt đầu 1/7',
    ),
  ];

  static const moods = [
    Mood(key: 'great', label: 'Tuyệt vời', icon: 'smile', color: 'green'),
    Mood(key: 'good', label: 'Ổn', icon: 'smile', color: 'sky'),
    Mood(key: 'meh', label: 'Bình thường', icon: 'meh', color: 'amber'),
    Mood(key: 'bad', label: 'Không vui', icon: 'frown', color: 'coral'),
  ];

  static List<JournalEntry> journal() => const [
    JournalEntry(
      id: 'j1',
      date: 'Hôm nay · 21:30',
      mood: 'great',
      text:
          'Hoàn thành cả 5 thói quen hôm nay! Chạy bộ buổi chiều giúp đầu óc nhẹ hẳn.',
      habits: ['Thiền', 'Đọc sách', 'Không đường'],
    ),
    JournalEntry(
      id: 'j2',
      date: 'Hôm qua · 22:10',
      mood: 'good',
      text:
          'Hơi mệt nhưng vẫn giữ được streak đọc sách. Mai thử dậy sớm hơn.',
      habits: ['Đọc sách', 'Uống nước'],
    ),
    JournalEntry(
      id: 'j3',
      date: '2 ngày trước · 20:45',
      mood: 'meh',
      text: 'Ngày bận rộn, bỏ lỡ buổi chạy. Không sao, mai làm lại.',
      habits: ['Thiền'],
    ),
  ];

  /// Seeded pseudo-random matching the JS `seeded()` helper, so the heatmap and
  /// mini-calendar look identical to the original mock.
  static double seeded(double n) {
    final x = math.sin(n) * 10000;
    return x - x.floorToDouble();
  }

  /// 18 weeks × 7 days heatmap intensity values (0–4), as in `makeHeatmap`.
  static List<int> heatmap() {
    final out = <int>[];
    const density = 1;
    for (var i = 0; i < heatmapWeeks * 7; i++) {
      final r = seeded(i * 2.3 + density * 7);
      var v = 0;
      if (r > 0.78) {
        v = 4;
      } else if (r > 0.62) {
        v = 3;
      } else if (r > 0.45) {
        v = 2;
      } else if (r > 0.3) {
        v = 1;
      }
      out.add(v);
    }
    return out;
  }
}
