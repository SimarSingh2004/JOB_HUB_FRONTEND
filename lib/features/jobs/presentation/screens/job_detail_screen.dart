import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/app_router.dart';
import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../viewmodels/job_detail_viewmodel.dart';

class JobDetailScreen extends ConsumerWidget {
  final String jobId;

  const JobDetailScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Family provider — pass jobId as argument
    final detailState = ref.watch(jobDetailViewModelProvider(jobId));
    final authState = ref.watch(authViewModelProvider).value;
    final isCandidate = authState?.user?.role == 'candidate';

    if (detailState.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF4F46E5)),
        ),
      );
    }

    if (detailState.error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(detailState.error!)),
      );
    }

    final job = detailState.job!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Collapsing app bar
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: const Color(0xFF4F46E5),
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        job.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        job.recruiter.fullname,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick info row
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      if (job.location != null && job.location!.isNotEmpty)
                        _DetailChip(
                          icon: Icons.location_on_outlined,
                          label: job.location!,
                        ),
                      if (job.salary != null)
                        _DetailChip(
                          icon: Icons.currency_rupee_rounded,
                          label: '${job.salary!.toStringAsFixed(0)} / yr',
                        ),
                      _DetailChip(
                        icon: job.isActive
                            ? Icons.check_circle_outline
                            : Icons.cancel_outlined,
                        label: job.isActive ? 'Active' : 'Closed',
                        color: job.isActive ? Colors.green : Colors.red,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Apply error
                  if (detailState.applyError != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        detailState.applyError!,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ),

                  // Apply success
                  if (detailState.applySuccess)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            'Application submitted successfully!',
                            style: TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                    ),

                  // Description
                  const Text(
                    'About the Role',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    job.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Skills required
                  if (job.skillsRequired.isNotEmpty) ...[
                    const Text(
                      'Skills Required',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: job.skillsRequired
                          .map(
                            (skill) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF4F46E5,
                                ).withOpacity(0.08),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                skill,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF4F46E5),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 100), // space for bottom button
                  ],
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom action button — different for candidate vs recruiter
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        child: isCandidate
            ? _ApplyButton(
                jobId: jobId,
                isApplying: detailState.isApplying,
                alreadyApplied: detailState.applySuccess,
                isActive: job.isActive,
              )
            : SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () =>
                      context.push(AppRoutes.applicants, extra: jobId),
                  icon: const Icon(Icons.people_outline),
                  label: const Text('View Applicants'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF4F46E5),
                    side: const BorderSide(color: Color(0xFF4F46E5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class _ApplyButton extends ConsumerWidget {
  final String jobId;
  final bool isApplying;
  final bool alreadyApplied;
  final bool isActive;

  const _ApplyButton({
    required this.jobId,
    required this.isApplying,
    required this.alreadyApplied,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        // Disable if already applied, currently applying, or job is closed
        onPressed: (isApplying || alreadyApplied || !isActive)
            ? null
            : () => ref
                  .read(jobDetailViewModelProvider(jobId).notifier)
                  .applyToJob(),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4F46E5),
          foregroundColor: Colors.white,
          disabledBackgroundColor: alreadyApplied
              ? Colors.green.shade100
              : Colors.grey.shade200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: isApplying
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                alreadyApplied
                    ? '✓ Applied'
                    : !isActive
                    ? 'Job Closed'
                    : 'Apply Now',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _DetailChip({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? Colors.grey.shade700;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: c),
          const SizedBox(width: 5),
          Text(label, style: TextStyle(fontSize: 13, color: c)),
        ],
      ),
    );
  }
}
