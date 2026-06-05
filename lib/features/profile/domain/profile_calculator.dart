import 'package:daily_habits_tracking/features/habits/domain/entities/habit.dart';
import 'package:daily_habits_tracking/features/habits/domain/habit_activity.dart';

import 'entities/badge.dart';
import 'entities/user_profile.dart';

/// XP awarded per completed habit-day.
const _xpPerDone = 10;

/// XP required to advance one level.
const _xpPerLevel = 100;

/// The achievement catalog (app content). `got` is computed from real activity.
List<Badge> computeBadges({
  required int totalDone,
  required int longestStreak,
  required int level,
  required int habitCount,
}) => [
  Badge(
    id: 'starter',
    name: 'Khởi đầu',
    icon: 'sparkle',
    got: habitCount >= 1,
    desc: 'Tạo thói quen đầu tiên',
    color: 'green',
  ),
  Badge(
    id: 'first_done',
    name: 'Lần đầu tiên',
    icon: 'check',
    got: totalDone >= 1,
    desc: 'Hoàn thành lần đầu',
    color: 'sky',
  ),
  Badge(
    id: 'streak7',
    name: 'Chuỗi 7 ngày',
    icon: 'fire',
    got: longestStreak >= 7,
    desc: 'Giữ streak 7 ngày liên tục',
    color: 'coral',
  ),
  Badge(
    id: 'streak30',
    name: 'Chuỗi 30 ngày',
    icon: 'flag',
    got: longestStreak >= 30,
    desc: 'Giữ streak 30 ngày',
    color: 'green',
  ),
  Badge(
    id: 'done50',
    name: 'Bền bỉ',
    icon: 'star',
    got: totalDone >= 50,
    desc: 'Hoàn thành 50 lần',
    color: 'amber',
  ),
  Badge(
    id: 'done100',
    name: 'Kiên trì',
    icon: 'trophy',
    got: totalDone >= 100,
    desc: 'Hoàn thành 100 lần',
    color: 'violet',
  ),
  Badge(
    id: 'level5',
    name: 'Cấp 5',
    icon: 'zap',
    got: level >= 5,
    desc: 'Đạt cấp độ 5',
    color: 'amber',
  ),
  Badge(
    id: 'collector',
    name: 'Đa dạng',
    icon: 'leaf',
    got: habitCount >= 5,
    desc: 'Cùng lúc theo dõi 5 thói quen',
    color: 'green',
  ),
];

/// Level reached for a given total XP (levels start at 1).
int levelForXp(int totalXp) => totalXp ~/ _xpPerLevel + 1;

/// Builds the [UserProfile] from real activity. [name]/[handle] are persisted
/// preferences; everything else is derived.
UserProfile computeUserProfile({
  required String name,
  required String handle,
  required List<Habit> habits,
  required Map<String, Map<String, int>> completions,
  required DateTime now,
  required DateTime installedAt,
}) {
  final agg = aggregateActivity(habits, completions);
  final totalXp = agg.totalDone * _xpPerDone;
  final level = levelForXp(totalXp);
  final xp = totalXp % _xpPerLevel;

  // "Joined" = days since the earliest of install time / first habit.
  var earliest = installedAt;
  for (final h in habits) {
    if (h.createdAt.isBefore(earliest)) earliest = h.createdAt;
  }
  final joinedDays = DateTime(now.year, now.month, now.day)
          .difference(DateTime(earliest.year, earliest.month, earliest.day))
          .inDays +
      1;

  final badgesGot = computeBadges(
    totalDone: agg.totalDone,
    longestStreak: agg.longestStreak,
    level: level,
    habitCount: habits.length,
  ).where((b) => b.got).length;

  return UserProfile(
    name: name,
    handle: handle,
    level: level,
    xp: xp,
    xpMax: _xpPerLevel,
    totalDone: agg.totalDone,
    longestStreak: agg.longestStreak,
    badges: badgesGot,
    joinedDays: joinedDays,
  );
}
