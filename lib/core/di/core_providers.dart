import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../storage/hive_key_value_store.dart';
import '../storage/key_value_store.dart';

/// Name of the single Hive box that backs all on-device storage.
const kHiveBoxName = 'app';

/// Provides the opened Hive [Box]. Overridden in `main()` after async
/// initialization.
final hiveBoxProvider = Provider<Box>(
  (ref) => throw UnimplementedError('hiveBoxProvider must be overridden'),
);

/// The app-wide [KeyValueStore] used by every feature's local data source.
final keyValueStoreProvider = Provider<KeyValueStore>(
  (ref) => HiveKeyValueStore(ref.watch(hiveBoxProvider)),
);
