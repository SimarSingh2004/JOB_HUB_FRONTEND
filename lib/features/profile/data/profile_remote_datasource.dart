import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../models/candidate_profile.dart';
import '../../../models/recruiter_profile.dart';

class ProfileRemoteDataSource {
  final Dio _dio;

  ProfileRemoteDataSource(this._dio);

  // GET /profile/me — returns candidate or recruiter profile
  // based on the logged-in user's role (backend reads from JWT)
  // Returns dynamic because shape differs by role
  Future<Map<String, dynamic>> getMyProfile() async {
    try {
      final response = await _dio.get(ApiConstants.profileMe);
      return response.data['data'] as Map<String, dynamic>;
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  // POST /profile/candidate — creates candidate profile (first time only)
  Future<CandidateProfileModel> createCandidateProfile(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.post(
        ApiConstants.candidateProfile,
        data: data,
      );
      return CandidateProfileModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  // POST /profile/recruiter — creates recruiter profile (first time only)
  Future<RecruiterProfileModel> createRecruiterProfile(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.post(
        ApiConstants.recruiterProfile,
        data: data,
      );
      return RecruiterProfileModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  // PATCH /profile/me — updates either profile type
  // Backend reads role from JWT and updates the right collection
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _dio.patch(ApiConstants.profileMe, data: data);
      return response.data['data'] as Map<String, dynamic>;
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}
