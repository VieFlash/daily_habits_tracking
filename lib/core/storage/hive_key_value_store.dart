import 'package:hive/hive.dart';

import 'key_value_store.dart';

/// [KeyValueStore] backed by a Hive [Box]. Reads hit Hive's in-memory cache
/// (hence synchronous); writes are awaited.
class HiveKeyValueStore implements KeyValueStore {
  HiveKeyValueStore(this._box);

  final Box _box;

  @override
  String? getString(String key) => _box.get(key) as String?;

  @override
  Future<void> setString(String key, String value) => _box.put(key, value);

  @override
  bool? getBool(String key) => _box.get(key) as bool?;

  @override
  Future<void> setBool(String key, bool value) => _box.put(key, value);

  @override
  int? getInt(String key) => _box.get(key) as int?;

  @override
  Future<void> setInt(String key, int value) => _box.put(key, value);
}
