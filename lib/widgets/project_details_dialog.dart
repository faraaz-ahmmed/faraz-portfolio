import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/project_model.dart';

// Project Details Section

class ProjectDetailsDialog extends StatefulWidget {
  final ProjectModel project;

  const ProjectDetailsDialog({
    super.key,
    required this.project,
  });

  @override
  State<ProjectDetailsDialog> createState() =>
      _ProjectDetailsDialogState();
}

class _ProjectDetailsDialogState extends State<ProjectDetailsDialog> {
  int _selectedImage = 0;

  // Gallery Navigation Section

  void _changeImage(int direction) {
    final images = widget.project.galleryImages;
    if (images.length < 2) return;

    setState(() {
      _selectedImage = (_selectedImage + direction) % images.length;
    });
  }

  // Gallery Navigation End

  // External Links Section

  Future<void> _openLink(String value) async {
    final uri = Uri.tryParse(value.trim());

    if (uri == null ||
        !['http', 'https'].contains(uri.scheme) ||
        uri.host.isEmpty) {
      _showError('This link is not valid.');
      return;
    }

    try {
      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank',
      );

      if (!opened) {
        _showError('Unable to open this link.');
      }
    } catch (_) {
      _showError('Unable to open this link.');
    }
  }

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // External Links End

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);
    final images = widget.project.galleryImages;
    final height = (screen.height * 0.88).clamp(0.0, 820.0);

    return Dialog(
      backgroundColor: const Color(0xffedf3fc),
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: const BorderSide(color: Colors.white),
      ),
      child: SizedBox(
        width: 1100,
        height: height,
        child: Column(
          children: [
            // Dialog Header Section
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 12, 0),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'PROJECT DETAILS',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            // Dialog Header End

            // Responsive Content Section
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 750;
                  final imageHeight = wide
                      ? (constraints.maxHeight - 70).clamp(260.0, 540.0)
                      : 320.0;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: wide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 4,
                                child: _gallery(images, imageHeight),
                              ),
                              const SizedBox(width: 32),
                              Expanded(
                                flex: 5,
                                child: _details(images),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _gallery(images, imageHeight),
                              const SizedBox(height: 28),
                              _details(images),
                            ],
                          ),
                  );
                },
              ),
            ),
            // Responsive Content End
          ],
        ),
      ),
    );
  }

  // Main Image Section

  Widget _gallery(List<String> images, double height) {
    return Column(
      children: [
        Container(
          height: height,
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xffe0ebfc),
            borderRadius: BorderRadius.circular(24),
          ),
          child: images.isEmpty
              ? const Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 80,
                    color: Color(0xff036ffc),
                  ),
                )
              : _image(images[_selectedImage]),
        ),
        if (images.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  tooltip: 'Previous image',
                  onPressed: () => _changeImage(-1),
                  icon: const Icon(Icons.chevron_left),
                ),
                Text('${_selectedImage + 1} / ${images.length}'),
                IconButton(
                  tooltip: 'Next image',
                  onPressed: () => _changeImage(1),
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // Main Image End

  // Project Description Section

  Widget _details(List<String> images) {
    final project = widget.project;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          project.title,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xff142158),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'About this project',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: Color(0xff142158),
          ),
        ),
        const SizedBox(height: 10),
        SelectableText(
          project.description,
          style: const TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Color(0xff526580),
          ),
        ),

        // Screenshot Thumbnails Section
        if (images.isNotEmpty) ...[
          const SizedBox(height: 24),
          const Text(
            'Screenshots',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Color(0xff142158),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 125,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final selected = index == _selectedImage;

                return Semantics(
                  selected: selected,
                  button: true,
                  label: 'Screenshot ${index + 1}',
                  child: Material(
                    color: const Color(0xffe0ebfc),
                    borderRadius: BorderRadius.circular(14),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        setState(() => _selectedImage = index);
                      },
                      child: Container(
                        width: 90,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: selected
                                ? const Color(0xff036ffc)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: _image(images[index]),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
        // Screenshot Thumbnails End

        // Technologies Section
        if (project.technologies.isNotEmpty) ...[
          const SizedBox(height: 24),
          const Text(
            'Technologies',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Color(0xff142158),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final technology in project.technologies)
                Chip(
                  label: Text(technology),
                  backgroundColor: const Color(0xffe0ebfc),
                  side: BorderSide.none,
                ),
            ],
          ),
        ],
        // Technologies End

        // Project Links Section
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            if (project.githubUrl.trim().isNotEmpty)
              OutlinedButton.icon(
                onPressed: () => _openLink(project.githubUrl),
                icon: const Icon(Icons.code),
                label: const Text('View on GitHub'),
              ),
            if (project.demoUrl.trim().isNotEmpty)
              FilledButton.icon(
                onPressed: () => _openLink(project.demoUrl),
                icon: const Icon(Icons.open_in_new),
                label: const Text('Live Demo'),
              ),
          ],
        ),
        // Project Links End
      ],
    );
  }

  // Project Description End

  // Network Image Section

  Widget _image(String url) {
    return Image.network(
      url,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;

        return const Center(
          child: SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
      errorBuilder: (_, __, ___) => const Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: Colors.blueGrey,
          size: 32,
        ),
      ),
    );
  }

  // Network Image End
}

// Project Details End