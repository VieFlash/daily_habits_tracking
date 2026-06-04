import '../entities/challenge.dart';
import '../repositories/challenge_repository.dart';

class GetChallenges {
  const GetChallenges(this._repo);
  final ChallengeRepository _repo;

  List<Challenge> call() => _repo.getChallenges();
}
