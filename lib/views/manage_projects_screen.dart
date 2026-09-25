import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/project_model.dart';
import '../viewmodels/admin_projects_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'add_project_screen.dart';

// Manage Projects Screen
class ManageProjectsScreen extends StatelessWidget {
  const ManageProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.watch<AuthViewModel>().isAdmin;

    // Admin Access Section
    if (!isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Manage Projects')),
        body: const Center(
          child: Text('Please log in as admin.'),
        ),
      );
    }
    // Admin Access End

    // Admin Projects Provider Section
    return ChangeNotifierProvider(
      create: (_) => AdminProjectsViewModel(),
      child: const _ManageProjectsContent(),
    );
    // Admin Projects Provider End
  }
}
// Manage Projects Screen End

// Manage Projects Content
class _ManageProjectsContent extends StatelessWidget {
  const _ManageProjectsContent();

  // Add Project Section
  Future<void> _addProject(BuildContext context) async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddProjectScreen(),
      ),
    );

    if (!context.mounted || saved != true) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Project saved successfully.')),
    );
  }
  // Add Project End

  // Delete Confirmation Section
  Future<void> _deleteProject(
    BuildContext context,
    ProjectModel project,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete project?'),
          content: Text(
            '“${project.title}” will be permanently deleted.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (!context.mounted || confirmed != true) return;

    if (!context.read<AuthViewModel>().isAdmin) return;

    final viewModel = context.read<AdminProjectsViewModel>();
    final deleted = await viewModel.deleteProject(project.id);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          deleted
              ? 'Project deleted.'
              : viewModel.actionError ?? 'Unable to delete project.',
        ),
      ),
    );
  }
  // Delete Confirmation End

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AdminProjectsViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xffedf3fc),

      // App Bar Section
      appBar: AppBar(
        title: const Text('Manage Projects'),
      ),
      // App Bar End

      // Add Button Section
      floatingActionButton: FloatingActionButton.extended(
        onPressed:
            viewModel.isDeleting ? null : () => _addProject(context),
        backgroundColor: const Color(0xff036ffc),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Project'),
      ),
      // Add Button End

      // Projects Content Section
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: _buildContent(context, viewModel),
          ),
        ),
      ),
      // Projects Content End
    );
  }

  // Projects List Section
  Widget _buildContent(
    BuildContext context,
    AdminProjectsViewModel viewModel,
  ) {
    // Loading Section
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    // Loading End

    // Error Section
    if (viewModel.loadError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            viewModel.loadError!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
      );
    }
    // Error End

    // Empty State Section
    if (viewModel.projects.isEmpty) {
      return const Center(
        child: Text(
          'No projects yet. Tap Add Project to start.',
          textAlign: TextAlign.center,
        ),
      );
    }
    // Empty State End

    // Project Cards Section
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 110),
      itemCount: viewModel.projects.length,
      separatorBuilder: (_, __) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        final project = viewModel.projects[index];

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xffedf3fc),
            borderRadius: BorderRadius.circular(22),
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
              // Project Title Section
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
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xff52647e),
                  height: 1.6,
                ),
              ),
              // Project Title End

              const SizedBox(height: 16),

              // Status And Delete Section
              Wrap(
                spacing: 16,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Chip(
                    avatar: Icon(
                      project.isPublished
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 18,
                    ),
                    label: Text(
                      project.isPublished ? 'Published' : 'Hidden',
                    ),
                  ),
                  TextButton.icon(
                    onPressed: viewModel.isDeleting
                        ? null
                        : () => _deleteProject(context, project),
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Delete'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
              // Status And Delete End
            ],
          ),
        );
      },
    );
    // Project Cards End
  }
  // Projects List End
}
// Manage Projects Content End