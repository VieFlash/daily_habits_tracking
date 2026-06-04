import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'data/local_store.dart';
import 'providers/app_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize local storage (seeds mock data on first launch). This replaces
  // what would otherwise be a backend API.
  final store = await LocalStore.create();
  runApp(
    ProviderScope(
      overrides: [localStoreProvider.overrideWithValue(store)],
      child: const SproutApp(),
    ),
  );
}
