import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/project_model.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/project_viewmodel.dart';

// Add Project Screen
class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  // Form State Section
  final _formKey = GlobalKey<FormState>();

  final _title = TextEditingController();
  final _description = TextEditingController();
  final _imageUrl = TextEditingController();
  final _githubUrl = TextEditingController();
  final _demoUrl = TextEditingController();
  final _technologies = TextEditingController();

  bool _isPublished = true;
  // Form State End

  // Save Project Section
  Future<void> _saveProject() async {
    if (!_formKey.currentState!.validate()) return;

    if (!context.read<AuthViewModel>().isAdmin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in as admin.')),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    final project = ProjectModel(
      id: '',
      title: _title.text.trim(),
      description: _description.text.trim(),
      imageUrl: _imageUrl.text.trim(),
      githubUrl: _githubUrl.text.trim(),
      demoUrl: _demoUrl.text.trim(),
      technologies: _technologies.text
          .split(',')
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toSet()
          .toList(),
      isPublished: _isPublished,
    );

    final saved =
        await context.read<ProjectViewModel>().saveProject(project);

    if (!mounted) return;

    if (saved) {
      Navigator.pop(context, true);
    }
  }
  // Save Project End

  // URL Validation Section
  String? _validateUrl(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;

    final uri = Uri.tryParse(text);

    if (uri == null ||
        uri.host.isEmpty ||
        (uri.scheme != 'https' && uri.scheme != 'http')) {
      return 'Enter a valid https:// link.';
    }

    return null;
  }
  // URL Validation End

  // Controllers Cleanup Section
  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _imageUrl.dispose();
    _githubUrl.dispose();
    _demoUrl.dispose();
    _technologies.dispose();
    super.dispose();
  }
  // Controllers Cleanup End

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProjectViewModel>();
    final isAdmin = context.watch<AuthViewModel>().isAdmin;

    return Scaffold(
      backgroundColor: const Color(0xffedf3fc),

      // App Bar Section
      appBar: AppBar(
        title: const Text('Add Project'),
      ),
      // App Bar End

      // Project Form Section
      body: !isAdmin
          ? const Center(
              child: Text('Please log in as admin to add projects.'),
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
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Project Details Section
                          const Text(
                            'Showcase Your Work',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff142158),
                            ),
                          ),
                          const SizedBox(height: 24),
                          _field(
                            controller: _title,
                            label: 'Project name',
                            requiredField: true,
                          ),
                          _field(
                            controller: _description,
                            label: 'Description',
                            lines: 4,
                            requiredField: true,
                          ),
                          // Project Details End

                          // Project Links Section
                          _field(
                            controller: _imageUrl,
                            label: 'Image URL (optional)',
                            isUrl: true,
                          ),
                          _field(
                            controller: _githubUrl,
                            label: 'GitHub URL (optional)',
                            isUrl: true,
                          ),
                          _field(
                            controller: _demoUrl,
                            label: 'Live demo URL (optional)',
                            isUrl: true,
                          ),
                          // Project Links End

                          // Technologies Section
                          _field(
                            controller: _technologies,
                            label: 'Technologies',
                            hint: 'Flutter, Dart, Firebase',
                          ),
                          // Technologies End

                          // Publish Section
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Publish project'),
                            subtitle: const Text(
                              'Show this project on your public portfolio.',
                            ),
                            value: _isPublished,
                            onChanged: viewModel.isSaving
                                ? null
                                : (value) {
                                    setState(() {
                                      _isPublished = value;
                                    });
                                  },
                          ),
                          // Publish End

                          const SizedBox(height: 16),

                          // Error Section
                          if (viewModel.error != null) ...[
                            Text(
                              viewModel.error!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                          // Error End

                          // Save Button Section
                          FilledButton.icon(
                            onPressed:
                                viewModel.isSaving ? null : _saveProject,
                            icon: const Icon(Icons.save_outlined),
                            label: Text(
                              viewModel.isSaving
                                  ? 'Saving...'
                                  : 'Save Project',
                            ),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xff036ffc),
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
      // Project Form End
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
        enabled: !context.read<ProjectViewModel>().isSaving,
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
          if (requiredField && (value == null || value.trim().isEmpty)) {
            return 'This field is required.';
          }

          return isUrl ? _validateUrl(value) : null;
        },
      ),
    );
  }
  // Reusable Input End
}
// Add Project Screen End