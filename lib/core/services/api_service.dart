import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';

class ApiService {
  static final Map<String, String> _headers = ApiConstants.headers;

  static Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConstants.baseUrl}$endpoint'),
            headers: _headers,
          )
          .timeout(ApiConstants.timeoutDuration);

      return _handleResponse(response);
    } on TimeoutException {
      throw ApiException(
          'Request timed out. The backend service may be starting up, please try again in a moment.');
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw ApiException(
            'Request timed out. The backend service may be starting up, please try again in a moment.');
      }
      throw ApiException('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConstants.baseUrl}$endpoint'),
            headers: _headers,
            body: json.encode(data),
          )
          .timeout(ApiConstants.timeoutDuration);

      return _handleResponse(response);
    } on TimeoutException {
      throw ApiException(
          'Request timed out. The backend service may be starting up, please try again in a moment.');
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw ApiException(
            'Request timed out. The backend service may be starting up, please try again in a moment.');
      }
      throw ApiException('Network error: $e');
    }
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final data = json.decode(response.body);

      switch (response.statusCode) {
        case 200:
          return data;
        case 404:
          throw ApiException('Repository not found');
        case 422:
          throw ApiException('Invalid request format');
        case 500:
          throw ApiException('Server error. Please try again later.');
        case 503:
          throw ApiException(
              'AI service temporarily unavailable. The service may be starting up, please try again in a moment.');
        case 502:
          throw ApiException(
              'Backend service unavailable. Please try again later.');
        default:
          throw ApiException('Unexpected error: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Failed to parse response: $e');
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}
