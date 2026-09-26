import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/contact_model.dart';

// Contact Service Section

class ContactService {
  final _messages =
      FirebaseFirestore.instance.collection('messages');

  // Send Message Section

  Future<void> sendMessage(ContactModel contact) async {
    await _messages.add({
      ...contact.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Send Message End
}

// Contact Service End