import '../entities/challenge.dart';
import '../repositories/challenge_repository.dart';

class JoinChallenge {
  const JoinChallenge(this._repo);
  final ChallengeRepository _repo;

  List<Challenge> call(String id) => _repo.join(id);
}
