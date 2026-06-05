import 'package:daily_habits_tracking/core/di/core_providers.dart';
import 'package:daily_habits_tracking/core/theme/habit_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/settings_local_data_source.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';

final settingsLocalDataSourceProvider = Provider<SettingsLocalDataSource>(
  (ref) => SettingsLocalDataSource(ref.watch(keyValueStoreProvider)),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepositoryImpl(ref.watch(settingsLocalDataSourceProvider)),
);

/// Holds the current [AppSettings] and persists every change via the repository.
class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier(this._repo) : super(_repo.getSettings());

  final SettingsRepository _repo;

  void _update(AppSettings next) {
    state = next;
    _repo.saveSettings(next);
  }

  void toggleDark() => _update(state.copyWith(dark: !state.dark));
  void setDark(bool v) => _update(state.copyWith(dark: v));
  void setAccentIndex(int i) => _update(state.copyWith(accentIndex: i));
  void setCorner(String c) => _update(state.copyWith(corner: c));
  void setLayout(String l) => _update(state.copyWith(layout: l));
  void completeOnboarding() => _update(state.copyWith(onboarded: true));

  void hideSuggestions() => _update(state.copyWith(suggestionsHidden: true));
  void setSuggestionsHidden(bool v) =>
      _update(state.copyWith(suggestionsHidden: v));

  /// Cycles card -> list -> grid (cycleLayout in app.jsx); returns the new value.
  String cycleLayout() {
    const order = ['card', 'list', 'grid'];
    final next = order[(order.indexOf(state.layout) + 1) % order.length];
    setLayout(next);
    return next;
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>(
  (ref) => SettingsNotifier(ref.watch(settingsRepositoryProvider)),
);

/// Resolves the selected accent index to a concrete [Color] (presentation
/// concern, kept out of the domain entity).
Color accentColorOf(AppSettings s) =>
    HabitPalette.accents[s.accentIndex % HabitPalette.accents.length];
