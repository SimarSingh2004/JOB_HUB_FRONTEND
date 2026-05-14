import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/app_router.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../widgets/auth_widgets.dart';

// ConsumerStatefulWidget because:
// 1. We need TextEditingControllers (require disposal → StatefulWidget)
// 2. We need to read/watch Riverpod providers (→ ConsumerWidget)
// Together = ConsumerStatefulWidget
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;

  @override
  void dispose() {
    // Always dispose controllers — prevents memory leaks
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    // Validate all form fields first
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(authViewModelProvider.notifier)
        .login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    // ref.watch rebuilds this widget when authViewModelProvider changes.
    // We use .when() to handle all three AsyncValue states cleanly.
    final authAsync = ref.watch(authViewModelProvider);

    // Listen for successful auth and navigate — side effect, not UI
    ref.listen<AsyncValue<AuthState>>(authViewModelProvider, (_, next) {
      next.whenData((state) {
        if (state.isAuthenticated && !state.isLoading) {
          final role = state.user!.role;
          context.go(
            role == 'recruiter'
                ? AppRoutes.recruiterHome
                : AppRoutes.candidateHome,
          );
        }
      });
    });

    // Extract current auth state values safely
    final authState = authAsync.value;
    final isLoading = authState?.isLoading ?? false;
    final error = authState?.error;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const Icon(
                    Icons.work_rounded,
                    size: 48,
                    color: Color(0xFF4F46E5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Welcome back',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Sign in to continue to JobHub',
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 32),

                  // Error banner — only shown when there's an error
                  if (error != null) ...[
                    AuthErrorBanner(
                      message: error,
                      onDismiss: () =>
                          ref.read(authViewModelProvider.notifier).clearError(),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Email field
                  AuthTextField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'you@example.com',
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Email is required';
                      }
                      if (!val.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password field
                  AuthTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: '••••••••',
                    obscureText: !_showPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () =>
                          setState(() => _showPassword = !_showPassword),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Password is required';
                      }
                      if (val.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Login button
                  AuthButton(
                    label: 'Sign In',
                    isLoading: isLoading,
                    onPressed: _onLogin,
                  ),
                  const SizedBox(height: 20),

                  // Navigate to Register
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      GestureDetector(
                        onTap: () => context.push(AppRoutes.register),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Color(0xFF4F46E5),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
