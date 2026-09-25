// Profile Model
class ProfileModel {
  final String name;
  final String role;
  final String bio;
  final List<String> skills;
  final String photoUrl;
  final String cvUrl;
  final String githubUrl;
  final String linkedinUrl;

  const ProfileModel({
    required this.name,
    required this.role,
    required this.bio,
    required this.skills,
    this.photoUrl = '',
    this.cvUrl = '',
    this.githubUrl = '',
    this.linkedinUrl = '',
  });

  // Read Firebase Data Section
  factory ProfileModel.fromMap(Map<String, dynamic> data) {
    return ProfileModel(
      name: data['name'] as String? ?? '',
      role: data['role'] as String? ?? '',
      bio: data['bio'] as String? ?? '',
      skills: List<String>.from(data['skills'] ?? []),
      photoUrl: data['photoUrl'] as String? ?? '',
      cvUrl: data['cvUrl'] as String? ?? '',
      githubUrl: data['githubUrl'] as String? ?? '',
      linkedinUrl: data['linkedinUrl'] as String? ?? '',
    );
  }
  // Read Firebase Data End

  // Prepare Firebase Data Section
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'role': role,
      'bio': bio,
      'skills': skills,
      'photoUrl': photoUrl,
      'cvUrl': cvUrl,
      'githubUrl': githubUrl,
      'linkedinUrl': linkedinUrl,
    };
  }
  // Prepare Firebase Data End
}
// Profile Model End