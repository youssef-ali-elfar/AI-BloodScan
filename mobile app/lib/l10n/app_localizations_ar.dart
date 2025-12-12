// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'فحص الدم الذكي';

  @override
  String get hello => 'مرحبا';

  @override
  String get user => 'مستخدم';

  @override
  String greeting(String name) {
    return 'مرحبًا، $name 👋';
  }

  @override
  String get welcomeToApp => 'مرحبًا بك في فحص الدم الذكي';

  @override
  String get smartCBCAnalysis => 'تحليل تعداد الدم الشامل الذكي';

  @override
  String get skip => 'تخطي';

  @override
  String get next => 'التالي';

  @override
  String get back => 'رجوع';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get onboardingTitle1 => 'المسح والتحليل';

  @override
  String get onboardingSubtitle1 =>
      'التقط تقرير تعداد الدم فورًا ودع الذكاء الاصطناعي يستخرج البيانات لك.';

  @override
  String get onboardingTitle2 => 'التشخيص الذكي';

  @override
  String get onboardingSubtitle2 =>
      'احصل على رؤى فورية حول الحالات المحتملة مثل فقر الدم بناءً على مستوياتك.';

  @override
  String get onboardingTitle3 => 'تقارير مفصلة';

  @override
  String get onboardingSubtitle3 =>
      'اعرض تحليلات شاملة ونصائح صحية مصممة خصيصًا لنتائجك.';

  @override
  String get home => 'الرئيسية';

  @override
  String get history => 'السجل';

  @override
  String get settings => 'الإعدادات';

  @override
  String get uploadCBCSheet => 'رفع ورقة التحليل';

  @override
  String get scanOrUpload => 'امسح أو ارفع تقرير فحص الدم الخاص بك';

  @override
  String get manualEntry => 'الإدخال اليدوي';

  @override
  String get enterManually => 'أدخل نتائج الفحص يدويًا';

  @override
  String get recentActivity => 'النشاط الأخير';

  @override
  String get lastAnalysis => 'آخر تحليل';

  @override
  String get uploadReport => 'رفع التقرير';

  @override
  String get gallery => 'المعرض';

  @override
  String get camera => 'الكاميرا';

  @override
  String get noImageSelected => 'لم يتم اختيار صورة';

  @override
  String get takePhotoOrUpload => 'التقط صورة أو ارفع من المعرض';

  @override
  String get analyzeReport => 'تحليل التقرير';

  @override
  String get analyzing => 'جاري تحليل التقرير...';

  @override
  String get analysisResult => 'نتيجة التحليل';

  @override
  String get viewDiagnosis => 'عرض التشخيص';

  @override
  String get diagnosis => 'التشخيص';

  @override
  String get potentialDiagnosis => 'التشخيص المحتمل';

  @override
  String get analysis => 'التحليل';

  @override
  String get viewFullReport => 'عرض التقرير الكامل';

  @override
  String get fullReport => 'التقرير الكامل';

  @override
  String get generatedReport => 'تم إنشاء التقرير المفصل';

  @override
  String get generatePDF => 'إنشاء PDF';

  @override
  String get shareReport => 'مشاركة التقرير';

  @override
  String get noHistory => 'لا يوجد سجل فحوصات';

  @override
  String get noTestsYet => 'لم تقم بتحليل أي فحص دم بعد';

  @override
  String get deleteTest => 'حذف الفحص';

  @override
  String get confirmDelete => 'هل أنت متأكد من حذف هذا الفحص؟';

  @override
  String get delete => 'حذف';

  @override
  String get cancel => 'إلغاء';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get lightMode => 'الوضع الفاتح';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get manageNotifications => 'إدارة إشعارات التطبيق';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get readPrivacyPolicy => 'اقرأ سياسة الخصوصية الخاصة بنا';

  @override
  String get about => 'حول';

  @override
  String get version => 'الإصدار 1.0.0';

  @override
  String get clearHistory => 'مسح السجل';

  @override
  String get clearAllHistory => 'مسح كل السجل';

  @override
  String get confirmClearHistory => 'هل أنت متأكد من مسح سجل الفحوصات بالكامل؟';

  @override
  String get clear => 'مسح';

  @override
  String get editName => 'تعديل الاسم';

  @override
  String get enterYourName => 'أدخل اسمك';

  @override
  String get save => 'حفظ';

  @override
  String get normal => 'طبيعي';

  @override
  String get low => 'منخفض';

  @override
  String get high => 'مرتفع';

  @override
  String get withinRange => 'ضمن المعدل الطبيعي';

  @override
  String get value => 'القيمة';

  @override
  String get referenceRange => 'المعدل الطبيعي';

  @override
  String get parameters => 'المعايير';

  @override
  String get hemoglobin => 'الهيموجلوبين (HGB)';

  @override
  String get redBloodCells => 'كريات الدم الحمراء (RBC)';

  @override
  String get whiteBloodCells => 'كريات الدم البيضاء (WBC)';

  @override
  String get platelets => 'الصفائح الدموية (PLT)';

  @override
  String get lymphocytes => 'الخلايا اللمفاوية (LYMP)';

  @override
  String get monocytes => 'الخلايا الوحيدة (MONO)';

  @override
  String get hematocrit => 'الهيماتوكريت (HCT)';

  @override
  String get mcv => 'متوسط حجم الكرية (MCV)';

  @override
  String get mch => 'متوسط هيموجلوبين الكرية (MCH)';

  @override
  String get mchc => 'متوسط تركيز الهيموجلوبين (MCHC)';

  @override
  String get rdw => 'عرض توزيع الكريات الحمراء (RDW)';

  @override
  String get pdw => 'عرض توزيع الصفائح (PDW)';

  @override
  String get mpv => 'متوسط حجم الصفائح (MPV)';

  @override
  String get pct => 'نسبة حجم الصفائح (PCT)';

  @override
  String get gender => 'الجنس';

  @override
  String get male => 'ذكر';

  @override
  String get female => 'أنثى';
}
