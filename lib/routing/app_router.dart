import 'package:daily_habits_tracking/features/challenges/presentation/screens/challenges_screen.dart';
import 'package:daily_habits_tracking/features/habits/presentation/screens/create_habit_screen.dart';
import 'package:daily_habits_tracking/features/habits/presentation/screens/habit_detail_screen.dart';
import 'package:daily_habits_tracking/features/habits/presentation/screens/home_screen.dart';
import 'package:daily_habits_tracking/features/journal/presentation/screens/journal_screen.dart';
import 'package:daily_habits_tracking/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:daily_habits_tracking/features/profile/presentation/screens/gamification_screen.dart';
import 'package:daily_habits_tracking/features/profile/presentation/screens/profile_screen.dart';
import 'package:daily_habits_tracking/features/settings/presentation/providers/settings_providers.dart';
import 'package:daily_habits_tracking/features/shell/presentation/screens/shell_screen.dart';
import 'package:daily_habits_tracking/features/stats/presentation/screens/stats_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _rootKey = GlobalKey<NavigatorState>();

/// App router. Onboarding is shown until completed, after which the four-tab
/// shell becomes the home.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/home',
    redirect: (context, state) {
      final onboarded = ref.read(settingsProvider).onboarded;
      final goingToOnboarding = state.matchedLocation == '/onboarding';
      if (!onboarded && !goingToOnboarding) return '/onboarding';
      if (onboarded && goingToOnboarding) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            ShellScreen(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/stats',
                builder: (context, state) => const StatsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/challenges',
                builder: (context, state) => const ChallengesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/journal',
                builder: (context, state) => const JournalScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/create',
        parentNavigatorKey: _rootKey,
        builder: (context, state) =>
            CreateHabitScreen(editingId: state.uri.queryParameters['editId']),
      ),
      GoRoute(
        path: '/detail/:id',
        parentNavigatorKey: _rootKey,
        builder: (context, state) =>
            HabitDetailScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/gamification',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const GamificationScreen(),
      ),
      GoRoute(
        path: '/profile',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
});
