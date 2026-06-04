import '../../domain/entities/challenge.dart';
import '../../domain/repositories/challenge_repository.dart';
import '../datasources/challenge_seed.dart';

/// In-memory challenge repository. Join state lives for the app session only
/// (challenges are reference content in the original mock, not persisted).
class ChallengeRepositoryImpl implements ChallengeRepository {
  List<Challenge> _state = List.of(kChallengeSeed);

  @override
  List<Challenge> getChallenges() => List.unmodifiable(_state);

  @override
  List<Challenge> join(String id) {
    _state = [
      for (final ch in _state)
        if (ch.id == id)
          ch.copyWith(joined: true, current: ch.current == 0 ? 1 : ch.current)
        else
          ch,
    ];
    return List.unmodifiable(_state);
  }
}
