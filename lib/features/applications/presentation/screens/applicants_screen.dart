import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/applicants_viewmodel.dart';
import '../widgets/applicant_card_widget.dart';

class ApplicantsScreen extends ConsumerStatefulWidget {
  final String jobId;

  const ApplicantsScreen({super.key, required this.jobId});

  @override
  ConsumerState<ApplicantsScreen> createState() => _ApplicantsScreenState();
}

class _ApplicantsScreenState extends ConsumerState<ApplicantsScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final max = _scrollController.position.maxScrollExtent;
      if (_scrollController.offset >= max - 200) {
        ref
            .read(applicantsViewModelProvider(widget.jobId).notifier)
            .loadMore(widget.jobId);
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
    final state = ref.watch(applicantsViewModelProvider(widget.jobId));

    // Show snackbar on error (e.g. failed status update)
    ref.listen<ApplicantsState>(applicantsViewModelProvider(widget.jobId), (
      prev,
      next,
    ) {
      if (next.error != null && prev?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      appBar: AppBar(
        title: const Text(
          'Applicants',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.grey.shade200),
        ),
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(ApplicantsState state) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF4F46E5)),
      );
    }

    if (state.error != null && state.applicants.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.error!),
            TextButton(
              onPressed: () => ref
                  .read(applicantsViewModelProvider(widget.jobId).notifier)
                  .refresh(widget.jobId),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.applicants.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 56, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              'No applicants yet',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: const Color(0xFF4F46E5),
      onRefresh: () => ref
          .read(applicantsViewModelProvider(widget.jobId).notifier)
          .refresh(widget.jobId),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        itemCount: state.applicants.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.applicants.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final application = state.applicants[index];
          return ApplicantCard(
            application: application,
            // Is THIS specific card being updated?
            isUpdating: state.updatingApplicationId == application.id,
            onStatusUpdate: (newStatus) => ref
                .read(applicantsViewModelProvider(widget.jobId).notifier)
                .updateStatus(
                  applicationId: application.id,
                  newStatus: newStatus,
                ),
          );
        },
      ),
    );
  }
}
