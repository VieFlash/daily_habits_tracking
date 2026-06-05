import 'entities/habit.dart';

/// Pure functions that turn a habit's raw completion history into the derived
/// stats shown in the UI. Shared by the habits, stats and profile features.
///
/// Completions are stored per habit as a map of `dateKey -> count`, where the
/// count is how many units were logged that day (for `target == 1` habits any
/// count > 0 means done).

/// `DateTime` -> `yyyy-MM-dd` (date only, local).
String habitDateKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

/// Parses a `yyyy-MM-dd` key back to a date-only [DateTime], or null.
DateTime? parseHabitDateKey(String key) {
  final parts = key.split('-');
  if (parts.length != 3) return null;
  final y = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  final d = int.tryParse(parts[2]);
  if (y == null || m == null || d == null) return null;
  return DateTime(y, m, d);
}

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Whether [target] is satisfied by the logged count on [day].
bool isHabitDoneOn(int target, Map<String, int>? completions, DateTime day) {
  final count = completions?[habitDateKey(day)] ?? 0;
  return target <= 1 ? count > 0 : count >= target;
}

/// All dates on which the habit counted as "done", sorted ascending.
List<DateTime> _doneDates(int target, Map<String, int>? completions) {
  final out = <DateTime>[];
  completions?.forEach((key, count) {
    final satisfied = target <= 1 ? count > 0 : count >= target;
    if (!satisfied) return;
    final d = parseHabitDateKey(key);
    if (d != null) out.add(d);
  });
  out.sort();
  return out;
}

/// Longest run of consecutive done-days in [sortedDates].
int _longestRun(List<DateTime> sortedDates) {
  var best = 0;
  var run = 0;
  DateTime? prev;
  for (final d in sortedDates) {
    if (prev != null && d.difference(prev).inDays == 1) {
      run++;
    } else {
      run = 1;
    }
    if (run > best) best = run;
    prev = d;
  }
  return best;
}

/// Returns [definition] with the derived fields filled in for [now].
Habit deriveHabit(Habit definition, Map<String, int>? completions, DateTime now) {
  final today = _dateOnly(now);
  final created = _dateOnly(definition.createdAt);
  final target = definition.target;

  final todayCount = completions?[habitDateKey(today)] ?? 0;
  final done = target <= 1 ? todayCount > 0 : todayCount >= target;

  // Current streak: walk back from today (or yesterday if today isn't done yet)
  // until the first miss, so the streak doesn't visually drop before check-in.
  var streak = 0;
  var cursor = done ? today : today.subtract(const Duration(days: 1));
  while (!cursor.isBefore(created) && isHabitDoneOn(target, completions, cursor)) {
    streak++;
    cursor = cursor.subtract(const Duration(days: 1));
  }

  final doneDates = _doneDates(target, completions);
  final best = _longestRun(doneDates) < streak ? streak : _longestRun(doneDates);

  // This week's completion (Monday-first).
  final monday = today.subtract(Duration(days: today.weekday - 1));
  final weekDone = [
    for (var i = 0; i < 7; i++)
      isHabitDoneOn(target, completions, monday.add(Duration(days: i))) ? 1 : 0,
  ];

  // Completion rate over the habit's lifetime.
  final trackedDays = today.difference(created).inDays + 1;
  final tracked = trackedDays < 1 ? 1 : trackedDays;
  final completedInRange = doneDates
      .where((d) => !d.isBefore(created) && !d.isAfter(today))
      .length;
  final rate = (100 * completedInRange / tracked).round();

  return definition.copyWith(
    progress: todayCount,
    done: done,
    streak: streak,
    best: best,
    weekDone: weekDone,
    rate: rate,
  );
}

/// Percentage (0–100) of the habits that existed on [day] which were done that
/// day. Returns 0 for future days or when no habit existed yet.
int dayCompletionPercent(
  List<Habit> definitions,
  Map<String, Map<String, int>> completions,
  DateTime day,
  DateTime today,
) {
  final d = _dateOnly(day);
  if (d.isAfter(_dateOnly(today))) return 0;
  final existing = definitions
      .where((h) => !_dateOnly(h.createdAt).isAfter(d))
      .toList();
  if (existing.isEmpty) return 0;
  final done = existing
      .where((h) => isHabitDoneOn(h.target, completions[h.id], d))
      .length;
  return (100 * done / existing.length).round();
}

/// Aggregate activity across all habits: total done-days and the single longest
/// streak ever achieved.
({int totalDone, int longestStreak}) aggregateActivity(
  List<Habit> definitions,
  Map<String, Map<String, int>> completions,
) {
  var totalDone = 0;
  var longestStreak = 0;
  for (final h in definitions) {
    final dates = _doneDates(h.target, completions[h.id]);
    totalDone += dates.length;
    final best = _longestRun(dates);
    if (best > longestStreak) longestStreak = best;
  }
  return (totalDone: totalDone, longestStreak: longestStreak);
}
