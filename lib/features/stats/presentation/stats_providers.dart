import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/stats_repository_impl.dart';
import '../domain/entities/stats_overview.dart';
import '../domain/repositories/stats_repository.dart';

final statsRepositoryProvider = Provider<StatsRepository>(
  (ref) => const StatsRepositoryImpl(),
);

final statsOverviewProvider = Provider<StatsOverview>(
  (ref) => ref.watch(statsRepositoryProvider).getOverview(),
);
