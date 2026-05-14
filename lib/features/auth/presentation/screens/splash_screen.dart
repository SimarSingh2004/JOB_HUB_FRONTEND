import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/app_router.dart';
import '../viewmodels/auth_viewmodel.dart';

// ConsumerStatefulWidget = StatefulWidget that can read Riverpod providers.
// We need StatefulWidget here because we want to run navigation logic
// once after the auth check completes — using a listener, not rebuild.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Listen to auth state AFTER the first frame renders.
    // We can't navigate during build — Flutter doesn't allow that.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _listenAndNavigate();
    });
  }

  void _listenAndNavigate() {
    // ref.listen watches a provider and calls the callback when it changes.
    // Unlike ref.watch (which rebuilds UI), ref.listen is for side effects
    // like navigation, showing snackbars, etc.
    ref.listen<AsyncValue<AuthState>>(authViewModelProvider, (previous, next) {
      // next is AsyncValue — could be loading, error, or data
      next.whenData((authState) {
        if (!authState.isLoading) {
          if (authState.isAuthenticated) {
            final role = authState.user!.role;
            if (role == 'recruiter') {
              context.go(AppRoutes.recruiterHome);
            } else {
              context.go(AppRoutes.candidateHome);
            }
          } else {
            context.go(AppRoutes.login);
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.work_rounded, size: 64, color: Color(0xFF4F46E5)),
            SizedBox(height: 16),
            Text(
              'JobHub',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4F46E5),
              ),
            ),
            SizedBox(height: 32),
            CircularProgressIndicator(color: Color(0xFF4F46E5)),
          ],
        ),
      ),
    );
  }
}
