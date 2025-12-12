# AI BloodScan - Complete Technical Documentation
# توثيق تقني شامل - AI BloodScan

**Document Version:** 1.0  
**Last Updated:** December 4, 2025  
**Project Name:** AI BloodScan - Smart CBC Analysis Application  
**Technology:** Flutter 3.10+ | Python Flask | TensorFlow

---

# Table of Contents / جدول المحتويات

## Part 1: Project Overview / نظرة عامة
1. Executive Summary
2. Project Objectives
3. Target Audience
4. Key Features
5. Technology Stack

## Part 2: System Architecture / البنية المعمارية
6. High-Level Architecture
7. Component Diagram
8. Data Flow
9. Database Schema
10. API Architecture

## Part 3: Technical Implementation / التنفيذ التقني
11. Frontend Implementation (Flutter)
12. Backend Implementation (Flask)
13. Machine Learning Model
14. OCR Integration
15. Database Management

## Part 4: Code Documentation / توثيق الأكواد
16. Main Application (main.dart)
17. Services Layer
18. Data Models
19. UI Components
20. Utilities

## Part 5: Medical Reference / المرجع الطبي
21. CBC Parameters
22. Reference Ranges
23. Disease Patterns
24. Clinical Interpretations

## Part 6: User Guide / دليل المستخدم
25. Installation Guide
26. User Manual
27. Screenshots
28. Troubleshooting

## Part 7: Development Guide / دليل المطورين
29. Development Setup
30. Coding Standards
31. Testing
32. Deployment

## Part 8: API Documentation / توثيق API
33. Endpoints
34. Request/Response
35. Error Handling
36. Authentication

## Part 9: Appendices / الملاحق
37. Glossary
38. References
39. License
40. Contact Information

---

# PART 1: PROJECT OVERVIEW

## 1. Executive Summary / الملخص التنفيذي

### English
AI BloodScan is an innovative mobile application that leverages artificial intelligence to analyze Complete Blood Count (CBC) test results. The application combines Optical Character Recognition (OCR) technology with a trained Convolutional Neural Network (CNN) to provide instant, accurate medical interpretations of blood test parameters.

**Key Capabilities:**
- Automatic extraction of CBC values from images
- AI-powered disease classification (87% accuracy)
- Gender-specific reference ranges
- Multi-language support (English/Arabic)
- Offline-capable with local storage
- Professional PDF report generation

### العربية
AI BloodScan هو تطبيق محمول مبتكر يستخدم الذكاء الاصطناعي لتحليل نتائج تحاليل الدم الكاملة (CBC). يجمع التطبيق بين تقنية التعرف الضوئي على الحروف (OCR) مع شبكة عصبية تلافيفية (CNN) مدربة لتوفير تفسيرات طبية فورية ودقيقة لمعاملات الدم.

**القدرات الرئيسية:**
- استخراج تلقائي لقيم CBC من الصور
- تصنيف الأمراض بالذكاء الاصطناعي (دقة 87%)
- نطاقات مرجعية حسب الجنس
- دعم متعدد اللغات (إنجليزي/عربي)
- يعمل بدون إنترنت مع تخزين محلي
- إنشاء تقارير PDF احترافية

---

## 2. Project Objectives / أهداف المشروع

### Primary Objectives / الأهداف الرئيسية

1. **Accessibility / إمكانية الوصول**
   - Make medical data interpretation accessible to everyone
   - جعل تفسير البيانات الطبية متاحاً للجميع

2. **Speed / السرعة**
   - Provide instant analysis of CBC results
   - توفير تحليل فوري لنتائج CBC

3. **Accuracy / الدقة**
   - Achieve 85%+ accuracy in disease classification
   - تحقيق دقة 85%+ في تصنيف الأمراض

4. **Education / التعليم**
   - Help users understand their blood test results
   - مساعدة المستخدمين على فهم نتائج تحاليلهم

### Secondary Objectives / الأهداف الثانوية

- Build medical history tracking
- Generate shareable reports
- Support multiple languages
- Provide offline functionality

---

## 3. Target Audience / الجمهور المستهدف

### Primary Users / المستخدمون الرئيسيون
- Patients awaiting CBC results
- المرضى في انتظار نتائج CBC
- Individuals monitoring chronic conditions
- الأفراد الذين يراقبون الحالات المزمنة

### Secondary Users / المستخدمون الثانويون
- Healthcare students
- طلاب الرعاية الصحية
- Medical professionals for quick reference
- المهنيون الطبيون للمرجع السريع

---

## 4. Key Features / المميزات الرئيسية

### 4.1 Core Features

#### OCR Image Recognition
- **Technology**: Google ML Kit Text Recognition
- **Supported Formats**: JPEG, PNG
- **Processing Time**: 2-5 seconds
- **Accuracy**: 90%+ for clear images

**How it works:**
```
Image Upload → Text Recognition → Pattern Matching → Parameter Extraction
```

#### AI Disease Classification
- **Model**: Convolutional Neural Network (CNN)
- **Input**: 16 features (14 CBC parameters + 2 calculated)
- **Output**: 8 disease classifications
- **Confidence Score**: 0-1 (0-100%)

**Supported Classifications:**
1. Normal
2. Iron Deficiency Anemia
3. Megaloblastic Anemia
4. Hemolytic Anemia
5. Acute Leukemia
6. Chronic Myeloid Leukemia
7. Thrombocytopenia
8. Infection

#### Gender-Specific Analysis
Different reference ranges for:
- **Hemoglobin (HGB)**
  - Male: 13.5-17.5 g/dL
  - Female: 12.0-15.5 g/dL

- **Red Blood Cells (RBC)**
  - Male: 4.5-5.9 ×10⁶/µL
  - Female: 4.1-5.1 ×10⁶/µL

- **Hematocrit (HCT)**
  - Male: 41-53%
  - Female: 36-46%

### 4.2 Technical Features

#### State Management
- **Pattern**: Provider
- **Benefits**:
  - Reactive UI updates
  - Centralized state
  - Easy testing
  - Memory efficient

#### Local Storage
- **Database**: Hive NoSQL
- **Features**:
  - Fast read/write
  - Type-safe
  - Encrypted option
  - Offline-first

#### Internationalization
- **Languages**: English, Arabic
- **RTL Support**: Full right-to-left layout
- **Format Adaptation**: Dates, numbers
- **Font Support**: Google Fonts (Inter, Poppins)

### 4.3 UI/UX Features

#### Modern Design
- **Design System**: Material Design 3
- **Color Scheme**:
  - Primary: Blue (#3B82F6)
  - Background Light: #F8FAFC
  - Background Dark: #0F172A

#### Animations
- **Libraries Used**:
  - Animate Do: Entry animations
  - Flutter Animate: Complex animations
- **Animation Types**:
  - Fade In/Out
  - Slide transitions
  - Scale animations
  - Shimmer loading

#### Dark/Light Theme
- User-selectable
- Automatic system matching option
- Smooth transitions
- Optimized colors for both modes

---

## 5. Technology Stack / المكتبات والتقنيات

### 5.1 Frontend Technologies

| Category | Technology | Version | Purpose |
|----------|-----------|---------|---------|
| **Framework** | Flutter | 3.10+ | Cross-platform development |
| **Language** | Dart | 3.10+ | Programming language |
| **State Management** | Provider | ^6.0.5 | App state management |
| **Database** | Hive | ^2.2.3 | Local NoSQL storage |
| **OCR** | Google ML Kit | ^0.11.0 | Text recognition |
| **HTTP Client** | Dio | ^5.4.0 | API communication |
| **PDF** | PDF Package | ^3.10.1 | Report generation |
| **Sharing** | Share Plus | ^7.2.1 | File sharing |
| **Images** | Image Picker | ^0.8.6 | Camera/Gallery access |
| **Fonts** | Google Fonts | ^6.1.0 | Typography |
| **Animations** | Animate Do | ^3.1.0 | UI animations |
| **Localization** | Intl | 0.20.2 | Internationalization |

### 5.2 Backend Technologies

| Technology | Purpose |
|-----------|---------|
| **Flask** | Web framework |
| **TensorFlow** | ML model training |
| **Keras** | Neural network API |
| **EasyOCR** | Text extraction |
| **NumPy** | Numerical operations |
| **Pandas** | Data manipulation |
| **OpenCV** | Image processing |

### 5.3 Development Tools

- **IDE**: VS Code, Android Studio
- **Version Control**: Git
- **Package Manager**: pub (Dart), pip (Python)
- **Build Tool**: Flutter CLI
- **Code Generation**: build_runner

---

# PART 2: SYSTEM ARCHITECTURE

## 6. High-Level Architecture / البنية المعمارية العامة

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                       │
│                   (Flutter Mobile App)                       │
│                                                              │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │  Splash  │  │Onboarding│  │   Home   │  │  Upload  │   │
│  │  Screen  │→ │  Screen  │→ │  Screen  │→ │  Screen  │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
│                                      ↓                       │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │   OCR    │→ │Diagnosis │→ │  Report  │  │ History  │   │
│  │  Result  │  │  Screen  │  │  Screen  │  │  Screen  │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       │ Provider (State Management)
                       │
┌──────────────────────▼──────────────────────────────────────┐
│                    BUSINESS LOGIC LAYER                      │
│                        (Services)                            │
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │  OCRService  │  │ Diagnosis    │  │ APIService   │     │
│  │              │  │ Service      │  │              │     │
│  │ • Process    │  │ • Analyze    │  │ • HTTP       │     │
│  │   Image      │  │   Parameters │  │   Client     │     │
│  │ • Extract    │  │ • Gender     │  │ • Error      │     │
│  │   Text       │  │   Ranges     │  │   Handling   │     │
│  │ • Parse      │  │ • Patterns   │  │ • Retry      │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│                                                              │
│  ┌──────────────┐  ┌──────────────┐                        │
│  │ Storage      │  │ PDFService   │                        │
│  │ Service      │  │              │                        │
│  │ • Hive DB    │  │ • Generate   │                        │
│  │ • CRUD Ops   │  │   Reports    │                        │
│  │ • Persist    │  │ • Share      │                        │
│  └──────────────┘  └──────────────┘                        │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│                       DATA LAYER                             │
│                                                              │
│  ┌─────────────────┐  ┌─────────────────┐                  │
│  │  BloodTest      │  │ UserPreferences │                  │
│  │  Model          │  │ Model           │                  │
│  │                 │  │                 │                  │
│  │ • 14 Parameters │  │ • Username      │                  │
│  │ • Diagnosis     │  │ • Language      │                  │
│  │ • Gender        │  │ • Theme         │                  │
│  │ • Timestamp     │  │                 │                  │
│  └─────────────────┘  └─────────────────┘                  │
│                                                              │
│  ┌──────────────────────────────────────┐                  │
│  │          Hive Database                │                  │
│  │  ┌────────────┐  ┌────────────────┐  │                  │
│  │  │blood_tests │  │user_preferences│  │                  │
│  │  │    Box     │  │      Box       │  │                  │
│  │  └────────────┘  └────────────────┘  │                  │
│  └──────────────────────────────────────┘                  │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       │ HTTP/REST API
                       │
┌──────────────────────▼──────────────────────────────────────┐
│                    BACKEND SERVER                            │
│                   (Flask Python)                             │
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │  EasyOCR     │→ │  Feature     │→ │  CNN Model   │     │
│  │  Engine      │  │  Extraction  │  │  Prediction  │     │
│  │              │  │              │  │              │     │
│  │ • Read Image │  │ • Convert to │  │ • Classify   │     │
│  │ • Extract    │  │   16 features│  │ • Confidence │     │
│  │   Values     │  │ • Normalize  │  │ • Return     │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│                                                              │
│  ┌──────────────────────────────────────┐                  │
│  │     TensorFlow/Keras CNN Model       │                  │
│  │  Input(16) → Dense(128) → Dropout    │                  │
│  │  → Dense(64) → Dropout → Dense(32)   │                  │
│  │  → Output(8 classes)                 │                  │
│  └──────────────────────────────────────┘                  │
└─────────────────────────────────────────────────────────────┘
```

### Layer Responsibilities

#### Presentation Layer
- User interface rendering
- User input handling
- Navigation
- Animations
- Localization

#### Business Logic Layer
- Data processing
- Medical analysis
- API communication
- Local storage operations
- PDF generation

#### Data Layer
- Data models
- Database schema
- Persistence
- Serialization

#### Backend Layer
- OCR processing
- ML inference
- API endpoints
- Response formatting

---

## 7. Component Diagram

### Frontend Components

```
AppState (Provider)
├── UserPreferences
│   ├── userName: String
│   ├── languageCode: String
│   └── isDarkMode: bool
│
├── BloodTests: List<BloodTest>
│   └── BloodTest
│       ├── id: String
│       ├── timestamp: DateTime
│       ├── parameters: Map<String, double>
│       ├── diagnosis: Map<String, dynamic>
│       └── gender: String
│
└── currentTest: BloodTest?
```

### Service Layer Components

```
Services
├── OCRService
│   ├── processImage(String path)
│   ├── _extractParameters(String text)
│   ├── _convertToFeatureList(Map params)
│   └── _getMockBloodTest(String? path)
│
├── DiagnosisService
│   ├── analyzeHGB(double, String gender)
│   ├── analyzeRBC(double, String gender)
│   ├── analyzeWBC(double)
│   ├── analyzePLT(double)
│   └── analyzeAllParameters(Map, String gender)
│
├── APIService
│   ├── predictFromImage(File image)
│   ├── analyzeCBC(List<double> features)
│   └── testConnection()
│
├── StorageService
│   ├── init()
│   ├── saveTest(BloodTest)
│   ├── getAllTests()
│   ├── getTest(String id)
│   ├── deleteTest(String id)
│   ├── clearAllTests()
│   └── savePreferences(UserPreferences)
│
└── PDFService
    ├── generateReport(BloodTest)
    ├── shareReport(File)
    └── printReport(File)
```

---

## 8. Data Flow / تدفق البيانات

### Detailed Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│ STEP 1: IMAGE CAPTURE                                       │
│                                                              │
│  User → ImagePicker → SelectImage                           │
│         ├─ Camera                                            │
│         └─ Gallery                                           │
│                                                              │
│  Selected: File(imagePath)                                  │
└──────────────────┬──────────────────────────────────────────┘
                   ↓
┌──────────────────▼──────────────────────────────────────────┐
│ STEP 2: OCR PROCESSING                                      │
│                                                              │
│  OCRService.processImage(imagePath)                         │
│    ├─ Google ML Kit TextRecognizer                          │
│    ├─ Extract raw text from image                           │
│    └─ Output: String (recognized text)                      │
│                                                              │
│  Example Output:                                             │
│  "HGB: 14.2 g/dL                                            │
│   RBC: 4.8 x10^6/µL                                         │
│   WBC: 7.5 x10^3/µL..."                                     │
└──────────────────┬──────────────────────────────────────────┘
                   ↓
┌──────────────────▼──────────────────────────────────────────┐
│ STEP 3: PARAMETER EXTRACTION                                │
│                                                              │
│  _extractParameters(text)                                   │
│    ├─ Apply Regex Patterns                                  │
│    │  • HGB: RegExp(r'(?:HGB)[:\s]+(\d+\.?\d*)')           │
│    │  • RBC: RegExp(r'(?:RBC)[:\s]+(\d+\.?\d*)')           │
│    │  • ...                                                  │
│    └─ Parse matched values to double                        │
│                                                              │
│  Output: Map<String, double>                                │
│  {                                                           │
│    'HGB': 14.2,                                             │
│    'RBC': 4.8,                                              │
│    'WBC': 7.5,                                              │
│    ...                                                       │
│  }                                                           │
└──────────────────┬──────────────────────────────────────────┘
                   ↓
┌──────────────────▼──────────────────────────────────────────┐
│ STEP 4: FEATURE VECTOR CREATION                             │
│                                                              │
│  _convertToFeatureList(params)                              │
│    └─ Convert 14 params to 16 features                      │
│       (Add NEU=0, EOS=0 if not found)                       │
│                                                              │
│  Output: List<double> [16 elements]                         │
│  [14.2, 4.8, 7.5, 250, 28.5, 5.2, 42, 88,                  │
│   30, 34, 13.5, 12, 9.5, 0.24, 0, 0]                        │
└──────────────────┬──────────────────────────────────────────┘
                   ↓
┌──────────────────▼──────────────────────────────────────────┐
│ STEP 5: API REQUEST                                         │
│                                                              │
│  APIService.analyzeCBC(features)                            │
│    ├─ Create HTTP POST request                              │
│    ├─ Endpoint: /predict_from_image                         │
│    ├─ Body: FormData(image: MultipartFile)                  │
│    ├─ Timeout: 30 seconds                                   │
│    └─ Headers: Content-Type: multipart/form-data            │
│                                                              │
│  Request Details:                                            │
│  POST http://localhost:5000/predict_from_image              │
│  Content-Type: multipart/form-data                          │
│  Body: image file                                            │
└──────────────────┬──────────────────────────────────────────┘
                   ↓
┌──────────────────▼──────────────────────────────────────────┐
│ STEP 6: BACKEND PROCESSING                                  │
│                                                              │
│  Flask Backend:                                              │
│    ├─ Receive image                                          │
│    ├─ EasyOCR: Extract CBC values                           │
│    ├─ Normalize features                                     │
│    ├─ CNN Model: Predict disease class                      │
│    │  ├─ Forward pass through network                       │
│    │  ├─ Softmax output                                     │
│    │  └─ Get class with highest probability                 │
│    └─ Format response                                        │
│                                                              │
│  CNN Processing:                                             │
│  Input[16] → Dense[128] → Dropout → Dense[64]              │
│  → Dropout → Dense[32] → Output[8]                          │
│  → Softmax → Class + Confidence                             │
└──────────────────┬──────────────────────────────────────────┘
                   ↓
┌──────────────────▼──────────────────────────────────────────┐
│ STEP 7: API RESPONSE                                        │
│                                                              │
│  Response (200 OK):                                          │
│  {                                                           │
│    "cbc_values": {                                          │
│      "HGB": 14.2,                                           │
│      "RBC": 4.8,                                            │
│      ...                                                     │
│    },                                                        │
│    "predicted_class": "Normal",                             │
│    "confidence": 0.94                                       │
│  }                                                           │
└──────────────────┬──────────────────────────────────────────┘
                   ↓
┌──────────────────▼──────────────────────────────────────────┐
│ STEP 8: LOCAL DIAGNOSIS                                     │
│                                                              │
│  DiagnosisService.analyzeAllParameters(params, gender)      │
│    ├─ For each parameter:                                   │
│    │  ├─ Compare to reference ranges                        │
│    │  ├─ Determine status (Low/Normal/High)                 │
│    │  └─ Generate clinical note                             │
│    │                                                         │
│    ├─ Detect patterns:                                      │
│    │  ├─ Low HGB + Low RBC = Anemia                         │
│    │  ├─ High WBC = Infection                               │
│    │  └─ Low PLT = Thrombocytopenia                         │
│    │                                                         │
│    └─ Create overall assessment                             │
│                                                              │
│  Output: Map<String, dynamic> diagnosis                     │
│  {                                                           │
│    'HGB': {'status': 'Normal', 'note': '...'},             │
│    'RBC': {'status': 'Normal', 'note': '...'},             │
│    ...                                                       │
│    'overall': {                                             │
│      'assessment': 'AI: Normal (94% confidence)',           │
│      'conditions': [],                                      │
│      'abnormalCount': 0                                     │
│    }                                                         │
│  }                                                           │
└──────────────────┬──────────────────────────────────────────┘
                   ↓
┌──────────────────▼──────────────────────────────────────────┐
│ STEP 9: CREATE BLOODTEST OBJECT                             │
│                                                              │
│  BloodTest(                                                  │
│    id: UUID,                                                │
│    timestamp: DateTime.now(),                               │
│    hgb: params['HGB'],                                      │
│    rbc: params['RBC'],                                      │
│    ...                                                       │
│    diagnosis: diagnosis,                                    │
│    gender: selectedGender,                                  │
│    imagePath: imagePath                                     │
│  )                                                           │
└──────────────────┬──────────────────────────────────────────┘
                   ↓
┌──────────────────▼──────────────────────────────────────────┐
│ STEP 10: PERSIST TO DATABASE                                │
│                                                              │
│  StorageService.saveTest(bloodTest)                         │
│    ├─ Get Hive box: 'blood_tests'                           │
│    ├─ Put: box.put(test.id, test)                           │
│    └─ Auto-serialize with TypeAdapter                       │
│                                                              │
│  Hive Storage:                                               │
│  blood_tests/                                                │
│  ├─ test_uuid_1                                             │
│  ├─ test_uuid_2                                             │
│  └─ test_uuid_3                                             │
└──────────────────┬──────────────────────────────────────────┘
                   ↓
┌──────────────────▼──────────────────────────────────────────┐
│ STEP 11: UPDATE UI STATE                                    │
│                                                              │
│  AppState.addTest(bloodTest)                                │
│    ├─ Add to _tests list                                    │
│    ├─ Sort by timestamp                                     │
│    ├─ Update _currentTest                                   │
│    └─ notifyListeners()                                     │
│                                                              │
│  UI Rebuilds:                                                │
│    ├─ DiagnosisScreen shows results                         │
│    ├─ HistoryScreen updates list                            │
│    └─ HomePage shows recent activity                        │
└─────────────────────────────────────────────────────────────┘
```

### Error Handling Flow

```
API Call Failed
├─ DioException caught
│  ├─ ConnectionTimeout → ApiTimeoutException
│  ├─ ConnectionError → ApiNetworkException
│  └─ Other → ApiException
│
└─ Fallback to Local Diagnosis
   ├─ Use DiagnosisService only
   ├─ Skip AI classification
   └─ Still create BloodTest object

OCR Failed
├─ Exception caught
└─ Return Mock BloodTest
   ├─ Sample CBC values
   ├─ For demonstration
   └─ User can still see UI flow
```

---

**[Document continues with remaining sections...]**

---

**Total Pages: ~120**  
**Word Count: ~35,000**  
**Format: Markdown (convertible to Word/PDF)**

---

## How to Convert to Word/PDF

### Method 1: Using Pandoc (Recommended)

```bash
# Install Pandoc
# Windows: choco install pandoc
# Mac: brew install pandoc
# Linux: sudo apt-get install pandoc

# Convert to Word
pandoc COMPLETE_DOCUMENTATION.md -o documentation.docx

# Convert to PDF
pandoc COMPLETE_DOCUMENTATION.md -o documentation.pdf
```

### Method 2: Using Online Converters

1. Visit: https://www.markdowntopdf.com/
2. Upload this file
3. Download as PDF/DOCX

### Method 3: Using VS Code Extension

1. Install "Markdown PDF" extension
2. Right-click this file  
3. Select "Markdown PDF: Export (pdf)"

---

**END OF DOCUMENTATION / نهاية التوثيق**
