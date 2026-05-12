import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../models/user.dart';

class AuthRemoteDataSource {
  final Dio _dio;

  // We receive Dio via constructor — never create it inside.
  // This is dependency injection.
  AuthRemoteDataSource(this._dio);

  Future<UserModel> register({
    required String fullname,
    required String username,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.register,
        data: {
          'fullname': fullname,
          'username': username,
          'email': email,
          'password': password,
          'role': role,
        },
      );

      // Your backend wraps everything in ApiResponse:
      // { statusCode, data: { ...user }, message, success }
      // So we always read response.data['data'] to get the actual payload
      return UserModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  // Login returns both the user AND tokens — we need both
  Future<({UserModel user, String accessToken, String refreshToken})> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      final data = response.data['data'] as Map<String, dynamic>;

      //check for referesh token returned in backemd or not.
      return (
        user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
        accessToken: data['accessToken'] as String,
        refreshToken: data['refreshToken'] as String,
      );
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post(ApiConstants.logout);
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}
