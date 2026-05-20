import 'package:flutter/material.dart';

// Centralized status badge — used in both candidate and recruiter views.
// Single source of truth for status colors and labels.
// If your backend adds a new status, you update it here once.
class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final config = _statusConfig(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        config.label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: config.textColor,
        ),
      ),
    );
  }

  _StatusConfig _statusConfig(String status) {
    switch (status) {
      case 'applied':
        return _StatusConfig(
          label: 'Applied',
          background: const Color(0xFFE6F1FB),
          textColor: const Color(0xFF0C447C),
        );
      case 'shortlisted':
        return _StatusConfig(
          label: 'Shortlisted',
          background: const Color(0xFFFAEEDA),
          textColor: const Color(0xFF633806),
        );
      case 'accepted':
        return _StatusConfig(
          label: 'Accepted ✓',
          background: const Color(0xFFE1F5EE),
          textColor: const Color(0xFF085041),
        );
      case 'rejected':
        return _StatusConfig(
          label: 'Rejected',
          background: const Color(0xFFFAECE7),
          textColor: const Color(0xFF4A1B0C),
        );
      case 'expired':
        return _StatusConfig(
          label: 'Expired',
          background: const Color(0xFFF0F0F0),
          textColor: const Color(0xFF555555),
        );
      default:
        return _StatusConfig(
          label: status,
          background: Colors.grey.shade100,
          textColor: Colors.grey.shade700,
        );
    }
  }
}

class _StatusConfig {
  final String label;
  final Color background;
  final Color textColor;

  _StatusConfig({
    required this.label,
    required this.background,
    required this.textColor,
  });
}
