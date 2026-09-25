import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/project_model.dart';
import '../services/project_service.dart';

// Project ViewModel
class ProjectViewModel extends ChangeNotifier {
  final ProjectService _service = ProjectService();
  StreamSubscription<List<ProjectModel>>? _subscription;

  // Project State Section
  List<ProjectModel> _projects = [];
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;

  List<ProjectModel> get publishedProjects =>
      _projects.where((project) => project.isPublished).toList();

  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;
  // Project State End

  // Initial Loading Section
  ProjectViewModel() {
    _subscription = _service.watchPublishedProjects().listen(
      (projects) {
        _projects = projects;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (Object error) {
        _isLoading = false;
        _error = 'Unable to load projects. Please try again.';
        notifyListeners();
      },
    );
  }
  // Initial Loading End

  // Save Project Section
  Future<bool> saveProject(ProjectModel project) async {
    if (_isSaving) return false;

    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      await _service.saveProject(project);
      return true;
    } catch (_) {
      _error = 'Unable to save the project. Please try again.';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
  // Save Project End

  // Delete Project Section
  Future<bool> deleteProject(String id) async {
    if (_isSaving) return false;

    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      await _service.deleteProject(id);
      return true;
    } catch (_) {
      _error = 'Unable to delete the project. Please try again.';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
  // Delete Project End

  // Cleanup Section
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
  // Cleanup End
}
// Project ViewModel End