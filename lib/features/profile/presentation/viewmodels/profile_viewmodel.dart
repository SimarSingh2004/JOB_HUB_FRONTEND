import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/app_exception.dart';
// ignore: unused_import
import '../../../../core/network/dio_client.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../models/candidate_profile.dart';
import '../../../../models/recruiter_profile.dart';
import '../../data/profile_remote_datasource.dart';
import '../../data/profile_repository.dart';

// Profile can be one of three states:
// 1. Not yet loaded
// 2. Loaded as candidate profile
// 3. Loaded as recruiter profile
// We use a sealed-class-like pattern with a type discriminator
class ProfileState {
  final CandidateProfileModel? candidateProfile;
  final RecruiterProfileModel? recruiterProfile;
  final bool isLoading;
  final bool isSaving; // separate flag for save button spinner
  final bool profileExists; // false = show create form, true = show edit
  final bool loadFailed; // true = a real error occurred loading the profile
  // (NOT the same as profileExists:false / 404 —
  // this must NOT fall through to the create form)
  final String? error;
  final String? saveError;
  final bool saveSuccess;

  const ProfileState({
    this.candidateProfile,
    this.recruiterProfile,
    this.isLoading = true,
    this.isSaving = false,
    this.profileExists = false,
    this.loadFailed = false,
    this.error,
    this.saveError,
    this.saveSuccess = false,
  });

  // Convenience getters
  bool get isCandidate => candidateProfile != null;
  bool get isRecruiter => recruiterProfile != null;

  ProfileState copyWith({
    CandidateProfileModel? candidateProfile,
    RecruiterProfileModel? recruiterProfile,
    bool? isLoading,
    bool? isSaving,
    bool? profileExists,
    bool? loadFailed,
    String? error,
    String? saveError,
    bool? saveSuccess,
    bool clearError = false,
    bool clearSaveError = false,
  }) {
    return ProfileState(
      candidateProfile: candidateProfile ?? this.candidateProfile,
      recruiterProfile: recruiterProfile ?? this.recruiterProfile,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      profileExists: profileExists ?? this.profileExists,
      loadFailed: loadFailed ?? this.loadFailed,
      error: clearError ? null : error ?? this.error,
      saveError: clearSaveError ? null : saveError ?? this.saveError,
      saveSuccess: saveSuccess ?? this.saveSuccess,
    );
  }
}

class ProfileViewModel extends AutoDisposeAsyncNotifier<ProfileState> {
  @override
  Future<ProfileState> build() async {
    return _loadProfile();
  }

  Future<ProfileState> _loadProfile() async {
    final repo = ref.read(profileRepositoryProvider);
    try {
      final data = await repo.getMyProfile();

      // Determine profile type from the data shape.
      // Candidate profiles have 'skills', recruiter profiles have 'companyName'
      if (data.containsKey('companyName')) {
        return ProfileState(
          recruiterProfile: RecruiterProfileModel.fromJson(data),
          isLoading: false,
          profileExists: true,
        );
      } else {
        return ProfileState(
          candidateProfile: CandidateProfileModel.fromJson(data),
          isLoading: false,
          profileExists: true,
        );
      }
    } on AppException catch (e) {
      // 404 means profile doesn't exist yet — show create form
      if (e.statusCode == 404) {
        return const ProfileState(isLoading: false, profileExists: false);
      }
      // Any other error (401, 500, network, etc.) is a real failure —
      // must NOT be treated the same as "no profile yet", or the app
      // silently loops you back into the create form every time.
      return ProfileState(isLoading: false, loadFailed: true, error: e.message);
    } catch (e) {
      return ProfileState(
        isLoading: false,
        loadFailed: true,
        error: e.toString(),
      );
    }
  }

  // Called by candidate profile form on first-time save
  Future<void> createCandidateProfile(Map<String, dynamic> data) async {
    final current = state.value;
    if (current == null) return;

    state = AsyncData(current.copyWith(isSaving: true, clearSaveError: true));
    final repo = ref.read(profileRepositoryProvider);

    try {
      final profile = await repo.createCandidateProfile(data);
      state = AsyncData(
        ProfileState(
          candidateProfile: profile,
          isLoading: false,
          profileExists: true,
          saveSuccess: true,
        ),
      );
    } on AppException catch (e) {
      state = AsyncData(
        current.copyWith(isSaving: false, saveError: e.message),
      );
    } catch (e) {
      state = AsyncData(
        current.copyWith(isSaving: false, saveError: e.toString()),
      );
    }
  }

  // Called by recruiter profile form on first-time save
  Future<void> createRecruiterProfile(Map<String, dynamic> data) async {
    final current = state.value;
    if (current == null) return;

    state = AsyncData(current.copyWith(isSaving: true, clearSaveError: true));
    final repo = ref.read(profileRepositoryProvider);

    try {
      final profile = await repo.createRecruiterProfile(data);
      state = AsyncData(
        ProfileState(
          recruiterProfile: profile,
          isLoading: false,
          profileExists: true,
          saveSuccess: true,
        ),
      );
    } on AppException catch (e) {
      state = AsyncData(
        current.copyWith(isSaving: false, saveError: e.message),
      );
    } catch (e) {
      state = AsyncData(
        current.copyWith(isSaving: false, saveError: e.toString()),
      );
    }
  }

  // Called on subsequent edits for both roles
  Future<void> updateProfile(Map<String, dynamic> data) async {
    final current = state.value;
    if (current == null) return;

    state = AsyncData(current.copyWith(isSaving: true, clearSaveError: true));
    final repo = ref.read(profileRepositoryProvider);

    try {
      final updated = await repo.updateProfile(data);

      // Re-parse updated profile from response
      if (updated.containsKey('companyName')) {
        state = AsyncData(
          current.copyWith(
            recruiterProfile: RecruiterProfileModel.fromJson(updated),
            isSaving: false,
            saveSuccess: true,
          ),
        );
      } else {
        state = AsyncData(
          current.copyWith(
            candidateProfile: CandidateProfileModel.fromJson(updated),
            isSaving: false,
            saveSuccess: true,
          ),
        );
      }
    } on AppException catch (e) {
      state = AsyncData(
        current.copyWith(isSaving: false, saveError: e.message),
      );
    } catch (e) {
      state = AsyncData(
        current.copyWith(isSaving: false, saveError: e.toString()),
      );
    }
  }

  // Unified save — ViewModel decides create vs update
  // The View just calls save() — no if/else needed in UI
  Future<void> save({
    required String role,
    required Map<String, dynamic> data,
  }) async {
    final current = state.value;
    if (current == null) return;

    if (!current.profileExists) {
      // First time — create
      if (role == 'candidate') {
        await createCandidateProfile(data);
      } else {
        await createRecruiterProfile(data);
      }
    } else {
      // Already exists — update
      await updateProfile(data);
    }
  }

  void clearSaveSuccess() {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(saveSuccess: false));
  }
}

// ---- Providers ----

final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((
  ref,
) {
  final dio = ref.watch(dioClientProvider).dio;
  return ProfileRemoteDataSource(dio);
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final remote = ref.watch(profileRemoteDataSourceProvider);
  return ProfileRepository(remote);
});

final profileViewModelProvider =
    AsyncNotifierProvider.autoDispose<ProfileViewModel, ProfileState>(
      ProfileViewModel.new,
    );
