import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'core/di/core_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize on-device storage. The app starts empty — the user creates their
  // own habits/journal, and all stats are derived from real activity.
  await Hive.initFlutter();
  final box = await Hive.openBox(kHiveBoxName);
  runApp(
    ProviderScope(
      overrides: [hiveBoxProvider.overrideWithValue(box)],
      child: const SproutApp(),
    ),
  );
}
