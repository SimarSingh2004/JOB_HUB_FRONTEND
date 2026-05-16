import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../models/job.dart';
// ignore: unused_import
import '../../data/jobs_repository.dart';
import 'jobs_viewmodel.dart';

class MyJobsState {
  final List<JobModel> jobs;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasNextPage;
  final int currentPage;
  final String? error;

  const MyJobsState({
    this.jobs = const [],
    this.isLoading = true,
    this.isLoadingMore = false,
    this.hasNextPage = false,
    this.currentPage = 1,
    this.error,
  });

  MyJobsState copyWith({
    List<JobModel>? jobs,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasNextPage,
    int? currentPage,
    String? error,
    bool clearError = false,
  }) {
    return MyJobsState(
      jobs: jobs ?? this.jobs,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      currentPage: currentPage ?? this.currentPage,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class MyJobsViewModel extends Notifier<MyJobsState> {
  @override
  MyJobsState build() {
    Future.microtask(() => _fetchFirstPage());
    return const MyJobsState(isLoading: true);
  }

  Future<void> refresh() => _fetchFirstPage();

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasNextPage) return;
    state = state.copyWith(isLoadingMore: true);
    await _fetchPage(state.currentPage + 1, append: true);
  }

  Future<void> _fetchFirstPage() async {
    state = state.copyWith(isLoading: true, clearError: true, jobs: []);
    await _fetchPage(1, append: false);
  }

  Future<void> _fetchPage(int page, {required bool append}) async {
    final repo = ref.read(jobsRepositoryProvider);
    try {
      final result = await repo.getMyJobs(page: page);
      state = state.copyWith(
        jobs: append ? [...state.jobs, ...result.jobs] : result.jobs,
        isLoading: false,
        isLoadingMore: false,
        hasNextPage: result.hasNextPage,
        currentPage: result.page,
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

final myJobsViewModelProvider = NotifierProvider<MyJobsViewModel, MyJobsState>(
  MyJobsViewModel.new,
);
