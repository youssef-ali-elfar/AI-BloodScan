import 'package:hive_flutter/hive_flutter.dart';
import '../models/blood_test.dart';
import '../models/user_preferences.dart';

/// Local Storage Service using Hive Database
///
/// Manages persistent storage for the application using Hive, a lightweight and
/// fast NoSQL database optimized for Flutter applications.
///
/// **Stored Data:**
/// - **Blood Tests**: Complete CBC analysis history with all parameters and diagnoses
/// - **User Preferences**: Language, theme, and user profile settings
///
/// **Features:**
/// - Fast read/write operations
/// - Type-safe storage with generated adapters
/// - Automatic data persistence
/// - Support for complex objects
///
/// **Storage Boxes:**
/// - `blood_tests`: Stores BloodTest objects indexed by UUID
/// - `user_preferences`: Stores single UserPreferences object
///
/// **Initialization:**
/// Must be initialized before app starts:
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await StorageService.init();
///   runApp(MyApp());
/// }
/// ```
///
/// **Example Usage:**
/// ```dart
/// // Save blood test
/// final test = BloodTest(...);
/// await StorageService.saveTest(test);
///
/// // Get all tests (sorted by timestamp)
/// final tests = StorageService.getAllTests();
///
/// // Update preferences
/// await StorageService.updateLanguage('ar');
/// ```
class StorageService {
  static const String _testsBoxName = 'blood_tests';
  static const String _prefsBoxName = 'user_preferences';

  // Initialize Hive
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(BloodTestAdapter());
    Hive.registerAdapter(UserPreferencesAdapter());
    
    // Open boxes
    await Hive.openBox<BloodTest>(_testsBoxName);
    await Hive.openBox<UserPreferences>(_prefsBoxName);
  }

  // Blood Test Operations
  static Future<void> saveTest(BloodTest test) async {
    final box = Hive.box<BloodTest>(_testsBoxName);
    await box.put(test.id, test);
  }

  static List<BloodTest> getAllTests() {
    final box = Hive.box<BloodTest>(_testsBoxName);
    return box.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  static BloodTest? getTest(String id) {
    final box = Hive.box<BloodTest>(_testsBoxName);
    return box.get(id);
  }

  static Future<void> deleteTest(String id) async {
    final box = Hive.box<BloodTest>(_testsBoxName);
    await box.delete(id);
  }

  static Future<void> clearAllTests() async {
    final box = Hive.box<BloodTest>(_testsBoxName);
    await box.clear();
  }

  // User Preferences Operations
  static Future<void> savePreferences(UserPreferences prefs) async {
    final box = Hive.box<UserPreferences>(_prefsBoxName);
    await box.put('prefs', prefs);
  }

  static UserPreferences getPreferences() {
    final box = Hive.box<UserPreferences>(_prefsBoxName);
    return box.get('prefs', defaultValue: UserPreferences())!;
  }

  static Future<void> updateUserName(String name) async {
    final prefs = getPreferences();
    prefs.userName = name;
    await savePreferences(prefs);
  }

  static Future<void> updateLanguage(String languageCode) async {
    final prefs = getPreferences();
    prefs.languageCode = languageCode;
    await savePreferences(prefs);
  }

  static Future<void> updateThemeMode(bool isDarkMode) async {
    final prefs = getPreferences();
    prefs.isDarkMode = isDarkMode;
    await savePreferences(prefs);
  }
}
