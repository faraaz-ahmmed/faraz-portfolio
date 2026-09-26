// Contact Model Section

class ContactModel {
  // Contact Fields Section

  final String name;
  final String email;
  final String message;

  // Contact Fields End

  // Constructor Section

  const ContactModel({
    required this.name,
    required this.email,
    required this.message,
  });

  // Constructor End

  // Firebase Data Section

  Map<String, dynamic> toMap() {
    return {
      'name': name.trim(),
      'email': email.trim(),
      'message': message.trim(),
    };
  }

  // Firebase Data End
}

// Contact Model End