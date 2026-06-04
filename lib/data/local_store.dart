import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'models/habit.dart';
import 'models/journal_entry.dart';
import 'seed_data.dart';

/// Thin wrapper around [SharedPreferences] that persists all app state locally.
/// This replaces what would otherwise be a remote API.
class LocalStore {
  LocalStore(this._prefs);

  final SharedPreferences _prefs;

  static const _kSeeded = 'seeded_v1';
  static const _kHabits = 'habits';
  static const _kJournal = 'journal';
  static const _kOnboarded = 'onboarded';
  static const _kDark = 'pref_dark';
  static const _kAccent = 'pref_accent';
  static const _kCorner = 'pref_corner';
  static const _kLayout = 'pref_layout';

  /// Creates the store and seeds the initial mock data on first launch.
  static Future<LocalStore> create() async {
    final prefs = await SharedPreferences.getInstance();
    final store = LocalStore(prefs);
    if (!(prefs.getBool(_kSeeded) ?? false)) {
      await store.saveHabits(SeedData.habits());
      await store.saveJournal(SeedData.journal());
      await prefs.setBool(_kSeeded, true);
    }
    return store;
  }

  // ---- Habits ----
  List<Habit> loadHabits() {
    final raw = _prefs.getString(_kHabits);
    if (raw == null) return SeedData.habits();
    final list = jsonDecode(raw) as List;
    return list
        .map((e) => Habit.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<void> saveHabits(List<Habit> habits) {
    return _prefs.setString(
      _kHabits,
      jsonEncode(habits.map((h) => h.toJson()).toList()),
    );
  }

  // ---- Journal ----
  List<JournalEntry> loadJournal() {
    final raw = _prefs.getString(_kJournal);
    if (raw == null) return SeedData.journal();
    final list = jsonDecode(raw) as List;
    return list
        .map((e) => JournalEntry.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<void> saveJournal(List<JournalEntry> entries) {
    return _prefs.setString(
      _kJournal,
      jsonEncode(entries.map((e) => e.toJson()).toList()),
    );
  }

  // ---- Onboarding ----
  bool get onboarded => _prefs.getBool(_kOnboarded) ?? false;
  Future<void> setOnboarded(bool value) => _prefs.setBool(_kOnboarded, value);

  // ---- Appearance settings ----
  bool get dark => _prefs.getBool(_kDark) ?? false;
  Future<void> setDark(bool v) => _prefs.setBool(_kDark, v);

  int get accentIndex => _prefs.getInt(_kAccent) ?? 0;
  Future<void> setAccentIndex(int v) => _prefs.setInt(_kAccent, v);

  String get corner => _prefs.getString(_kCorner) ?? 'rounded';
  Future<void> setCorner(String v) => _prefs.setString(_kCorner, v);

  String get layout => _prefs.getString(_kLayout) ?? 'card';
  Future<void> setLayout(String v) => _prefs.setString(_kLayout, v);
}
