import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';

// Route name constants — never hardcode route strings in widgets
class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const candidateHome = '/candidate/home';
  static const recruiterHome = '/recruiter/home';
}

// Placeholder screens — we'll replace these in Phase 2

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen(this.title);
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(child: Text(title, style: TextStyle(fontSize: 24))),
  );
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
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
