import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

// Upload Service Section

class UploadService {
  Future<String> upload({
    required Uint8List bytes,
    required String folder,
    required String extension,
    required String contentType,
  }) async {
    final id = DateTime.now().microsecondsSinceEpoch;

    final reference = FirebaseStorage.instance.ref(
      'portfolio/$folder/$id.$extension',
    );

    await reference.putData(
      bytes,
      SettableMetadata(contentType: contentType),
    );

    return reference.getDownloadURL();
  }
}

// Upload Service End