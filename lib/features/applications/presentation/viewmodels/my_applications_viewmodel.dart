import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/providers/core_providers.dart';
// ignore: unused_import
import '../../../../core/network/dio_client.dart';
import '../../../../models/application.dart';
import '../../data/applications_remote_datasource.dart';
import '../../data/applications_repository.dart';

class MyApplicationsState {
  final List<ApplicationModel> applications;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasNextPage;
  final int currentPage;
  final String? error;

  const MyApplicationsState({
    this.applications = const [],
    this.isLoading = true,
    this.isLoadingMore = false,
    this.hasNextPage = false,
    this.currentPage = 1,
    this.error,
  });

  MyApplicationsState copyWith({
    List<ApplicationModel>? applications,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasNextPage,
    int? currentPage,
    String? error,
    bool clearError = false,
  }) {
    return MyApplicationsState(
      applications: applications ?? this.applications,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      currentPage: currentPage ?? this.currentPage,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class MyApplicationsViewModel extends Notifier<MyApplicationsState> {
  @override
  MyApplicationsState build() {
    Future.microtask(() => _fetchFirstPage());
    return const MyApplicationsState(isLoading: true);
  }

  Future<void> refresh() => _fetchFirstPage();

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasNextPage) return;
    state = state.copyWith(isLoadingMore: true);
    await _fetchPage(state.currentPage + 1, append: true);
  }

  Future<void> _fetchFirstPage() async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      applications: [],
      currentPage: 1,
    );
    await _fetchPage(1, append: false);
  }

  Future<void> _fetchPage(int page, {required bool append}) async {
    final repo = ref.read(applicationsRepositoryProvider);
    try {
      final result = await repo.getMyApplications(page: page);
      final incoming = result['applications'] as List<ApplicationModel>;

      state = state.copyWith(
        applications: append ? [...state.applications, ...incoming] : incoming,
        isLoading: false,
        isLoadingMore: false,
        hasNextPage: result['hasNextPage'] as bool,
        currentPage: result['page'] as int,
        clearError: true,
      );
    } on AppException catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: e.message,
      );
    }
  }
}

// ---- Providers ----

final applicationsRemoteDataSourceProvider =
    Provider<ApplicationsRemoteDataSource>((ref) {
      final dio = ref.watch(dioClientProvider).dio;
      return ApplicationsRemoteDataSource(dio);
    });

final applicationsRepositoryProvider = Provider<ApplicationsRepository>((ref) {
  final remote = ref.watch(applicationsRemoteDataSourceProvider);
  return ApplicationsRepository(remote);
});

final myApplicationsViewModelProvider =
    NotifierProvider<MyApplicationsViewModel, MyApplicationsState>(
      MyApplicationsViewModel.new,
    );
