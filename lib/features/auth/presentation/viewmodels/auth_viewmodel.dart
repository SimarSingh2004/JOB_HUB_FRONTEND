// ignore_for_file: unused_import

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../models/user.dart';
import '../../data/auth_remote_datasource.dart';
import '../../data/auth_repository.dart';

// AuthState holds everything the UI needs to know about the current user.

class AuthState {
  final UserModel? user; // null = not logged in
  final bool isLoading;
  final String? error;

  const AuthState({this.user, this.isLoading = false, this.error});

  // Are we logged in? Simple derived property.
  bool get isAuthenticated => user != null;

  // copyWith — create a new state with one field changed.

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool clearUser = false, // explicit flag to set user to null
    bool clearError = false, // explicit flag to clear error
  }) {
    return AuthState(
      user: clearUser ? null : user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }
}

// AsyncNotifier<AuthState> means:
// - this notifier manages an AuthState value
// - it has a build() method that runs on first access (like initState)
// - state is wrapped in AsyncValue automatically
class AuthViewModel extends AsyncNotifier<AuthState> {
  // build() is called once when this notifier is first read.
  // This is where we check if the user is already logged in.
  // It's async because reading from SecureStorage is async.
  @override
  Future<AuthState> build() async {
    final repo = ref.read(authRepositoryProvider);
    final stored = await repo.getStoredAuth();

    // print('AUTH BUILD: role=${stored.role}, userId=${stored.userId}');

    if (stored.role != null && stored.userId != null) {
      //  print('AUTH BUILD: returning authenticated state');

      return AuthState(
        user: UserModel(
          id: stored.userId!,
          fullname: '',
          username: '',
          email: '',
          role: stored.role!,
          avatar: '',
        ),
      );
    }

    // No stored credentials — user needs to log in
    // print('AUTH BUILD: returning unauthenticated state');

    return const AuthState();
  }

  Future<void> login({required String email, required String password}) async {
    final repo = ref.read(authRepositoryProvider);
    print('LOGIN: starting, email=$email');

    // Set loading state — keeps current user data, clears error, sets loading
    state = AsyncData(state.value!.copyWith(isLoading: true, clearError: true));
    print('LOGIN: state set to loading');

    try {
      final user = await repo.login(email: email, password: password);
      print('LOGIN: success, user=${user.id}, role=${user.role}');

      // Success — store user, clear loading
      state = AsyncData(AuthState(user: user));
    } on AppException catch (e) {
      print('LOGIN: AppException caught: ${e.message}');

      // Failure — clear loading, set error message
      state = AsyncData(
        state.value!.copyWith(isLoading: false, error: e.message),
      );
    } catch (e) {
      // This catches anything that isn't AppException
      print('LOGIN: unknown error caught: $e');
      state = AsyncData(
        state.value!.copyWith(isLoading: false, error: e.toString()),
      );
    }
  }

  Future<void> register({
    required String fullname,
    required String username,
    required String email,
    required String password,
    required String role,
  }) async {
    final repo = ref.read(authRepositoryProvider);

    state = AsyncData(state.value!.copyWith(isLoading: true, clearError: true));

    try {
      // Register first
      await repo.register(
        fullname: fullname,
        username: username,
        email: email,
        password: password,
        role: role,
      );

      // Auto-login after successful registration
      // No need to show register success then redirect to login —
      // better UX to just log them in immediately
      await login(email: email, password: password);
    } on AppException catch (e) {
      state = AsyncData(
        state.value!.copyWith(isLoading: false, error: e.message),
      );
    }
  }

  Future<void> logout() async {
    final repo = ref.read(authRepositoryProvider);

    state = AsyncData(state.value!.copyWith(isLoading: true));

    try {
      await repo.logout();
    } catch (_) {
      // Even if the API call fails, clear local storage and log out.
      // The user should never be stuck logged in due to a network error.
    }

    // Always clear state regardless of API result
    state = const AsyncData(AuthState());
  }

  void clearError() {
    if (state.value != null) {
      state = AsyncData(state.value!.copyWith(clearError: true));
    }
  }
}

// ---- Providers ----
// These wire everything together. Read top to bottom:
// dioClientProvider (Phase 1) → AuthRemoteDataSource → AuthRepository → AuthViewModel

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  // Get the Dio instance from the core provider we made in Phase 1
  final dio = ref.watch(dioClientProvider).dio;
  return AuthRemoteDataSource(dio);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remote = ref.watch(authRemoteDataSourceProvider);
  final storage = ref.watch(secureStorageProvider);
  return AuthRepository(remote, storage);
});

// AsyncNotifierProvider — the right provider type for AsyncNotifier
final authViewModelProvider = AsyncNotifierProvider<AuthViewModel, AuthState>(
  AuthViewModel.new,
);
