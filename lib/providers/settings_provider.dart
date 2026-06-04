import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/habit_palette.dart';
import 'app_providers.dart';

/// Appearance + layout preferences, persisted to local storage.
@immutable
class Settings {
  const Settings({
    required this.dark,
    required this.accentIndex,
    required this.corner,
    required this.layout,
    required this.onboarded,
  });

  final bool dark;
  final int accentIndex;
  final String corner; // rounded | soft | sharp
  final String layout; // card | list | grid
  final bool onboarded;

  Color get accent => HabitPalette.accents[accentIndex % HabitPalette.accents.length];

  Settings copyWith({
    bool? dark,
    int? accentIndex,
    String? corner,
    String? layout,
    bool? onboarded,
  }) => Settings(
    dark: dark ?? this.dark,
    accentIndex: accentIndex ?? this.accentIndex,
    corner: corner ?? this.corner,
    layout: layout ?? this.layout,
    onboarded: onboarded ?? this.onboarded,
  );
}

class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier(this._ref)
    : super(
        Settings(
          dark: _ref.read(localStoreProvider).dark,
          accentIndex: _ref.read(localStoreProvider).accentIndex,
          corner: _ref.read(localStoreProvider).corner,
          layout: _ref.read(localStoreProvider).layout,
          onboarded: _ref.read(localStoreProvider).onboarded,
        ),
      );

  final Ref _ref;

  void toggleDark() => setDark(!state.dark);

  void setDark(bool v) {
    state = state.copyWith(dark: v);
    _ref.read(localStoreProvider).setDark(v);
  }

  void setAccentIndex(int i) {
    state = state.copyWith(accentIndex: i);
    _ref.read(localStoreProvider).setAccentIndex(i);
  }

  void setCorner(String c) {
    state = state.copyWith(corner: c);
    _ref.read(localStoreProvider).setCorner(c);
  }

  void setLayout(String l) {
    state = state.copyWith(layout: l);
    _ref.read(localStoreProvider).setLayout(l);
  }

  /// Cycles card -> list -> grid (cycleLayout in app.jsx).
  String cycleLayout() {
    const order = ['card', 'list', 'grid'];
    final next = order[(order.indexOf(state.layout) + 1) % order.length];
    setLayout(next);
    return next;
  }

  void completeOnboarding() {
    state = state.copyWith(onboarded: true);
    _ref.read(localStoreProvider).setOnboarded(true);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, Settings>(
  (ref) => SettingsNotifier(ref),
);
