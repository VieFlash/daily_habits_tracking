import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/badge.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => const ProfileRepositoryImpl(),
);

final userProfileProvider = Provider<UserProfile>(
  (ref) => ref.watch(profileRepositoryProvider).getProfile(),
);

final badgesProvider = Provider<List<Badge>>(
  (ref) => ref.watch(profileRepositoryProvider).getBadges(),
);
