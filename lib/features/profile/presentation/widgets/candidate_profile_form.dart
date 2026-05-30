import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/candidate_profile.dart';
import '../viewmodels/profile_viewmodel.dart';
import 'dynamic_list_field.dart';

// The candidate profile form handles both create (no existing profile)
// and edit (pre-filled with existing data).
// Parent passes existingProfile — null means first time creation.
class CandidateProfileForm extends ConsumerStatefulWidget {
  final CandidateProfileModel? existingProfile;

  const CandidateProfileForm({super.key, this.existingProfile});

  @override
  ConsumerState<CandidateProfileForm> createState() =>
      _CandidateProfileFormState();
}

class _CandidateProfileFormState extends ConsumerState<CandidateProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _bioController;
  late TextEditingController _resumeController;

  // Local state for list fields
  late List<String> _skills;
  late List<Map<String, dynamic>> _education;
  late List<Map<String, dynamic>> _experience;
  late List<Map<String, dynamic>> _projects;

  // Controllers for adding new education entry
  final _eduInstitutionCtrl = TextEditingController();
  final _eduDegreeCtrl = TextEditingController();
  final _eduFieldCtrl = TextEditingController();
  final _eduStartCtrl = TextEditingController();
  final _eduEndCtrl = TextEditingController();

  // Controllers for adding new experience entry
  final _expCompanyCtrl = TextEditingController();
  final _expRoleCtrl = TextEditingController();
  final _expDurationCtrl = TextEditingController();

  // Controllers for adding new project entry
  final _projTitleCtrl = TextEditingController();
  final _projDescCtrl = TextEditingController();
  final _projLinkCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final p = widget.existingProfile;
    _bioController = TextEditingController(text: p?.bio ?? '');
    _resumeController = TextEditingController(text: p?.resume ?? '');
    _skills = List.from(p?.skills ?? []);
    _education =
        p?.education
            .map(
              (e) => {
                'institution': e.institution,
                'degree': e.degree,
                'field': e.field,
                'startYear': e.startYear?.toString() ?? '',
                'endYear': e.endYear?.toString() ?? '',
              },
            )
            .toList() ??
        [];
    _experience =
        p?.experience
            .map(
              (e) => {
                'company': e.company,
                'role': e.role,
                'duration': e.duration,
              },
            )
            .toList() ??
        [];
    _projects =
        p?.projects
            .map(
              (e) => {
                'title': e.title,
                'description': e.description,
                'link': e.link,
              },
            )
            .toList() ??
        [];
  }

  @override
  void dispose() {
    _bioController.dispose();
    _resumeController.dispose();
    _eduInstitutionCtrl.dispose();
    _eduDegreeCtrl.dispose();
    _eduFieldCtrl.dispose();
    _eduStartCtrl.dispose();
    _eduEndCtrl.dispose();
    _expCompanyCtrl.dispose();
    _expRoleCtrl.dispose();
    _expDurationCtrl.dispose();
    _projTitleCtrl.dispose();
    _projDescCtrl.dispose();
    _projLinkCtrl.dispose();
    super.dispose();
  }

  void _addEducation() {
    if (_eduInstitutionCtrl.text.trim().isEmpty) return;
    setState(() {
      _education.add({
        'institution': _eduInstitutionCtrl.text.trim(),
        'degree': _eduDegreeCtrl.text.trim(),
        'field': _eduFieldCtrl.text.trim(),
        'startYear': int.tryParse(_eduStartCtrl.text.trim()),
        'endYear': int.tryParse(_eduEndCtrl.text.trim()),
      });
      _eduInstitutionCtrl.clear();
      _eduDegreeCtrl.clear();
      _eduFieldCtrl.clear();
      _eduStartCtrl.clear();
      _eduEndCtrl.clear();
    });
  }

  void _addExperience() {
    if (_expCompanyCtrl.text.trim().isEmpty) return;
    setState(() {
      _experience.add({
        'company': _expCompanyCtrl.text.trim(),
        'role': _expRoleCtrl.text.trim(),
        'duration': _expDurationCtrl.text.trim(),
      });
      _expCompanyCtrl.clear();
      _expRoleCtrl.clear();
      _expDurationCtrl.clear();
    });
  }

  void _addProject() {
    if (_projTitleCtrl.text.trim().isEmpty) return;
    setState(() {
      _projects.add({
        'title': _projTitleCtrl.text.trim(),
        'description': _projDescCtrl.text.trim(),
        'link': _projLinkCtrl.text.trim(),
      });
      _projTitleCtrl.clear();
      _projDescCtrl.clear();
      _projLinkCtrl.clear();
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(profileViewModelProvider.notifier)
        .save(
          role: 'candidate',
          data: {
            'bio': _bioController.text.trim(),
            'resume': _resumeController.text.trim(),
            'skills': _skills,
            'education': _education,
            'experience': _experience,
            'projects': _projects,
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileViewModelProvider);
    final isSaving = profileAsync.value?.isSaving ?? false;
    final saveError = profileAsync.value?.saveError;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Error
            if (saveError != null)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  saveError,
                  style: TextStyle(color: Colors.red.shade700),
                ),
              ),

            // Bio
            _SectionLabel('Bio'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _bioController,
              maxLines: 3,
              maxLength: 500,
              decoration: _inputDeco('Tell recruiters about yourself...'),
            ),
            const SizedBox(height: 16),

            // Resume URL
            _SectionLabel('Resume URL'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _resumeController,
              keyboardType: TextInputType.url,
              decoration: _inputDeco('https://drive.google.com/...'),
              validator: (val) {
                if (val != null && val.isNotEmpty && !val.startsWith('http')) {
                  return 'Must be a valid URL starting with http';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Skills
            _SectionLabel('Skills'),
            const SizedBox(height: 8),
            SkillsInput(
              skills: _skills,
              onAdd: (s) => setState(() => _skills.add(s)),
              onRemove: (s) => setState(() => _skills.remove(s)),
            ),
            const SizedBox(height: 24),

            // Education
            _SectionLabel('Education'),
            const SizedBox(height: 8),
            // Existing entries
            ..._education.asMap().entries.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: EntryCard(
                  title: e.value['institution'] as String? ?? '',
                  subtitle: '${e.value['degree']} · ${e.value['field']}',
                  onRemove: () => setState(() => _education.removeAt(e.key)),
                ),
              ),
            ),
            // Add new education
            _ExpandableForm(
              title: '+ Add Education',
              children: [
                _MiniField(_eduInstitutionCtrl, 'Institution *'),
                _MiniField(_eduDegreeCtrl, 'Degree'),
                _MiniField(_eduFieldCtrl, 'Field of Study'),
                Row(
                  children: [
                    Expanded(child: _MiniField(_eduStartCtrl, 'Start Year')),
                    const SizedBox(width: 8),
                    Expanded(child: _MiniField(_eduEndCtrl, 'End Year')),
                  ],
                ),
                _AddButton('Add Education', _addEducation),
              ],
            ),
            const SizedBox(height: 24),

            // Experience
            _SectionLabel('Experience'),
            const SizedBox(height: 8),
            ..._experience.asMap().entries.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: EntryCard(
                  title: e.value['company'] as String? ?? '',
                  subtitle: '${e.value['role']} · ${e.value['duration']}',
                  onRemove: () => setState(() => _experience.removeAt(e.key)),
                ),
              ),
            ),
            _ExpandableForm(
              title: '+ Add Experience',
              children: [
                _MiniField(_expCompanyCtrl, 'Company *'),
                _MiniField(_expRoleCtrl, 'Role'),
                _MiniField(_expDurationCtrl, 'Duration (e.g. 6 months)'),
                _AddButton('Add Experience', _addExperience),
              ],
            ),
            const SizedBox(height: 24),

            // Projects
            _SectionLabel('Projects'),
            const SizedBox(height: 8),
            ..._projects.asMap().entries.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: EntryCard(
                  title: e.value['title'] as String? ?? '',
                  subtitle: e.value['description'] as String? ?? '',
                  onRemove: () => setState(() => _projects.removeAt(e.key)),
                ),
              ),
            ),
            _ExpandableForm(
              title: '+ Add Project',
              children: [
                _MiniField(_projTitleCtrl, 'Project Title *'),
                _MiniField(_projDescCtrl, 'Description'),
                _MiniField(_projLinkCtrl, 'Link (GitHub/Live)'),
                _AddButton('Add Project', _addProject),
              ],
            ),
            const SizedBox(height: 32),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isSaving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: isSaving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        widget.existingProfile == null
                            ? 'Create Profile'
                            : 'Save Changes',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String hint) {
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

// Private helpers for the form

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1A2E),
      ),
    );
  }
}

// Expandable "add entry" section — collapsed by default
class _ExpandableForm extends StatefulWidget {
  final String title;
  final List<Widget> children;

  const _ExpandableForm({required this.title, required this.children});

  @override
  State<_ExpandableForm> createState() => _ExpandableFormState();
}

class _ExpandableFormState extends State<_ExpandableForm> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Text(
            widget.title,
            style: const TextStyle(
              color: Color(0xFF4F46E5),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        if (_expanded) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.children
                  .map(
                    (c) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: c,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ],
    );
  }
}

class _MiniField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const _MiniField(this.controller, this.hint);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        isDense: true,
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _AddButton(this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4F46E5),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
        child: Text(label, style: const TextStyle(fontSize: 13)),
      ),
    );
  }
}
