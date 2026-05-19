import 'package:flutter/material.dart';
import '../../data/jobs_filter.dart';

// Bottom sheet for filtering jobs.
// Uses local StatefulWidget state — NOT Riverpod — because this
// is temporary UI state that only matters while the sheet is open.
// Only when user taps "Apply" do we push it to the ViewModel.
class JobsFilterSheet extends StatefulWidget {
  final JobsFilter currentFilter;
  final void Function(JobsFilter) onApply;

  const JobsFilterSheet({
    super.key,
    required this.currentFilter,
    required this.onApply,
  });

  @override
  State<JobsFilterSheet> createState() => _JobsFilterSheetState();
}

class _JobsFilterSheetState extends State<JobsFilterSheet> {
  late TextEditingController _locationController;
  late TextEditingController _minSalaryController;
  late TextEditingController _maxSalaryController;
  late TextEditingController _skillController;
  late List<String> _skills;

  @override
  void initState() {
    super.initState();
    // Pre-fill with current filter values
    _locationController = TextEditingController(
      text: widget.currentFilter.location,
    );
    _minSalaryController = TextEditingController(
      text: widget.currentFilter.minSalary?.toString() ?? '',
    );
    _maxSalaryController = TextEditingController(
      text: widget.currentFilter.maxSalary?.toString() ?? '',
    );
    _skillController = TextEditingController();
    _skills = List.from(
      widget.currentFilter.skills,
    ); // make a mutable copy of skills list to prevent modifying the original filter's list until "Apply" is tapped
  }

  @override
  void dispose() {
    _locationController.dispose();
    _minSalaryController.dispose();
    _maxSalaryController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  void _addSkill() {
    final skill = _skillController.text.trim().toLowerCase();
    if (skill.isNotEmpty && !_skills.contains(skill)) {
      setState(() {
        _skills.add(skill);
        _skillController.clear();
      });
    }
  }

  void _apply() {
    final newFilter = JobsFilter(
      location: _locationController.text.trim(),
      minSalary: double.tryParse(_minSalaryController.text),
      maxSalary: double.tryParse(_maxSalaryController.text),
      skills: _skills,
      // keep existing search — don't reset it from filter sheet
      search: widget.currentFilter.search,
    );
    widget.onApply(newFilter); // pass new filter to viewmodel
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        // Shift up when keyboard appears
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Filter Jobs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Location
            _FilterLabel('Location'),
            const SizedBox(height: 8),
            TextField(
              controller: _locationController,
              decoration: _inputDecoration('e.g. Delhi, Remote'),
            ),
            const SizedBox(height: 16),

            // Salary range
            _FilterLabel('Salary Range (per year)'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minSalaryController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration('Min'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('—'),
                ),
                Expanded(
                  child: TextField(
                    controller: _maxSalaryController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration('Max'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Skills
            _FilterLabel('Skills'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _skillController,
                    decoration: _inputDecoration('Add a skill'),
                    onSubmitted: (_) => _addSkill(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _addSkill,
                  icon: const Icon(Icons.add_circle_outline),
                  color: const Color(0xFF4F46E5),
                ),
              ],
            ),
            if (_skills.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _skills.map((skill) {
                  return Chip(
                    label: Text(skill, style: const TextStyle(fontSize: 12)),
                    onDeleted: () => setState(() => _skills.remove(skill)),
                    deleteIconColor: Colors.grey,
                    backgroundColor: Colors.grey.shade100,
                    side: BorderSide.none,
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 28),

            // Apply button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _apply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Apply Filters',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }
}

class _FilterLabel extends StatelessWidget {
  final String text;
  const _FilterLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1A2E),
      ),
    );
  }
}
