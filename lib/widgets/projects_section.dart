import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/project_viewmodel.dart';

// Projects Section
class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProjectViewModel>();
    final projects = viewModel.publishedProjects;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Heading Section
        const Row(
          children: [
            Icon(
              Icons.work_outline,
              color: Color(0xff036ffc),
              size: 28,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'My Projects',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff142158),
                ),
              ),
            ),
          ],
        ),
        // Heading End

        const SizedBox(height: 24),

        // Loading Section
        if (viewModel.isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          )
        // Loading End

        // Error Section
        else if (viewModel.error != null)
          Text(
            viewModel.error!,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
            ),
          )
        // Error End

        // Empty Projects Section
        else if (projects.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Text(
              'No projects published yet.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff52647e),
              ),
            ),
          )
        // Empty Projects End

        // Project Cards Section
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 850
                  ? 3
                  : constraints.maxWidth >= 550
                      ? 2
                      : 1;

              final cardWidth =
                  (constraints.maxWidth - (columns - 1) * 20) / columns;

              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  for (final project in projects)
                    Container(
                      width: cardWidth,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xffedf3fc),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white70),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.white,
                            offset: Offset(-5, -5),
                            blurRadius: 12,
                          ),
                          BoxShadow(
                            color: Color(0xffc4d1e3),
                            offset: Offset(5, 5),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Project Image Section
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: AspectRatio(
                              aspectRatio: 16 / 10,
                              child: project.imageUrl.isEmpty
                                  ? const _ImagePlaceholder()
                                  : Image.network(
                                      project.imageUrl,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (
                                        context,
                                        child,
                                        progress,
                                      ) {
                                        if (progress == null) return child;

                                        return const ColoredBox(
                                          color: Color(0xffe0ecff),
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        );
                                      },
                                      errorBuilder: (_, __, ___) {
                                        return const _ImagePlaceholder();
                                      },
                                    ),
                            ),
                          ),
                          // Project Image End

                          const SizedBox(height: 18),

                          // Project Details Section
                          Text(
                            project.title,
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff142158),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            project.description,
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.6,
                              color: Color(0xff52647e),
                            ),
                          ),
                          // Project Details End

                          // Technologies Section
                          if (project.technologies.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (final technology
                                    in project.technologies)
                                  Chip(
                                    label: Text(technology),
                                    backgroundColor:
                                        const Color(0xffe0ecff),
                                    side: BorderSide.none,
                                    labelStyle: const TextStyle(
                                      color: Color(0xff142158),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                          // Technologies End
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        // Project Cards End
      ],
    );
  }
}
// Projects Section End

// Image Placeholder Section
class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xffe0ecff),
      child: Center(
        child: Icon(
          Icons.apps_rounded,
          size: 56,
          color: Color(0xff036ffc),
        ),
      ),
    );
  }
}
// Image Placeholder End