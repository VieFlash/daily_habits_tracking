import '../../domain/entities/badge.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_seed.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl();

  @override
  UserProfile getProfile() => kUserSeed;

  @override
  List<Badge> getBadges() => kBadgeSeed;
}
