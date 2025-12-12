import 'package:dio/dio.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/api.dart';
import 'package:get/get.dart' as getx;
import 'dart:developer' as developer;

class ApiService {
  static final ApiService _instance = ApiService._internal();
  late Dio _dio;

  factory ApiService() {
    return _instance;
  }

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: DefaultApi.apiUrl,
        connectTimeout: 30000, // 30 seconds
        receiveTimeout: 30000, // 30 seconds
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Log request
          developer.log('📤 REQUEST[${options.method}] => PATH: ${options.path}');
          developer.log('📤 Data: ${options.data}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Log response
          developer.log('📥 RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          developer.log('📥 Data: ${response.data}');
          return handler.next(response);
        },
        onError: (DioError e, handler) {
          // Log error
          developer.log('❌ ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
          developer.log('❌ Message: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;

  // POST request with better error handling
  Future<Response?> post(
    String endpoint,
    Map<String, dynamic> data, {
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        options: options,
      );
      return response;
    } on DioError catch (e) {
      return _handleError(e);
    }
  }

  // POST request with FormData (for file uploads)
  Future<Response?> postFormData(
    String endpoint,
    FormData formData, {
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: formData,
        options: options,
      );
      return response;
    } on DioError catch (e) {
      return _handleError(e);
    }
  }

  // GET request with better error handling
  Future<Response?> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioError catch (e) {
      return _handleError(e);
    }
  }

  // Centralized error handling
  Response? _handleError(DioError error) {
    String errorMessage = 'str_something_wrong'.tr;

    switch (error.type) {
      case DioErrorType.connectTimeout:
        errorMessage = 'Connection timeout. Please check your internet connection.';
        break;
      case DioErrorType.sendTimeout:
        errorMessage = 'Send timeout. Please try again.';
        break;
      case DioErrorType.receiveTimeout:
        errorMessage = 'Receive timeout. Please try again.';
        break;
      case DioErrorType.response:
        errorMessage = _getErrorMessageFromResponse(error.response);
        break;
      case DioErrorType.cancel:
        errorMessage = 'Request was cancelled.';
        break;
      case DioErrorType.other:
        if (error.message.contains('SocketException')) {
          errorMessage = 'No internet connection. Please check your network.';
        } else {
          errorMessage = 'An unexpected error occurred. Please try again.';
        }
        break;
    }

    developer.log('🔴 Error: $errorMessage');

    // Return error response for UI handling
    return Response(
      requestOptions: error.requestOptions,
      statusCode: error.response?.statusCode ?? 500,
      data: {
        'status': '0',
        'message': errorMessage,
      },
    );
  }

  // Extract error message from response
  String _getErrorMessageFromResponse(Response? response) {
    if (response == null) return 'Server error occurred.';

    try {
      final data = response.data;

      // Check if response has a message field
      if (data is Map<String, dynamic> && data.containsKey('message')) {
        return data['message'].toString();
      }

      // Handle different status codes
      switch (response.statusCode) {
        case 400:
          return 'Bad request. Please check your input.';
        case 401:
          return 'Unauthorized. Please login again.';
        case 403:
          return 'Access forbidden.';
        case 404:
          return 'Resource not found.';
        case 500:
          return 'Server error. Please try again later.';
        case 502:
          return 'Bad gateway. Server is unavailable.';
        case 503:
          return 'Service unavailable. Please try again later.';
        default:
          return 'An error occurred (${response.statusCode}).';
      }
    } catch (e) {
      return 'An error occurred while processing the response.';
    }
  }

  // Clear cache
  void clearCache() {
    _dio.options.extra.clear();
  }

  // Update headers (e.g., for authentication token)
  void updateHeaders(Map<String, dynamic> headers) {
    _dio.options.headers.addAll(headers);
  }
}
