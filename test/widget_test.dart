// Basic smoke test for the Sprout habit tracker.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:daily_habits_tracking/app.dart';
import 'package:daily_habits_tracking/data/local_store.dart';
import 'package:daily_habits_tracking/providers/app_providers.dart';

void main() {
  testWidgets('App boots into onboarding on first launch', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final store = await LocalStore.create();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [localStoreProvider.overrideWithValue(store)],
        child: const SproutApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Onboarding shows the "skip" affordance.
    expect(find.text('Bỏ qua'), findsOneWidget);
  });
}
