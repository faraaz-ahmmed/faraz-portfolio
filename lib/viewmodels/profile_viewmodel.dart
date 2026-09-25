import 'package:flutter/foundation.dart';

import '../models/profile_model.dart';

// Profile ViewModel
class ProfileViewModel extends ChangeNotifier {
  // Initial Profile Section
  ProfileModel _profile = const ProfileModel(
    name: 'Faraz Ahmad',
    role: 'Flutter Developer',
    bio: 'I am a Computer Science graduate from the University '
        'of Agriculture Peshawar. I enjoy building clean, '
        'user-friendly apps with Flutter and Firebase.',
    skills: ['Flutter', 'Dart', 'Firebase', 'Git'],
  );
  // Initial Profile End

  ProfileModel get profile => _profile;

  // Update Profile Section
  void updateProfile(ProfileModel profile) {
    _profile = profile;
    notifyListeners();
  }
  // Update Profile End
}
// Profile ViewModel End