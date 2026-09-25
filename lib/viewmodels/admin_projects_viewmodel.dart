import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/project_model.dart';
import '../services/project_service.dart';

// Admin Projects ViewModel
class AdminProjectsViewModel extends ChangeNotifier {
  final ProjectService _service = ProjectService();
  StreamSubscription<List<ProjectModel>>? _subscription;

  bool _disposed = false;

  // Projects State Section
  List<ProjectModel> _projects = [];
  bool _isLoading = true;
  bool _isDeleting = false;
  String? _loadError;
  String? _actionError;

  List<ProjectModel> get projects => List.unmodifiable(_projects);

  bool get isLoading => _isLoading;
  bool get isDeleting => _isDeleting;
  String? get loadError => _loadError;
  String? get actionError => _actionError;
  // Projects State End

  // Load Admin Projects Section
  AdminProjectsViewModel() {
    _subscription = _service.watchAllProjects().listen(
      (projects) {
        if (_disposed) return;

        _projects = projects;
        _isLoading = false;
        _loadError = null;
        notifyListeners();
      },
      onError: (Object error) {
        if (_disposed) return;

        _projects = [];
        _isLoading = false;
        _loadError = 'Unable to load projects. Check your admin login.';
        notifyListeners();
      },
    );
  }
  // Load Admin Projects End

  // Delete Project Section
  Future<bool> deleteProject(String id) async {
    if (_isDeleting || _disposed) return false;

    _isDeleting = true;
    _actionError = null;
    notifyListeners();

    try {
      await _service.deleteProject(id);
      return true;
    } catch (_) {
      _actionError = 'Unable to delete the project. Please try again.';
      return false;
    } finally {
      _isDeleting = false;

      if (!_disposed) {
        notifyListeners();
      }
    }
  }
  // Delete Project End

  // Cleanup Section
  @override
  void dispose() {
    _disposed = true;
    _subscription?.cancel();
    super.dispose();
  }
  // Cleanup End
}
// Admin Projects ViewModel End