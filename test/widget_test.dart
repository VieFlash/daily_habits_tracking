// Basic smoke test for the Sprout habit tracker.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:daily_habits_tracking/app.dart';
import 'package:daily_habits_tracking/core/di/core_providers.dart';

void main() {
  late Box box;

  setUp(() async {
    Hive.init('./.dart_tool/test_hive');
    box = await Hive.openBox(
      'test_${DateTime.now().microsecondsSinceEpoch}',
    );
  });

  tearDown(() async {
    await box.deleteFromDisk();
  });

  testWidgets('App boots into onboarding on first launch', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [hiveBoxProvider.overrideWithValue(box)],
        child: const SproutApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Onboarding shows the "skip" affordance.
    expect(find.text('Bỏ qua'), findsOneWidget);
  });
}
