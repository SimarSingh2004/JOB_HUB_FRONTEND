import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/app_router.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../widgets/auth_widgets.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Role selection — default to candidate
  String _selectedRole = 'candidate';
  bool _showPassword = false;

  @override
  void dispose() {
    _fullnameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onRegister() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(authViewModelProvider.notifier)
        .register(
          fullname: _fullnameController.text.trim(),
          username: _usernameController.text.trim().toLowerCase(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          role: _selectedRole,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authViewModelProvider);

    // Navigate on successful auth (register auto-logs in)
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

    final isLoading = authAsync.value?.isLoading ?? false;
    final error = authAsync.value?.error;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A2E)),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Join JobHub today',
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 28),

                if (error != null) ...[
                  AuthErrorBanner(
                    message: error,
                    onDismiss: () =>
                        ref.read(authViewModelProvider.notifier).clearError(),
                  ),
                  const SizedBox(height: 16),
                ],

                // Full name
                AuthTextField(
                  controller: _fullnameController,
                  label: 'Full Name',
                  hint: 'John Doe',
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Full name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Username
                AuthTextField(
                  controller: _usernameController,
                  label: 'Username',
                  hint: 'johndoe',
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Username is required';
                    }
                    if (val.contains(' ')) return 'No spaces in username';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Email
                AuthTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Email is required';
                    if (!val.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Password
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
                      return 'Minimum 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Role selector
                // This is important — it determines everything about the user's
                // experience in the app, matching your backend role middleware
                const Text(
                  'I am a...',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _RoleCard(
                      label: 'Candidate',
                      icon: Icons.person_search_rounded,
                      description: 'Looking for jobs',
                      isSelected: _selectedRole == 'candidate',
                      onTap: () => setState(() => _selectedRole = 'candidate'),
                    ),
                    const SizedBox(width: 12),
                    _RoleCard(
                      label: 'Recruiter',
                      icon: Icons.business_center_rounded,
                      description: 'Hiring talent',
                      isSelected: _selectedRole == 'recruiter',
                      onTap: () => setState(() => _selectedRole = 'recruiter'),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                AuthButton(
                  label: 'Create Account',
                  isLoading: isLoading,
                  onPressed: _onRegister,
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Color(0xFF4F46E5),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Role selection card widget — private to this file
class _RoleCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.label,
    required this.icon,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                // ignore: deprecated_member_use
                ? const Color(0xFF4F46E5).withOpacity(0.08)
                : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF4F46E5)
                  : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? const Color(0xFF4F46E5)
                    : Colors.grey.shade500,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? const Color(0xFF4F46E5)
                      : const Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
