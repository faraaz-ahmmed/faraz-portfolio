// Contact Model Section

class ContactModel {
  final String id;
  final String name;
  final String email;
  final String message;
  final DateTime? createdAt;

  const ContactModel({
    this.id = '',
    required this.name,
    required this.email,
    required this.message,
    this.createdAt,
  });

  // Read Message Section

  factory ContactModel.fromMap(
    String id,
    Map<String, dynamic> data, {
    DateTime? createdAt,
  }) {
    return ContactModel(
      id: id,
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      message: data['message'] as String? ?? '',
      createdAt: createdAt,
    );
  }

  // Read Message End

  // Save Message Section

  Map<String, dynamic> toMap() {
    return {
      'name': name.trim(),
      'email': email.trim(),
      'message': message.trim(),
    };
  }

  // Save Message End
}

// Contact Model End