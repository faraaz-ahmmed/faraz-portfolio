import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/profile_model.dart';

// Profile Service
class ProfileService {
  // Profile Document Section
  final _profile = FirebaseFirestore.instance
      .collection('profile')
      .doc('main');
  // Profile Document End

  // Watch Profile Section
  Stream<ProfileModel?> watchProfile() {
    return _profile.snapshots().map((snapshot) {
      final data = snapshot.data();

      if (data == null) return null;

      return ProfileModel.fromMap(data);
    });
  }
  // Watch Profile End

  // Save Profile Section
  Future<void> saveProfile(ProfileModel profile) async {
    await _profile.set(profile.toMap());
  }
  // Save Profile End
}
// Profile Service End