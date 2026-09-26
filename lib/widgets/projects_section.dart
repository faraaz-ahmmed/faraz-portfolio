import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/project_model.dart';
import '../viewmodels/project_viewmodel.dart';
import 'project_details_dialog.dart';

// Projects Section

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key}); 

  // Open Project Section

  void _openProject(BuildContext context, ProjectModel project) {
    showDialog<void>(
      context: context,
      builder: (_) => ProjectDetailsDialog(project: project),
    );
  }

  // Open Project End

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProjectViewModel>();
    final projects = viewModel.publishedProjects;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Heading
        const Row(
          children: [
            Icon(
              Icons.work_outline,
              size: 30,
              color: Color(0xff036ffc),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'My Projects',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff142158),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Section Heading End

        // Projects List Section
        if (viewModel.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (viewModel.error != null)
          Text(viewModel.error!)
        else if (projects.isEmpty)
          const Text('No projects published yet.')
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 900
                  ? 3
                  : constraints.maxWidth >= 600
                      ? 2
                      : 1;

              final width =
                  (constraints.maxWidth - (columns - 1) * 20) / columns;

              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  for (final project in projects)
                    SizedBox(
                      width: width,
                      child: _projectCard(context, project),
                    ),
                ],
              );
            },
          ),
        // Projects List End
      ],
    );
  }

  // Project Card Section

  Widget _projectCard(BuildContext context, ProjectModel project) {
    final images = project.galleryImages;

    return Container(
      decoration: BoxDecoration(
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
      child: Material(
        color: const Color(0xffedf3fc),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Colors.white),
        ),
        child: InkWell(
          onTap: () => _openProject(context, project),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cover Image Section
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: AspectRatio(
                    aspectRatio: 16 / 10,
                    child: ColoredBox(
                      color: const Color(0xffe0ebfc),
                      child: images.isEmpty
                          ? const _ProjectPlaceholder()
                          : Image.network(
                              images.first,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const _ProjectPlaceholder(),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Cover Image End

                // Card Details Section
                Text(
                  project.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff142158),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  project.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xff526580),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final technology in project.technologies.take(3))
                      Chip(
                        label: Text(technology),
                        backgroundColor: const Color(0xffe0ebfc),
                        side: BorderSide.none,
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Text(
                      'View Project',
                      style: TextStyle(
                        color: Color(0xff036ffc),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward,
                      size: 20,
                      color: Color(0xff036ffc),
                    ),
                  ],
                ),
                // Card Details End
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Project Card End
}

// Projects End

// Placeholder Section

class _ProjectPlaceholder extends StatelessWidget {
  const _ProjectPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(
        Icons.apps,
        size: 60,
        color: Color(0xff036ffc),
      ),
    );
  }
}

// Placeholder End