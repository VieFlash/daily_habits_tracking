import 'package:daily_habits_tracking/core/di/core_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/challenge_local_data_source.dart';
import '../../data/repositories/challenge_repository_impl.dart';
import '../../domain/entities/challenge.dart';
import '../../domain/repositories/challenge_repository.dart';
import '../../domain/usecases/get_challenges.dart';
import '../../domain/usecases/join_challenge.dart';

final challengeLocalDataSourceProvider = Provider<ChallengeLocalDataSource>(
  (ref) => ChallengeLocalDataSource(ref.watch(keyValueStoreProvider)),
);

final challengeRepositoryProvider = Provider<ChallengeRepository>(
  (ref) => ChallengeRepositoryImpl(ref.watch(challengeLocalDataSourceProvider)),
);

final _getChallengesProvider = Provider(
  (ref) => GetChallenges(ref.watch(challengeRepositoryProvider)),
);
final _joinChallengeProvider = Provider(
  (ref) => JoinChallenge(ref.watch(challengeRepositoryProvider)),
);

class ChallengesNotifier extends StateNotifier<List<Challenge>> {
  ChallengesNotifier(this._ref) : super(_ref.read(_getChallengesProvider)());

  final Ref _ref;

  void join(String id) {
    state = _ref.read(_joinChallengeProvider)(id);
  }
}

final challengesProvider =
    StateNotifierProvider<ChallengesNotifier, List<Challenge>>(
      (ref) => ChallengesNotifier(ref),
    );
