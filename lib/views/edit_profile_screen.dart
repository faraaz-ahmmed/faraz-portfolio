import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/profile_model.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/profile_viewmodel.dart';

// Edit Profile Screen
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Form State Section
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _role = TextEditingController();
  final _bio = TextEditingController();
  final _skills = TextEditingController();
  final _photoUrl = TextEditingController();
  final _cvUrl = TextEditingController();
  final _githubUrl = TextEditingController();
  final _linkedinUrl = TextEditingController();

  bool _formLoaded = false;
  String? _error;
  // Form State End

  // Load Profile Section
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final viewModel = context.watch<ProfileViewModel>();

    if (_formLoaded ||
        viewModel.isLoading ||
        viewModel.loadError != null) {
      return;
    }

    final profile = viewModel.profile;

    _name.text = profile.name;
    _role.text = profile.role;
    _bio.text = profile.bio;
    _skills.text = profile.skills.join(', ');
    _photoUrl.text = profile.photoUrl;
    _cvUrl.text = profile.cvUrl;
    _githubUrl.text = profile.githubUrl;
    _linkedinUrl.text = profile.linkedinUrl;

    _formLoaded = true;
  }
  // Load Profile End

  // Save Profile Section
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (!context.read<AuthViewModel>().isAdmin) return;

    FocusScope.of(context).unfocus();
    setState(() => _error = null);

    final profile = ProfileModel(
      name: _name.text.trim(),
      role: _role.text.trim(),
      bio: _bio.text.trim(),
      skills: _skills.text
          .split(',')
          .map((skill) => skill.trim())
          .where((skill) => skill.isNotEmpty)
          .toSet()
          .toList(),
      photoUrl: _photoUrl.text.trim(),
      cvUrl: _cvUrl.text.trim(),
      githubUrl: _githubUrl.text.trim(),
      linkedinUrl: _linkedinUrl.text.trim(),
    );

    final viewModel = context.read<ProfileViewModel>();
    final saved = await viewModel.updateProfile(profile);

    if (!mounted) return;

    if (saved) {
      Navigator.pop(context, true);
    } else {
      setState(() {
        _error = viewModel.saveError ?? 'Unable to save profile.';
      });
    }
  }
  // Save Profile End

  // Cleanup Section
  @override
  void dispose() {
    _name.dispose();
    _role.dispose();
    _bio.dispose();
    _skills.dispose();
    _photoUrl.dispose();
    _cvUrl.dispose();
    _githubUrl.dispose();
    _linkedinUrl.dispose();
    super.dispose();
  }
  // Cleanup End

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();
    final isAdmin = context.watch<AuthViewModel>().isAdmin;

    return Scaffold(
      backgroundColor: const Color(0xffedf3fc),

      // App Bar Section
      appBar: AppBar(title: const Text('Edit Profile')),
      // App Bar End

      // Profile Content Section
      body: !isAdmin
          ? const Center(child: Text('Please log in as admin.'))
          : viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : viewModel.loadError != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          viewModel.loadError!,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : SafeArea(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 650),
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: const Color(0xffedf3fc),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(-6, -6),
                                  blurRadius: 16,
                                ),
                                BoxShadow(
                                  color: Color(0xffc4d1e3),
                                  offset: Offset(6, 6),
                                  blurRadius: 16,
                                ),
                              ],
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                children: [
                                  // Personal Details Section
                                  const Text(
                                    'Your Profile',
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff142158),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  _field(
                                    controller: _name,
                                    label: 'Full name',
                                    requiredField: true,
                                  ),
                                  _field(
                                    controller: _role,
                                    label: 'Professional title',
                                    requiredField: true,
                                  ),
                                  _field(
                                    controller: _bio,
                                    label: 'About me',
                                    lines: 4,
                                    requiredField: true,
                                  ),
                                  _field(
                                    controller: _skills,
                                    label: 'Skills',
                                    hint: 'Flutter, Dart, Firebase, Git',
                                  ),
                                  // Personal Details End

                                  // Profile Links Section
                                  _field(
                                    controller: _photoUrl,
                                    label: 'Profile photo URL (optional)',
                                    isUrl: true,
                                  ),
                                  _field(
                                    controller: _cvUrl,
                                    label: 'CV URL (optional)',
                                    isUrl: true,
                                  ),
                                  _field(
                                    controller: _githubUrl,
                                    label: 'GitHub profile URL (optional)',
                                    isUrl: true,
                                  ),
                                  _field(
                                    controller: _linkedinUrl,
                                    label: 'LinkedIn URL (optional)',
                                    isUrl: true,
                                  ),
                                  // Profile Links End

                                  // Error Section
                                  if (_error != null) ...[
                                    Text(
                                      _error!,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .error,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                  // Error End

                                  // Save Button Section
                                  FilledButton.icon(
                                    onPressed: viewModel.isSaving
                                        ? null
                                        : _saveProfile,
                                    icon: const Icon(Icons.save_outlined),
                                    label: Text(
                                      viewModel.isSaving
                                          ? 'Saving...'
                                          : 'Save Profile',
                                    ),
                                    style: FilledButton.styleFrom(
                                      backgroundColor:
                                          const Color(0xff036ffc),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                    ),
                                  ),
                                  // Save Button End
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
      // Profile Content End
    );
  }

  // Reusable Input Section
  Widget _field({
    required TextEditingController controller,
    required String label,
    String? hint,
    int lines = 1,
    bool isUrl = false,
    bool requiredField = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        enabled: !context.read<ProfileViewModel>().isSaving,
        maxLines: lines,
        keyboardType: isUrl
            ? TextInputType.url
            : lines > 1
                ? TextInputType.multiline
                : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          alignLabelWithHint: true,
          filled: true,
          fillColor: Colors.white70,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        validator: (value) {
          final text = value?.trim() ?? '';

          if (requiredField && text.isEmpty) {
            return 'This field is required.';
          }

          if (isUrl && text.isNotEmpty) {
            final uri = Uri.tryParse(text);

            if (uri == null ||
                uri.host.isEmpty ||
                (uri.scheme != 'https' && uri.scheme != 'http')) {
              return 'Enter a valid https:// link.';
            }
          }

          return null;
        },
      ),
    );
  }
  // Reusable Input End
}
// Edit Profile Screen End