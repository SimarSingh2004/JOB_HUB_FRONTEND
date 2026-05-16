import '../../../models/job.dart';
import 'jobs_filter.dart';
import 'jobs_remote_datasource.dart';

class JobsRepository {
  final JobsRemoteDataSource _remote;

  JobsRepository(this._remote);

  Future<PaginatedJobsResponse> getJobs({
    required int page,
    required JobsFilter filter,
    int limit = 10,
  }) {
    return _remote.getJobs(page: page, limit: limit, filter: filter);
  }

  Future<JobModel> getJobById(String jobId) {
    return _remote.getJobById(jobId);
  }

  Future<PaginatedJobsResponse> getMyJobs({required int page, int limit = 10}) {
    return _remote.getMyJobs(page: page, limit: limit);
  }

  Future<void> applyToJob(String jobId) {
    return _remote.applyToJob(jobId);
  }
}
