import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/app_router.dart';
import '../viewmodels/my_jobs_viewmodel.dart';
import '../widgets/job_card_widget.dart';

class RecruiterHomeScreen extends ConsumerStatefulWidget {
  const RecruiterHomeScreen({super.key});

  @override
  ConsumerState<RecruiterHomeScreen> createState() =>
      _RecruiterHomeScreenState();
}

class _RecruiterHomeScreenState extends ConsumerState<RecruiterHomeScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final max = _scrollController.position.maxScrollExtent;
      if (_scrollController.offset >= max - 200) {
        ref.read(myJobsViewModelProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myJobsViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Jobs',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        Text(
                          'Manage your job postings',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  // Post new job FAB — Phase 5 will wire this up
                  FloatingActionButton.small(
                    onPressed: () => context.push(AppRoutes.postJob),
                    backgroundColor: const Color(0xFF4F46E5),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildBody(state)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(state) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF4F46E5)),
      );
    }

    if (state.error != null && state.jobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.error!),
            TextButton(
              onPressed: () =>
                  ref.read(myJobsViewModelProvider.notifier).refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.jobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.work_outline, size: 56, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              "You haven't posted any jobs yet",
              style: TextStyle(color: Colors.grey.shade500),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.push(AppRoutes.postJob),
              child: const Text('Post your first job'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: const Color(0xFF4F46E5),
      onRefresh: () => ref.read(myJobsViewModelProvider.notifier).refresh(),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(top: 4, bottom: 16),
        itemCount: state.jobs.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.jobs.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final job = state.jobs[index];
          return JobCard(
            job: job,
            onTap: () => context.push(AppRoutes.jobDetail, extra: job.id),
            onLongPress: () => context.push(AppRoutes.postJob, extra: job),
          );
        },
      ),
    );
  }
}
