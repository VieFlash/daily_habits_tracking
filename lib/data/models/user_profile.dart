import 'package:flutter/foundation.dart';

/// The current user's profile / gamification stats (USER in data.jsx).
@immutable
class UserProfile {
  const UserProfile({
    required this.name,
    required this.handle,
    required this.level,
    required this.xp,
    required this.xpMax,
    required this.totalDone,
    required this.longestStreak,
    required this.badges,
    required this.joinedDays,
  });

  final String name;
  final String handle;
  final int level;
  final int xp;
  final int xpMax;
  final int totalDone;
  final int longestStreak;
  final int badges;
  final int joinedDays;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}
