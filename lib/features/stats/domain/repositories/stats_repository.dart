import '../entities/stats_overview.dart';

abstract interface class StatsRepository {
  StatsOverview getOverview();
}
