import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local_store.dart';

/// Provides the [LocalStore]. Overridden in `main()` with the initialized
/// instance so the whole app can read/write local storage synchronously.
final localStoreProvider = Provider<LocalStore>(
  (ref) => throw UnimplementedError('localStoreProvider must be overridden'),
);
