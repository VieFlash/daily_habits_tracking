import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/settings/presentation/providers/settings_providers.dart';
import 'routing/app_router.dart';

/// Root widget. Rebuilds the theme whenever appearance settings change.
class SproutApp extends ConsumerWidget {
  const SproutApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'Sprout — Habit Tracker',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(
        dark: settings.dark,
        accent: accentColorOf(settings),
        cornerKey: settings.corner,
      ),
      routerConfig: router,
    );
  }
}
