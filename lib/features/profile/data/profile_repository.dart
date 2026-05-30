import '../../../models/candidate_profile.dart';
import '../../../models/recruiter_profile.dart';
import 'profile_remote_datasource.dart';

class ProfileRepository {
  final ProfileRemoteDataSource _remote;

  ProfileRepository(this._remote);

  Future<Map<String, dynamic>> getMyProfile() {
    return _remote.getMyProfile();
  }

  Future<CandidateProfileModel> createCandidateProfile(
    Map<String, dynamic> data,
  ) {
    return _remote.createCandidateProfile(data);
  }

  Future<RecruiterProfileModel> createRecruiterProfile(
    Map<String, dynamic> data,
  ) {
    return _remote.createRecruiterProfile(data);
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) {
    return _remote.updateProfile(data);
  }
}
