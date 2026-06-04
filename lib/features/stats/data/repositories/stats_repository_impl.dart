import '../../domain/entities/stats_overview.dart';
import '../../domain/repositories/stats_repository.dart';
import '../datasources/stats_seed.dart';

class StatsRepositoryImpl implements StatsRepository {
  const StatsRepositoryImpl();

  @override
  StatsOverview getOverview() => kStatsOverviewSeed;
}
