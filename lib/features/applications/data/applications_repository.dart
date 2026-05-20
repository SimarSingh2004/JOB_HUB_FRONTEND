import '../../../models/application.dart';
import 'applications_remote_datasource.dart';

class ApplicationsRepository {
  final ApplicationsRemoteDataSource _remote;

  ApplicationsRepository(this._remote);

  Future<Map<String, dynamic>> getMyApplications({
    required int page,
    int limit = 10,
  }) {
    return _remote.getMyApplications(page: page, limit: limit);
  }

  Future<Map<String, dynamic>> getApplicantsForJob({
    required String jobId,
    required int page,
    int limit = 10,
  }) {
    return _remote.getApplicantsForJob(jobId: jobId, page: page, limit: limit);
  }

  Future<ApplicationModel> updateStatus({
    required String applicationId,
    required String status,
  }) {
    return _remote.updateStatus(applicationId: applicationId, status: status);
  }
}
