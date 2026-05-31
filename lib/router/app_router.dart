import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/jobs/presentation/screens/candidate_home_screen.dart';
import '../features/jobs/presentation/screens/job_detail_screen.dart';
import '../features/jobs/presentation/screens/recruiter_home_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const candidateHome = '/candidate/home';
  static const recruiterHome = '/recruiter/home';
  static const jobDetail = '/jobs/detail';
  static const applicants = '/jobs/applicants';
  static const postJob = '/jobs/post';
}

// Shell screen — holds the bottom nav bar.
// Its child changes as user taps different tabs.
class ShellScreen extends StatelessWidget {
  final Widget child;
  final bool isCandidate;

  const ShellScreen({
    super.key,
    required this.child,
    required this.isCandidate,
  });

  @override
  Widget build(BuildContext context) {
    // Get current location to highlight the right tab
    final location = GoRouterState.of(context).uri.toString();

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex(location, isCandidate),
        onDestinationSelected: (index) =>
            _onTabTap(context, index, isCandidate),
        backgroundColor: Colors.white,
        elevation: 8,
        destinations: isCandidate
            ? const [
                NavigationDestination(
                  icon: Icon(Icons.work_outline),
                  selectedIcon: Icon(Icons.work_rounded),
                  label: 'Jobs',
                ),
                NavigationDestination(
                  icon: Icon(Icons.assignment_outlined),
                  selectedIcon: Icon(Icons.assignment_rounded),
                  label: 'Applications',
                ),
                NavigationDestination(
                  icon: Icon(Icons.chat_bubble_outline),
                  selectedIcon: Icon(Icons.chat_bubble_rounded),
                  label: 'Messages',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person_rounded),
                  label: 'Profile',
                ),
              ]
            : const [
                NavigationDestination(
                  icon: Icon(Icons.work_outline),
                  selectedIcon: Icon(Icons.work_rounded),
                  label: 'My Jobs',
                ),
                NavigationDestination(
                  icon: Icon(Icons.chat_bubble_outline),
                  selectedIcon: Icon(Icons.chat_bubble_rounded),
                  label: 'Messages',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person_rounded),
                  label: 'Profile',
                ),
              ],
      ),
    );
  }

  int _selectedIndex(String location, bool isCandidate) {
    if (isCandidate) {
      if (location.startsWith('/candidate/home')) return 0;
      if (location.startsWith('/candidate/applications')) return 1;
      if (location.startsWith('/candidate/messages')) return 2;
      if (location.startsWith('/candidate/profile')) return 3;
      return 0;
    } else {
      if (location.startsWith('/recruiter/home')) return 0;
      if (location.startsWith('/recruiter/messages')) return 1;
      if (location.startsWith('/recruiter/profile')) return 2;
      return 0;
    }
  }

  void _onTabTap(BuildContext context, int index, bool isCandidate) {
    if (isCandidate) {
      switch (index) {
        case 0:
          context.go(AppRoutes.candidateHome);
        case 1:
          context.go('/candidate/applications');
        case 2:
          context.go('/candidate/messages');
        case 3:
          context.go('/candidate/profile');
      }
    } else {
      switch (index) {
        case 0:
          context.go(AppRoutes.recruiterHome);
        case 1:
          context.go('/recruiter/messages');
        case 2:
          context.go('/recruiter/profile');
      }
    }
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashScreen()),
      GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginScreen()),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, __) => const RegisterScreen(),
      ),

      // Job detail — accessible from both candidate and recruiter
      GoRoute(
        path: AppRoutes.jobDetail,
        builder: (_, state) {
          final jobId = state.extra as String;
          return JobDetailScreen(jobId: jobId);
        },
      ),

      // Placeholder routes — wired in Phase 4 and 5
      GoRoute(
        path: AppRoutes.postJob,
        builder: (_, __) =>
            const Scaffold(body: Center(child: Text('Post Job — Phase 5'))),
      ),
      GoRoute(
        path: AppRoutes.applicants,
        builder: (_, state) =>
            Scaffold(body: Center(child: Text('Applicants — Phase 4'))),
      ),

      // Candidate shell — bottom nav wraps all candidate tabs
      ShellRoute(
        builder: (_, __, child) => ShellScreen(isCandidate: true, child: child),
        routes: [
          GoRoute(
            path: AppRoutes.candidateHome,
            builder: (_, __) => const CandidateHomeScreen(),
          ),
          GoRoute(
            path: '/candidate/applications',
            builder: (_, __) => const Scaffold(
              body: Center(child: Text('Applications — Phase 4')),
            ),
          ),
          GoRoute(
            path: '/candidate/messages',
            builder: (_, __) =>
                const Scaffold(body: Center(child: Text('Messages — Phase 6'))),
          ),
          GoRoute(
            path: '/candidate/profile',
            builder: (_, __) =>
                const Scaffold(body: Center(child: Text('Profile — Phase 5'))),
          ),
        ],
      ),

      // Recruiter shell
      ShellRoute(
        builder: (_, __, child) =>
            ShellScreen(isCandidate: false, child: child),
        routes: [
          GoRoute(
            path: AppRoutes.recruiterHome,
            builder: (_, __) => const RecruiterHomeScreen(),
          ),
          GoRoute(
            path: '/recruiter/messages',
            builder: (_, __) =>
                const Scaffold(body: Center(child: Text('Messages — Phase 6'))),
          ),
          GoRoute(
            path: '/recruiter/profile',
            builder: (_, __) =>
                const Scaffold(body: Center(child: Text('Profile — Phase 5'))),
          ),
        ],
      ),
    ],
  );
});
