import '../entities/challenge.dart';

abstract interface class ChallengeRepository {
  List<Challenge> getChallenges();

  /// Marks a challenge as joined and returns the updated list.
  List<Challenge> join(String id);
}
