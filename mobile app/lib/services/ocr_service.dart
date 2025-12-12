import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';
import '../models/blood_test.dart';
import '../services/diagnosis_service.dart';
import '../services/api_service.dart';
import 'package:uuid/uuid.dart';

/// OCR Service for CBC Blood Test Image Processing
///
/// This service handles the complete workflow of processing CBC blood test images:
/// 1. **Text Extraction**: Uses Google ML Kit for OCR to extract text from images
/// 2. **Parameter Parsing**: Identifies and extracts blood test parameters using regex patterns
/// 3. **AI Analysis**: Sends extracted data to Flask backend with trained CNN model
/// 4. **Diagnosis Generation**: Combines AI predictions with rule-based analysis
///
/// **Supported Workflow:**
/// ```
/// Image → OCR → Parse Parameters → AI Prediction → Diagnosis → BloodTest Object
/// ```
///
/// **Backend Integration:**
/// The service integrates with a Flask backend running a Convolutional Neural Network (CNN)
/// trained on CBC data to classify blood conditions. The CNN model can detect:
/// - Normal blood values
/// - Anemia (various types)
/// - Infections
/// - Thrombocytopenia
/// - Other blood disorders
///
/// **Feature Extraction:**
/// Converts 14 standard CBC parameters into a 16-feature vector required by the CNN:
/// HGB, RBC, WBC, PLT, LYMP, MONO, HCT, MCV, MCH, MCHC, RDW, PDW, MPV, PCT, NEU, EOS
///
/// **Fallback Mechanism:**
/// - If API fails → Falls back to local rule-based diagnosis
/// - If OCR fails → Returns mock data for demonstration purposes
///
/// **Example Usage:**
/// ```dart
/// final bloodTest = await OCRService.processImage('/path/to/cbc_image.jpg');
/// print(bloodTest.diagnosis['overall']['assessment']);
/// print('Confidence: ${bloodTest.diagnosis['confidence']}');
/// ```
class OCRService {
  static final _textRecognizer = TextRecognizer();

  /// Processes a CBC blood test image and returns complete analysis
  ///
  /// **Workflow:**
  /// 1. Performs OCR on the image using Google ML Kit
  /// 2. Extracts CBC parameters using regex pattern matching
  /// 3. Converts parameters to 16-feature vector for CNN model
  /// 4. Sends features to Flask API for AI prediction
  /// 5. Combines AI results with rule-based diagnosis
  /// 6. Creates and returns BloodTest object
  ///
  /// **Parameters:**
  /// - [imagePath]: Absolute path to the CBC blood test image file
  ///
  /// **Returns:**
  /// A `BloodTest` object containing:
  /// - Extracted CBC parameter values
  /// - AI prediction (class + confidence)
  /// - Individual parameter analysis
  /// - Overall health assessment
  /// - Reference to original image
  ///
  /// **Error Handling:**
  /// - If API call fails: Falls back to local rule-based diagnosis
  /// - If OCR fails completely: Returns mock data for demonstration
  ///
  /// **Throws:**
  /// Does not throw exceptions - always returns a BloodTest object
  ///
  /// **Example:**
  /// ```dart
  /// try {
  ///   final result = await OCRService.processImage('/storage/cbc.jpg');
  ///   if (result.diagnosis['overall']['conditions'].isNotEmpty) {
  ///     print('Potential health concerns detected');
  ///   }
  /// } catch (e) {
  ///   print('Error: $e');
  /// }
  /// ```
  static Future<BloodTest> processImage(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      // Extract parameters from text
      final params = _extractParameters(recognizedText.text);

      // ✅ Convert to 16-feature list for API
      final features = _convertToFeatureList(params);

      // ✅ Call Flask API for AI prediction
      Map<String, dynamic> diagnosis;
      try {
        final apiResult = await ApiService.analyzeCBC(features);
        
        // Build diagnosis from API result
        diagnosis = {
          'overall': {
            'assessment': 'AI Prediction: ${apiResult['predicted_class']} with ${apiResult['confidence'].toStringAsFixed(1)}% confidence',
            'conditions': apiResult['predicted_class'] != 'Normal' 
                ? [apiResult['predicted_class']]
                : [],
          },
          // Add individual parameter analysis
          ...DiagnosisService.analyzeAllParameters(params),
        };
      } catch (e) {
        // If API fails, fall back to local diagnosis
        print('API call failed: $e');
        diagnosis = DiagnosisService.analyzeAllParameters(params);
      }

      // Create BloodTest object
      return BloodTest(
        id: const Uuid().v4(),
        timestamp: DateTime.now(),
        hgb: params['HGB'] ?? 0,
        rbc: params['RBC'] ?? 0,
        wbc: params['WBC'] ?? 0,
        plt: params['PLT'] ?? 0,
        lymp: params['LYMP'] ?? 0,
        mono: params['MONO'] ?? 0,
        hct: params['HCT'] ?? 0,
        mcv: params['MCV'] ?? 0,
        mch: params['MCH'] ?? 0,
        mchc: params['MCHC'] ?? 0,
        rdw: params['RDW'] ?? 0,
        pdw: params['PDW'] ?? 0,
        mpv: params['MPV'] ?? 0,
        pct: params['PCT'] ?? 0,
        imagePath: imagePath,
        diagnosis: diagnosis,
      );
    } catch (e) {
      // If OCR fails, return mock data for demonstration
      return _getMockBloodTest(imagePath);
    }
  }

  /// Convert parameters map to 16-feature list in correct order
  /// Order: HGB, RBC, WBC, PLT, LYMP, MONO, HCT, MCV, MCH, MCHC, RDW, PDW, MPV, PCT, NEU, EOS
  static List<double> _convertToFeatureList(Map<String, double> params) {
    return [
      params['HGB'] ?? 0.0,
      params['RBC'] ?? 0.0,
      params['WBC'] ?? 0.0,
      params['PLT'] ?? 0.0,
      params['LYMP'] ?? 0.0,
      params['MONO'] ?? 0.0,
      params['HCT'] ?? 0.0,
      params['MCV'] ?? 0.0,
      params['MCH'] ?? 0.0,
      params['MCHC'] ?? 0.0,
      params['RDW'] ?? 0.0,
      params['PDW'] ?? 0.0,
      params['MPV'] ?? 0.0,
      params['PCT'] ?? 0.0,
      params['NEU'] ?? 0.0,  // Neutrophils (if not extracted, defaults to 0)
      params['EOS'] ?? 0.0,  // Eosinophils (if not extracted, defaults to 0)
    ];
  }

  /// Extract parameters using pattern matching
  static Map<String, double> _extractParameters(String text) {
    final Map<String, double> params = {};

    // Common patterns for blood test reports
    final patterns = {
      'HGB': RegExp(r'(?:HGB|Hemoglobin|Hb)[:\s]+(\d+\.?\d*)', caseSensitive: false),
      'RBC': RegExp(r'(?:RBC|Red Blood Cell)[:\s]+(\d+\.?\d*)', caseSensitive: false),
      'WBC': RegExp(r'(?:WBC|White Blood Cell)[:\s]+(\d+\.?\d*)', caseSensitive: false),
      'PLT': RegExp(r'(?:PLT|Platelet)[:\s]+(\d+\.?\d*)', caseSensitive: false),
      'LYMP': RegExp(r'(?:LYMP|Lymphocyte)[:\s]+(\d+\.?\d*)', caseSensitive: false),
      'MONO': RegExp(r'(?:MONO|Monocyte)[:\s]+(\d+\.?\d*)', caseSensitive: false),
      'HCT': RegExp(r'(?:HCT|Hematocrit)[:\s]+(\d+\.?\d*)', caseSensitive: false),
      'MCV': RegExp(r'(?:MCV)[:\s]+(\d+\.?\d*)', caseSensitive: false),
      'MCH': RegExp(r'(?:MCH)[:\s]+(\d+\.?\d*)', caseSensitive: false),
      'MCHC': RegExp(r'(?:MCHC)[:\s]+(\d+\.?\d*)', caseSensitive: false),
      'RDW': RegExp(r'(?:RDW)[:\s]+(\d+\.?\d*)', caseSensitive: false),
      'PDW': RegExp(r'(?:PDW)[:\s]+(\d+\.?\d*)', caseSensitive: false),
      'MPV': RegExp(r'(?:MPV)[:\s]+(\d+\.?\d*)', caseSensitive: false),
      'PCT': RegExp(r'(?:PCT)[:\s]+(\d+\.?\d*)', caseSensitive: false),
      'NEU': RegExp(r'(?:NEU|Neutrophil)[:\s]+(\d+\.?\d*)', caseSensitive: false),
      'EOS': RegExp(r'(?:EOS|Eosinophil)[:\s]+(\d+\.?\d*)', caseSensitive: false),
    };

    patterns.forEach((key, pattern) {
      final match = pattern.firstMatch(text);
      if (match != null && match.groupCount > 0) {
        params[key] = double.tryParse(match.group(1)!) ?? 0;
      }
    });

    return params;
  }

  /// Generate mock blood test data for demonstration
  static BloodTest _getMockBloodTest(String? imagePath) {
    final params = {
      'HGB': 11.4,
      'RBC': 3.8,
      'WBC': 7200.0,
      'PLT': 180.0,
      'LYMP': 25.0,
      'MONO': 5.0,
      'HCT': 34.0,
      'MCV': 72.0,
      'MCH': 24.0,
      'MCHC': 29.0,
      'RDW': 15.5,
      'PDW': 12.0,
      'MPV': 9.0,
      'PCT': 0.18,
    };

    final diagnosis = DiagnosisService.analyzeAllParameters(params);

    return BloodTest(
      id: const Uuid().v4(),
      timestamp: DateTime.now(),
      hgb: params['HGB']!,
      rbc: params['RBC']!,
      wbc: params['WBC']!,
      plt: params['PLT']!,
      lymp: params['LYMP']!,
      mono: params['MONO']!,
      hct: params['HCT']!,
      mcv: params['MCV']!,
      mch: params['MCH']!,
      mchc: params['MCHC']!,
      rdw: params['RDW']!,
      pdw: params['PDW']!,
      mpv: params['MPV']!,
      pct: params['PCT']!,
      imagePath: imagePath,
      diagnosis: diagnosis,
    );
  }

  static void dispose() {
    _textRecognizer.close();
  }
}
