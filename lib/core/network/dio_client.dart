import 'package:dio/dio.dart';
// ignore: unused_import
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_constants.dart';
import '../storage/secure_storage.dart';

// This is your Dio client — the Flutter equivalent of your axios/fetch setup
// in Node. Every API call in the app goes through this one instance.
class DioClient {
  late final Dio _dio;
  final SecureStorage _secureStorage;

  DioClient(this._secureStorage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add our interceptor — this is the key piece
    _dio.interceptors.add(_AuthInterceptor(_secureStorage, _dio));
  }

  // Expose the dio instance for making calls
  Dio get dio => _dio;
}

// The interceptor — think of this like your verifyJWT middleware in Express.
// Except instead of verifying on the SERVER, this ATTACHES the token
// on the CLIENT before every outgoing request.
class _AuthInterceptor extends Interceptor {
  final SecureStorage _secureStorage;
  final Dio _dio;

  // This flag prevents infinite retry loops
  bool _isRefreshing = false;

  _AuthInterceptor(this._secureStorage, this._dio);

  // Called BEFORE every request goes out
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.getAccessToken();

    // If we have a token, attach it as Bearer — same format your
    // auth.middleware.js reads: req.header("Authorization")?.replace("Bearer ", "")
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Continue with the request
    return handler.next(options);
  }

  // Called when a response comes back with an ERROR status code
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // 401 = token expired or invalid
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;

      try {
        // Try to get a new access token using the refresh token
        final refreshToken = await _secureStorage.getRefreshToken();

        if (refreshToken == null) {
          // No refresh token means user needs to log in again
          await _secureStorage.clearAll();
          return handler.next(err);
        }

        // Call your /auth/refresh-token endpoint
        // We use a NEW Dio instance here — not _dio — to avoid
        // triggering this interceptor again (infinite loop prevention)
        final refreshDio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

        final response = await refreshDio.post(
          ApiConstants.refreshToken,
          data: {'refreshToken': refreshToken},
        );

        // Your backend returns { data: { accessToken } }
        final newAccessToken = response.data['data']['accessToken'] as String;

        final newRefreshToken =
            response.data['data']['refreshToken'] as String? ?? refreshToken;

        // Save the new token
        await _secureStorage.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );

        // Retry the original failed request with the new token
        final retryOptions = err.requestOptions;
        retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';

        final retryResponse = await _dio.fetch(retryOptions);
        return handler.resolve(retryResponse);
      } catch (e) {
        // Refresh also failed — user must log in again
        await _secureStorage.clearAll();
        return handler.next(err);
      } finally {
        _isRefreshing = false;
      }
    }

    return handler.next(err);
  }
}
