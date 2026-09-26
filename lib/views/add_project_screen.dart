import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/project_model.dart';
import '../services/upload_service.dart';
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

  final _uploads = UploadService();
  final List<String> _imageUrls = [];
  final List<({Uint8List bytes, String extension})> _newImages = [];

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
    _imageUrls.addAll(project.galleryImages);
  }

  // Load Project End

  // Choose Screenshots Section

  Future<void> _chooseImages() async {
    if (_busy) return;

    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final files = await openFiles(
        acceptedTypeGroups: const [
          XTypeGroup(
            label: 'Project screenshots',
            extensions: ['jpg', 'jpeg', 'png'],
            mimeTypes: ['image/jpeg', 'image/png'],
            uniformTypeIdentifiers: ['public.jpeg', 'public.png'],
          ),
        ],
      );

      if (files.isEmpty || !mounted) return;

      if (_imageUrls.length + _newImages.length + files.length > 12) {
        throw const FormatException('Choose up to 12 images per project.');
      }

      final selected = <({Uint8List bytes, String extension})>[];

      for (final file in files) {
        final extension = file.name.split('.').last.toLowerCase();

        if (!['jpg', 'jpeg', 'png'].contains(extension)) {
          throw const FormatException('Only JPG and PNG images are allowed.');
        }

        final size = await file.length();

        if (size == 0 || size > 5 * 1024 * 1024) {
          throw const FormatException(
            'Each image must be non-empty and no larger than 5 MB.',
          );
        }

        selected.add((
          bytes: await file.readAsBytes(),
          extension: extension,
        ));
      }

      if (!mounted) return;

      setState(() => _newImages.addAll(selected));
    } on FormatException catch (error) {
      if (mounted) {
        setState(() => _error = error.message.toString());
      }
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Unable to select images.');
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  // Choose Screenshots End

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
      // Keep successful uploads if a later upload needs retrying.
      while (_newImages.isNotEmpty) {
        final image = _newImages.first;

        final url = await _uploads.upload(
          bytes: image.bytes,
          folder: 'photos',
          extension: image.extension,
          contentType:
              image.extension == 'png' ? 'image/png' : 'image/jpeg',
        );

        if (!mounted) return;

        setState(() {
          _imageUrls.add(url);
          _newImages.removeAt(0);
        });
      }

      if (!mounted) return;

      final project = ProjectModel(
        id: widget.project?.id ?? '',
        title: _title.text.trim(),
        description: _description.text.trim(),
        imageUrl: _imageUrls.isEmpty ? '' : _imageUrls.first,
        imageUrls: _imageUrls.skip(1).toList(),
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
              'Image upload failed. Check your connection and Firebase Storage.';
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
            // Project Information End

            // Screenshots Section
            const Text(
              'Project Screenshots',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xff142158),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'The first image is the cover. Add up to 12 JPG or PNG images.',
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (int i = 0; i < _imageUrls.length; i++)
                  _thumbnail(
                    image: Image.network(
                      _imageUrls[i],
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image_outlined),
                    ),
                    onRemove: () {
                      setState(() => _imageUrls.removeAt(i));
                    },
                  ),
                for (int i = 0; i < _newImages.length; i++)
                  _thumbnail(
                    image: Image.memory(
                      _newImages[i].bytes,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image_outlined),
                    ),
                    onRemove: () {
                      setState(() => _newImages.removeAt(i));
                    },
                  ),
              ],
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _busy ? null : _chooseImages,
              icon: const Icon(Icons.add_photo_alternate_outlined),
              label: const Text('Choose Screenshots'),
            ),
            const SizedBox(height: 20),
            // Screenshots End

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

  // Thumbnail Section

  Widget _thumbnail({
    required Widget image,
    required VoidCallback onRemove,
  }) {
    return Container(
      width: 120,
      height: 160,
      decoration: BoxDecoration(
        color: const Color(0xffe0ebfc),
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: image,
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              tooltip: 'Remove from project',
              onPressed: _busy ? null : onRemove,
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              icon: const Icon(Icons.close, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  // Thumbnail End

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