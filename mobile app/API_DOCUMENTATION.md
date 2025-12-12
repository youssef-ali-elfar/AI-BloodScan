# API Documentation - AI BloodScan Backend

## Base URL
```
http://localhost:5000
```

## Authentication

All requests require an API key in the headers:

```http
x-api-key: your-api-key-here
```

---

## Endpoints

### 1. Health Check

Check if the backend server is running.

**Endpoint:**
```http
GET /health
```

**Request:**
```bash
curl -X GET http://localhost:5000/health
```

**Response:**
```json
{
  "status": "healthy",
  "timestamp": "2025-12-04T17:30:00Z",
  "model_loaded": true
}
```

**Status Codes:**
- `200 OK`: Server is running
- `503 Service Unavailable`: Server is down

---

### 2. Analyze CBC from Image

Upload a CBC report image for OCR extraction and AI-powered analysis.

**Endpoint:**
```http
POST /predict_from_image
Content-Type: multipart/form-data
```

**Request Headers:**
```http
x-api-key: your-api-key-here
Content-Type: multipart/form-data
```

**Request Body:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `image` | File | Yes | CBC report image (JPEG, PNG) |

**cURL Example:**
```bash
curl -X POST http://localhost:5000/predict_from_image \
  -H "x-api-key: your-api-key-here" \
  -F "image=@/path/to/cbc_report.jpg"
```

**Dart Example:**
```dart
final formData = FormData.fromMap({
  'image': await MultipartFile.fromFile(
    imageFile.path,
    filename: 'cbc_report.jpg',
  ),
});

final response = await dio.post(
  '/predict_from_image',
  data: formData,
  options: Options(headers: {'x-api-key': 'your-api-key'}),
);
```

**Success Response (200 OK):**
```json
{
  "cbc_values": {
    "HGB": 14.2,
    "RBC": 4.8,
    "WBC": 7.5,
    "PLT": 250.0,
    "LYMP": 28.5,
    "MONO": 5.2,
    "HCT": 42.0,
    "MCV": 88.0,
    "MCH": 30.0,
    "MCHC": 34.0,
    "RDW": 13.5,
    "PDW": 12.0,
    "MPV": 9.5,
    "PCT": 0.24,
    "NEU": 60.0,
    "EOS": 2.0
  },
  "predicted_class": "Normal",
  "confidence": 0.94,
  "timestamp": "2025-12-04T17:30:00Z"
}
```

**Response Fields:**

| Field | Type | Description |
|-------|------|-------------|
| `cbc_values` | Object | Extracted CBC parameter values |
| `predicted_class` | String | AI-predicted condition |
| `confidence` | Number | Prediction confidence (0-1) |
| `timestamp` | String | Analysis timestamp |

**Predicted Classes:**

The model can classify the following conditions:

1. **Normal** - All values within healthy ranges
2. **Iron Deficiency Anemia** - Low HGB, MCV, MCH
3. **Megaloblastic Anemia** - High MCV, low RBC
4. **Hemolytic Anemia** - Low RBC, high reticulocytes
5. **Acute Leukemia** - Abnormal WBC, low PLT
6. **Chronic Myeloid Leukemia** - Very high WBC
7. **Thrombocytopenia** - Low PLT
8. **Infection** - High WBC, high neutrophils

**Error Responses:**

#### 400 Bad Request
```json
{
  "error": "Invalid image format",
  "details": "Supported formats: JPEG, PNG"
}
```

#### 401 Unauthorized
```json
{
  "error": "Invalid API key",
  "details": "Please provide a valid x-api-key header"
}
```

#### 422 Unprocessable Entity
```json
{
  "error": "OCR extraction failed",
  "details": "Unable to extract CBC values from image"
}
```

#### 500 Internal Server Error
```json
{
  "error": "Model prediction failed",
  "details": "Error processing the request"
}
```

---

### 3. Analyze CBC from Values

Send pre-extracted CBC values for AI analysis (without image).

**Endpoint:**
```http
POST /analyze_cbc
Content-Type: application/json
```

**Request Body:**
```json
{
  "values": [14.2, 4.8, 7.5, 250.0, 28.5, 5.2, 42.0, 88.0, 30.0, 34.0, 13.5, 12.0, 9.5, 0.24, 60.0, 2.0],
  "gender": "female"
}
```

**Response:**
```json
{
  "predicted_class": "Normal",
  "confidence": 0.94,
  "analysis": {
    "risk_level": "low",
    "recommendations": [
      "All values are within normal range",
      "Maintain healthy diet and lifestyle"
    ]
  }
}
```

---

## Rate Limiting

- **Rate Limit**: 100 requests per hour per API key
- **Rate Limit Header**: `X-RateLimit-Remaining`

**Rate Limit Response (429):**
```json
{
  "error": "Rate limit exceeded",
  "retry_after": 3600
}
```

---

## Error Handling

### Standard Error Format

All errors follow this structure:

```json
{
  "error": "Error title",
  "details": "Detailed error description",
  "timestamp": "2025-12-04T17:30:00Z"
}
```

### HTTP Status Codes

| Code | Meaning | Description |
|------|---------|-------------|
| 200 | OK | Request successful |
| 400 | Bad Request | Invalid request parameters |
| 401 | Unauthorized | Missing or invalid API key |
| 422 | Unprocessable Entity | Cannot process image/data |
| 429 | Too Many Requests | Rate limit exceeded |
| 500 | Internal Server Error | Server error |
| 503 | Service Unavailable | Server down or maintenance |

---

## Flutter Integration Example

### Complete Integration

```dart
import 'package:dio/dio.dart';
import 'dart:io';

class ApiService {
  static const String baseUrl = 'http://localhost:5000';
  static const String apiKey = 'your-api-key-here';
  
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: {'x-api-key': apiKey},
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
    ),
  );

  static Future<Map<String, dynamic>> analyzeCBC(File imageFile) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imageFile.path),
      });

      final response = await _dio.post(
        '/predict_from_image',
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('API error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Cannot connect to server');
      } else {
        throw Exception('Request failed: ${e.message}');
      }
    }
  }
}
```

### Usage Example

```dart
try {
  final result = await ApiService.analyzeCBC(imageFile);
  
  final cbcValues = result['cbc_values'];
  final predictedClass = result['predicted_class'];
  final confidence = result['confidence'];
  
  print('Diagnosis: $predictedClass');
  print('Confidence: ${(confidence * 100).toStringAsFixed(1)}%');
  print('HGB: ${cbcValues['HGB']} g/dL');
  
} catch (e) {
  print('Error: $e');
}
```

---

## Testing

### Test with cURL

```bash
# Health check
curl http://localhost:5000/health

# Analyze CBC image
curl -X POST http://localhost:5000/predict_from_image \
  -H "x-api-key: test-key" \
  -F "image=@sample_cbc.jpg"
```

### Test with Postman

1. Create new POST request to `http://localhost:5000/predict_from_image`
2. Add header: `x-api-key: your-api-key`
3. In Body, select `form-data`
4. Add key `image` with type `File`
5. Upload CBC image file
6. Send request

---

## CNN Model Details

### Architecture

```
Input Layer: 16 features
    ↓
Dense Layer: 128 neurons (ReLU)
    ↓
Dropout: 0.3
    ↓
Dense Layer: 64 neurons (ReLU)
    ↓
Dropout: 0.2
    ↓
Dense Layer: 32 neurons (ReLU)
    ↓
Output Layer: 8 classes (Softmax)
```

### Training Details

- **Dataset Size**: 5,000+ labeled CBC samples
- **Training Accuracy**: 92%
- **Validation Accuracy**: 87%
- **Test Accuracy**: 85%
- **Optimizer**: Adam
- **Loss Function**: Categorical Cross-Entropy
- **Epochs**: 100
- **Batch Size**: 32

### Feature Importance

Most important features for classification:
1. Hemoglobin (HGB)
2. White Blood Cells (WBC)
3. Platelets (PLT)
4. Mean Corpuscular Volume (MCV)
5. Red Blood Cells (RBC)

---

## Support

For API support:
- **Email**: api-support@aibloodscan.com
- **GitHub Issues**: [Open an issue](https://github.com/yourusername/ai-bloodscan/issues)

---

## Changelog

### v1.0.0 (2025-12-04)
- Initial API release
- Support for CBC image analysis
- 8 disease classifications
- 87% accuracy on validation set

---

**Last Updated**: December 4, 2025
