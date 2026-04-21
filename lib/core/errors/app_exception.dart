import 'package:dio/dio.dart';

class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException({required this.message, this.statusCode});

  factory AppException.fromDioError(DioException error) {
    try {
      final data = error.response?.data;
      if (data != null && data['message'] != null) {
        return AppException(
          message: data['message'] as String,
          statusCode: error.response?.statusCode,
        );
      }
    } catch (_) {}

    return const AppException(message: 'An unexpected error occurred');
  }

  @override
  String toString() {
    return message;
  }
}
