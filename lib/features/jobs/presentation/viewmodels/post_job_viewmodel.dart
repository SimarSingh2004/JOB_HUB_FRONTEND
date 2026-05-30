import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../models/job.dart';
import 'jobs_viewmodel.dart';
import 'my_jobs_viewmodel.dart';

class PostJobState {
  final bool isSaving;
  final bool isDeleting;
  final String? error;
  final bool success;
  final JobModel? savedJob; // returned after create/update

  const PostJobState({
    this.isSaving = false,
    this.isDeleting = false,
    this.error,
    this.success = false,
    this.savedJob,
  });

  PostJobState copyWith({
    bool? isSaving,
    bool? isDeleting,
    String? error,
    bool? success,
    JobModel? savedJob,
    bool clearError = false,
  }) {
    return PostJobState(
      isSaving: isSaving ?? this.isSaving,
      isDeleting: isDeleting ?? this.isDeleting,
      error: clearError ? null : error ?? this.error,
      success: success ?? this.success,
      savedJob: savedJob ?? this.savedJob,
    );
  }
}

class PostJobViewModel extends Notifier<PostJobState> {
  @override
  PostJobState build() => const PostJobState();

  Future<void> createJob({
    required String title,
    required String description,
    required List<String> skillsRequired,
    double? salary,
    String? location,
  }) async {
    state = state.copyWith(isSaving: true, clearError: true);
    final repo = ref.read(jobsRepositoryProvider);

    try {
      final job = await repo.createJob(
        title: title,
        description: description,
        skillsRequired: skillsRequired,
        salary: salary,
        location: location,
      );

      // Invalidate myJobs so the list refreshes automatically
      // when user navigates back to RecruiterHome
      ref.invalidate(myJobsViewModelProvider);

      state = state.copyWith(isSaving: false, success: true, savedJob: job);
    } on AppException catch (e) {
      state = state.copyWith(isSaving: false, error: e.message);
    }
  }

  Future<void> updateJob({
    required String jobId,
    required Map<String, dynamic> data,
  }) async {
    state = state.copyWith(isSaving: true, clearError: true);
    final repo = ref.read(jobsRepositoryProvider);

    try {
      final job = await repo.updateJob(jobId: jobId, data: data);

      // Invalidate both lists so they both refresh
      ref.invalidate(myJobsViewModelProvider);
      ref.invalidate(jobsViewModelProvider);

      state = state.copyWith(isSaving: false, success: true, savedJob: job);
    } on AppException catch (e) {
      state = state.copyWith(isSaving: false, error: e.message);
    }
  }

  Future<bool> deleteJob(String jobId) async {
    state = state.copyWith(isDeleting: true, clearError: true);
    final repo = ref.read(jobsRepositoryProvider);

    try {
      await repo.deleteJob(jobId);

      // Invalidate so RecruiterHome refreshes
      ref.invalidate(myJobsViewModelProvider);

      state = state.copyWith(isDeleting: false, success: true);
      return true;
    } on AppException catch (e) {
      state = state.copyWith(isDeleting: false, error: e.message);
      return false;
    }
  }
}

final postJobViewModelProvider =
    NotifierProvider<PostJobViewModel, PostJobState>(PostJobViewModel.new);
