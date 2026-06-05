import '../../domain/entities/challenge.dart';
import '../../domain/repositories/challenge_repository.dart';
import '../datasources/challenge_catalog.dart';
import '../datasources/challenge_local_data_source.dart';

/// Serves the challenge catalog with the user's persisted join state overlaid.
class ChallengeRepositoryImpl implements ChallengeRepository {
  ChallengeRepositoryImpl(this._local);

  final ChallengeLocalDataSource _local;

  @override
  List<Challenge> getChallenges() {
    final joins = _local.readJoins();
    return [
      for (final c in kChallengeCatalog)
        if (joins.containsKey(c.id))
          c.copyWith(joined: true, current: joins[c.id])
        else
          c,
    ];
  }

  @override
  List<Challenge> join(String id) {
    final joins = Map<String, int>.of(_local.readJoins());
    if (!joins.containsKey(id)) {
      joins[id] = 1; // day 1 on joining
      // Hive updates its in-memory cache synchronously, so the read below already
      // reflects this write even though persistence completes asynchronously.
      _local.writeJoins(joins);
    }
    return getChallenges();
  }
}
