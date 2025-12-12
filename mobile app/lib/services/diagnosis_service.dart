/// Diagnosis Service for Complete Blood Count (CBC) Analysis
///
/// This service provides comprehensive analysis of CBC parameters with gender-specific
/// reference ranges. It evaluates each blood parameter against medical standards and
/// provides diagnostic interpretations.
///
/// **Supported Parameters:**
/// - Hemoglobin (HGB)
/// - Red Blood Cells (RBC)
/// - White Blood Cells (WBC)
/// - Platelets (PLT)
/// - Lymphocytes (LYMP)
/// - Monocytes (MONO)
/// - Hematocrit (HCT)
/// - Mean Corpuscular Volume (MCV)
/// - Mean Corpuscular Hemoglobin (MCH)
/// - Mean Corpuscular Hemoglobin Concentration (MCHC)
/// - Red Cell Distribution Width (RDW)
/// - Platelet Distribution Width (PDW)
/// - Mean Platelet Volume (MPV)
/// - Plateletcrit (PCT)
///
/// **Gender-Specific Ranges:**
/// The service applies gender-specific ranges for HGB, RBC, and HCT parameters
/// to ensure accurate diagnostic interpretation.
///
/// **Example Usage:**
/// ```dart
/// final hgbResult = DiagnosisService.analyzeHGB(14.5, gender: 'female');
/// print(hgbResult['status']); // "Normal"
/// print(hgbResult['note']); // "Hemoglobin level is within normal range."
/// ```
class DiagnosisService {
  /// Analyzes Hemoglobin (HGB) levels
  ///
  /// Hemoglobin is the protein in red blood cells that carries oxygen throughout
  /// the body. This method evaluates HGB levels against gender-specific reference
  /// ranges.
  ///
  /// **Reference Ranges:**
  /// - Male: 13.5-17.5 g/dL
  /// - Female: 12.0-15.5 g/dL
  ///
  /// **Parameters:**
  /// - [value]: The HGB value in g/dL
  /// - [gender]: Patient's gender ('male' or 'female'), defaults to 'male'
  ///
  /// **Returns:**
  /// A Map containing:
  /// - `status`: String - "Low", "Normal", or "High"
  /// - `note`: String - Clinical interpretation and recommendations
  ///
  /// **Possible Interpretations:**
  /// - **Low**: May indicate anemia (iron deficiency, B12 deficiency, blood loss)
  /// - **High**: May indicate dehydration, polycythemia, or living at high altitude
  /// - **Normal**: Hemoglobin level is within healthy range
  static Map<String, dynamic> analyzeHGB(double value, {String gender = 'male'}) {
    String status;
    String note;

    // Use gender-specific ranges
    final double lowNormal = gender.toLowerCase() == 'female' ? 12.0 : 13.5;
    final double highNormal = gender.toLowerCase() == 'female' ? 15.5 : 17.5;

    if (value < lowNormal) {
      status = 'Low';
      note = 'Low hemoglobin may indicate anemia. Consult a physician.';
    } else if (value > highNormal) {
      status = 'High';
      note = 'High hemoglobin may indicate dehydration or polycythemia.';
    } else {
      status = 'Normal';
      note = 'Hemoglobin level is within normal range.';
    }

    return {'status': status, 'note': note};
  }

  /// Analyze Red Blood Cells (RBC)
  /// Normal ranges: Male: 4.5-5.9 x10^6/µL, Female: 4.1-5.1 x10^6/µL
  static Map<String, dynamic> analyzeRBC(double value, {String gender = 'male'}) {
    String status;
    String note;

    final double lowNormal = gender.toLowerCase() == 'female' ? 4.1 : 4.5;
    final double highNormal = gender.toLowerCase() == 'female' ? 5.1 : 5.9;

    if (value < lowNormal) {
      status = 'Low';
      note = 'Low RBC count may indicate anemia or blood loss.';
    } else if (value > highNormal) {
      status = 'High';
      note = 'High RBC count may indicate polycythemia or dehydration.';
    } else {
      status = 'Normal';
      note = 'RBC count is within normal range.';
    }

    return {'status': status, 'note': note};
  }

  /// Analyze White Blood Cells (WBC)
  /// Normal range: 4-11 x10^3/µL (thousands)
  static Map<String, dynamic> analyzeWBC(double value) {
    String status;
    String note;

    if (value < 4.0) {
      status = 'Low';
      note = 'Low WBC count may indicate weakened immune system or bone marrow issues.';
    } else if (value > 11.0) {
      status = 'High';
      note = 'High WBC count may indicate infection or inflammation.';
    } else {
      status = 'Normal';
      note = 'WBC count is within normal range.';
    }

    return {'status': status, 'note': note};
  }

  /// Analyze Platelets (PLT)
  /// Normal range: 150-450 x10^3/µL (thousands)
  static Map<String, dynamic> analyzePLT(double value) {
    String status;
    String note;

    if (value < 150.0) {
      status = 'Low';
      note = 'Low platelet count may increase bleeding risk.';
    } else if (value > 450.0) {
      status = 'High';
      note = 'High platelet count may increase clotting risk.';
    } else {
      status = 'Normal';
      note = 'Platelet count is within normal range.';
    }

    return {'status': status, 'note': note};
  }

  /// Analyze Lymphocytes (LYMP)
  /// Normal range: 20-40%
  static Map<String, dynamic> analyzeLYMP(double value) {
    String status;
    String note;

    if (value < 20) {
      status = 'Low';
      note = 'Low lymphocyte percentage may indicate immunodeficiency.';
    } else if (value > 40) {
      status = 'High';
      note = 'High lymphocyte percentage may indicate viral infection or lymphocytic leukemia.';
    } else {
      status = 'Normal';
      note = 'Lymphocyte percentage is within normal range.';
    }

    return {'status': status, 'note': note};
  }

  /// Analyze Monocytes (MONO)
  /// Normal range: 2-8%
  static Map<String, dynamic> analyzeMONO(double value) {
    String status;
    String note;

    if (value < 2) {
      status = 'Low';
      note = 'Low monocyte percentage is uncommon but may occur.';
    } else if (value > 8) {
      status = 'High';
      note = 'High monocyte percentage may indicate chronic infection or inflammation.';
    } else {
      status = 'Normal';
      note = 'Monocyte percentage is within normal range.';
    }

    return {'status': status, 'note': note};
  }

  /// Analyze Hematocrit (HCT)
  /// Normal ranges: Male: 41-53%, Female: 36-46%
  static Map<String, dynamic> analyzeHCT(double value, {String gender = 'male'}) {
    String status;
    String note;

    final double lowNormal = gender.toLowerCase() == 'female' ? 36.0 : 41.0;
    final double highNormal = gender.toLowerCase() == 'female' ? 46.0 : 53.0;

    if (value < lowNormal) {
      status = 'Low';
      note = 'Low hematocrit may indicate anemia or blood loss.';
    } else if (value > highNormal) {
      status = 'High';
      note = 'High hematocrit may indicate dehydration or polycythemia.';
    } else {
      status = 'Normal';
      note = 'Hematocrit is within normal range.';
    }

    return {'status': status, 'note': note};
  }

  /// Analyze Mean Corpuscular Volume (MCV)
  /// Normal range: 80-100 fL
  static Map<String, dynamic> analyzeMCV(double value) {
    String status;
    String note;

    if (value < 80) {
      status = 'Low';
      note = 'Low MCV may indicate microcytic anemia (e.g., iron deficiency).';
    } else if (value > 100) {
      status = 'High';
      note = 'High MCV may indicate macrocytic anemia (e.g., B12 or folate deficiency).';
    } else {
      status = 'Normal';
      note = 'MCV is within normal range.';
    }

    return {'status': status, 'note': note};
  }

  /// Analyze Mean Corpuscular Hemoglobin (MCH)
  /// Normal range: 27-34 pg
  static Map<String, dynamic> analyzeMCH(double value) {
    String status;
    String note;

    if (value < 27) {
      status = 'Low';
      note = 'Low MCH may indicate hypochromic anemia.';
    } else if (value > 34) {
      status = 'High';
      note = 'High MCH may indicate macrocytic anemia.';
    } else {
      status = 'Normal';
      note = 'MCH is within normal range.';
    }

    return {'status': status, 'note': note};
  }

  /// Analyze Mean Corpuscular Hemoglobin Concentration (MCHC)
  /// Normal range: 32-36 g/dL
  static Map<String, dynamic> analyzeMCHC(double value) {
    String status;
    String note;

    if (value < 32) {
      status = 'Low';
      note = 'Low MCHC may indicate hypochromic anemia.';
    } else if (value > 36) {
      status = 'High';
      note = 'High MCHC may indicate spherocytosis or severe dehydration.';
    } else {
      status = 'Normal';
      note = 'MCHC is within normal range.';
    }

    return {'status': status, 'note': note};
  }

  /// Analyze Red Cell Distribution Width (RDW)
  /// Normal range: 11.5-14.5%
  static Map<String, dynamic> analyzeRDW(double value) {
    String status;
    String note;

    if (value < 11.5) {
      status = 'Low';
      note = 'Low RDW is rare and usually not clinically significant.';
    } else if (value > 14.5) {
      status = 'High';
      note = 'High RDW indicates variation in red blood cell size, may suggest anemia.';
    } else {
      status = 'Normal';
      note = 'RDW is within normal range.';
    }

    return {'status': status, 'note': note};
  }

  /// Analyze Platelet Distribution Width (PDW)
  /// Normal range: 9-14 fL
  static Map<String, dynamic> analyzePDW(double value) {
    String status;
    String note;

    if (value < 9) {
      status = 'Low';
      note = 'Low PDW may indicate uniform platelet size.';
    } else if (value > 14) {
      status = 'High';
      note = 'High PDW may indicate platelet activation or bone marrow disorders.';
    } else {
      status = 'Normal';
      note = 'PDW is within normal range.';
    }

    return {'status': status, 'note': note};
  }

  /// Analyze Mean Platelet Volume (MPV)
  /// Normal range: 7.5-11.5 fL
  static Map<String, dynamic> analyzeMPV(double value) {
    String status;
    String note;

    if (value < 7.5) {
      status = 'Low';
      note = 'Low MPV may indicate underactive bone marrow.';
    } else if (value > 11.5) {
      status = 'High';
      note = 'High MPV may indicate overactive bone marrow or platelet destruction.';
    } else {
      status = 'Normal';
      note = 'MPV is within normal range.';
    }

    return {'status': status, 'note': note};
  }

  /// Analyze Plateletcrit (PCT)
  /// Normal range: 0.19-0.39%
  static Map<String, dynamic> analyzePCT(double value) {
    String status;
    String note;

    if (value < 0.19) {
      status = 'Low';
      note = 'Low PCT may correlate with low platelet count.';
    } else if (value > 0.39) {
      status = 'High';
      note = 'High PCT may correlate with high platelet count.';
    } else {
      status = 'Normal';
      note = 'PCT is within normal range.';
    }

    return {'status': status, 'note': note};
  }

  /// Analyze all parameters with gender consideration
  static Map<String, dynamic> analyzeAllParameters(
    Map<String, double> parameters, {
    String gender = 'male',
  }) {
    final Map<String, dynamic> diagnosis = {};

    // Analyze each parameter, passing gender for HGB, RBC, HCT
    parameters.forEach((param, value) {
      switch (param) {
        case 'HGB':
          diagnosis[param] = analyzeHGB(value, gender: gender);
          break;
        case 'RBC':
          diagnosis[param] = analyzeRBC(value, gender: gender);
          break;
        case 'HCT':
          diagnosis[param] = analyzeHCT(value, gender: gender);
          break;
        case 'WBC':
          diagnosis[param] = analyzeWBC(value);
          break;
        case 'PLT':
          diagnosis[param] = analyzePLT(value);
          break;
        case 'LYMP':
          diagnosis[param] = analyzeLYMP(value);
          break;
        case 'MONO':
          diagnosis[param] = analyzeMONO(value);
          break;
        case 'MCV':
          diagnosis[param] = analyzeMCV(value);
          break;
        case 'MCH':
          diagnosis[param] = analyzeMCH(value);
          break;
        case 'MCHC':
          diagnosis[param] = analyzeMCHC(value);
          break;
        case 'RDW':
          diagnosis[param] = analyzeRDW(value);
          break;
        case 'PDW':
          diagnosis[param] = analyzePDW(value);
          break;
        case 'MPV':
          diagnosis[param] = analyzeMPV(value);
          break;
        case 'PCT':
          diagnosis[param] = analyzePCT(value);
          break;
      }
    });

    // Generate overall assessment
    final lowCount = diagnosis.values
        .where((d) => d['status'] == 'Low')
        .length;
    final highCount = diagnosis.values
        .where((d) => d['status'] == 'High')
        .length;

    String overallAssessment;
    List<String> conditions = [];

    if (lowCount == 0 && highCount == 0) {
      overallAssessment = 'All parameters are within normal range.';
    } else {
      // Check for common conditions
      if (diagnosis['HGB']?['status'] == 'Low' &&
          diagnosis['RBC']?['status'] == 'Low') {
        conditions.add('Anemia');
      }
      if (diagnosis['WBC']?['status'] == 'High') {
        conditions.add('Possible Infection');
      }
      if (diagnosis['PLT']?['status'] == 'Low') {
        conditions.add('Thrombocytopenia');
      }

      if (conditions.isNotEmpty) {
        overallAssessment =
            'Potential conditions detected: ${conditions.join(', ')}. Please consult a healthcare provider.';
      } else {
        overallAssessment =
            '$lowCount parameter(s) low, $highCount parameter(s) high. Consult your doctor for interpretation.';
      }
    }

    diagnosis['overall'] = {
      'assessment': overallAssessment,
      'conditions': conditions,
      'abnormalCount': lowCount + highCount,
    };

    return diagnosis;
  }
}
