/// Abstraction over a synchronous-read key/value store. Data sources depend on
/// this rather than on `shared_preferences` directly, keeping the data layer
/// free of plugin details (and trivially swappable / mockable).
abstract interface class KeyValueStore {
  String? getString(String key);
  Future<void> setString(String key, String value);

  bool? getBool(String key);
  Future<void> setBool(String key, bool value);

  int? getInt(String key);
  Future<void> setInt(String key, int value);
}
