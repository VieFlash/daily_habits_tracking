import 'package:daily_habits_tracking/core/storage/key_value_store.dart';

import '../../domain/entities/app_settings.dart';

/// Persists [AppSettings] fields as individual keys in the [KeyValueStore].
class SettingsLocalDataSource {
  SettingsLocalDataSource(this._store);

  final KeyValueStore _store;

  static const _kDark = 'pref_dark';
  static const _kAccent = 'pref_accent';
  static const _kCorner = 'pref_corner';
  static const _kLayout = 'pref_layout';
  static const _kOnboarded = 'onboarded';

  AppSettings read() => AppSettings(
    dark: _store.getBool(_kDark) ?? AppSettings.initial.dark,
    accentIndex: _store.getInt(_kAccent) ?? AppSettings.initial.accentIndex,
    corner: _store.getString(_kCorner) ?? AppSettings.initial.corner,
    layout: _store.getString(_kLayout) ?? AppSettings.initial.layout,
    onboarded: _store.getBool(_kOnboarded) ?? AppSettings.initial.onboarded,
  );

  Future<void> write(AppSettings s) async {
    await _store.setBool(_kDark, s.dark);
    await _store.setInt(_kAccent, s.accentIndex);
    await _store.setString(_kCorner, s.corner);
    await _store.setString(_kLayout, s.layout);
    await _store.setBool(_kOnboarded, s.onboarded);
  }
}
