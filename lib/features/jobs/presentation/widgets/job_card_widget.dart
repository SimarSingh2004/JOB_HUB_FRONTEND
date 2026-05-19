import 'package:flutter/material.dart';
import '../../../../models/job.dart';

// Reusable card used in both candidate job list and recruiter my-jobs list.
// Takes a JobModel and an onTap callback — knows nothing about navigation.
class JobCard extends StatelessWidget {
  final JobModel job;
  final VoidCallback onTap;

  const JobCard({super.key, required this.job, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Card tap triggers navigation to job details
      child: Container(
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
            // Title + active badge row
            Row(
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
                // Show inactive badge for recruiter's closed jobs
                if (!job.isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Closed',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.red.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),

            // Recruiter name
            Text(
              job.recruiter.fullname,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),

            // Location + Salary chips
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                if (job.location != null && job.location!.isNotEmpty)
                  _InfoChip(
                    icon: Icons.location_on_outlined,
                    label: job.location!,
                  ),
                if (job.salary != null)
                  _InfoChip(
                    icon: Icons.currency_rupee_rounded,
                    label: '${_formatSalary(job.salary!)} / yr',
                  ),
              ],
            ),

            // Skills
            if (job.skillsRequired.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: job.skillsRequired
                    .take(4) // show max 4 skills on card
                    .map((skill) => _SkillChip(skill: skill))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Format salary: 100000 → "1L", 1000000 → "10L"
  String _formatSalary(double salary) {
    if (salary >= 100000) {
      return '${(salary / 100000).toStringAsFixed(1)}L';
    }
    return salary.toStringAsFixed(0);
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.grey.shade600),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String skill;
  const _SkillChip({required this.skill});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF4F46E5).withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        skill,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF4F46E5),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
