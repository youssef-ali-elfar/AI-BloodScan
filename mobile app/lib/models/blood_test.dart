import 'package:hive/hive.dart';

part 'blood_test.g.dart';

/// Data Model for Complete Blood Count (CBC) Test Results
///
/// Represents a complete CBC blood test analysis including all measured parameters,
/// diagnostic results, and metadata. This model is persistable using Hive database.
///
/// **CBC Parameters Tracked (14 standard + gender):**
/// 
/// **Red Blood Cell Parameters:**
/// - [hgb]: Hemoglobin (g/dL) - Oxygen-carrying protein
/// - [rbc]: Red Blood Cell count (×10⁶/µL)
/// - [hct]: Hematocrit (%) - Percentage of blood volume that is RBCs
/// - [mcv]: Mean Corpuscular Volume (fL) - Average RBC size
/// - [mch]: Mean Corpuscular Hemoglobin (pg) - Average hemoglobin per RBC
/// - [mchc]: Mean Corpuscular Hemoglobin Concentration (g/dL)
/// - [rdw]: Red Cell Distribution Width (%) - RBC size variation
///
/// **White Blood Cell Parameters:**
/// - [wbc]: White Blood Cell count (×10³/µL)
/// - [lymp]: Lymphocytes (%) - Immune cells
/// - [mono]: Monocytes (%) - Immune cells
///
/// **Platelet Parameters:**
/// - [plt]: Platelet count (×10³/µL) - Blood clotting cells
/// - [pdw]: Platelet Distribution Width (fL) - Platelet size variation
/// - [mpv]: Mean Platelet Volume (fL) - Average platelet size
/// - [pct]: Plateletcrit (%) - Percentage of blood volume that is platelets
///
/// **Metadata:**
/// - [id]: Unique identifier (UUID)
/// - [timestamp]: When the test was analyzed
/// - [gender]: Patient gender for gender-specific analysis
/// - [imagePath]: Path to the original CBC report image
/// - [diagnosis]: Complete diagnostic analysis results
///
/// **Database Storage:**
/// Uses Hive for efficient local storage with TypeAdapter for serialization.
///
/// **Example:**
/// ```dart
/// final test = BloodTest(
///   id: uuid.v4(),
///   timestamp: DateTime.now(),
///   hgb: 14.2,
///   rbc: 4.8,
///   wbc: 7.5,
///   // ... other parameters
///   gender: 'female',
///   diagnosis: diagnosisResults,
/// );
/// await StorageService.saveTest(test);
/// ```
@HiveType(typeId: 0)
class BloodTest extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime timestamp;

  // Complete Blood Count Parameters
  @HiveField(2)
  double hgb; // Hemoglobin

  @HiveField(3)
  double rbc; // Red Blood Cell count

  @HiveField(4)
  double wbc; // White Blood Cell count

  @HiveField(5)
  double plt; // Platelet count

  @HiveField(6)
  double lymp; // Lymphocytes

  @HiveField(7)
  double mono; // Monocytes

  @HiveField(8)
  double hct; // Hematocrit

  @HiveField(9)
  double mcv; // Mean Corpuscular Volume

  @HiveField(10)
  double mch; // Mean Corpuscular Hemoglobin

  @HiveField(11)
  double mchc; // Mean Corpuscular Hemoglobin Concentration

  @HiveField(12)
  double rdw; // Red Cell Distribution Width

  @HiveField(13)
  double pdw; // Platelet Distribution Width

  @HiveField(14)
  double mpv; // Mean Platelet Volume

  @HiveField(15)
  double pct; // Plateletcrit

  @HiveField(16)
  String? imagePath;

  @HiveField(17)
  Map<String, dynamic> diagnosis;

  @HiveField(18)
  String gender; // 'male' or 'female'

  BloodTest({
    required this.id,
    required this.timestamp,
    required this.hgb,
    required this.rbc,
    required this.wbc,
    required this.plt,
    required this.lymp,
    required this.mono,
    required this.hct,
    required this.mcv,
    required this.mch,
    required this.mchc,
    required this.rdw,
    required this.pdw,
    required this.mpv,
    required this.pct,
    this.imagePath,
    required this.diagnosis,
    this.gender = 'male', // Default to male
  });

  // Helper method to get all parameters as a map
  Map<String, double> getAllParameters() {
    return {
      'HGB': hgb,
      'RBC': rbc,
      'WBC': wbc,
      'PLT': plt,
      'LYMP': lymp,
      'MONO': mono,
      'HCT': hct,
      'MCV': mcv,
      'MCH': mch,
      'MCHC': mchc,
      'RDW': rdw,
      'PDW': pdw,
      'MPV': mpv,
      'PCT': pct,
    };
  }

  // Check if any parameter is abnormal
  bool hasAbnormalValues() {
    return diagnosis.values.any((status) => status != 'Normal');
  }
}
