import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Route name constants — never hardcode route strings in widgets
class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const candidateHome = '/candidate/home';
  static const recruiterHome = '/recruiter/home';
}

// Placeholder screens — we'll replace these in Phase 2
class _SplashScreen extends StatelessWidget {
  const _SplashScreen();
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen(this.title);
  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: Text(title)));
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const _SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const _PlaceholderScreen('Login'),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const _PlaceholderScreen('Register'),
      ),
      GoRoute(
        path: AppRoutes.candidateHome,
        builder: (context, state) => const _PlaceholderScreen('Candidate Home'),
      ),
      GoRoute(
        path: AppRoutes.recruiterHome,
        builder: (context, state) => const _PlaceholderScreen('Recruiter Home'),
      ),
    ],
  );
});
