import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../models/job.dart';
import '../../data/jobs_filter.dart';
import '../../data/jobs_remote_datasource.dart';
import '../../data/jobs_repository.dart';

// The complete state for the jobs list screen.
// Notice we track TWO loading states:
// - isLoading: true when fetching the FIRST page (show full screen spinner)
// - isLoadingMore: true when fetching NEXT pages (show bottom spinner)
// This gives better UX — the list stays visible while loading more
class JobsState {
  final List<JobModel> jobs;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasNextPage;
  final int currentPage;
  final JobsFilter filter;
  final String? error;

  const JobsState({
    this.jobs = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasNextPage = false,
    this.currentPage = 1,
    this.filter = const JobsFilter(), // default empty filter
    this.error,
  });

  JobsState copyWith({
    List<JobModel>? jobs,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasNextPage,
    int? currentPage,
    JobsFilter? filter,
    String? error,
    bool clearError = false,
  }) {
    return JobsState(
      jobs: jobs ?? this.jobs,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      currentPage: currentPage ?? this.currentPage,
      filter: filter ?? this.filter,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class JobsViewModel extends Notifier<JobsState> {
  // Timer for debouncing search input
  Timer? _searchDebounce;

  @override
  JobsState build() {
    // Fetch first page immediately when this ViewModel is first read
    // We use Future.microtask to avoid calling async code during build
    Future.microtask(() => _fetchFirstPage());

    // Clean up debounce timer when provider is disposed
    ref.onDispose(
      () => _searchDebounce?.cancel(),
    ); // kill debounce timer on provider dispose

    return const JobsState(isLoading: true);
  }

  // Called when user types in search box
  // Debounced — waits 500ms after last keystroke before fetching
  void onSearchChanged(String query) {
    _searchDebounce
        ?.cancel(); // cancel previous timer if still active , when user types again before 500ms
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      final newFilter = state.filter.copyWith(
        search: query,
      ); // create new filter with updated search query
      // Only fetch if filter actually changed
      if (newFilter != state.filter) {
        state = state.copyWith(
          filter: newFilter,
        ); // update state with new filter
        _fetchFirstPage();
      }
    });
  }

  // Called when user applies filters from the filter bottom sheet
  void applyFilter(JobsFilter newFilter) {
    state = state.copyWith(filter: newFilter);
    _fetchFirstPage();
  }

  // Reset all filters and reload
  void clearFilters() {
    state = state.copyWith(filter: const JobsFilter());
    _fetchFirstPage();
  }

  // Called when user scrolls to end of list
  // Guard: don't load more if already loading or no more pages
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasNextPage) return;

    state = state.copyWith(isLoadingMore: true);
    await _fetchPage(state.currentPage + 1, append: true);
  }

  // Refresh — pull to refresh gesture
  Future<void> refresh() async {
    _fetchFirstPage();
  }

  // Private: fetch page 1, replacing the entire list
  Future<void> _fetchFirstPage() async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      jobs: [], // clear existing list
      currentPage: 1,
    );
    await _fetchPage(1, append: false);
  }

  // Private: core fetch logic
  // append=false → replace list (first page / filter change)
  // append=true  → add to list (load more)
  Future<void> _fetchPage(int page, {required bool append}) async {
    final repo = ref.read(jobsRepositoryProvider);

    try {
      final result = await repo.getJobs(page: page, filter: state.filter);

      state = state.copyWith(
        // If appending, combine old list with new results
        // If replacing, just use new results
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

// ---- Providers ----

final jobsRemoteDataSourceProvider = Provider<JobsRemoteDataSource>((ref) {
  final dio = ref.watch(dioClientProvider).dio;
  return JobsRemoteDataSource(dio);
});

final jobsRepositoryProvider = Provider<JobsRepository>((ref) {
  final remote = ref.watch(jobsRemoteDataSourceProvider);
  return JobsRepository(remote);
});

// NotifierProvider (not Async) because we manage async manually
// inside the ViewModel for fine-grained loading states
final jobsViewModelProvider = NotifierProvider<JobsViewModel, JobsState>(
  JobsViewModel.new,
);
