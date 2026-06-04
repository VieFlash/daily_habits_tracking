import '../entities/app_settings.dart';

/// Reads/writes the user's [AppSettings]. Reads are synchronous (cached local
/// store); writes are awaited.
abstract interface class SettingsRepository {
  AppSettings getSettings();
  Future<void> saveSettings(AppSettings settings);
}
