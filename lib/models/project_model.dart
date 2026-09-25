// Project Model
class ProjectModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String githubUrl;
  final String demoUrl;
  final List<String> technologies;
  final bool isPublished;

  const ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl = '',
    this.githubUrl = '',
    this.demoUrl = '',
    this.technologies = const [],
    this.isPublished = true,
  });

  // Read Firebase Data
  factory ProjectModel.fromMap(String id, Map<String, dynamic> data) {
    return ProjectModel(
      id: id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      imageUrl: data['imageUrl'] as String? ?? '',
      githubUrl: data['githubUrl'] as String? ?? '',
      demoUrl: data['demoUrl'] as String? ?? '',
      technologies: List<String>.from(data['technologies'] ?? []),
      isPublished: data['isPublished'] as bool? ?? true,
    );
  }
  // Read Firebase Data End

  // Prepare Firebase Data
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'githubUrl': githubUrl,
      'demoUrl': demoUrl,
      'technologies': technologies,
      'isPublished': isPublished,
    };
  }
  // Prepare Firebase Data End
}
// Project Model End