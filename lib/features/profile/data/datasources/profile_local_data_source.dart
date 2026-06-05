import 'package:daily_habits_tracking/core/storage/key_value_store.dart';

/// Persists the user's editable profile fields and the install timestamp used
/// to compute "days joined". All gamification numbers are derived elsewhere.
class ProfileLocalDataSource {
  ProfileLocalDataSource(this._store);

  final KeyValueStore _store;

  static const _kName = 'profile_name';
  static const _kHandle = 'profile_handle';
  static const _kInstalledAt = 'installed_at';

  static const _defaultName = 'Bạn';
  static const _defaultHandle = '@ban';

  String getName() => _store.getString(_kName) ?? _defaultName;
  String getHandle() => _store.getString(_kHandle) ?? _defaultHandle;

  Future<void> setName(String name) => _store.setString(_kName, name);
  Future<void> setHandle(String handle) => _store.setString(_kHandle, handle);

  /// The first-launch timestamp, recorded lazily the first time it is read.
  DateTime getInstalledAt() {
    final raw = _store.getString(_kInstalledAt);
    final parsed = raw == null ? null : DateTime.tryParse(raw);
    if (parsed != null) return parsed;
    final now = DateTime.now();
    _store.setString(_kInstalledAt, now.toIso8601String());
    return now;
  }
}
