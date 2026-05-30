import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../models/job.dart';
import '../viewmodels/post_job_viewmodel.dart';
// ignore: unused_import
import '../../presentation/widgets/jobs_filter_sheet.dart';

class PostJobScreen extends ConsumerStatefulWidget {
  // If editing, pass the existing job — null means creating new
  final JobModel? existingJob;

  const PostJobScreen({super.key, this.existingJob});

  @override
  ConsumerState<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends ConsumerState<PostJobScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _salaryCtrl;
  late TextEditingController _locationCtrl;
  late TextEditingController _skillCtrl;
  late List<String> _skills;

  bool get _isEditing => widget.existingJob != null;

  @override
  void initState() {
    super.initState();
    final j = widget.existingJob;
    _titleCtrl = TextEditingController(text: j?.title ?? '');
    _descCtrl = TextEditingController(text: j?.description ?? '');
    _salaryCtrl = TextEditingController(
      text: j?.salary?.toStringAsFixed(0) ?? '',
    );
    _locationCtrl = TextEditingController(text: j?.location ?? '');
    _skillCtrl = TextEditingController();
    _skills = List.from(j?.skillsRequired ?? []);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _salaryCtrl.dispose();
    _locationCtrl.dispose();
    _skillCtrl.dispose();
    super.dispose();
  }

  void _addSkill() {
    final skill = _skillCtrl.text.trim().toLowerCase();
    if (skill.isNotEmpty && !_skills.contains(skill)) {
      setState(() {
        _skills.add(skill);
        _skillCtrl.clear();
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final vm = ref.read(postJobViewModelProvider.notifier);

    if (_isEditing) {
      await vm.updateJob(
        jobId: widget.existingJob!.id,
        data: {
          'title': _titleCtrl.text.trim(),
          'description': _descCtrl.text.trim(),
          'skillsRequired': _skills,
          if (_salaryCtrl.text.isNotEmpty)
            'salary': double.tryParse(_salaryCtrl.text.trim()),
          if (_locationCtrl.text.isNotEmpty)
            'location': _locationCtrl.text.trim(),
        },
      );
    } else {
      await vm.createJob(
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        skillsRequired: _skills,
        salary: double.tryParse(_salaryCtrl.text.trim()),
        location: _locationCtrl.text.trim(),
      );
    }
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Job?'),
        content: const Text(
          'This will close the job and remove it from listings. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Delete', style: TextStyle(color: Colors.red.shade600)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await ref
          .read(postJobViewModelProvider.notifier)
          .deleteJob(widget.existingJob!.id);
      if (success && mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(postJobViewModelProvider);

    // Navigate back on success
    ref.listen<PostJobState>(postJobViewModelProvider, (_, next) {
      if (next.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing ? 'Job updated!' : 'Job posted successfully!',
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.pop();
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit Job' : 'Post a Job',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.grey.shade200),
        ),
        // Delete button — only shown when editing
        actions: _isEditing
            ? [
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red.shade600),
                  onPressed: state.isDeleting ? null : _delete,
                ),
              ]
            : null,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Error
              if (state.error != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    state.error!,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ),

              _label('Job Title *'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleCtrl,
                decoration: _deco('e.g. Senior Flutter Developer'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              _label('Description *'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descCtrl,
                maxLines: 5,
                decoration: _deco('Describe the role, responsibilities...'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              _label('Location'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _locationCtrl,
                decoration: _deco('e.g. Delhi, Remote'),
              ),
              const SizedBox(height: 16),

              _label('Salary (per year)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _salaryCtrl,
                keyboardType: TextInputType.number,
                decoration: _deco('e.g. 1200000'),
                validator: (val) {
                  if (val != null && val.isNotEmpty) {
                    if (double.tryParse(val) == null) {
                      return 'Enter a valid number';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              _label('Skills Required'),
              const SizedBox(height: 8),

              // Skills chips
              if (_skills.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _skills.map((skill) {
                      return Chip(
                        label: Text(
                          skill,
                          style: const TextStyle(fontSize: 13),
                        ),
                        onDeleted: () => setState(() => _skills.remove(skill)),
                        deleteIconColor: Colors.grey.shade500,
                        backgroundColor: const Color(
                          0xFF4F46E5,
                          // ignore: deprecated_member_use
                        ).withOpacity(0.08),
                        side: BorderSide.none,
                        labelStyle: const TextStyle(color: Color(0xFF4F46E5)),
                      );
                    }).toList(),
                  ),
                ),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _skillCtrl,
                      decoration: _deco('Add skill (e.g. Flutter)'),
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
              const SizedBox(height: 32),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: state.isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: state.isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          _isEditing ? 'Save Changes' : 'Post Job',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Color(0xFF1A1A2E),
    ),
  );

  InputDecoration _deco(String hint) => InputDecoration(
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
