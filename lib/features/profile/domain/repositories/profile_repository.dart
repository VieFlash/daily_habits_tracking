import '../entities/badge.dart';
import '../entities/user_profile.dart';

abstract interface class ProfileRepository {
  UserProfile getProfile();
  List<Badge> getBadges();
}
