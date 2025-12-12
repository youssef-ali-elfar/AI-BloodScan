import 'package:hive/hive.dart';

part 'user_preferences.g.dart';

/// User Preferences Data Model
///
/// Stores user-specific settings and preferences that persist across app sessions.
/// Managed by StorageService using Hive database for fast local storage.
///
/// **Stored Preferences:**
/// - [userName]: Display name shown in greetings and reports
/// - [languageCode]: App language ('en' for English, 'ar' for Arabic)
/// - [isDarkMode]: Theme preference (true = dark theme, false = light theme)
///
/// **Localization Support:**
/// The app supports English and Arabic with RTL layout for Arabic.
///
/// **Theme Support:**
/// - Light theme with blue primary color
/// - Dark theme with navy background and blue accents
///
/// **Default Values:**
/// - userName: 'User'
/// - languageCode: 'en'
/// - isDarkMode: true
///
/// **Example:**
/// ```dart
/// final prefs = UserPreferences(
///   userName: 'Ahmed',
///   languageCode: 'ar',
///   isDarkMode: true,
/// );
/// await StorageService.savePreferences(prefs);
/// ```
@HiveType(typeId: 1)
class UserPreferences extends HiveObject {
  @HiveField(0)
  String userName;

  @HiveField(1)
  String languageCode; // 'en' or 'ar'

  @HiveField(2)
  bool isDarkMode;

  UserPreferences({
    this.userName = 'User',
    this.languageCode = 'en',
    this.isDarkMode = true, // Dark mode as default
  });
}
