import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../models/application.dart';
// ignore: unused_import
import '../../data/applications_repository.dart';
import 'my_applications_viewmodel.dart';

class ApplicantsState {
  final List<ApplicationModel> applicants;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasNextPage;
  final int currentPage;
  final String? error;
  // Tracks which application is currently being updated
  // so we can show a per-card loading indicator
  final String? updatingApplicationId;

  const ApplicantsState({
    this.applicants = const [],
    this.isLoading = true,
    this.isLoadingMore = false,
    this.hasNextPage = false,
    this.currentPage = 1,
    this.error,
    this.updatingApplicationId,
  });

  ApplicantsState copyWith({
    List<ApplicationModel>? applicants,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasNextPage,
    int? currentPage,
    String? error,
    String? updatingApplicationId,
    bool clearError = false,
    bool clearUpdating = false,
  }) {
    return ApplicantsState(
      applicants: applicants ?? this.applicants,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      currentPage: currentPage ?? this.currentPage,
      error: clearError ? null : error ?? this.error,
      updatingApplicationId: clearUpdating
          ? null
          : updatingApplicationId ?? this.updatingApplicationId,
    );
  }
}

class ApplicantsViewModel
    extends AutoDisposeFamilyNotifier<ApplicantsState, String> {
  // FamilyNotifier — jobId is the parameter
  // One ViewModel instance per job's applicants list

  @override
  ApplicantsState build(String jobId) {
    Future.microtask(() => _fetchFirstPage(jobId));
    return const ApplicantsState(isLoading: true);
  }

  Future<void> refresh(String jobId) => _fetchFirstPage(jobId);

  Future<void> loadMore(String jobId) async {
    if (state.isLoadingMore || !state.hasNextPage) return;
    state = state.copyWith(isLoadingMore: true);
    await _fetchPage(jobId, state.currentPage + 1, append: true);
  }

  // Update application status with optimistic UI.
  // Steps:
  // 1. Save the old status in case we need to roll back
  // 2. Update the card in the list immediately (optimistic)
  // 3. Call the API
  // 4. If API succeeds → confirm (state already updated)
  // 5. If API fails → roll back to old status + show error
  Future<void> updateStatus({
    required String applicationId,
    required String newStatus,
  }) async {
    final repo = ref.read(applicationsRepositoryProvider);

    // Find the application we're updating
    final index = state.applicants.indexWhere((a) => a.id == applicationId);
    if (index == -1) return;

    // Save old status for rollback
    final oldStatus = state.applicants[index].status;

    // Step 1: Mark this card as updating
    state = state.copyWith(updatingApplicationId: applicationId);

    // Step 2: Optimistic update — change status in list immediately
    final updatedList = [...state.applicants];
    updatedList[index] = updatedList[index].copyWith(status: newStatus);
    state = state.copyWith(applicants: updatedList, clearUpdating: true);

    // Step 3: Call API
    try {
      await repo.updateStatus(applicationId: applicationId, status: newStatus);
      // API confirmed — nothing more to do, state is already correct
    } on AppException catch (e) {
      // Step 5: Roll back on failure
      final rolledBack = [...state.applicants];
      rolledBack[index] = rolledBack[index].copyWith(status: oldStatus);
      state = state.copyWith(
        applicants: rolledBack,
        error: e.message,
        clearUpdating: true,
      );
    }
  }

  Future<void> _fetchFirstPage(String jobId) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      applicants: [],
      currentPage: 1,
    );
    await _fetchPage(jobId, 1, append: false);
  }

  Future<void> _fetchPage(
    String jobId,
    int page, {
    required bool append,
  }) async {
    final repo = ref.read(applicationsRepositoryProvider);
    try {
      final result = await repo.getApplicantsForJob(jobId: jobId, page: page);
      final incoming = result['applications'] as List<ApplicationModel>;

      state = state.copyWith(
        applicants: append ? [...state.applicants, ...incoming] : incoming,
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
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }
}

final applicantsViewModelProvider = NotifierProvider.autoDispose
    .family<ApplicantsViewModel, ApplicantsState, String>(
      ApplicantsViewModel.new,
    );
