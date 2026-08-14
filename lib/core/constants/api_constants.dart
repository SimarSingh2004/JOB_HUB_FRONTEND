class ApiConstants {
  // Set at build time with --dart-define=API_BASE_URL=https://your-backend.example.com/api/v1
  // Falls back to the Android-emulator loopback address (10.0.2.2) for local dev,
  // since that's the only environment where this default is ever correct.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000/api/v1',
  );
  //Auth
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh-token';

  // Profile
  static const String profileMe = '/profile/me';
  static const String candidateProfile = '/profile/candidate';
  static const String recruiterProfile = '/profile/recruiter';

  // Jobs
  static const String jobs = '/jobs';
  static const String myJobs = '/jobs/my-jobs';

  // Applications
  static const String applications = '/applications';
  static const String myApplications = '/applications/my';

  // Conversations
  static const String conversations = '/conversations';

  // Messages
  static const String messages = '/messages';
}
