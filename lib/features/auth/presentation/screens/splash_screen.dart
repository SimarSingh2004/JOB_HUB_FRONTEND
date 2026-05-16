import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/app_router.dart';
import '../viewmodels/auth_viewmodel.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.listen MUST live inside build() — this is a Riverpod rule.
    // It watches the provider and runs the callback on every change,
    // but does NOT rebuild the widget. Perfect for navigation side effects.
    ref.listen<AsyncValue<AuthState>>(authViewModelProvider, (_, next) {
      // next.whenData only runs when AsyncValue is in Data state (not loading/error)
      next.whenData((authState) {
        if (authState.isAuthenticated) {
          final role = authState.user!.role;
          context.go(
            role == 'recruiter'
                ? AppRoutes.recruiterHome
                : AppRoutes.candidateHome,
          );
        } else {
          context.go(AppRoutes.login);
        }
      });
    });

    // Also handle the case where provider already resolved before
    // the listener was registered — read current value and navigate
    // after the frame is done
    final authAsync = ref.watch(authViewModelProvider);
    authAsync.whenData((authState) {
      // Schedule navigation after current build frame completes
      // Never navigate during build — Flutter forbids it
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        if (authState.isAuthenticated) {
          final role = authState.user!.role;
          context.go(
            role == 'recruiter'
                ? AppRoutes.recruiterHome
                : AppRoutes.candidateHome,
          );
        } else {
          context.go(AppRoutes.login);
        }
      });
    });

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
