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

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9FF),
      body: Stack(
        children: [
          // Bottom decorative waves
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 230,
            child: CustomPaint(painter: _SplashWavePainter()),
          ),

          // Main splash content
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/branding/jobhub_icon_light.png',
                      width: 105,
                    ),

                    const SizedBox(height: 14),

                    Image.asset(
                      'assets/branding/jobhub_wordmark.png',
                      width: 210,
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Connecting talent with opportunity',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                        letterSpacing: 0.1,
                      ),
                    ),

                    const SizedBox(height: 32),

                    const SizedBox(
                      width: 26,
                      height: 26,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Color(0xFF5B3CC4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashWavePainter extends CustomPainter {
  const _SplashWavePainter();

  @override
  void paint(Canvas canvas, Size size) {
    // ─────────────────────────────────────────────
    // Back/light wave
    // ─────────────────────────────────────────────

    final lightWave = Paint()
      ..color = const Color(0xFFE9E4FF)
      ..style = PaintingStyle.fill;

    final lightPath = Path()
      ..moveTo(0, size.height * 0.25)
      ..cubicTo(
        size.width * 0.20,
        size.height * 0.05,
        size.width * 0.38,
        size.height * 0.50,
        size.width * 0.58,
        size.height * 0.42,
      )
      ..cubicTo(
        size.width * 0.78,
        size.height * 0.34,
        size.width * 0.85,
        size.height * 0.10,
        size.width,
        size.height * 0.20,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(lightPath, lightWave);

    // ─────────────────────────────────────────────
    // Middle purple wave
    // ─────────────────────────────────────────────

    final middleWave = Paint()
      ..color = const Color(0xFF7C5CFF)
      ..style = PaintingStyle.fill;

    final middlePath = Path()
      ..moveTo(0, size.height * 0.48)
      ..cubicTo(
        size.width * 0.18,
        size.height * 0.30,
        size.width * 0.35,
        size.height * 0.72,
        size.width * 0.55,
        size.height * 0.62,
      )
      ..cubicTo(
        size.width * 0.72,
        size.height * 0.54,
        size.width * 0.84,
        size.height * 0.34,
        size.width,
        size.height * 0.40,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(middlePath, middleWave);

    // ─────────────────────────────────────────────
    // Front/deep-purple wave
    // ─────────────────────────────────────────────

    final frontWave = Paint()
      ..color = const Color(0xFF5B3CC4)
      ..style = PaintingStyle.fill;

    final frontPath = Path()
      ..moveTo(0, size.height * 0.70)
      ..cubicTo(
        size.width * 0.20,
        size.height * 0.55,
        size.width * 0.36,
        size.height * 0.86,
        size.width * 0.58,
        size.height * 0.76,
      )
      ..cubicTo(
        size.width * 0.78,
        size.height * 0.67,
        size.width * 0.88,
        size.height * 0.58,
        size.width,
        size.height * 0.63,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(frontPath, frontWave);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
