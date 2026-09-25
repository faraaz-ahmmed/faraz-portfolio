import 'package:flutter/foundation.dart';

import '../models/project_model.dart';

// Project ViewModel
class ProjectViewModel extends ChangeNotifier {
  // Preview Projects Section
  final List<ProjectModel> _projects = [
    const ProjectModel(
      id: 'time-watch',
      title: 'Time Watch',
      description: 'A Flutter clock app with alarms, timer and stopwatch.',
      technologies: ['Flutter', 'Dart', 'Provider'],
    ),
  ];
  // Preview Projects End

  // Published Projects Section
  List<ProjectModel> get publishedProjects {
    return _projects.where((project) => project.isPublished).toList();
  }
  // Published Projects End

  // Save Project Section
  void saveProject(ProjectModel project) {
    final index = _projects.indexWhere((item) => item.id == project.id);

    if (index == -1) {
      _projects.add(project);
    } else {
      _projects[index] = project;
    }

    notifyListeners();
  }
  // Save Project End

  // Delete Project Section
  void deleteProject(String id) {
    _projects.removeWhere((project) => project.id == id);
    notifyListeners();
  }
  // Delete Project End
}
// Project ViewModel End