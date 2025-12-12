import 'package:dio/dio.dart';
import 'dart:io';

/// Flask Backend API Service for AI-Powered CBC Analysis
///
/// This service communicates with a Flask backend that hosts a trained Convolutional
/// Neural Network (CNN) model for automated Complete Blood Count (CBC) analysis and
/// disease classification.
///
/// **Backend Architecture:**
/// - **Framework**: Flask (Python)
/// - **ML Model**: CNN trained on CBC dataset
/// - **OCR**: EasyOCR for text extraction from images
/// - **Input**: 16 CBC parameters as feature vector
/// - **Output**: Disease classification + confidence score
///
/// **Supported Classifications:**
/// The CNN model can detect multiple blood conditions including:
/// - Normal (healthy blood values)
/// - Iron Deficiency Anemia
/// - Megaloblastic Anemia  
/// - Hemolytic Anemia
/// - Acute Leukemia
/// - Chronic Myeloid Leukemia
/// - Thrombocytopenia
/// - Infections (bacterial/viral)
///
/// **Communication Protocol:**
/// - **Protocol**: HTTP/HTTPS
/// - **Format**: JSON
/// - **Authentication**: API Key (configurable)
/// - **Timeout**: 30 seconds
///
/// **Error Handling:**
/// The service implements comprehensive error handling for:
/// - Network failures (no internet, server down)
/// - Timeout errors
/// - Server errors (500, 400, etc.)
/// - Invalid response format
///
/// **Example Usage:**
/// ```dart
/// try {
///   final result = await ApiService.predictFromImage(imageFile);
///   print('Disease: ${result['predicted_class']}');
///   print('Confidence: ${result['confidence']}%');
/// } on ApiNetworkException catch (e) {
///   print('Network error: $e');
/// } on ApiTimeoutException catch (e) {
///   print('Request timeout: $e');
/// }
/// ```
///
/// **Configuration:**
/// Update [baseUrl] to point to your Flask backend:
/// ```dart
/// static const String baseUrl = 'http://your-server.com:5000';
/// ```
class ApiService {
  static const String baseUrl = 'http://127.0.0.1:5000';
  static const String predictEndpoint = '/predict_from_image';
  static const String apiKey = 'your-api-key-here'; // TODO: Replace with actual API key
  
  // Dio instance with custom configuration
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'x-api-key': apiKey,
      },
    ),
  );

  /// Upload CBC report image and get extraction + prediction
  /// 
  /// Returns a Map with:
  /// - cbc_values: Map<String, dynamic> (extracted CBC values)
  /// - predicted_class: String (ML model prediction)
  /// - confidence: double (prediction confidence 0-1)
  /// 
  /// Throws:
  /// - ApiNetworkException if no internet connection
  /// - ApiTimeoutException if request times out
  /// - ApiServerException if server returns error
  /// - ApiResponseException if response format is invalid
  static Future<Map<String, dynamic>> predictFromImage(File imageFile) async {
    try {
      // Create multipart file
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      // Send POST request
      final response = await _dio.post(
        predictEndpoint,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      // ✅ CHECKPOINT: Validate response status
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        // ✅ CHECKPOINT: Check for error in response
        if (data.containsKey('error')) {
          throw ApiResponseException(
            'Backend error: ${data['error']}',
          );
        }

        // ✅ CHECKPOINT: Validate response contains required fields
        if (!data.containsKey('cbc_values')) {
          throw ApiResponseException(
            'Response missing required field: cbc_values',
          );
        }
        if (!data.containsKey('predicted_class')) {
          throw ApiResponseException(
            'Response missing required field: predicted_class',
          );
        }
        if (!data.containsKey('confidence')) {
          throw ApiResponseException(
            'Response missing required field: confidence',
          );
        }

        // Return validated response
        return {
          'cbc_values': data['cbc_values'] as Map<String, dynamic>,
          'predicted_class': data['predicted_class'] as String,
          'confidence': (data['confidence'] as num).toDouble(),
        };
      } else {
        throw ApiServerException(
          'Server returned status code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      // ✅ CHECKPOINT: Handle all network error scenarios
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiTimeoutException(
          'Request timed out. Please check your connection and try again.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw ApiNetworkException(
          'Cannot connect to server. Please ensure backend is running.',
        );
      } else if (e.response != null) {
        // Handle HTTP error responses
        final responseData = e.response!.data;
        String errorMessage = 'Server error: ${e.response!.statusCode}';
        
        if (responseData is Map && responseData.containsKey('error')) {
          errorMessage = responseData['error'].toString();
        }
        
        throw ApiServerException(
          errorMessage,
          statusCode: e.response!.statusCode,
        );
      } else {
        throw ApiNetworkException(
          'Network error: ${e.message}',
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Unexpected error: $e');
    }
  }

  /// Test connection to Flask backend
  static Future<bool> testConnection() async {
    try {
      final response = await _dio.get(
        '/health',
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

// Custom Exception Classes for specific error handling

/// Base exception for API errors
class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  
  @override
  String toString() => message;
}

/// Thrown when request times out
class ApiTimeoutException extends ApiException {
  ApiTimeoutException(super.message);
}

/// Thrown when no internet connection
class ApiNetworkException extends ApiException {
  ApiNetworkException(super.message);
}

/// Thrown when server returns error status
class ApiServerException extends ApiException {
  final int? statusCode;
  ApiServerException(super.message, {this.statusCode});
  
  @override
  String toString() => statusCode != null 
    ? '$message (Status: $statusCode)'
    : message;
}

/// Thrown when response format is invalid
class ApiResponseException extends ApiException {
  ApiResponseException(super.message);
}
