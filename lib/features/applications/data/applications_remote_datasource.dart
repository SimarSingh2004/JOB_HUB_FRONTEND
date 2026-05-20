import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../models/application.dart';

class ApplicationsRemoteDataSource {
  final Dio _dio;

  ApplicationsRemoteDataSource(this._dio);

  // GET /applications/my — candidate only
  // Returns paginated list of the candidate's own applications
  Future<Map<String, dynamic>> getMyApplications({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.myApplications,
        queryParameters: {'page': page, 'limit': limit},
      );

      final data = response.data['data'] as Map<String, dynamic>;
      final applications = (data['applications'] as List)
          .map((a) => ApplicationModel.fromJson(a as Map<String, dynamic>))
          .toList();

      return {
        'applications': applications,
        'hasNextPage': data['hasNextPage'] as bool,
        'page': data['page'] as int,
      };
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  // GET /applications/job/:jobId — recruiter only
  // Returns paginated list of candidates who applied to a specific job
  Future<Map<String, dynamic>> getApplicantsForJob({
    required String jobId,
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.applications}/job/$jobId',
        queryParameters: {'page': page, 'limit': limit},
      );

      final data = response.data['data'] as Map<String, dynamic>;
      final applications = (data['applicants'] as List)
          .map((a) => ApplicationModel.fromJson(a as Map<String, dynamic>))
          .toList();

      return {
        'applications': applications,
        'hasNextPage': data['hasNextPage'] as bool,
        'page': data['page'] as int,
      };
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  // PATCH /applications/:id — recruiter only
  // Updates the status of an application
  Future<ApplicationModel> updateStatus({
    required String applicationId,
    required String status,
  }) async {
    try {
      final response = await _dio.patch(
        '${ApiConstants.applications}/$applicationId',
        data: {'status': status},
      );

      return ApplicationModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}
