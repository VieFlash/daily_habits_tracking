/// Persistence for the user's editable profile fields and install timestamp.
/// Gamification numbers (XP, level, badges) are computed, not stored.
abstract interface class ProfileRepository {
  String getName();
  String getHandle();
  DateTime getInstalledAt();
  Future<void> saveName(String name);
}
