import '../../../core/storage/secure_storage.dart';
import '../../../models/user.dart';
import 'auth_remote_datasource.dart';

// The repository sits between the ViewModel and the data source.
// Its job: coordinate between remote (API) and local (storage).

class AuthRepository {
  final AuthRemoteDataSource _remote;
  final SecureStorage _storage;

  AuthRepository(this._remote, this._storage);

  Future<UserModel> register({
    required String fullname,
    required String username,
    required String email,
    required String password,
    required String role,
  }) async {
    // Register doesn't return tokens — just the user.
    // The ViewModel will trigger login after successful register.
    return _remote.register(
      fullname: fullname,
      username: username,
      email: email,
      password: password,
      role: role,
    );
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final result = await _remote.login(email: email, password: password);

    // After successful login, persist tokens and user meta locally.

    await _storage.saveTokens(
      accessToken: result.accessToken,
      refreshToken: result.refreshToken,
    );

    await _storage.saveUserMeta(role: result.user.role, userId: result.user.id);

    return result.user;
  }

  Future<void> logout() async {
    try {
      // Tell the backend to clear the refreshToken in DB
      await _remote.logout();
    } finally {
      // Clear everything stored locally
      await _storage.clearAll();
    }
  }

  // Called on app start — checks if user is already logged in
  Future<({String? role, String? userId})> getStoredAuth() async {
    final role = await _storage.getUserRole();
    final userId = await _storage.getUserId();
    return (role: role, userId: userId);
  }
}
