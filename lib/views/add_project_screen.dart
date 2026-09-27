import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/project_model.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/project_viewmodel.dart';
// Add And Edit Project Section
class AddProjectScreen extends StatefulWidget {
  final ProjectModel? project;
  const AddProjectScreen({
    super.key,
    this.project,
  });

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}
class _AddProjectScreenState extends State<AddProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _technologies = TextEditingController();
  final _github = TextEditingController();
  final _demo = TextEditingController();
  final _imageLink = TextEditingController();
  bool _published = true;
  bool _busy = false;
  String? _error;
  bool get _isEditing => widget.project != null;

  // Load Project Section

  @override
  void initState() {
    super.initState();
    final project = widget.project;
    if (project == null) return;
    _title.text = project.title;
    _description.text = project.description;
    _technologies.text = project.technologies.join(', ');
    _github.text = project.githubUrl;
    _demo.text = project.demoUrl;
    _published = project.isPublished;
    final images = project.galleryImages;
    _imageLink.text = images.isEmpty ? '' : images.first;
  }

  // Load Project End

  // Save Project Section
  Future<void> _save() async {
    if (_busy || !_formKey.currentState!.validate()) return;
    if (!context.read<AuthViewModel>().isAdmin) {
      setState(() => _error = 'Please sign in as admin.');
      return;
    }
    final viewModel = context.read<ProjectViewModel>();
    if (viewModel.isSaving) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final project = ProjectModel(
        id: widget.project?.id ?? '',
        title: _title.text.trim(),
        description: _description.text.trim(),
        imageUrl: _imageLink.text.trim(),
        imageUrls: const [],
        githubUrl: _github.text.trim(),
        demoUrl: _demo.text.trim(),
        technologies: _technologies.text
            .split(',')
            .map((item) => item.trim())
            .where((item) => item.isNotEmpty)
            .toSet()
            .toList(),
        isPublished: _published,
      );
      final saved = await viewModel.saveProject(project);
      if (!mounted) return;
      if (saved) {
        Navigator.pop(context, true);
      } else {
        setState(() {
          _error = viewModel.error ?? 'Unable to save project.';
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _error =
              'Unable to save project. Please try again.';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  // Save Project End

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _technologies.dispose();
    _github.dispose();
    _demo.dispose();
    _imageLink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.watch<AuthViewModel>().isAdmin;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Project' : 'Add Project'),
      ),
      body: !isAdmin
          ? const Center(child: Text('Please sign in as admin.'))
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: _buildForm(),
                  ),
                ),
              ),
            ),
    );
  }

  // Project Form Section
  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xffedf3fc),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white),
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
            // Project Information Section
            _field(_title, 'Project title', requiredField: true),
            _field(
              _description,
              'Full project description',
              requiredField: true,
              lines: 6,
            ),
            _field(_technologies, 'Technologies separated by commas'),
            _field(_github, 'GitHub URL (optional)', link: true),
            _field(_demo, 'Live Demo URL (optional)', link: true),
            _field(_imageLink, 'App Image', link: true),
            // Project Information End
            // Image Preview Section
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _imageLink,
              builder: (context, value, child) {
                final url = value.text.trim();
                final uri = Uri.tryParse(url);
                final valid = uri != null &&
                    ['http', 'https'].contains(uri.scheme) &&
                    uri.host.isNotEmpty;
                return ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: AspectRatio(
                    aspectRatio: 16 / 10,
                    child: ColoredBox(
                      color: const Color(0xffe0ebfc),
                      child: !valid
                          ? const Center(
                              child: Icon(Icons.image_outlined,
                                  size: 60, color: Color(0xff036ffc)),
                            )
                          : Image.network(
                              url,
                              key: ValueKey(url),
                              fit: BoxFit.contain,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              errorBuilder: (_, __, ___) => const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    'Image could not load. Check the direct image URL.',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            // Image Preview End
            // Publish Section
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Published'),
              subtitle: Text(
                _published
                    ? 'Visible to portfolio visitors.'
                    : 'Only visible in your admin dashboard.',
              ),
              value: _published,
              onChanged: _busy
                  ? null
                  : (value) => setState(() => _published = value),
            ),
            const SizedBox(height: 20),
            // Publish End
            // Save Button Section
            if (_error != null) ...[
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 12),
            ],
            FilledButton.icon(
              onPressed: _busy ? null : _save,
              icon: _busy
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(_busy ? 'Saving...' : 'Save Project'),
            ),
            // Save Button End
          ],
        ),
      ),
    );
  }

  // Project Form End

  // Text Field Section
  Widget _field(
    TextEditingController controller,
    String label, {
    bool requiredField = false,
    bool link = false,
    int lines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        enabled: !_busy,
        maxLines: lines,
        keyboardType: link ? TextInputType.url : TextInputType.multiline,
        autocorrect: !link,
        enableSuggestions: !link,
        decoration: InputDecoration(
          labelText: label,
          alignLabelWithHint: true,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          final text = (value ?? '').trim();
          if (requiredField && text.isEmpty) {
            return 'This field is required.';
          }
          if (link && text.isNotEmpty) {
            final uri = Uri.tryParse(text);
            if (uri == null ||
                !['http', 'https'].contains(uri.scheme) ||
                uri.host.isEmpty) {
              return 'Enter a valid https:// link.';
            }
          }
          return null;
        },
      ),
    );
  }

  // Text Field End
}
// Add And Edit Project End
