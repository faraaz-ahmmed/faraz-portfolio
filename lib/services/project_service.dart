import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/project_model.dart';

// Project Service
class ProjectService {
  final _projects = FirebaseFirestore.instance.collection('projects');

  // Public Projects Section
  Stream<List<ProjectModel>> watchPublishedProjects() {
    return _projects
        .where('isPublished', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ProjectModel.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }
  // Public Projects End

  // Admin Projects Section
  Stream<List<ProjectModel>> watchAllProjects() {
    return _projects.snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => ProjectModel.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }
  // Admin Projects End

  // Save Project Section
  Future<void> saveProject(ProjectModel project) async {
    final document = project.id.isEmpty
        ? _projects.doc()
        : _projects.doc(project.id);

    await document.set(project.toMap());
  }
  // Save Project End

  // Delete Project Section
  Future<void> deleteProject(String id) async {
    await _projects.doc(id).delete();
  }
  // Delete Project End
}
// Project Service End