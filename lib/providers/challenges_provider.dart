import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/challenge.dart';
import '../data/seed_data.dart';

/// In-memory challenges with join toggling. (Challenges are reference content in
/// the original mock, so they are not persisted.)
class ChallengesNotifier extends StateNotifier<List<Challenge>> {
  ChallengesNotifier() : super(SeedData.challenges);

  void join(String id) {
    state = [
      for (final ch in state)
        if (ch.id == id)
          ch.copyWith(joined: true, current: ch.current == 0 ? 1 : ch.current)
        else
          ch,
    ];
  }
}

final challengesProvider =
    StateNotifierProvider<ChallengesNotifier, List<Challenge>>(
      (ref) => ChallengesNotifier(),
    );
