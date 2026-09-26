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

  // Read Messages Section

  Stream<List<ContactModel>> watchMessages() {
    return _messages
        .orderBy('createdAt', descending: true)
        .limit(100)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        final timestamp = data['createdAt'];

        return ContactModel.fromMap(
          doc.id,
          data,
          createdAt: timestamp is Timestamp
              ? timestamp.toDate()
              : null,
        );
      }).toList();
    });
  }

  // Read Messages End

  // Delete Message Section

  Future<void> deleteMessage(String id) async {
    await _messages.doc(id).delete();
  }

  // Delete Message End
}

// Contact Service End