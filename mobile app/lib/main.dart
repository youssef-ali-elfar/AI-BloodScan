import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import 'models/blood_test.dart';
import 'models/user_preferences.dart';
import 'services/storage_service.dart';
import 'services/diagnosis_service.dart';
import 'services/api_service.dart';
import 'services/pdf_service.dart';
import 'screens/history_screen.dart';
import 'screens/api_test_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const AIBloodScanApp(),
    ),
  );
}

class AppState extends ChangeNotifier {
  UserPreferences _prefs = StorageService.getPreferences();
  List<BloodTest> _tests = StorageService.getAllTests();
  BloodTest? _currentTest;

  UserPreferences get prefs => _prefs;
  List<BloodTest> get tests => _tests;
  BloodTest? get currentTest => _currentTest;

  String get userName => _prefs.userName;
  String get languageCode => _prefs.languageCode;
  bool get isDarkMode => _prefs.isDarkMode;

  Locale get locale => Locale(languageCode);
  ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  Future<void> setUserName(String name) async {
    _prefs.userName = name;
    await StorageService.savePreferences(_prefs);
    notifyListeners();
  }

  Future<void> setLanguage(String code) async {
    _prefs.languageCode = code;
    await StorageService.savePreferences(_prefs);
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _prefs.isDarkMode = !_prefs.isDarkMode;
    await StorageService.savePreferences(_prefs);
    notifyListeners();
  }

  Future<void> addTest(BloodTest test) async {
    await StorageService.saveTest(test);
    _tests = StorageService.getAllTests();
    notifyListeners();
  }

  Future<void> deleteTest(String id) async {
    await StorageService.deleteTest(id);
    _tests = StorageService.getAllTests();
    notifyListeners();
  }

  Future<void> clearHistory() async {
    await StorageService.clearAllTests();
    _tests = [];
    notifyListeners();
  }

  void setCurrentTest(BloodTest? test) {
    _currentTest = test;
    notifyListeners();
  }
}

class AIBloodScanApp extends StatelessWidget {
  const AIBloodScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return MaterialApp(
          title: 'AI BloodScan',
          debugShowCheckedModeBanner: false,
          locale: appState.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('ar')],
          theme: _buildLightTheme(),
          darkTheme: _buildDarkTheme(),
          themeMode: appState.themeMode,
          initialRoute: '/',
          onGenerateRoute: (settings) {
            Widget page;
            switch (settings.name) {
              case '/':
                page = const SplashScreen();
                break;
              case '/onboarding':
                page = const OnboardingScreen();
                break;
              case '/home':
                page = const HomePage();
                break;
              case '/upload':
                page = const UploadScreen();
                break;
              case '/ocr_result':
                page = const OCRResultScreen();
                break;
              case '/diagnosis':
                page = const DiagnosisScreen();
                break;
              case '/report':
                page = const FullReportScreen();
                break;
              case '/history':
                page = const HistoryScreen();
                break;
              case '/settings':
                page = const SettingsScreen();
                break;
              default:
                page = const SplashScreen();
            }

            return PageRouteBuilder(
              settings: settings,
              pageBuilder: (context, animation, secondaryAnimation) => page,
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOutCubic;

                var slideTween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                var fadeTween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(slideTween),
                  child: FadeTransition(
                    opacity: animation.drive(fadeTween),
                    child: child,
                  ),
                );
              },
              transitionDuration: const Duration(milliseconds: 400),
            );
          },
        );
      },
    );
  }

  ThemeData _buildLightTheme() {
    const primaryColor = Color(0xFF3B82F6);
    const backgroundColor = Color(0xFFF8FAFC);
    const surfaceColor = Colors.white;

    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.fromSeed(seedColor: primaryColor, brightness: Brightness.light),
      useMaterial3: true,
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.inter(fontSize: 16),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      cardTheme: CardThemeData(color: surfaceColor, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    const primaryColor = Color(0xFF3B82F6);
    const backgroundColor = Color(0xFF0F172A);
    const surfaceColor = Color(0xFF1E293B);

    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.fromSeed(seedColor: primaryColor, brightness: Brightness.dark, surface: surfaceColor),
      useMaterial3: true,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
        displayMedium: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
        bodyLarge: GoogleFonts.inter(fontSize: 16, color: Colors.white70),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      cardTheme: CardThemeData(color: surfaceColor, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

// Continuing with screens in next part to avoid token limit...
// -------------------- Splash Screen --------------------
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2500), () {
      Navigator.of(context).pushReplacementNamed('/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInDown(
              duration: const Duration(milliseconds: 1200),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.bloodtype_rounded,
                  size: 64,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              duration: const Duration(milliseconds: 1200),
              delay: const Duration(milliseconds: 200),
              child: Text(
                l10n.appTitle,
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 8),
            FadeInUp(
              duration: const Duration(milliseconds: 1200),
              delay: const Duration(milliseconds: 400),
              child: Text(
                l10n.smartCBCAnalysis,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------- Onboarding --------------------
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pc = PageController();
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primary = Theme.of(context).primaryColor;
    
    final pages = [
      {'title': l10n.onboardingTitle1, 'subtitle': l10n.onboardingSubtitle1, 'icon': Icons.document_scanner_rounded},
      {'title': l10n.onboardingTitle2, 'subtitle': l10n.onboardingSubtitle2, 'icon': Icons.health_and_safety_rounded},
      {'title': l10n.onboardingTitle3, 'subtitle': l10n.onboardingSubtitle3, 'icon': Icons.analytics_rounded},
    ];

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.1),
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
                    child: Text(l10n.skip),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pc,
                    itemCount: pages.length,
                    onPageChanged: (i) => setState(() => pageIndex = i),
                    itemBuilder: (context, i) {
                      final p = pages[i];
                      return Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ZoomIn(
                              duration: const Duration(milliseconds: 800),
                              child: Container(
                                width: 280,
                                height: 280,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardTheme.color,
                                  borderRadius: BorderRadius.circular(40),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primary.withOpacity(0.15),
                                      blurRadius: 40,
                                      offset: const Offset(0, 20),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    p['icon'] as IconData,
                                    size: 100,
                                    color: primary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 48),
                            FadeInUp(
                              duration: const Duration(milliseconds: 600),
                              delay: const Duration(milliseconds: 200),
                              child: Text(
                                p['title'] as String,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.displayMedium,
                              ),
                            ),
                            const SizedBox(height: 16),
                            FadeInUp(
                              duration: const Duration(milliseconds: 600),
                              delay: const Duration(milliseconds: 400),
                              child: Text(
                                p['subtitle'] as String,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (pageIndex > 0)
                        TextButton.icon(
                          onPressed: () {
                            _pc.previousPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOutCubic,
                            );
                          },
                          icon: const Icon(Icons.arrow_back_rounded),
                          label: Text(l10n.back),
                        )
                      else
                        const SizedBox(width: 100),
                      Row(
                        children: List.generate(
                          pages.length,
                          (idx) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 8),
                            width: idx == pageIndex ? 32 : 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: idx == pageIndex ? primary : primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (pageIndex == pages.length - 1) {
                            Navigator.of(context).pushReplacementNamed('/home');
                          } else {
                            _pc.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOutCubic,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: pageIndex == pages.length - 1 ? null : const CircleBorder(),
                          padding: pageIndex == pages.length - 1 ? null : const EdgeInsets.all(20),
                        ),
                        child: pageIndex == pages.length - 1
                            ? Text(l10n.getStarted)
                            : const Icon(Icons.arrow_forward_rounded),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Continue with remaining screens in next file...

// -------------------- Home Page --------------------
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appState = context.watch<AppState>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            floating: true,
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.greeting(appState.userName),
                    style: GoogleFonts.poppins(
                      color: Theme.of(context).textTheme.displayMedium?.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Welcome back!',
                    style: GoogleFonts.inter(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => Navigator.of(context).pushNamed('/history'),
                icon: const Icon(Icons.history_rounded),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pushNamed('/settings'),
                icon: const Icon(Icons.settings_rounded),
              ),
              const SizedBox(width: 8),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  child: _buildActionCard(
                    context,
                    title: l10n.uploadCBCSheet,
                    subtitle: l10n.scanOrUpload,
                    icon: Icons.upload_file_rounded,
                    color: Theme.of(context).primaryColor,
                    onTap: () => Navigator.of(context).pushNamed('/upload'),
                  ),
                ),
                const SizedBox(height: 20),
                FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 100),
                  child: _buildActionCard(
                    context,
                    title: l10n.manualEntry,
                    subtitle: l10n.enterManually,
                    icon: Icons.edit_note_rounded,
                    color: Colors.orange.shade600,
                    onTap: () {},
                  ),
                ),
                const SizedBox(height: 32),
                FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 200),
                  child: Text(
                    l10n.recentActivity,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 16),
                if (appState.tests.isNotEmpty)
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 300),
                    child: _buildRecentActivityCard(context, appState.tests.first, l10n),
                  )
                else
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 300),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(
                        child: Text(
                          l10n.noTestsYet,
                          style: TextStyle(color: Colors.grey.shade400),
                        ),
                      ),
                    ),
                  ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTapDown: (_) {},
      onTapUp: (_) => onTap(),
      onTapCancel: () {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 16),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withOpacity(isDark ? 0.15 : 0.1),
                color.withOpacity(isDark ? 0.08 : 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.15),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: color,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivityCard(BuildContext context, BloodTest test, AppLocalizations l10n) {
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_circle_rounded, color: Colors.green.shade600),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.lastAnalysis,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  dateFormat.format(test.timestamp),
                  style: GoogleFonts.inter(
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
        ],
      ),
    );
  }
}

// -------------------- Upload Screen --------------------
class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isAnalyzing = false;
  String _selectedGender = 'male'; // Default to male

  Future<void> _pick(ImageSource src) async {
    final XFile? picked = await _picker.pickImage(
      source: src,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  Future<void> _analyzeImage() async {
    if (_image == null || _isAnalyzing) return;

    setState(() => _isAnalyzing = true);
    final appState = context.read<AppState>();

    try {
      // Call backend API - it handles OCR extraction + ML prediction
      final apiResponse = await ApiService.predictFromImage(_image!);
      
      // Extract CBC values and prediction from response
      final cbcValues = apiResponse['cbc_values'] as Map<String, dynamic>;
      final predictedClass = apiResponse['predicted_class'] as String;
      final confidence = apiResponse['confidence'] as double;

      // Convert CBC values to Map<String, double> for analysis
      final cbcParams = {
        'HGB': (cbcValues['HGB'] as num?)?.toDouble() ?? 0.0,
        'RBC': (cbcValues['RBC'] as num?)?.toDouble() ?? 0.0,
        'WBC': (cbcValues['WBC'] as num?)?.toDouble() ?? 0.0,
        'PLT': (cbcValues['PLT'] as num?)?.toDouble() ?? 0.0,
        'LYMP': (cbcValues['LYMP'] as num?)?.toDouble() ?? 0.0,
        'MONO': (cbcValues['MONO'] as num?)?.toDouble() ?? 0.0,
        'HCT': (cbcValues['HCT'] as num?)?.toDouble() ?? 0.0,
        'MCV': (cbcValues['MCV'] as num?)?.toDouble() ?? 0.0,
        'MCH': (cbcValues['MCH'] as num?)?.toDouble() ?? 0.0,
        'MCHC': (cbcValues['MCHC'] as num?)?.toDouble() ?? 0.0,
        'RDW': (cbcValues['RDW'] as num?)?.toDouble() ?? 0.0,
        'PDW': (cbcValues['PDW'] as num?)?.toDouble() ?? 0.0,
        'MPV': (cbcValues['MPV'] as num?)?.toDouble() ?? 0.0,
        'PCT': (cbcValues['PCT'] as num?)?.toDouble() ?? 0.0,
      };

      // Analyze all parameters with gender
      final diagnosis = DiagnosisService.analyzeAllParameters(
        cbcParams,
        gender: _selectedGender,
      );

      // Add AI prediction to diagnosis
      diagnosis['overall'] = {
        'assessment': 'AI Prediction: $predictedClass (${(confidence * 100).toStringAsFixed(1)}% confidence)',
        'conditions': predictedClass != 'Normal' ? [predictedClass] : [],
      };

      // Create BloodTest object from API response
      final test = BloodTest(
        id: const Uuid().v4(),
        timestamp: DateTime.now(),
        hgb: cbcParams['HGB']!,
        rbc: cbcParams['RBC']!,
        wbc: cbcParams['WBC']!,
        plt: cbcParams['PLT']!,
        lymp: cbcParams['LYMP']!,
        mono: cbcParams['MONO']!,
        hct: cbcParams['HCT']!,
        mcv: cbcParams['MCV']!,
        mch: cbcParams['MCH']!,
        mchc: cbcParams['MCHC']!,
        rdw: cbcParams['RDW']!,
        pdw: cbcParams['PDW']!,
        mpv: cbcParams['MPV']!,
        pct: cbcParams['PCT']!,
        imagePath: _image!.path,
        gender: _selectedGender,
        diagnosis: diagnosis,
      );

      // Store test result
      await appState.addTest(test);
      appState.setCurrentTest(test);

      if (mounted) {
        setState(() => _isAnalyzing = false);
        Navigator.of(context).pushReplacementNamed('/ocr_result');
      }
    } on ApiNetworkException catch (e) {
      if (mounted) {
        setState(() => _isAnalyzing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } on ApiTimeoutException catch (e) {
      if (mounted) {
        setState(() => _isAnalyzing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } on ApiServerException catch (e) {
      if (mounted) {
        setState(() => _isAnalyzing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isAnalyzing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Analysis failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(title: Text(l10n.uploadReport)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: FadeInDown(
                duration: const Duration(milliseconds: 600),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      width: 2.5,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                  ),
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.file(_image!, fit: BoxFit.cover),
                              Positioned(
                                top: 16,
                                right: 16,
                                child: IconButton(
                                  onPressed: () => setState(() => _image = null),
                                  icon: const Icon(Icons.close_rounded),
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.black54,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : _PulsingUploadPlaceholder(
                          primaryColor: Theme.of(context).primaryColor,
                          l10n: l10n,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 200),
              child: Row(
                children: [
                  Expanded(
                    child: _buildOptionButton(
                      context,
                      icon: Icons.photo_library_rounded,
                      label: l10n.gallery,
                      onTap: () => _pick(ImageSource.gallery),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildOptionButton(
                      context,
                      icon: Icons.camera_alt_rounded,
                      label: l10n.camera,
                      onTap: () => _pick(ImageSource.camera),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Gender Selection
            if (_image != null)
              FadeInUp(
                duration: const Duration(milliseconds: 400),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).cardColor,
                        Theme.of(context).cardColor.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_outline_rounded,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Gender',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            _genderButton('Male', _selectedGender == 'male', () {
                              setState(() => _selectedGender = 'male');
                            }),
                            _genderButton('Female', _selectedGender == 'female', () {
                              setState(() => _selectedGender = 'female');
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            if (_image != null)
              FadeInUp(
                duration: const Duration(milliseconds: 400),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Colors.purple.shade600,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _isAnalyzing ? null : _analyzeImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isAnalyzing
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                l10n.analyzeReport,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.auto_awesome_rounded, color: Colors.white),
                            ],
                          ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _genderButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.8),
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    final secondaryColor = Colors.purple.shade400;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryColor.withOpacity(isDark ? 0.2 : 0.12),
              secondaryColor.withOpacity(isDark ? 0.15 : 0.08),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: primaryColor.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.15),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, size: 28, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------- Pulsing Upload Placeholder --------------------
class _PulsingUploadPlaceholder extends StatefulWidget {
  final Color primaryColor;
  final AppLocalizations l10n;

  const _PulsingUploadPlaceholder({
    required this.primaryColor,
    required this.l10n,
  });

  @override
  State<_PulsingUploadPlaceholder> createState() => _PulsingUploadPlaceholderState();
}

class _PulsingUploadPlaceholderState extends State<_PulsingUploadPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        widget.primaryColor.withOpacity(0.2),
                        widget.primaryColor.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Icon(
                    Icons.cloud_upload_rounded,
                    size: 64,
                    color: widget.primaryColor,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 32),
        Text(
          widget.l10n.noImageSelected,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade400,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.l10n.takePhotoOrUpload,
          style: GoogleFonts.inter(
            color: Colors.grey.shade400,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Tap the buttons below',
          style: GoogleFonts.inter(
            color: widget.primaryColor.withOpacity(0.7),
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

// Continuing in next part...

// -------------------- OCR Result Screen --------------------
class OCRResultScreen extends StatelessWidget {
  const OCRResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appState = context.watch<AppState>();
    final test = appState.currentTest;

    if (test == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.analysisResult)),
        body: const Center(child: Text('No test data available')),
      );
    }

    final params = test.getAllParameters();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.analysisResult)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: params.length,
              itemBuilder: (context, index) {
                final entry = params.entries.toList()[index];
                final param = entry.key;
                final value = entry.value;
                final analysis = test.diagnosis[param];
                final status = analysis?['status'] ?? 'Normal';
                final isNormal = status == 'Normal';

                return FadeInUp(
                  duration: const Duration(milliseconds: 400),
                  delay: Duration(milliseconds: index * 50),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          isNormal
                              ? Colors.green.withOpacity(0.08)
                              : Colors.red.withOpacity(0.08),
                          isNormal
                              ? Colors.teal.withOpacity(0.04)
                              : Colors.orange.withOpacity(0.04),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isNormal
                            ? Colors.green.withOpacity(0.2)
                            : Colors.red.withOpacity(0.2),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (isNormal ? Colors.green : Colors.red).withOpacity(0.1),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isNormal
                                  ? [Colors.green.shade400, Colors.teal.shade400]
                                  : [Colors.red.shade400, Colors.orange.shade400],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: (isNormal ? Colors.green : Colors.red).withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            isNormal ? Icons.check_circle_rounded : Icons.warning_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                param,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${l10n.value}: ${value.toStringAsFixed(2)}',
                                style: GoogleFonts.inter(
                                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isNormal
                                  ? [Colors.green.shade100, Colors.teal.shade50]
                                  : [Colors.red.shade100, Colors.orange.shade50],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isNormal
                                  ? Colors.green.shade300
                                  : Colors.red.shade300,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            status,
                            style: GoogleFonts.inter(
                              color: isNormal ? Colors.green.shade700 : Colors.red.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Colors.purple.shade600,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed('/diagnosis'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.viewDiagnosis,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------- Diagnosis Screen --------------------
class DiagnosisScreen extends StatefulWidget {
  const DiagnosisScreen({super.key});

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appState = context.watch<AppState>();
    final test = appState.currentTest;

    if (test == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.diagnosis)),
        body: const Center(child: Text('No test data available')),
      );
    }

    final overall = test.diagnosis['overall'];
    final assessment = overall?['assessment'] ?? 'No assessment available';
    final conditions = (overall?['conditions'] as List?) ?? [];
    final hasConditions = conditions.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.diagnosis)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FadeInDown(
              duration: const Duration(milliseconds: 600),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: hasConditions
                        ? [
                            Colors.red.withOpacity(0.12),
                            Colors.orange.withOpacity(0.08),
                          ]
                        : [
                            Colors.green.withOpacity(0.12),
                            Colors.teal.withOpacity(0.08),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: hasConditions
                        ? Colors.red.withOpacity(0.3)
                        : Colors.green.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (hasConditions ? Colors.red : Colors.green).withOpacity(0.2),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: hasConditions
                                    ? [Colors.red.shade400, Colors.orange.shade400]
                                    : [Colors.green.shade400, Colors.teal.shade400],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: (hasConditions ? Colors.red : Colors.green).withOpacity(0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Icon(
                              hasConditions
                                  ? Icons.warning_rounded
                                  : Icons.check_circle_rounded,
                              size: 56,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      l10n.potentialDiagnosis,
                      style: GoogleFonts.poppins(
                        color: hasConditions
                            ? Colors.red.shade700
                            : Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    if (hasConditions) ...[
                      const SizedBox(height: 12),
                      ...conditions.map((c) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.red.shade100,
                                Colors.orange.shade50,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.red.shade300,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            c.toString(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade900,
                            ),
                          ),
                        ),
                      )),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 200),
              child: Text(
                l10n.analysis,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 300),
                  child: _buildRichTextAnalysis(assessment),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 400),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Colors.purple.shade600,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed('/report'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    l10n.viewFullReport,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRichTextAnalysis(String text) {
    // Highlight key medical terms
    final keywords = ['Hemoglobin', 'HGB', 'MCV', 'MCHC', 'RBC', 'WBC', 'PLT', 'Anemia', 'Infection'];
    final spans = <TextSpan>[];
    
    var currentIndex = 0;
    final lowerText = text.toLowerCase();
    
    for (final keyword in keywords) {
      final index = lowerText.indexOf(keyword.toLowerCase(), currentIndex);
      if (index != -1) {
        // Add normal text before keyword
        if (index > currentIndex) {
          spans.add(TextSpan(
            text: text.substring(currentIndex, index),
            style: GoogleFonts.inter(fontSize: 16, height: 1.6),
          ));
        }
        // Add highlighted keyword
        spans.add(TextSpan(
          text: text.substring(index, index + keyword.length),
          style: GoogleFonts.inter(
            fontSize: 16,
            height: 1.6,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ));
        currentIndex = index + keyword.length;
      }
    }
    
    // Add remaining text
    if (currentIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentIndex),
        style: GoogleFonts.inter(fontSize: 16, height: 1.6),
      ));
    }
    
    return RichText(
      text: TextSpan(
        children: spans.isNotEmpty ? spans : [
          TextSpan(
            text: text,
            style: GoogleFonts.inter(
              fontSize: 16,
              height: 1.6,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------- Full Report Screen --------------------
class FullReportScreen extends StatelessWidget {
  const FullReportScreen({super.key});

  Future<void> _generateAndSharePDF(BuildContext context) async {
    final appState = context.read<AppState>();
    final test = appState.currentTest;
    
    if (test == null) return;

    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final pdfFile = await PDFService.generateReport(test);
      
      if (context.mounted) {
        Navigator.pop(context); // Close loading
        
        // Show options
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Report Generated'),
            content: const Text('What would you like to do?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  PDFService.shareReport(pdfFile);
                },
                child: const Text('Share'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  PDFService.printReport(pdfFile);
                },
                child: const Text('Print'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate PDF: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appState = context.watch<AppState>();
    final test = appState.currentTest;
    
    if (test == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.fullReport)),
        body: const Center(child: Text('No test data available')),
      );
    }

    final params = test.getAllParameters();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.fullReport),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card
                  FadeInDown(
                    duration: const Duration(milliseconds: 600),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor.withOpacity(0.12),
                            Colors.purple.withOpacity(0.08),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Theme.of(context).primaryColor.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).primaryColor,
                                  Colors.purple.shade600,
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.description_rounded,
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.fullReport,
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${params.length} Parameters Analyzed',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Parameters Section
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 200),
                    child: Text(
                      'Test Parameters',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // ExpansionTiles for each parameter
                  ...params.entries.map((entry) {
                    final param = entry.key;
                    final value = entry.value;
                    final analysis = test.diagnosis[param];
                    final status = analysis?['status'] ?? 'Normal';
                    final isNormal = status == 'Normal';
                    final explanation = analysis?['note'] ?? 'Within normal range';
                    
                    return FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      delay: Duration(milliseconds: 200 + params.entries.toList().indexOf(entry) * 50),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              isNormal
                                  ? Colors.green.withOpacity(0.06)
                                  : Colors.red.withOpacity(0.06),
                              isNormal
                                  ? Colors.teal.withOpacity(0.02)
                                  : Colors.orange.withOpacity(0.02),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isNormal
                                ? Colors.green.withOpacity(0.15)
                                : Colors.red.withOpacity(0.15),
                          ),
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isNormal
                                      ? [Colors.green.shade300, Colors.teal.shade300]
                                      : [Colors.red.shade300, Colors.orange.shade300],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isNormal ? Icons.check_rounded : Icons.priority_high_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              param,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              '${value.toStringAsFixed(2)} - $status',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: isNormal ? Colors.green.shade700 : Colors.red.shade700,
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.info_outline_rounded,
                                          size: 18,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Analysis',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      explanation,
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        height: 1.5,
                                        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          
          // Bottom Actions
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Colors.purple.shade600,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).primaryColor.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () => _generateAndSharePDF(context),
                      icon: const Icon(Icons.picture_as_pdf_rounded, color: Colors.white),
                      label: Text(
                        l10n.generatePDF,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).pushNamed('/history'),
                    icon: Icon(Icons.history_rounded, color: Theme.of(context).primaryColor),
                    label: Text(
                      l10n.history,
                      style: GoogleFonts.poppins(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      side: BorderSide(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------- Settings Screen --------------------
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showNameDialog(BuildContext context) {
    final appState = context.read<AppState>();
    final controller = TextEditingController(text: appState.userName);
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editName),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: l10n.enterYourName,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              appState.setUserName(controller.text);
              Navigator.pop(context);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // User Name
          _buildSettingTile(
            context,
            icon: Icons.person_rounded,
            title: appState.userName,
            subtitle: l10n.editName,
            onTap: () => _showNameDialog(context),
          ),
          
          // Language
          _buildSettingTile(
            context,
            icon: Icons.language_rounded,
            title: l10n.language,
            subtitle: appState.languageCode == 'en' ? l10n.english : l10n.arabic,
            trailing: Switch(
              value: appState.languageCode == 'ar',
              onChanged: (value) {
                appState.setLanguage(value ? 'ar' : 'en');
              },
            ),
          ),
          
          // Theme
          _buildSettingTile(
            context,
            icon: Icons.brightness_6_rounded,
            title: appState.isDarkMode ? l10n.darkMode : l10n.lightMode,
            subtitle: 'Toggle theme',
            trailing: Switch(
              value: appState.isDarkMode,
              onChanged: (_) => appState.toggleTheme(),
            ),
          ),
          
          // Notifications
          _buildSettingTile(
            context,
            icon: Icons.notifications_rounded,
            title: l10n.notifications,
            subtitle: l10n.manageNotifications,
            onTap: () {},
          ),
          
          // Privacy Policy
          _buildSettingTile(
            context,
            icon: Icons.privacy_tip_rounded,
            title: l10n.privacyPolicy,
            subtitle: l10n.readPrivacyPolicy,
            onTap: () {},
          ),
          
          // About
          _buildSettingTile(
            context,
            icon: Icons.info_rounded,
            title: l10n.about,
            subtitle: l10n.version,
            onTap: () {},
          ),
          
          // API Test
          _buildSettingTile(
            context,
            icon: Icons.api_rounded,
            title: 'API Test',
            subtitle: 'Test Flask backend connection',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ApiTestPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor.withOpacity(0.15),
                Theme.of(context).primaryColor.withOpacity(0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Theme.of(context).primaryColor, size: 24),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(
            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
          ),
        ),
        trailing: trailing ??
            Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
