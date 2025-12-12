// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'AI BloodScan';

  @override
  String get hello => 'Hello';

  @override
  String get user => 'User';

  @override
  String greeting(String name) {
    return 'Hello, $name 👋';
  }

  @override
  String get welcomeToApp => 'Welcome to AI BloodScan';

  @override
  String get smartCBCAnalysis => 'Smart CBC Analysis';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get getStarted => 'Get Started';

  @override
  String get onboardingTitle1 => 'Scan & Analyze';

  @override
  String get onboardingSubtitle1 =>
      'Instantly capture your CBC report and let AI extract the data for you.';

  @override
  String get onboardingTitle2 => 'Smart Diagnosis';

  @override
  String get onboardingSubtitle2 =>
      'Get immediate insights into potential conditions like Anemia based on your levels.';

  @override
  String get onboardingTitle3 => 'Detailed Reports';

  @override
  String get onboardingSubtitle3 =>
      'View comprehensive breakdowns and health tips tailored to your results.';

  @override
  String get home => 'Home';

  @override
  String get history => 'History';

  @override
  String get settings => 'Settings';

  @override
  String get uploadCBCSheet => 'Upload CBC Sheet';

  @override
  String get scanOrUpload => 'Scan or upload your blood test report';

  @override
  String get manualEntry => 'Manual Entry';

  @override
  String get enterManually => 'Enter your test results manually';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get lastAnalysis => 'Last Analysis';

  @override
  String get uploadReport => 'Upload Report';

  @override
  String get gallery => 'Gallery';

  @override
  String get camera => 'Camera';

  @override
  String get noImageSelected => 'No Image Selected';

  @override
  String get takePhotoOrUpload => 'Take a photo or upload from gallery';

  @override
  String get analyzeReport => 'Analyze Report';

  @override
  String get analyzing => 'Analyzing Report...';

  @override
  String get analysisResult => 'Analysis Result';

  @override
  String get viewDiagnosis => 'View Diagnosis';

  @override
  String get diagnosis => 'Diagnosis';

  @override
  String get potentialDiagnosis => 'Potential Diagnosis';

  @override
  String get analysis => 'Analysis';

  @override
  String get viewFullReport => 'View Full Report';

  @override
  String get fullReport => 'Full Report';

  @override
  String get generatedReport => 'Detailed Report Generated';

  @override
  String get generatePDF => 'Generate PDF';

  @override
  String get shareReport => 'Share Report';

  @override
  String get noHistory => 'No test history';

  @override
  String get noTestsYet => 'You haven\'t analyzed any blood tests yet';

  @override
  String get deleteTest => 'Delete Test';

  @override
  String get confirmDelete => 'Are you sure you want to delete this test?';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get notifications => 'Notifications';

  @override
  String get manageNotifications => 'Manage app notifications';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get readPrivacyPolicy => 'Read our privacy policy';

  @override
  String get about => 'About';

  @override
  String get version => 'Version 1.0.0';

  @override
  String get clearHistory => 'Clear History';

  @override
  String get clearAllHistory => 'Clear All History';

  @override
  String get confirmClearHistory =>
      'Are you sure you want to clear all test history?';

  @override
  String get clear => 'Clear';

  @override
  String get editName => 'Edit Name';

  @override
  String get enterYourName => 'Enter your name';

  @override
  String get save => 'Save';

  @override
  String get normal => 'Normal';

  @override
  String get low => 'Low';

  @override
  String get high => 'High';

  @override
  String get withinRange => 'Within normal range';

  @override
  String get value => 'Value';

  @override
  String get referenceRange => 'Reference Range';

  @override
  String get parameters => 'Parameters';

  @override
  String get hemoglobin => 'Hemoglobin (HGB)';

  @override
  String get redBloodCells => 'Red Blood Cells (RBC)';

  @override
  String get whiteBloodCells => 'White Blood Cells (WBC)';

  @override
  String get platelets => 'Platelets (PLT)';

  @override
  String get lymphocytes => 'Lymphocytes (LYMP)';

  @override
  String get monocytes => 'Monocytes (MONO)';

  @override
  String get hematocrit => 'Hematocrit (HCT)';

  @override
  String get mcv => 'Mean Corpuscular Volume (MCV)';

  @override
  String get mch => 'Mean Corpuscular Hemoglobin (MCH)';

  @override
  String get mchc => 'MCHC';

  @override
  String get rdw => 'Red Cell Distribution Width (RDW)';

  @override
  String get pdw => 'Platelet Distribution Width (PDW)';

  @override
  String get mpv => 'Mean Platelet Volume (MPV)';

  @override
  String get pct => 'Plateletcrit (PCT)';

  @override
  String get gender => 'Gender';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';
}
