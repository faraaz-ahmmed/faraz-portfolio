// Project Model Section

class ProjectModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> imageUrls;
  final String githubUrl;
  final String demoUrl;
  final List<String> technologies;
  final bool isPublished;

  const ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl = '',
    this.imageUrls = const [],
    this.githubUrl = '',
    this.demoUrl = '',
    this.technologies = const [],
    this.isPublished = true,
  });

  // Project Gallery Section

  List<String> get galleryImages {
    return [
      imageUrl,
      ...imageUrls,
    ]
        .map((url) => url.trim())
        .where((url) => url.isNotEmpty)
        .toSet()
        .toList();
  }

  // Project Gallery End

  // Read Firebase Data Section

  factory ProjectModel.fromMap(
    String id,
    Map<String, dynamic> data,
  ) {
    return ProjectModel(
      id: id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      imageUrl: data['imageUrl'] as String? ?? '',
      imageUrls: _readList(data['imageUrls']),
      githubUrl: data['githubUrl'] as String? ?? '',
      demoUrl: data['demoUrl'] as String? ?? '',
      technologies: _readList(data['technologies']),
      isPublished: data['isPublished'] as bool? ?? true,
    );
  }

  static List<String> _readList(dynamic value) {
    if (value is! List) return [];

    return value
        .whereType<String>()
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  // Read Firebase Data End

  // Save Firebase Data Section

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'imageUrls': imageUrls,
      'githubUrl': githubUrl,
      'demoUrl': demoUrl,
      'technologies': technologies,
      'isPublished': isPublished,
    };
  }

  // Save Firebase Data End
}

// Project Model End