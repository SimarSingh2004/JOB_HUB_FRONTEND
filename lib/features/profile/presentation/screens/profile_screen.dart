import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/app_router.dart';
import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../widgets/candidate_profile_form.dart';
import '../widgets/recruiter_profile_form.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileViewModelProvider);
    final authState = ref.watch(authViewModelProvider).value;
    final role = authState?.user?.role ?? 'candidate';

    ref.listen<AsyncValue<ProfileState>>(profileViewModelProvider, (_, next) {
      next.whenData((state) {
        if (state.saveSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile saved successfully!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );

          ref.read(profileViewModelProvider.notifier).clearSaveSuccess();
        }
      });
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      body: SafeArea(
        child: Column(
          children: [
            // Header with logout
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                  ),
                  // Logout button
                  TextButton.icon(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Log out?'),
                          content: const Text(
                            'You will need to log in again to access JobHub.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: Text(
                                'Log out',
                                style: TextStyle(color: Colors.red.shade600),
                              ),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true && context.mounted) {
                        await ref.read(authViewModelProvider.notifier).logout();
                        // GoRouter has no redirect/refreshListenable wired to
                        // auth state, so it never re-routes on its own —
                        // navigate explicitly or the user is left stranded
                        // on this (now-invalid) screen after logout.
                        if (context.mounted) context.go(AppRoutes.login);
                      }
                    },
                    icon: const Icon(Icons.logout, size: 18),
                    label: const Text('Logout'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // Body
            Expanded(
              child: profileAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: Color(0xFF4F46E5)),
                ),
                error: (e, _) => Center(child: Text(e.toString())),
                data: (profileState) {
                  if (profileState.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // A real error (401/500/network) — NOT the same as "no
                  // profile yet". Must be checked before profileExists,
                  // or this silently shows the create form instead,
                  // which is why "Create Profile" kept reappearing.
                  if (profileState.loadFailed) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(profileState.error ?? 'Failed to load profile'),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () =>
                                ref.invalidate(profileViewModelProvider),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  // Profile doesn't exist yet — show create form
                  if (!profileState.profileExists) {
                    return role == 'candidate'
                        ? const CandidateProfileForm()
                        : const RecruiterProfileForm();
                  }

                  // Profile exists — show edit form pre-filled
                  return role == 'candidate'
                      ? CandidateProfileForm(
                          existingProfile: profileState.candidateProfile,
                        )
                      : RecruiterProfileForm(
                          existingProfile: profileState.recruiterProfile,
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
