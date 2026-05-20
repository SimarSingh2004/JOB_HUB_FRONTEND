import 'package:flutter/material.dart';
import '../../../../models/application.dart';
import 'status_badge_widget.dart';

// Card shown in the recruiter's applicants list.
// Shows candidate info + action buttons based on valid transitions.
// This is the most logic-heavy widget in Phase 4.
class ApplicantCard extends StatelessWidget {
  final ApplicationModel application;
  final bool isUpdating;
  final void Function(String newStatus) onStatusUpdate;

  const ApplicantCard({
    super.key,
    required this.application,
    required this.isUpdating,
    required this.onStatusUpdate,
  });

  // Mirror your backend's validTransitions map:
  // applied → [shortlisted, rejected]
  // shortlisted → [accepted, rejected]
  // accepted → [] (terminal)
  // rejected → [] (terminal)
  // expired → [] (terminal)
  List<_ActionButton> _getActions(String status) {
    switch (status) {
      case 'applied':
        return [
          _ActionButton(
            label: 'Shortlist',
            status: 'shortlisted',
            color: const Color(0xFFBA7517),
            background: const Color(0xFFFAEEDA),
          ),
          _ActionButton(
            label: 'Reject',
            status: 'rejected',
            color: const Color(0xFF993C1D),
            background: const Color(0xFFFAECE7),
          ),
        ];
      case 'shortlisted':
        return [
          _ActionButton(
            label: 'Accept',
            status: 'accepted',
            color: const Color(0xFF085041),
            background: const Color(0xFFE1F5EE),
          ),
          _ActionButton(
            label: 'Reject',
            status: 'rejected',
            color: const Color(0xFF993C1D),
            background: const Color(0xFFFAECE7),
          ),
        ];
      default:
        // accepted, rejected, expired — no actions
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    // candidate is populated by your backend as { fullname, email, username }
    // In ApplicationModel, candidate is stored as a String (id),
    // but from getApplicantsForJob it's populated.
    // We handle this by reading from the raw populated data.
    final actions = _getActions(application.status);

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
          // Candidate name + status badge
          Row(
            children: [
              // Avatar circle with initials
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF4F46E5).withOpacity(0.1),
                child: Text(
                  application.candidate.isNotEmpty
                      ? application.candidate[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: Color(0xFF4F46E5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      application.candidate,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                  ],
                ),
              ),
              StatusBadge(status: application.status),
            ],
          ),

          // Action buttons — only shown for non-terminal statuses
          if (actions.isNotEmpty) ...[
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 12),
            isUpdating
                ? const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF4F46E5),
                      ),
                    ),
                  )
                : Row(
                    children: actions
                        .map(
                          (action) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: _ActionButtonWidget(
                                action: action,
                                onTap: () => onStatusUpdate(action.status),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ],
        ],
      ),
    );
  }
}

class _ActionButton {
  final String label;
  final String status;
  final Color color;
  final Color background;

  const _ActionButton({
    required this.label,
    required this.status,
    required this.color,
    required this.background,
  });
}

class _ActionButtonWidget extends StatelessWidget {
  final _ActionButton action;
  final VoidCallback onTap;

  const _ActionButtonWidget({required this.action, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: action.background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            action.label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: action.color,
            ),
          ),
        ),
      ),
    );
  }
}
