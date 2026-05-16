import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../models/job.dart';
// ignore: unused_import
import '../../data/jobs_repository.dart';
import 'jobs_viewmodel.dart';

class JobDetailState {
  final JobModel? job;
  final bool isLoading;
  final bool isApplying; // separate loading for apply button
  final String? error;
  final String? applyError;
  final bool applySuccess; // shows success message after applying

  const JobDetailState({
    this.job,
    this.isLoading = true,
    this.isApplying = false,
    this.error,
    this.applyError,
    this.applySuccess = false,
  });

  JobDetailState copyWith({
    JobModel? job,
    bool? isLoading,
    bool? isApplying,
    String? error,
    String? applyError,
    bool? applySuccess,
    bool clearApplyError = false,
  }) {
    return JobDetailState(
      job: job ?? this.job,
      isLoading: isLoading ?? this.isLoading,
      isApplying: isApplying ?? this.isApplying,
      error: error ?? this.error,
      applyError: clearApplyError ? null : applyError ?? this.applyError,
      applySuccess: applySuccess ?? this.applySuccess,
    );
  }
}

class JobDetailViewModel extends FamilyNotifier<JobDetailState, String> {
  // FamilyNotifier takes a parameter — here it's the jobId.
  // This lets us create one ViewModel instance per job,
  // identified by its ID. Like a parameterized provider.

  @override
  JobDetailState build(String jobId) {
    Future.microtask(() => _fetchJob(jobId));
    return const JobDetailState(isLoading: true);
  }

  Future<void> _fetchJob(String jobId) async {
    final repo = ref.read(jobsRepositoryProvider);
    try {
      final job = await repo.getJobById(jobId);
      state = state.copyWith(job: job, isLoading: false);
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    }
  }

  Future<void> applyToJob() async {
    if (state.job == null) return;

    state = state.copyWith(isApplying: true, clearApplyError: true);
    final repo = ref.read(jobsRepositoryProvider);

    try {
      await repo.applyToJob(state.job!.id);
      state = state.copyWith(isApplying: false, applySuccess: true);
    } on AppException catch (e) {
      state = state.copyWith(isApplying: false, applyError: e.message);
    }
  }
}

// Family provider — takes a jobId argument
// Usage: ref.watch(jobDetailViewModelProvider('someJobId'))
final jobDetailViewModelProvider =
    NotifierProviderFamily<JobDetailViewModel, JobDetailState, String>(
      JobDetailViewModel.new,
    );
