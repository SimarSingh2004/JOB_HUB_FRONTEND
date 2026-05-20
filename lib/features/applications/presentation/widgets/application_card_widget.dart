import 'package:flutter/material.dart';
import '../../../../models/application.dart';
import 'status_badge_widget.dart';

// Card shown in the candidate's "My Applications" list.
// Shows what job they applied to and what the current status is.
class ApplicationCard extends StatelessWidget {
  final ApplicationModel application;

  const ApplicationCard({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    final job = application.job;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Job title + status badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  job.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              StatusBadge(status: application.status),
            ],
          ),
          const SizedBox(height: 4),

          // Recruiter name
          Text(
            job.recruiter.fullname,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 10),

          // Location + salary
          Wrap(
            spacing: 8,
            children: [
              if (job.location != null && job.location!.isNotEmpty)
                _InfoText(
                  icon: Icons.location_on_outlined,
                  label: job.location!,
                ),
              if (job.salary != null)
                _InfoText(
                  icon: Icons.currency_rupee_rounded,
                  label: '${job.salary!.toStringAsFixed(0)} / yr',
                ),
            ],
          ),
          const SizedBox(height: 10),

          // Applied date
          if (application.createdAt != null)
            Text(
              'Applied ${_formatDate(application.createdAt!)}',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
            ),
        ],
      ),
    );
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      final now = DateTime.now();
      final diff = now.difference(date).inDays;
      if (diff == 0) return 'today';
      if (diff == 1) return 'yesterday';
      if (diff < 7) return '$diff days ago';
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return '';
    }
  }
}

class _InfoText extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoText({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: Colors.grey.shade500),
        const SizedBox(width: 3),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
