import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'AI BloodScan'**
  String get appTitle;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name} 👋'**
  String greeting(String name);

  /// No description provided for @welcomeToApp.
  ///
  /// In en, this message translates to:
  /// **'Welcome to AI BloodScan'**
  String get welcomeToApp;

  /// No description provided for @smartCBCAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Smart CBC Analysis'**
  String get smartCBCAnalysis;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Scan & Analyze'**
  String get onboardingTitle1;

  /// No description provided for @onboardingSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'Instantly capture your CBC report and let AI extract the data for you.'**
  String get onboardingSubtitle1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Smart Diagnosis'**
  String get onboardingTitle2;

  /// No description provided for @onboardingSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'Get immediate insights into potential conditions like Anemia based on your levels.'**
  String get onboardingSubtitle2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Detailed Reports'**
  String get onboardingTitle3;

  /// No description provided for @onboardingSubtitle3.
  ///
  /// In en, this message translates to:
  /// **'View comprehensive breakdowns and health tips tailored to your results.'**
  String get onboardingSubtitle3;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @uploadCBCSheet.
  ///
  /// In en, this message translates to:
  /// **'Upload CBC Sheet'**
  String get uploadCBCSheet;

  /// No description provided for @scanOrUpload.
  ///
  /// In en, this message translates to:
  /// **'Scan or upload your blood test report'**
  String get scanOrUpload;

  /// No description provided for @manualEntry.
  ///
  /// In en, this message translates to:
  /// **'Manual Entry'**
  String get manualEntry;

  /// No description provided for @enterManually.
  ///
  /// In en, this message translates to:
  /// **'Enter your test results manually'**
  String get enterManually;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @lastAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Last Analysis'**
  String get lastAnalysis;

  /// No description provided for @uploadReport.
  ///
  /// In en, this message translates to:
  /// **'Upload Report'**
  String get uploadReport;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @noImageSelected.
  ///
  /// In en, this message translates to:
  /// **'No Image Selected'**
  String get noImageSelected;

  /// No description provided for @takePhotoOrUpload.
  ///
  /// In en, this message translates to:
  /// **'Take a photo or upload from gallery'**
  String get takePhotoOrUpload;

  /// No description provided for @analyzeReport.
  ///
  /// In en, this message translates to:
  /// **'Analyze Report'**
  String get analyzeReport;

  /// No description provided for @analyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing Report...'**
  String get analyzing;

  /// No description provided for @analysisResult.
  ///
  /// In en, this message translates to:
  /// **'Analysis Result'**
  String get analysisResult;

  /// No description provided for @viewDiagnosis.
  ///
  /// In en, this message translates to:
  /// **'View Diagnosis'**
  String get viewDiagnosis;

  /// No description provided for @diagnosis.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis'**
  String get diagnosis;

  /// No description provided for @potentialDiagnosis.
  ///
  /// In en, this message translates to:
  /// **'Potential Diagnosis'**
  String get potentialDiagnosis;

  /// No description provided for @analysis.
  ///
  /// In en, this message translates to:
  /// **'Analysis'**
  String get analysis;

  /// No description provided for @viewFullReport.
  ///
  /// In en, this message translates to:
  /// **'View Full Report'**
  String get viewFullReport;

  /// No description provided for @fullReport.
  ///
  /// In en, this message translates to:
  /// **'Full Report'**
  String get fullReport;

  /// No description provided for @generatedReport.
  ///
  /// In en, this message translates to:
  /// **'Detailed Report Generated'**
  String get generatedReport;

  /// No description provided for @generatePDF.
  ///
  /// In en, this message translates to:
  /// **'Generate PDF'**
  String get generatePDF;

  /// No description provided for @shareReport.
  ///
  /// In en, this message translates to:
  /// **'Share Report'**
  String get shareReport;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No test history'**
  String get noHistory;

  /// No description provided for @noTestsYet.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t analyzed any blood tests yet'**
  String get noTestsYet;

  /// No description provided for @deleteTest.
  ///
  /// In en, this message translates to:
  /// **'Delete Test'**
  String get deleteTest;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this test?'**
  String get confirmDelete;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @manageNotifications.
  ///
  /// In en, this message translates to:
  /// **'Manage app notifications'**
  String get manageNotifications;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @readPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Read our privacy policy'**
  String get readPrivacyPolicy;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get version;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clearHistory;

  /// No description provided for @clearAllHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear All History'**
  String get clearAllHistory;

  /// No description provided for @confirmClearHistory.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all test history?'**
  String get confirmClearHistory;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @editName.
  ///
  /// In en, this message translates to:
  /// **'Edit Name'**
  String get editName;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @withinRange.
  ///
  /// In en, this message translates to:
  /// **'Within normal range'**
  String get withinRange;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @referenceRange.
  ///
  /// In en, this message translates to:
  /// **'Reference Range'**
  String get referenceRange;

  /// No description provided for @parameters.
  ///
  /// In en, this message translates to:
  /// **'Parameters'**
  String get parameters;

  /// No description provided for @hemoglobin.
  ///
  /// In en, this message translates to:
  /// **'Hemoglobin (HGB)'**
  String get hemoglobin;

  /// No description provided for @redBloodCells.
  ///
  /// In en, this message translates to:
  /// **'Red Blood Cells (RBC)'**
  String get redBloodCells;

  /// No description provided for @whiteBloodCells.
  ///
  /// In en, this message translates to:
  /// **'White Blood Cells (WBC)'**
  String get whiteBloodCells;

  /// No description provided for @platelets.
  ///
  /// In en, this message translates to:
  /// **'Platelets (PLT)'**
  String get platelets;

  /// No description provided for @lymphocytes.
  ///
  /// In en, this message translates to:
  /// **'Lymphocytes (LYMP)'**
  String get lymphocytes;

  /// No description provided for @monocytes.
  ///
  /// In en, this message translates to:
  /// **'Monocytes (MONO)'**
  String get monocytes;

  /// No description provided for @hematocrit.
  ///
  /// In en, this message translates to:
  /// **'Hematocrit (HCT)'**
  String get hematocrit;

  /// No description provided for @mcv.
  ///
  /// In en, this message translates to:
  /// **'Mean Corpuscular Volume (MCV)'**
  String get mcv;

  /// No description provided for @mch.
  ///
  /// In en, this message translates to:
  /// **'Mean Corpuscular Hemoglobin (MCH)'**
  String get mch;

  /// No description provided for @mchc.
  ///
  /// In en, this message translates to:
  /// **'MCHC'**
  String get mchc;

  /// No description provided for @rdw.
  ///
  /// In en, this message translates to:
  /// **'Red Cell Distribution Width (RDW)'**
  String get rdw;

  /// No description provided for @pdw.
  ///
  /// In en, this message translates to:
  /// **'Platelet Distribution Width (PDW)'**
  String get pdw;

  /// No description provided for @mpv.
  ///
  /// In en, this message translates to:
  /// **'Mean Platelet Volume (MPV)'**
  String get mpv;

  /// No description provided for @pct.
  ///
  /// In en, this message translates to:
  /// **'Plateletcrit (PCT)'**
  String get pct;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
