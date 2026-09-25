import 'package:flutter/foundation.dart';

import '../models/profile_model.dart';

// Profile ViewModel
class ProfileViewModel extends ChangeNotifier {
  ProfileModel _profile = const ProfileModel(
    name: 'Faraz Ahmad',
    role: 'Flutter Developer',
    bio: 'I am a Computer Science graduate from the University '
        'of Agriculture Peshawar. I build mobile apps '
        'using Flutter and Firebase.',
    skills: ['Flutter', 'Dart', 'Firebase', 'Git'],
  );

  ProfileModel get profile => _profile;

  // Update Profile
  void updateProfile(ProfileModel profile) {
    _profile = profile;
    notifyListeners();
  }
  // Update Profile End
}
// Profile ViewModel End