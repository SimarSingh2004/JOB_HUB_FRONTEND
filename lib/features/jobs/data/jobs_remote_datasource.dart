import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../models/job.dart';
import 'jobs_filter.dart';

// Raw response shape from your backend for paginated jobs:
// { jobs: [], total, page, limit, totalPages, hasNextPage, hasPrevPage }
// We wrap this in a clean Dart class so the repository doesn't
// have to deal with raw Maps
class PaginatedJobsResponse {
  final List<JobModel> jobs;
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final bool hasNextPage;

  const PaginatedJobsResponse({
    required this.jobs,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.hasNextPage,
  });
}

class JobsRemoteDataSource {
  final Dio _dio;

  JobsRemoteDataSource(this._dio);

  PaginatedJobsResponse _parsePaginatedJobs(Response response) {
    final data = response.data['data'] as Map<String, dynamic>;

    final jobsList = (data['jobs'] as List)
        .map((j) => JobModel.fromJson(j as Map<String, dynamic>))
        .toList();

    return PaginatedJobsResponse(
      jobs: jobsList,
      total: data['total'] as int,
      page: data['page'] as int,
      limit: data['limit'] as int,
      totalPages: data['totalPages'] as int,
      hasNextPage: data['hasNextPage'] as bool,
    );
  }

  // GET /jobs — public endpoint, no auth needed for browsing
  Future<PaginatedJobsResponse> getJobs({
    required int page,
    required int limit,
    required JobsFilter filter,
  }) async {
    try {
      final queryParams = {
        'page': page,
        'limit': limit,
        ...filter.toQueryParams(), // spread filter params in
      };

      final response = await _dio.get(
        ApiConstants.jobs,
        queryParameters: queryParams,
      );

      return _parsePaginatedJobs(response);
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  // GET /jobs/:id — single job detail
  Future<JobModel> getJobById(String jobId) async {
    try {
      final response = await _dio.get('${ApiConstants.jobs}/$jobId');
      return JobModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  // GET /jobs/my-jobs — recruiter only
  Future<PaginatedJobsResponse> getMyJobs({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.myJobs,
        queryParameters: {'page': page, 'limit': limit},
      );

      return _parsePaginatedJobs(response);
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  // POST /applications — apply to a job (candidate only)
  // Placed here because it's triggered from job detail screen
  Future<void> applyToJob(String jobId) async {
    try {
      await _dio.post(ApiConstants.applications, data: {'jobId': jobId});
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}
