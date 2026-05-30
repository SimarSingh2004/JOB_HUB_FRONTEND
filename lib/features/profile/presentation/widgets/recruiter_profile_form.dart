import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/recruiter_profile.dart';
import '../viewmodels/profile_viewmodel.dart';

class RecruiterProfileForm extends ConsumerStatefulWidget {
  final RecruiterProfileModel? existingProfile;

  const RecruiterProfileForm({super.key, this.existingProfile});

  @override
  ConsumerState<RecruiterProfileForm> createState() =>
      _RecruiterProfileFormState();
}

class _RecruiterProfileFormState extends ConsumerState<RecruiterProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _companyNameCtrl;
  late TextEditingController _companyDescCtrl;
  late TextEditingController _companyWebsiteCtrl;
  late TextEditingController _companyLogoCtrl;

  @override
  void initState() {
    super.initState();
    final p = widget.existingProfile;
    _companyNameCtrl = TextEditingController(text: p?.companyName ?? '');
    _companyDescCtrl = TextEditingController(text: p?.companyDescription ?? '');
    _companyWebsiteCtrl = TextEditingController(text: p?.companyWebsite ?? '');
    _companyLogoCtrl = TextEditingController(text: p?.companyLogo ?? '');
  }

  @override
  void dispose() {
    _companyNameCtrl.dispose();
    _companyDescCtrl.dispose();
    _companyWebsiteCtrl.dispose();
    _companyLogoCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(profileViewModelProvider.notifier)
        .save(
          role: 'recruiter',
          data: {
            'companyName': _companyNameCtrl.text.trim(),
            'companyDescription': _companyDescCtrl.text.trim(),
            'companyWebsite': _companyWebsiteCtrl.text.trim(),
            'companyLogo': _companyLogoCtrl.text.trim(),
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileViewModelProvider);
    final isSaving = profileAsync.value?.isSaving ?? false;
    final saveError = profileAsync.value?.saveError;
    final saveSuccess = profileAsync.value?.saveSuccess ?? false;

    if (saveSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile saved!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        ref.read(profileViewModelProvider.notifier).clearSaveSuccess();
      });
    }

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

            _label('Company Name *'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _companyNameCtrl,
              decoration: _deco('e.g. Anthropic'),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            _label('Company Description *'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _companyDescCtrl,
              maxLines: 3,
              decoration: _deco('What does your company do?'),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            _label('Company Website'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _companyWebsiteCtrl,
              keyboardType: TextInputType.url,
              decoration: _deco('https://yourcompany.com'),
              validator: (val) {
                if (val != null && val.isNotEmpty && !val.startsWith('http')) {
                  return 'Must start with http';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            _label('Company Logo URL'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _companyLogoCtrl,
              keyboardType: TextInputType.url,
              decoration: _deco('https://yourcompany.com/logo.png'),
            ),
            const SizedBox(height: 32),

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
          ],
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
