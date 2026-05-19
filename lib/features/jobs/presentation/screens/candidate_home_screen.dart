import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/app_router.dart';
import '../viewmodels/jobs_viewmodel.dart';
import '../widgets/job_card_widget.dart';
import '../widgets/jobs_filter_sheet.dart';

class CandidateHomeScreen extends ConsumerStatefulWidget {
  const CandidateHomeScreen({super.key});

  @override
  ConsumerState<CandidateHomeScreen> createState() =>
      _CandidateHomeScreenState();
}

class _CandidateHomeScreenState extends ConsumerState<CandidateHomeScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Listen for scroll reaching the bottom — trigger load more
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Trigger load more when within 200px of the bottom
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll >= maxScroll - 200) {
      ref.read(jobsViewModelProvider.notifier).loadMore();
    }
  }

  void _openFilterSheet() {
    final currentFilter = ref.read(jobsViewModelProvider).filter;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // lets the sheet grow with keyboard
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => JobsFilterSheet(
        currentFilter: currentFilter,
        onApply: (newFilter) =>
            ref.read(jobsViewModelProvider.notifier).applyFilter(newFilter),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final jobsState = ref.watch(jobsViewModelProvider);
    final hasActiveFilters = !jobsState.filter.isEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Find Jobs',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        Text(
                          'Discover your next opportunity',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Search + Filter row
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) => ref
                          .read(jobsViewModelProvider.notifier)
                          .onSearchChanged(val),
                      decoration: InputDecoration(
                        hintText: 'Search jobs, skills...',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey.shade400,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Filter button — highlighted when filters are active
                  GestureDetector(
                    onTap: _openFilterSheet,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: hasActiveFilters
                            ? const Color(0xFF4F46E5)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.tune_rounded,
                        color: hasActiveFilters
                            ? Colors.white
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Active filter chips row — shown when filters are applied
            if (hasActiveFilters)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Row(
                  children: [
                    const Text(
                      'Filters active',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        ref.read(jobsViewModelProvider.notifier).clearFilters();
                      },
                      child: const Text(
                        'Clear all',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF4F46E5),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Main content
            Expanded(child: _buildBody(jobsState)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(jobsState) {
    // Full screen loading — first page only
    if (jobsState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF4F46E5)),
      );
    }

    // Error state
    if (jobsState.error != null && jobsState.jobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
            const SizedBox(height: 12),
            Text(
              jobsState.error!,
              style: TextStyle(color: Colors.red.shade400),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () =>
                  ref.read(jobsViewModelProvider.notifier).refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Empty state
    if (jobsState.jobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.work_off_outlined,
              size: 56,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 12),
            Text(
              'No jobs found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Try adjusting your search or filters',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
            ),
          ],
        ),
      );
    }

    // Job list with infinite scroll
    return RefreshIndicator(
      color: const Color(0xFF4F46E5),
      onRefresh: () => ref.read(jobsViewModelProvider.notifier).refresh(),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(top: 4, bottom: 16),
        // +1 for the loading indicator at the bottom
        itemCount: jobsState.jobs.length + (jobsState.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          // Last item — show load more spinner
          if (index == jobsState.jobs.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFF4F46E5)),
              ),
            );
          }

          final job = jobsState.jobs[index];
          return JobCard(
            job: job,
            onTap: () => context.push(AppRoutes.jobDetail, extra: job.id),
          );
        },
      ),
    );
  }
}
