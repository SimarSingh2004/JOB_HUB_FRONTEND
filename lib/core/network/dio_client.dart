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

  // Concurrent requests that all 401 at once (e.g. profile + jobs +
  // applications loading together) used to only let ONE of them trigger
  // a refresh — the others saw _isRefreshing == true and just failed
  // immediately instead of waiting. That's what caused "Invalid Access
  // token" to surface randomly on some requests but not others, since
  // whichever request lost the race never got retried.
  // A shared Future fixes this: every 401 either starts the refresh or
  // awaits the one already in flight, and all of them retry once it
  // resolves.
  Future<String?>? _refreshFuture;

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
    if (err.response?.statusCode == 401) {
      try {
        // Either starts a new refresh, or — if one is already running
        // because another request 401'd moments earlier — just awaits it.
        _refreshFuture ??= _refreshAccessToken();
        final newAccessToken = await _refreshFuture;

        if (newAccessToken == null) {
          await _secureStorage.clearAll();
          return handler.next(err);
        }

        // Retry the original failed request with the new token
        final retryOptions = err.requestOptions;
        retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';

        try {
          final retryResponse = await _dio.fetch(retryOptions);
          return handler.resolve(retryResponse);
        } on DioException catch (retryError) {
          // The retry reached the server and got its OWN real response —
          // e.g. a legitimate 400 "already applied to this job". This is
          // NOT a refresh failure: forward this real error to the caller
          // as-is, and don't wipe the session over a normal business-logic
          // rejection. (Previously this fell into the catch below, which
          // discarded this error, forwarded the stale original 401 instead,
          // and logged the user out — so the real message never reached
          // the UI even though the backend had returned it correctly.)
          return handler.next(retryError);
        }
      } catch (e) {
        // Only the refresh call itself (or getting a token to retry with)
        // failing lands here now — this is the actual "must log in again"
        // case.
        await _secureStorage.clearAll();
        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  Future<String?> _refreshAccessToken() async {
    try {
      final refreshToken = await _secureStorage.getRefreshToken();
      if (refreshToken == null) return null;

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

      await _secureStorage.saveTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
      );

      return newAccessToken;
    } catch (e) {
      return null;
    } finally {
      // Clear it once this refresh attempt is done (success or failure)
      // so the NEXT unrelated 401, later on, starts a fresh refresh
      // instead of reusing this already-resolved one.
      _refreshFuture = null;
    }
  }
}
