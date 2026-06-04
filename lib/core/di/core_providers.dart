import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../storage/key_value_store.dart';
import '../storage/shared_prefs_key_value_store.dart';

/// Provides the initialized [SharedPreferences] instance. Overridden in
/// `main()` after async initialization.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('sharedPreferencesProvider must be overridden'),
);

/// The app-wide [KeyValueStore] used by every feature's local data source.
final keyValueStoreProvider = Provider<KeyValueStore>(
  (ref) => SharedPrefsKeyValueStore(ref.watch(sharedPreferencesProvider)),
);
